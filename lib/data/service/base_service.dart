import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:social_media_app/config/app_config.dart';
import 'package:http/http.dart' as http;

abstract class ServiceBase<T> {
  Future<T> call();

  Uri _getParsedUrl(String url) => Uri.parse('${AppConfig.baseUrl}/$url');

  Future<Map<String, dynamic>> get(String apiUrl, {String? token}) async {
    try {
      final response = await MyRequest(token).get(_getParsedUrl(apiUrl));
      return _handleResponse(response);
    } on Exception catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String apiUrl, {
    Map<String, dynamic> body = const {},
    String? token,
  }) async {
    try {
      final response = await MyRequest(token).post(
        _getParsedUrl(apiUrl),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  // void upload(String apiUrl, String field) async {
  //   final client = http.MultipartRequest('POST', _getParsedUrl(apiUrl));
  //   client.files.add(await http.MultipartFile.fromPath(
  //     field,
  //     field,
  //     filename: field.split('/').last,
  //   ));
  //   final response = await client.send();
  //   final res = await http.Response.fromStream(response);
  //   print(res.body);
  // }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = jsonDecode(response.body);
    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    } else {
      throw Exception(responseBody['message']);
    }
  }
}

class MyRequest extends http.BaseClient {
  final String? token;

  MyRequest([this.token]);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (token != null) {
      request.headers['Authorization'] = 'Bearer  $token';
    }
    if (request.method == 'POST') {
      request.headers['Content-Type'] = 'application/json';
    }
    return request.send();
  }
}
