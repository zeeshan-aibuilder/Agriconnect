import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          // Physical device testing ke liye laptop ka IP use karna lazmi hai
          baseUrl: 'http://192.168.100.37:3000/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  // Future mein JWT token pass karne ke liye interceptor
  void addToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
