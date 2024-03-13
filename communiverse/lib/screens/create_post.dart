import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<File> _images = [];
  List<String> _videos = [];
  TextEditingController _textController = TextEditingController();

  FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.photo, color: Colors.white),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              setState(() {
                                _images.add(File(pickedFile.path));
                              });
                            }
                          },
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          icon: Icon(Icons.videocam, color: Colors.white),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickVideo(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              setState(() {
                                _videos.add(pickedFile.path);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ..._images.map((image) => _buildImageThumbnail(image)),
                        ..._videos.map((video) => _buildVideoThumbnail(video)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implementar la lógica para publicar el post
              },
              child: Text("Post", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(File image) {
    return GestureDetector(
      onTap: () {
        // Implementar la lógica para mostrar la imagen en pantalla completa
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          image,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(String videoPath) {
    return FutureBuilder<Uint8List?>(
      future: _getVideoThumbnail(videoPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Container(); // Handle error or no thumbnail available
        } else {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  snapshot.data!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              FutureBuilder<int>(
                future: getVideoDuration(videoPath),
                builder: (context, durationSnapshot) {
                  if (durationSnapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (durationSnapshot.hasError || durationSnapshot.data == null) {
                    return Container(); // Handle error
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        _formatDuration(durationSnapshot.data!),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        }
      },
    );
  }

  Future<Uint8List?> _getVideoThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100,
      quality: 25,
    );
  }

  Future<int> getVideoDuration(String videoPath) async {
    try {
      final result = await _flutterFFmpeg.execute("-i $videoPath");
      if (result == 0) {
        final mediaInformation = await _flutterFFmpeg.getLastReceivedMediaInformation();
        return mediaInformation.duration;
      } else {
        print("Error obteniendo información del video: $result");
        return -1; // Handle error
      }
    } catch (e) {
      print("Error obteniendo información del video: $e");
      return -1; // Handle error
    }
  }

  String _formatDuration(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
