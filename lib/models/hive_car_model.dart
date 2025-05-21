import 'package:fleet_app_monitor/models/car_model.dart';
import 'package:hive/hive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'hive_car_model.g.dart';

@HiveType(typeId: 0)
class HiveCarModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double latitude;

  @HiveField(3)
  double longitude;

  @HiveField(4)
  double speed;

  @HiveField(5)
  String status;

  @HiveField(6)
  DateTime lastUpdated;

  @HiveField(7)
  List<HiveLatLng> route;

  HiveCarModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.status,
    required this.lastUpdated,
    required this.route,
  });

  factory HiveCarModel.fromCarModel(CarModel car) {
    return HiveCarModel(
      id: car.id,
      name: car.name,
      latitude: car.latitude,
      longitude: car.longitude,
      speed: car.speed,
      status: car.status,
      lastUpdated: car.lastUpdated,
      route: car.route.map((r) => HiveLatLng(r.latitude, r.longitude)).toList(),
    );
  }

  CarModel toCarModel() {
    return CarModel(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      speed: speed,
      status: status,
      lastUpdated: lastUpdated,
      route: route.map((r) => LatLng(r.latitude, r.longitude)).toList(),
    );
  }
}

@HiveType(typeId: 1)
class HiveLatLng {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  HiveLatLng(this.latitude, this.longitude);
}
