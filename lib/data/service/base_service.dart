import 'dart:convert';

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
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String apiUrl, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      final response = await MyRequest(token).post(
        _getParsedUrl(apiUrl),
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception();
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
