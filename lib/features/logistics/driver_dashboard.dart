import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/location_service.dart';

class DriverDashboardState {
  final bool isTracking;
  final bool isLoading;
  final LatLng? currentLocation;
  final double currentSpeed;
  final String? error;

  DriverDashboardState({
    this.isTracking = false,
    this.isLoading = false,
    this.currentLocation,
    this.currentSpeed = 0.0,
    this.error,
  });

  DriverDashboardState copyWith({
    bool? isTracking,
    bool? isLoading,
    LatLng? currentLocation,
    double? currentSpeed,
    String? error,
    bool clearError = false,
  }) {
    return DriverDashboardState(
      isTracking: isTracking ?? this.isTracking,
      isLoading: isLoading ?? this.isLoading,
      currentLocation: currentLocation ?? this.currentLocation,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final locationServiceProvider = Provider((ref) => LocationService());

final driverDashboardProvider =
    NotifierProvider<DriverDashboardNotifier, DriverDashboardState>(
      DriverDashboardNotifier.new,
    );

class DriverDashboardNotifier extends Notifier<DriverDashboardState> {
  StreamSubscription<Position>? _positionSub;
  bool _mounted = true;

  @override
  DriverDashboardState build() {
    _mounted = true;
    ref.onDispose(() {
      _mounted = false;
      _positionSub?.cancel();
    });
    return DriverDashboardState();
  }

  LocationService get _locationService => ref.read(locationServiceProvider);

  Future<void> toggleTracking() async {
    if (state.isTracking) {
      _stopTracking();
    } else {
      await _startTracking();
    }
  }

  Future<void> _startTracking() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final hasPermission = await _locationService.handleLocationPermission();
    if (!hasPermission) {
      if (_mounted) {
        state = state.copyWith(
          isLoading: false,
          error: 'Location permission denied. Please enable GPS.',
        );
      }
      return;
    }

    if (!_mounted) return;
    state = state.copyWith(isTracking: true, isLoading: false);

    _positionSub?.cancel();
    _positionSub = _locationService.getPositionStream().listen(
      (Position position) {
        if (_mounted) {
          state = state.copyWith(
            currentLocation: LatLng(position.latitude, position.longitude),
            currentSpeed: position.speed * 3.6,
          );
        }
      },
      onError: (e) {
        if (_mounted) {
          state = state.copyWith(
            error: 'GPS Signal Lost. Retrying...',
            isTracking: false,
          );
        }
        _positionSub?.cancel();
      },
    );
  }

  void _stopTracking() {
    _positionSub?.cancel();
    _positionSub = null;
    if (_mounted) {
      state = state.copyWith(isTracking: false, currentSpeed: 0.0);
    }
  }

  Future<void> launchNativeNavigation(double destLat, double destLng) async {
    if (state.currentLocation != null) {
      try {
        await _locationService.openGoogleMaps(destLat, destLng);
      } catch (e) {
        if (_mounted)
          state = state.copyWith(error: 'Could not open Google Maps.');
      }
    } else {
      if (_mounted)
        state = state.copyWith(
          error: 'Wait for GPS lock to launch Navigation.',
        );
    }
  }
}
