import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:communiverse/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CommuniverseProvider extends ChangeNotifier {
  static String _baseUrl = AppConfig.BaseApiUrl;
  static String apiKey = '';
  static String apiAuthRoutes = "api/auth/";

  static Future<String> postJsonData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.http(_baseUrl, endpoint);
    print("url : $url");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': apiKey,
    };
    String jsonData = json.encode(data);
    try {
      final response = await http.post(url, headers: headers, body: jsonData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Solicitud POST exitosa');
        print(response.body);
        return response.body;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        throw Exception(
            response.body); // Lanza el cuerpo de la respuesta como excepción
      }
    } catch (error) {
      if (error is SocketException) {
        print('Error de red: $error');
      } else if (error is http.ClientException) {
        print('Error de cliente HTTP: $error');
      } else {
        print('Error desconocido: $error');
      }
      throw Exception('$error');
    }
  }

  static Future<String> getJsonData(String endpoint) async {
    final url = Uri.http(_baseUrl, endpoint);
    print("url : $url");
    Map<String, String> headers = {
      'Authorization': apiKey,
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print('Solicitud GET exitosa');
        print(response.body);
        return response.body;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      if (error is SocketException) {
        print('Error de red: $error');
      } else if (error is http.ClientException) {
        print('Error de cliente HTTP: $error');
      } else {
        print('Error desconocido: $error');
      }
      throw Exception('Error durante la solicitud: $error');
    }
  }

  static Future<String> putJsonData(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.http(_baseUrl, endpoint);
    print("url : $url");
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': apiKey,
    };
    String jsonData = json.encode(data);
    try {
      final response = await http.put(url, headers: headers, body: jsonData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Solicitud exitosa');
        print(response.body);
        return response.body;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      if (error is SocketException) {
        print('Error de red: $error');
      } else if (error is http.ClientException) {
        print('Error de cliente HTTP: $error');
      } else {
        print('Error desconocido: $error');
      }
      throw Exception('Error durante la solicitud: $error');
    }
  }

  static Future<String> deleteJsonData(String endpoint) async {
    final url = Uri.http(_baseUrl, endpoint);
    Map<String, String> headers = {
      'Authorization': apiKey,
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Solicitud DELETE exitosa');
        print(response.body);
        return response.body;
      } else {
        print('Error en la solicitud: ${response.statusCode}');
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      if (error is SocketException) {
        print('Error de red: $error');
      } else if (error is http.ClientException) {
        print('Error de cliente HTTP: $error');
      } else {
        print('Error desconocido: $error');
      }
      throw Exception('Error durante la solicitud: $error');
    }
  }
}
