import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../core/services/location_service.dart';

class DriverDashboardController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final MapController mapController = MapController();

  StreamSubscription<Position>? _positionSubscription;

  bool isTrackingActive = false;
  bool isMapReady = false;
  LatLng? currentLatLng;
  LatLng? _lastMovedPosition;
  double currentSpeedKmh = 0.0;
  String errorMessage = '';

  /// Toggles live tracking and handles stream lifecycle
  Future<void> toggleTracking(bool enable) async {
    if (enable) {
      final hasPermission = await _locationService.handleLocationPermission();
      if (!hasPermission) {
        errorMessage = 'Location permission denied. Please enable GPS.';
        notifyListeners();
        return;
      }

      isTrackingActive = true;
      isMapReady = true;
      errorMessage = '';
      notifyListeners();

      _positionSubscription = _locationService.getPositionStream().listen(
        (Position position) {
          currentSpeedKmh = position.speed * 3.6; // Convert m/s to km/h
          currentLatLng = LatLng(position.latitude, position.longitude);

          // Optimize Map Movement: Only move camera if distance changed significantly (>20m)
          if (_lastMovedPosition == null ||
              _calculateDistance(_lastMovedPosition!, currentLatLng!) > 20) {
            mapController.move(currentLatLng!, 16.0);
            _lastMovedPosition = currentLatLng;
          }
          notifyListeners();
        },
        onError: (error) {
          errorMessage = 'GPS Signal Lost.';
          isTrackingActive = false;
          notifyListeners();
        },
      );
    } else {
      _stopTracking();
    }
  }

  void _stopTracking() {
    isTrackingActive = false;
    currentSpeedKmh = 0.0;
    isMapReady = false;
    _positionSubscription?.cancel();
    _positionSubscription = null;
    notifyListeners();
  }

  /// Opens Native Google Maps using current coordinates
  Future<void> launchNativeNavigation() async {
    if (currentLatLng != null) {
      await _locationService.openGoogleMaps(
        currentLatLng!.latitude,
        currentLatLng!.longitude,
      );
    } else {
      errorMessage = 'Waiting for GPS signal to launch Maps...';
      notifyListeners();
    }
  }

  double _calculateDistance(LatLng pos1, LatLng pos2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, pos1, pos2);
  }

  @override
  void dispose() {
    _stopTracking();
    mapController.dispose();
    super.dispose();
  }
}
