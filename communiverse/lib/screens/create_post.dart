import 'dart:io';
import 'dart:typed_data';

import 'package:communiverse/models/models.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePostScreen extends StatefulWidget {
  final User user;

  CreatePostScreen({required this.user});
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<File> _images = [];
  List<String> _videos = [];
  TextEditingController _textController = TextEditingController();
  bool hasMedia = false;
  int _maxLines = 5;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Color.fromRGBO(165, 91, 194, 0.2),
            height: _images.isNotEmpty || _videos.isNotEmpty
                ? size.height * 0.63
                : size.height * 0.48,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  postHeader(),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _textController,
                      maxLines: 6,
                      maxLength: 200,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                        counterStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (text) {
                        final lines = text.split('\n');
                        if (lines.length > _maxLines) {
                          _textController.text =
                              lines.sublist(0, _maxLines).join('\n');
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo, color: Colors.white),
                              onPressed: () async {
                                if (_images.length + _videos.length >= 10) {
                                  // Mostrar una SnackBar si se excede el límite
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You have reached the limit of 10 elements between photos & videos'),
                                    ),
                                  );
                                  return;
                                }

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
                                if (_images.length + _videos.length >= 10) {
                                  // Mostrar una SnackBar si se excede el límite
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Se ha alcanzado el límite máximo de 10 elementos entre fotos y videos.'),
                                    ),
                                  );
                                  return;
                                }

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
                        ElevatedButton(
                          onPressed: () {
                            // Implementar la lógica para publicar el post
                          },
                          child: Text("Post",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(165, 91, 194, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 12,
                        runSpacing: 5,
                        children: [
                          ..._images
                              .map((image) => _buildImageThumbnail(image)),
                          ..._videos
                              .map((video) => _buildVideoThumbnail(video)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox()
        ],
      ),
    );
  }

  Padding postHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.user.photo),
            radius: 20,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.user.name} ${widget.user.lastName}',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                '@${widget.user.username}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(File imageFile) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _images.remove(imageFile);
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ),
      ],
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
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _videos.remove(videoPath);
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
              FutureBuilder<double?>(
                future: getVideoDuration(videoPath),
                builder: (context, durationSnapshot) {
                  if (durationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else if (durationSnapshot.hasError ||
                      durationSnapshot.data == null) {
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

  Future<double?> getVideoDuration(String videoPath) async {
    print("videopath: $videoPath");
    try {
      final info = FlutterVideoInfo();
      final videoInfo = await info.getVideoInfo(videoPath);
      return videoInfo!.duration;
    } catch (e) {
      print("Error obteniendo información del video: $e");
      return -1; // Maneja el error como desees
    }
  }

  String _formatDuration(double? milliseconds) {
    print("miliseconds: $milliseconds");
    if (milliseconds != null) {
      Duration duration = Duration(milliseconds: milliseconds.floor());
      return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
    } else {
      return ""; // O cualquier valor predeterminado que desees
    }
  }
}
