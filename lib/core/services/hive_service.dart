import 'package:hive/hive.dart';
import '../../models/car_model.dart';

class HiveService {
  static final _box = Hive.box<CarModel>('cars');

  static void saveCars(List<CarModel> cars) {
    _box.clear();
    for (var car in cars) {
      _box.put(car.id, car);
    }
  }

  static List<CarModel> getSavedCars() {
    return _box.values.toList();
  }
}
