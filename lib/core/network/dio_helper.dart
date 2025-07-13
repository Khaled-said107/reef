import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://82.29.172.199:8001/api/v1/',
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  static Future<Response> postData({
    required String? url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    print('Sending data: $data');

    final response = await dio.post(
      url!,
      queryParameters: query,
      data: data,
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    return response;
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final fullUrl = '${dio.options.baseUrl}$url';
    print('🔗 Requesting: $fullUrl');
    print('📦 Query: $query');
    print('🔑 Headers: $headers');

    try {
      return await dio.get(
        url,
        queryParameters: query,
        options: Options(headers: headers),
      );
    } catch (e) {
      print("❌ Dio Get Error: $e");
      rethrow;
    }
  }

  // static Future<Response> patchData({
  //   required String url,
  //   Map<String, dynamic>? data,
  //   Map<String, dynamic>? query,
  //   String? token,
  // }) async {
  //   dio.options.headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': token != null ? 'Bearer $token' : '',
  //   };
  //
  //   return await dio.patch(url, data: data, queryParameters: query);
  // }

  static Future<Response> postMultipartData({
    required String url,
    required FormData data,
    String? token,
  }) async {
    return await dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  static Future<Response> putData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String? token,
    bool isFormData = false,
  }) async {
    dio.options.headers = {
      'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      'Authorization': 'Bearer $token',
    };

    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> patchData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return await dio.patch(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response?> deleteData({
    required String? url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    if (url == null) {
      throw Exception('❌ URL must not be null.');
    }

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    print('🔴 Deleting data: $data');

    try {
      Response response = await dio.delete(
        url,
        queryParameters: query,
        data: data, // بعض APIs تسمح بإرسال body مع DELETE
      );
      print('✅ Response status: ${response.statusCode}');
      print('✅ Response data: ${response.data}');
      return response;
    } catch (e) {
      if (e is DioError) {
        print('❌ DioError: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('❌ Error: $e');
      }
      return null;
    }
  }

  static Future<Response> postDataPayment({
    required String url,
    required File img,
    required String token,
  }) async {
    final formData = FormData.fromMap({
      'receiptImage': await MultipartFile.fromFile(img.path,
          filename: img.path.split('/').last,
          contentType: MediaType("image", "jpg")),
    });
    return await dio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
        sendTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }
}
