import 'package:fleet_app_monitor/models/car_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final carFilterProvider = StateProvider<CarFilter>((ref) => CarFilter.all);
