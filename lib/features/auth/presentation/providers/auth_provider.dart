import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agriconnect/core/network/dio_client.dart';
import 'package:agriconnect/features/auth/data/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({this.isLoading = false, this.error});

  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = AuthRepository(DioClient());
    return const AuthState();
  }

  // 1. Send OTP Logic
  Future<bool> requestOtp(String phoneOrEmail, String method) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.requestOtp(phoneOrEmail, method);
      if (!success) {
        state = state.copyWith(
          isLoading: false,
          error: 'Unable to send OTP. Please try again.',
        );
        return false;
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // 2. Verify OTP Logic (NAYA ADD KIYA HAI)
  Future<bool> verifyOtp(String phone, String otp, String role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Prototype ke liye hum name "User" aur role pass kar rahe hain
      final response = await _repository.verifyOtp(
        phone,
        otp,
        name: "Premium User",
        roleId: role,
      );

      // Yahan se jo Token aayega usko Dio Client mein add kar denge taake aage ki API calls secure hon
      // DioClient().addToken(response['token']);

      state = state.copyWith(isLoading: false);
      return true; // Verification Success
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false; // Verification Failed
    }
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
