import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'car_model.g.dart';

@HiveType(typeId: 0)
class CarModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final double speed;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final DateTime lastUpdated;

  List<LatLng> route;

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

  CarModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    double? speed,
    String? status,
    DateTime? lastUpdated,
    List<LatLng>? route,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      route: route ?? this.route,
    );
  }
}

enum CarFilter { all, moving, parked }
