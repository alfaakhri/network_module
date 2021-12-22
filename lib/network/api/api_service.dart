import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_module/network/models/models.exports.dart';

const String baseUrl = 'https://api.pexels.com/v1/';

class ApiService {
  static const String _apiKey = '563492ad6f91700001000001768b3a098efb4912a758163e6ef35e51';
  final Dio _dio = Dio();

  Map<String, String> requestHeaders = {'Authorization': _apiKey};

  Future<PhotosModel?> getListPhotos(int limit, int offset) async {
    try {
      final response =
          await _dio.get("$baseUrl/curated?page=$offset&per_page=$limit", options: Options(headers: requestHeaders));
      if (response.statusCode == 200) {
        return PhotosModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load list restaurant');
      }
    } on DioError catch (e) {
      if (DioErrorType.receiveTimeout == e.type || DioErrorType.connectTimeout == e.type) {
        throw Exception("Server is not reachable. Please verify your internet connection and try again");
      } else if (DioErrorType.response == e.type) {
        throw Exception('Failed to load list restaurant');
      } else if (DioErrorType.other == e.type) {
        if (e.message.contains('SocketException')) {
          throw Exception('Problem connecting to the server. Please try again.');
        }
      } else {
        throw Exception("Problem connecting to the server. Please try again.");
      }
    }
  }
}
