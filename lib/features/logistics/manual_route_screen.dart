import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/services/map_service.dart'; // 🔥 ASLI SERVICE

class ManualRouteScreen extends StatefulWidget {
  final LatLng? currentLocation;

  const ManualRouteScreen({super.key, this.currentLocation});

  @override
  State<ManualRouteScreen> createState() => _ManualRouteScreenState();
}

class _ManualRouteScreenState extends State<ManualRouteScreen> {
  final MapController _mapController = MapController();
  final MapService _mapService = MapService();

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();

  LatLng? _pickupLatLng;
  LatLng? _dropoffLatLng;
  List<LatLng> _routePoints = [];

  String _distance = '';
  String _duration = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentLocation != null) {
      _pickupLatLng = widget.currentLocation;
      _pickupController.text = "Current Location";
      // Center map to current location
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_pickupLatLng!, 14.0);
      });
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  // 🚀 SENIOR LOGIC: Actual Geocoding and Route Fetching
  Future<void> _calculateRoute() async {
    FocusScope.of(context).unfocus();
    if (_pickupController.text.isEmpty || _dropoffController.text.isEmpty) {
      _showError("Please enter both Pickup and Dropoff locations.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Resolve Pickup if not using current location
      if (_pickupLatLng == null ||
          _pickupController.text != "Current Location") {
        _pickupLatLng = await _mapService.getCoordinatesFromName(
          _pickupController.text,
        );
      }

      // 2. Resolve Dropoff
      _dropoffLatLng = await _mapService.getCoordinatesFromName(
        _dropoffController.text,
      );

      if (_pickupLatLng == null || _dropoffLatLng == null) {
        throw Exception("Could not find one of the locations.");
      }

      // 3. Fetch Route Polyline & ETA
      final routeData = await _mapService.getRouteSummary(
        _pickupLatLng!,
        _dropoffLatLng!,
      );

      if (routeData != null) {
        setState(() {
          _routePoints = routeData['points'];
          _distance = routeData['distance'];
          _duration = routeData['duration'];
        });

        // 4. Adjust map bounds to fit the route perfectly (Google Maps style)
        final bounds = LatLngBounds.fromPoints([
          _pickupLatLng!,
          _dropoffLatLng!,
        ]);
        _mapController.fitCamera(
          CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Stack(
        children: [
          // --- 🗺️ FLUTTER MAP LAYER ---
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _pickupLatLng ?? const LatLng(31.5204, 74.3587),
              initialZoom: 12.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.agriconnect.app',
              ),
              // Real Polylines from OSRM
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 5.0,
                      color: AppColors.primary700,
                      strokeJoin: StrokeJoin.round,
                    ),
                  ],
                ),
              // Markers
              MarkerLayer(
                markers: [
                  if (_pickupLatLng != null)
                    Marker(
                      point: _pickupLatLng!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.radio_button_checked,
                        color: AppColors.success500,
                        size: 24,
                      ),
                    ),
                  if (_dropoffLatLng != null)
                    Marker(
                      point: _dropoffLatLng!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.error500,
                        size: 36,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // --- 🔍 TOP SEARCH BAR (INDRIVE / GOOGLE MAPS STYLE) ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _pickupController,
                            decoration: const InputDecoration(
                              hintText: 'Pickup Location (e.g. Lahore)',
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.radio_button_checked,
                                color: AppColors.success500,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1, indent: 48),
                    Row(
                      children: [
                        const SizedBox(width: 48),
                        Expanded(
                          child: TextField(
                            controller: _dropoffController,
                            decoration: const InputDecoration(
                              hintText: 'Destination (e.g. Multan)',
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.location_on,
                                color: AppColors.error500,
                                size: 16,
                              ),
                            ),
                            onSubmitted: (_) => _calculateRoute(),
                          ),
                        ),
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary700,
                              ),
                            ),
                          )
                        else
                          IconButton(
                            icon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.primary700,
                            ),
                            onPressed: _calculateRoute,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- 🚀 BOTTOM ROUTE DETAILS SHEET (LIKE SCREENSHOT) ---
          if (_routePoints.isNotEmpty && !_isLoading)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _duration,
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.success500,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              'Fastest route due to traffic conditions',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$_distance km',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigation Started!'),
                              backgroundColor: AppColors.success500,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Start Navigation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gray900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
