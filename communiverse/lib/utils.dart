import 'dart:convert';
import 'dart:io';

import 'package:communiverse/models/models.dart';
import 'package:communiverse/screens/screens.dart';
import 'package:communiverse/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Utils {
  static void openImageInFullScreen(
      BuildContext context, String imageUrl, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          imageUrl: imageUrl,
          post: post,
        ),
      ),
    );
  }

  static void openVideoInFullScreen(
      BuildContext context, String videoUrl, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideo(videoUrl: videoUrl, post: post),
      ),
    );
  }

  void _pickImage(
      ImageSource source,
      UserService userService,
      UserLoginRequestService userLoginRequestService,
      Function() onImageSelected) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        // Crear un objeto File a partir de la ruta de la imagen seleccionada
        File imageFile = File(pickedFile.path);
        print(pickedFile.path);

        // Convertir la imagen a bytes
        List<int> imageBytes = await imageFile.readAsBytes();

        // Convertir los bytes de la imagen a base64
        String base64Image = base64Encode(imageBytes);

        Map<String, dynamic> imageData = {
          '': base64Image, // Pasar la imagen como base64
        };

        // Llamar a la función editPhotoUser con los bytes de la imagen
        await userLoginRequestService.editPhotoUser(
            userService.user.id, imageData);
        await userService
            .findUserById(UserLoginRequestService.userLoginRequest.id);

        // Llamar a la función de devolución de llamada
        await onImageSelected();
      }
    } catch (error) {
      print("ERROR EN FOTO");
    }
  }

  void showImageOptions(
      BuildContext context,
      UserService userService,
      UserLoginRequestService userLoginRequestService,
      Function() onImageSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black, // Cambia el color de fondo a negro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(
                20.0)), // Agrega bordes redondeados en la parte superior
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildOption(
                context,
                Icon(Icons.photo_outlined,
                    color: Colors
                        .white), // Icono para seleccionar desde la galería
                Text('Select from gallery',
                    style: TextStyle(
                        color: Colors
                            .white)), // Texto para seleccionar desde la galería
                () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, userService,
                      userLoginRequestService, onImageSelected);
                },
              ),
              Divider(
                  height: 0,
                  thickness: 1,
                  color: Colors.white), // Línea divisoria entre las opciones
              _buildOption(
                context,
                Icon(Icons.camera_alt_outlined,
                    color: Colors.white), // Icono para tomar una foto
                Text('Take a photo',
                    style: TextStyle(
                        color: Colors.white)), // Texto para tomar una foto
                () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, userService,
                      userLoginRequestService, onImageSelected);
                },
              ),
              Divider(
                  height: 0,
                  thickness: 1,
                  color: Colors.white), // Línea divisoria entre las opciones
              _buildOption(
                context,
                Icon(Icons.delete,
                    color: Colors.red), // Icono para eliminar la foto
                Text('Delete photo',
                    style: TextStyle(
                        color: Colors.red)), // Texto para eliminar la foto
                () {
                  Navigator.pop(context);
                  _removeImage(userService, userLoginRequestService);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static String fileToBase64(File file) {
    List<int> fileBytes = file.readAsBytesSync();
    String base64Image = base64Encode(fileBytes);
    return base64Image;
  }

  static List<String> filesToBase64List(List<File> files) {
    List<String> base64List = [];
    for (File file in files) {
      base64List.add(fileToBase64(file));
    }
    return base64List;
  }

  static Future<double?> getVideoDuration(String videoUrl) async {
    try {
      final info = FlutterVideoInfo();
      final videoFile = await _downloadFile(videoUrl);
      if (videoFile != null) {
        final videoInfo = await info.getVideoInfo(videoFile.path);
        await videoFile.delete(); // Borra el archivo temporal después de obtener la información del video
        return videoInfo!.duration;
      } else {
        return null;
      }
    } catch (e) {
      print("Error obteniendo información del video: $e");
      return null;
    }
  }

  static Future<File?> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_video.mp4';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print("Error descargando el archivo: $e");
      return null;
    }
  }

    static String formatDuration(double? milliseconds) {
    print("miliseconds: $milliseconds");
    if (milliseconds != null) {
      Duration duration = Duration(milliseconds: milliseconds.floor());
      return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
    } else {
      return ""; // O cualquier valor predeterminado que desees
    }
  }

  Widget _buildOption(
      BuildContext context, Widget leading, Widget title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: leading,
        title: title,
      ),
    );
  }

  void _removeImage(UserService userService,
      UserLoginRequestService userLoginRequestService) {
    userService.user.photo = ''; // Vacía el campo de la foto
    Map<String, dynamic> data = {
      '': "",
    };
    print("data: $data");
    userLoginRequestService.editPhotoUser(userService.user.id, data);
  }
}
