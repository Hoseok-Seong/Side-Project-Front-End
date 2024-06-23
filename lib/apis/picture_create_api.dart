import 'package:dio/dio.dart';
import 'package:puppicasso/api_constants.dart';
import 'package:puppicasso/helper/logging_interceptor.dart';
import 'package:puppicasso/models/picture_create_resp.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PictureCreateAPI {
  final Dio _dio;

  PictureCreateAPI() : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<PictureCreateResp> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final response = await _dio.post(
        '/api/picture/create',
        options: Options(headers: {'Authorization_Access': token})
    );

    if (response.statusCode == 200) {
      return PictureCreateResp.fromJson(response.data);
    } else {
      throw Exception("Failed to load data");
    }
  }
}