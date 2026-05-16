import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppRole { none, supplier, buyer, transporter, admin }

class AuthState {
  final bool isAuthenticated;
  final AppRole currentRole;
  final String userName;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.currentRole = AppRole.none,
    this.userName = 'Guest User',
    this.isLoading = true,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    AppRole? currentRole,
    String? userName,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentRole: currentRole ?? this.currentRole,
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  bool _mounted = true;

  @override
  AuthState build() {
    _mounted = true;
    ref.onDispose(() => _mounted = false);
    Future.microtask(_checkAuthStatus);
    return const AuthState();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!_mounted) return;
      final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      final String savedRole = prefs.getString('user_role') ?? 'none';
      final String savedName = prefs.getString('user_name') ?? 'Verified User';

      AppRole role = AppRole.values.firstWhere(
        (e) => e.toString().split('.').last == savedRole,
        orElse: () => AppRole.none,
      );

      if (!_mounted) return;
      state = state.copyWith(
        isAuthenticated: isLoggedIn,
        currentRole: role,
        userName: savedName,
        isLoading: false,
      );
    } catch (e) {
      if (!_mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loginUser(AppRole role, String name) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1)); // Mock API delay
    if (!_mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_role', role.toString().split('.').last);
    await prefs.setString('user_name', name);

    if (!_mounted) return;
    state = state.copyWith(
      isAuthenticated: true,
      currentRole: role,
      userName: name,
      isLoading: false,
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!_mounted) return;
    state = const AuthState(isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
