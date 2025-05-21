import 'dart:async';
import 'package:fleet_app_monitor/providers/car_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import '../models/car_model.dart';

final carProvider = StateNotifierProvider<CarNotifier, List<CarModel>>((ref) {
  return CarNotifier();
});

class CarNotifier extends StateNotifier<List<CarModel>> {
  Timer? _timer;
  Timer? _trackingTimer;
  String? _currentlyTrackingId;

  CarNotifier() : super([]) {
    _loadFromCache();
  }

  Future<void> _loadFromCache() async {
    final box = await Hive.openBox<CarModel>('carsBox');
    state = box.values.toList();
  }

  void startFetchingCars() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchCars());
  }

  bool isTracking(String carId) => _currentlyTrackingId == carId;

  void startTrackingCar(String carId) {
    _currentlyTrackingId = carId;

    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final index = state.indexWhere((car) => car.id == carId);
      if (index != -1) {
        final currentCar = state[index];

        // Simulate updated position (in real app, fetch from backend)
        final updatedCar = currentCar.copyWith(
          latitude: currentCar.latitude + 0.0001,
          longitude: currentCar.longitude + 0.0001,
          route: [
            ...currentCar.route,
            LatLng(currentCar.latitude + 0.0001, currentCar.longitude + 0.0001),
          ],
        );

        // Create new list with updated car to trigger UI update
        final updatedCars = [...state];
        updatedCars[index] = updatedCar;
        state = updatedCars;
      }
    });
  }

  void stopTracking() {
    _currentlyTrackingId = null;
    _trackingTimer?.cancel();
    _trackingTimer = null;
  }

  Future<void> _fetchCars() async {
    final updatedList = await CarApiService.fetchCars();
    final box = await Hive.openBox<CarModel>('carsBox');

    await box.clear();
    for (final car in updatedList) {
      await box.put(car.id, car);
    }

    state = updatedList;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
