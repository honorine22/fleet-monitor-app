import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double speed;
  final String status;
  final DateTime lastUpdated;

  List<LatLng> route; // ← NEW

  CarModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.status,
    required this.lastUpdated,
    List<LatLng>? route,
  }) : route = route ?? [LatLng(latitude, longitude)];

  factory CarModel.fromJson(Map<String, dynamic> json) {
    final lat = (json['latitude'] as num).toDouble();
    final lng = (json['longitude'] as num).toDouble();
    return CarModel(
      id: json['id'],
      name: json['name'],
      latitude: lat,
      longitude: lng,
      speed: (json['speed'] as num).toDouble(),
      status: json['status'],
      lastUpdated:
          DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
      route: [LatLng(lat, lng)],
    );
  }

  CarModel copyWithUpdatedLocation(
    double lat,
    double lng,
    DateTime lastUpdate,
  ) {
    return CarModel(
      id: id,
      name: name,
      latitude: lat,
      longitude: lng,
      speed: speed,
      status: status,
      lastUpdated: lastUpdate,
      route: [...route, LatLng(lat, lng)], // Add new position to route
    );
  }
}

enum CarFilter {
  all,
  moving,
  parked,
}
