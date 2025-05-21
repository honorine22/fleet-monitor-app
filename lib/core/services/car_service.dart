import 'dart:convert';
import 'package:fleet_app_monitor/core/constants.dart';
import 'package:http/http.dart' as http;
import '../../models/car_model.dart';

class CarService {
  static Future<List<CarModel>> fetchCars() async {
    final res = await http.get(Uri.parse(AppConstants.mockApiEndpoint));

    if (res.statusCode == 200) {
      final List<dynamic> decoded = json.decode(res.body);
      return decoded.map((e) => CarModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }
}
