import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class MapService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {'User-Agent': 'AgriConnectApp/1.0 (contact@agriconnect.pk)'},
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  Future<LatLng?> getCoordinatesFromName(String address) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {'q': address, 'format': 'json', 'limit': 1},
      );

      if (response.statusCode == 200 && (response.data as List).isNotEmpty) {
        final data = response.data[0];
        return LatLng(double.parse(data['lat']), double.parse(data['lon']));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to resolve address: $address');
    }
  }

  Future<Map<String, dynamic>?> getRouteSummary(
    LatLng start,
    LatLng end,
  ) async {
    try {
      final response = await _dio.get(
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}',
        queryParameters: {'overview': 'full', 'geometries': 'geojson'},
      );

      if (response.statusCode == 200 && response.data['routes'].isNotEmpty) {
        final route = response.data['routes'][0];
        final geometry = route['geometry']['coordinates'] as List;

        List<LatLng> points = geometry
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
        final double distanceKm = route['distance'] / 1000.0;
        final double durationMin = route['duration'] / 60.0;

        return {
          'points': points,
          'distance': distanceKm.toStringAsFixed(1),
          'duration': _formatDuration(durationMin),
        };
      }
      return null;
    } catch (e) {
      throw Exception('Route calculation failed. Check network.');
    }
  }

  String _formatDuration(double totalMinutes) {
    if (totalMinutes < 60) return '${totalMinutes.toStringAsFixed(0)} min';
    final int hours = totalMinutes ~/ 60;
    final int minutes = (totalMinutes % 60).toInt();
    return '$hours hr $minutes min';
  }
}
