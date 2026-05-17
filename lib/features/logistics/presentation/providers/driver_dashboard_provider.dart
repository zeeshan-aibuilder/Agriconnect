import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDashboardState {
  final bool isOnline;
  final bool isLoading;
  final String? error;

  final double weeklyEarnings;
  final double todayEarnings;
  final int totalTrips;

  final bool hasActiveShipment;
  final String loadType;
  final String pickupLocation;
  final String dropoffLocation;
  final String eta;
  final String shipmentStatus;

  const DriverDashboardState({
    this.isOnline = false,
    this.isLoading = false,
    this.error,
    this.weeklyEarnings = 0.0,
    this.todayEarnings = 0.0,
    this.totalTrips = 0,
    this.hasActiveShipment = false,
    this.loadType = '',
    this.pickupLocation = '',
    this.dropoffLocation = '',
    this.eta = '',
    this.shipmentStatus = '',
  });

  DriverDashboardState copyWith({
    bool? isOnline,
    bool? isLoading,
    String? error,
    bool clearError = false,
    double? weeklyEarnings,
    double? todayEarnings,
    int? totalTrips,
    bool? hasActiveShipment,
    String? loadType,
    String? pickupLocation,
    String? dropoffLocation,
    String? eta,
    String? shipmentStatus,
  }) {
    return DriverDashboardState(
      isOnline: isOnline ?? this.isOnline,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      totalTrips: totalTrips ?? this.totalTrips,
      hasActiveShipment: hasActiveShipment ?? this.hasActiveShipment,
      loadType: loadType ?? this.loadType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      eta: eta ?? this.eta,
      shipmentStatus: shipmentStatus ?? this.shipmentStatus,
    );
  }
}

class DriverDashboardNotifier extends Notifier<DriverDashboardState> {
  bool _mounted = true;

  @override
  DriverDashboardState build() {
    _mounted = true;
    ref.onDispose(() => _mounted = false);
    return const DriverDashboardState();
  }

  void toggleOnlineStatus() {
    state = state.copyWith(isOnline: !state.isOnline);
  }

  void resetError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!_mounted) return;

      state = state.copyWith(
        isLoading: false,
        weeklyEarnings: 42500.0,
        todayEarnings: 8200.0,
        totalTrips: 14,
        hasActiveShipment: true,
        loadType: 'Wheat • 50 Tons',
        pickupLocation: 'Multan Grain Market',
        dropoffLocation: 'Bin Qasim Port, Karachi',
        eta: '14h 30m',
        shipmentStatus: 'Pending Pickup',
      );
    } catch (e) {
      if (!_mounted) return;
      state = state.copyWith(isLoading: false, error: 'Failed to load data.');
    }
  }

  Future<void> launchNativeNavigation(double destLat, double destLng) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng',
    );
    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (_mounted)
          state = state.copyWith(error: 'Could not open Google Maps.');
      }
    } catch (e) {
      if (_mounted)
        state = state.copyWith(error: 'Failed to launch map navigation.');
    }
  }
}

final driverDashboardProvider =
    NotifierProvider<DriverDashboardNotifier, DriverDashboardState>(
      DriverDashboardNotifier.new,
    );
