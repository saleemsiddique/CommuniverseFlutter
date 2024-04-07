import 'dart:io';
import 'dart:typed_data';

import 'package:communiverse/models/models.dart';
import 'package:communiverse/services/services.dart';
import 'package:communiverse/utils.dart';
import 'package:communiverse/widgets/community_dropdown.dart';
import 'package:communiverse/widgets/widgets.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<File> _images = [];
  List<String> _videos = [];
  TextEditingController _textController = TextEditingController();
  TextEditingController _communityController = TextEditingController();
  bool hasMedia = false;
  int _maxLines = 5;
  String selectedCommunityName =
      'Choose Community'; // Variable dentro del estado del widget

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color.fromRGBO(165, 91, 194, 0.2),
              height: _images.isNotEmpty || _videos.isNotEmpty
                  ? size.height * 0.62
                  : size.height * 0.50,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    postHeader(context),
                    SizedBox(height: 20),
                    postContent(),
                    SizedBox(height: 20),
                    postButtons(context),
                    SizedBox(height: 20),
                    postMedia()
                  ],
                ),
              ),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }

  Padding postMedia() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 12,
          runSpacing: 5,
          children: [
            ..._images.map((image) => _buildImageThumbnail(image)),
            ..._videos.map((video) => _buildVideoThumbnail(video)),
          ],
        ),
      ),
    );
  }

  postButtons(BuildContext context) {
    final postService = Provider.of<PostService>(context, listen: true);
    return Container(
      color: Color.fromRGBO(
          165, 91, 194, 1), // Establece el color de fondo del Container
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
                    print("video from createPost: $pickedFile");
                    setState(() {
                      _videos.add(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: (_formKey.currentState?.validate() != true &&
                          _images.isEmpty &&
                          _videos.isEmpty) ||
                      _communityController.text == ''
                  ? null
                  : () async {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Evita que se cierre la ventana emergente haciendo clic fuera de ella
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(), // Indicador de progreso
                                SizedBox(
                                    width:
                                        20), // Espacio entre el indicador y el texto
                                Text(
                                    "Posting..."), // Texto que indica que se está publicando
                              ],
                            ),
                          );
                        },
                      );

                      try {
                        Map<String, dynamic> postData = {
                          "community_id": _communityController.text,
                          'author_id': widget.user.id,
                          'content': _textController.text,
                          'photos': Utils.filesToBase64List(_images),
                          'videos': _videos.isNotEmpty
                              ? Utils.filesToBase64List(
                                  _videos.map((url) => File(url)).toList())
                              : [],
                          "postInteractions": PostInteractions.empty(),
                          "quizz": Quizz.empty(),
                          "comment": false
                        };
                        await postService.postPost(postData, "none");
                        postService.currentPostPage = 0;
                        await postService.findMyPostsPaged(widget.user.id);
                        Navigator.pop(
                            context); // Cierra el diálogo emergente cuando la publicación se ha realizado correctamente
                        Navigator.pop(
                            context); // Cierra la pantalla de creación de publicaciones
                      } catch (error) {
                        Navigator.pop(
                            context); // Cierra el diálogo emergente si hay un error
                        errorTokenExpired(context);
                      }
                    },
              child: Text("Post", style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding postContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
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
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onChanged: (text) {
          final lines = text.split('\n');
          if (lines.length > _maxLines) {
            _textController.text = lines.sublist(0, _maxLines).join('\n');
          }
          // Actualizar el estado del formulario
          setState(() {});
        },
      ),
    );
  }

  Padding postHeader(BuildContext context) {
    final communityService =
        Provider.of<CommunityService>(context, listen: false);
    final communities = communityService.myCommunities;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 20,
                // Usar la nueva URL con el identificador único para cargar la imagen
                backgroundImage: widget.user.photo != ""
                    ? NetworkImage(widget.user.photo)
                    : AssetImage('assets/no-user.png')
                        as ImageProvider<Object>?,
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
          CommunityDropdown(
            communities: communityService.myCommunities,
            communityController: _communityController,
            onChanged: (selectedCommunity) {
              setState(() {
                // Aquí puedes hacer cualquier acción necesaria después de seleccionar una comunidad
              });
            },
          )
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
                future: _getVideoDuration(videoPath),
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
                        Utils.formatDuration(durationSnapshot.data!),
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

  Future<double?> _getVideoDuration(String videoPath) async {
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

  Future<Uint8List?> _getVideoThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100,
      quality: 25,
    );
  }
}
