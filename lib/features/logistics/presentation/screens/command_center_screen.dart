import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../driver_dashboard.dart';

class CommandCenterScreen extends ConsumerStatefulWidget {
  const CommandCenterScreen({super.key});

  @override
  ConsumerState<CommandCenterScreen> createState() =>
      _CommandCenterScreenState();
}

class _CommandCenterScreenState extends ConsumerState<CommandCenterScreen> {
  final MapController _mapController = MapController();
  LatLng? _lastCenteredPosition;

  // Dummy Destination Coordinates (e.g., Bin Qasim Port, Karachi)
  final double _dropoffLat = 24.7981;
  final double _dropoffLng = 67.3406;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverDashboardProvider);
    final notifier = ref.read(driverDashboardProvider.notifier);

    // 🛡️ Error Handling via SnackBar
    ref.listen<DriverDashboardState>(driverDashboardProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error500,
          ),
        );
      }

      // Auto-center map smoothly when location updates (only if moved > 20 meters)
      if (next.currentLocation != null &&
          _mapController.camera.center != const LatLng(0, 0)) {
        if (_lastCenteredPosition == null ||
            const Distance().as(
                  LengthUnit.Meter,
                  _lastCenteredPosition!,
                  next.currentLocation!,
                ) >
                20) {
          _mapController.move(next.currentLocation!, 15.0);
          _lastCenteredPosition = next.currentLocation;
        }
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Command Center', style: AppTextStyles.h4),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 🗺️ TRACKING TOGGLE ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        state.isTracking
                            ? Icons.gps_fixed_rounded
                            : Icons.gps_off_rounded,
                        color: state.isTracking
                            ? AppColors.success500
                            : AppColors.gray400,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Live Tracking',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            state.isTracking
                                ? '${state.currentSpeed.toStringAsFixed(0)} km/h'
                                : 'Offline',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: state.isTracking,
                    activeTrackColor: AppColors.success500,
                    onChanged: (val) => notifier.toggleTracking(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- 🗺️ THE DRIVER LOCATION MAP ---
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gray200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: state.currentLocation == null
                    ? Container(
                        color: AppColors.gray100,
                        child: Center(
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.primary700,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_off_rounded,
                                      color: AppColors.gray400,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Turn on Tracking to view map',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                        ),
                      )
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: state.currentLocation!,
                          initialZoom: 15.0,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.all,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.agriconnect.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: state.currentLocation!,
                                width: 60,
                                height: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary700.withValues(
                                      alpha: 0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.local_shipping_rounded,
                                      color: AppColors.primary700,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 💰 EARNINGS & EFFICIENCY ---
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Weekly Profit',
                    'Rs. 42.5K',
                    Icons.account_balance_wallet_rounded,
                    AppColors.info500,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Efficiency',
                    '5.2 km/L',
                    Icons.speed_rounded,
                    AppColors.warning500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- 📦 ACTIVE SHIPMENT ---
            Text(
              'ACTIVE SHIPMENT',
              style: AppTextStyles.caption.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.gray200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary700.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'WHEAT • 50 TONS',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary700,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text('ETA: 14h', style: AppTextStyles.h4),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, color: AppColors.gray200),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.radio_button_checked_rounded,
                            color: AppColors.success500,
                            size: 20,
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            color: AppColors.gray200,
                          ),
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.error500,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pickup: Multan Grain Market',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Dropoff: Bin Qasim Port, Karachi',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 🔥 THE NATIVE GOOGLE MAPS LAUNCHER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: state.isTracking
                          ? () => notifier.launchNativeNavigation(
                              _dropoffLat,
                              _dropoffLng,
                            )
                          : null,
                      icon: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Navigate with Google Maps',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray900,
                        disabledBackgroundColor: AppColors.gray200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3.copyWith(fontSize: 20)),
          Text(title, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
