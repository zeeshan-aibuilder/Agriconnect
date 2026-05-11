import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  Future<bool> requestOtp(String phoneOrEmail, String method) async {
    try {
      // Backend ko request bhejein
      final response = await _dioClient.dio.post(
        '/auth/request-otp',
        data: {method == 'phone' ? 'phone' : 'email': phoneOrEmail},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network Error');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
    String phone,
    String otp, {
    String? name,
    String? roleId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/verify-otp',
        data: {'phone': phone, 'otp': otp, 'name': name, 'role_id': roleId},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Verification Failed');
    }
  }
}
