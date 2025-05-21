import 'dart:async';
import 'package:fleet_app_monitor/core/constants.dart';
import 'package:fleet_app_monitor/models/hive_car_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/car_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final carProvider = StateNotifierProvider<CarNotifier, List<CarModel>>(
  (ref) => CarNotifier(ref),
);

class CarNotifier extends StateNotifier<List<CarModel>> {
  final Ref ref;
  Timer? _pollingTimer;

  Future<void> _loadFromCache() async {
    final box = Hive.box<HiveCarModel>('cars');
    final cachedCars =
        box.values.map((hiveCar) => hiveCar.toCarModel()).toList();
    state = cachedCars;
  }

  CarNotifier(this.ref) : super([]) {
    _loadFromCache(); //  load cached cars first
    _fetchCars(); // then fetch fresh
    _startPolling();
  }

  final carListStreamProvider = StreamProvider<List<CarModel>>((ref) async* {
    while (true) {
      try {
        final response = await http.get(
          Uri.parse(AppConstants.mockApiEndpoint),
        );
        if (response.statusCode == 200) {
          final List data = jsonDecode(response.body);
          final cars =
              data.map((e) => CarModel.fromJson(e)).toList().cast<CarModel>();
          yield cars;
        } else {
          yield [];
        }
      } catch (e) {
        yield [];
      }
      await Future.delayed(Duration(seconds: 5)); // polling every 5s
    }
  });

  Future<void> _fetchCars() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.mockApiEndpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final updatedCars =
            data.map((json) {
              final newCar = CarModel.fromJson(json);
              final oldCar = state.firstWhere(
                (c) => c.id == newCar.id,
                orElse: () => newCar,
              );
              return oldCar.copyWithUpdatedLocation(
                newCar.latitude,
                newCar.longitude,
                newCar.lastUpdated,
              );
            }).toList();

        state = updatedCars;

        // Persist to Hive
        final box = Hive.box<HiveCarModel>('cars');
        for (var car in updatedCars) {
          box.put(car.id, HiveCarModel.fromCarModel(car));
        }
      }
    } catch (_) {
      // ignore
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _fetchCars();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  // Helper: get a single car by id
  CarModel? getCarById(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
