import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_app/config/app_config.dart';
import 'package:social_media_app/data/response/login_response.dart';
import 'package:social_media_app/data/service/base_service.dart';

class LoginUserService extends ServiceBase<LoginResponse> {
  final String email;
  final String password;

  LoginUserService(this.email, this.password);

  @override
  Future<LoginResponse> call() async {
    debugPrint('Calling Server...');
    debugPrint('$email: $password');
    final result = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    debugPrint(LoginResponse.fromJson(jsonDecode(result.body)).toString());
    return LoginResponse.fromJson(jsonDecode(result.body));
  }
}

sealed class DataResponse {}

final class DataSuccess<T> extends DataResponse {
  final T data;

  DataSuccess(this.data);
}

final class DataFailure extends DataResponse {
  final String error;

  DataFailure(this.error);
}
