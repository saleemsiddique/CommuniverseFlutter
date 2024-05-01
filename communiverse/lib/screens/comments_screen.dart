import 'dart:io';
import 'dart:typed_data';

import 'package:communiverse/services/services.dart';
import 'package:communiverse/utils.dart';
import 'package:communiverse/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:communiverse/models/post.dart';
import 'package:communiverse/widgets/post_widget.dart';
import 'package:communiverse/services/post_service.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  final PostService postService;

  const CommentsScreen(
      {Key? key, required this.post, required this.postService})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late ScrollController _scrollController;
  TextEditingController _commentController = TextEditingController();
  bool _loading = false;
  List<File> _images = [];
  List<String> _videos = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    final postService = widget.postService;
    final userService = Provider.of<UserService>(context, listen: true);

    postService.currentPostPage = 0;
    postService.currentRepostPage = 0;
    postService.currentCommunityPostPage = 0;
    postService.currentCommunityQuizzPage = 0;
    postService.currentMySpacePage = 0;
    postService.findMyPostsPaged(UserLoginRequestService.userLoginRequest.id);
    postService.findMyRePostsPaged(UserLoginRequestService.userLoginRequest.id);
    postService.getAllPostsFromCommunity(widget.post.communityId);
    postService.getAllQuizzFromCommunity(widget.post.communityId);
    postService.getMySpaceFromCommunity(
        widget.post.communityId, userService.user.followedId);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final postService = widget.postService;
    if (!_loading &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _loading = true;
      });
      postService.findMyCommentsPaged(widget.post.id).then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(165, 91, 194, 0.2),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Principal post
                // Your PostWidget goes here
                // Replace the following line with your PostWidget
                SizedBox(height: 20),
                PostWidget(post: widget.post, isExtend: true),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                // Lista de comentarios
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildCommentsList(),
                      ),
                      _buildCommentInput(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Back Button
          Positioned(
            top: 15,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    final List<Post> comments = widget.postService.comments;

    // Verificar si la lista de comentarios está vacía
    if (comments.isEmpty && !_loading) {
      return Center(
        child: Text(
          'No comments',
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: comments.length + (_loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < comments.length) {
          final Post comment = comments[index];
          return PostWidget(post: comment, isExtend: false);
        } else {
          return CircularProgressIndicator(); // Indicador de carga al final de la lista
        }
      },
    );
  }

  Widget _buildCommentInput() {
    final commentFormKey = GlobalKey<FormState>(); // Aquí se declara el formKey

    final userService = Provider.of<UserService>(context, listen: false);
    final userCommunities = [
      ...userService.user.createdCommunities,
      ...userService.user.moderatedCommunities,
      ...userService.user.memberCommunities,
    ];

    final isCommunityMember = userCommunities.contains(widget.post.communityId);

    if (!isCommunityMember) {
      return SizedBox
          .shrink(); // Si el usuario no es miembro de la comunidad, oculta el widget
    }

    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: commentFormKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
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
                    _pickImage();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () {
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
                    _pickVideo();
                  },
                ),
                Expanded(
                  child: TextFormField(
                    maxLines: 1,
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Comment cannot be empty';
                      }
                      final newLinesCount = value.split('\n').length - 1;
                      if (newLinesCount > 3) {
                        // Cambiado a 3 líneas máximas permitidas
                        return 'Comment cannot have more than 3 lines';
                      }
                      return null;
                    },
                    maxLength: 200,
                    onChanged: (text) {
                      final lines = text.split('\n');
                      if (lines.length > 4) {
                        // Cambiado a 5 para bloquear después de 4 líneas
                        _commentController.text = lines
                            .sublist(0, 3)
                            .join('\n'); // Cambiado a 4 líneas
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (commentFormKey.currentState!.validate() ||
                        _images.isNotEmpty ||
                        _videos.isNotEmpty) {
                      _submitComment();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            postMedia(),
            SizedBox(height: 8),
            // Mostrar fotos y videos seleccionados
          ],
        ),
      ),
    );
  }

  postMedia() {
    return SingleChildScrollView(
      child: Padding(
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
      ),
    );
  }

  void _pickVideo() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        _videos.add(pickedFile.path);
        setState(() {});
      }
    } catch (error) {
      print("Error selecting video: $error");
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _images.add(File(pickedFile.path));
      setState(() {});
    }
  }

  Future<void> _submitComment() async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que se cierre la ventana emergente haciendo clic fuera de ella
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(), // Indicador de progreso
              SizedBox(width: 20), // Espacio entre el indicador y el texto
              Text("Posting..."), // Texto que indica que se está publicando
            ],
          ),
        );
      },
    );

    try {
      final String commentText = _commentController.text.trim();
      if (commentText.isNotEmpty) {
        final postService = widget.postService;
        final Map<String, dynamic> commentData = {
          'community_id': widget.post.communityId,
          'author_id': UserLoginRequestService.userLoginRequest.id,
          'content': commentText,
          'photos': Utils.filesToBase64List(_images), // Agrega las fotos
          'videos': _videos.isNotEmpty
              ? Utils.filesToBase64List(
                  _videos.map((url) => File(url)).toList())
              : [],
          "postInteractions": PostInteractions.empty(),
          "quizz": Quizz.empty(),
          "comment": true
        };
        await postService.postPost(commentData, widget.post.id);
        postService.currentCommentPage = 0;
        await postService.findMyCommentsPaged(widget.post.id);
        Navigator.pop(context);
        setState(() {
          _images.clear();
          _videos.clear();
          _commentController.text = "";
          print("Updated Comments");
        });
      }
    } catch (e) {
      print(e.toString());
      errorTokenExpired(context);
    }
  }

  Widget _buildImageThumbnail(File imageFile) {
    return Stack(
      children: [
        Container(
          width: 63,
          height: 63,
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
