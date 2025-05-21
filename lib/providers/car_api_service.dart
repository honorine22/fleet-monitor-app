import 'dart:convert';
import 'package:fleet_app_monitor/core/constants.dart';
import 'package:http/http.dart' as http;
import '../../models/car_model.dart';

class CarApiService {
  /// Fetch all cars with full data
  static Future<List<CarModel>> fetchCars() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.mockApiEndpoint));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data.map((json) => CarModel.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception(
          'Failed to load cars. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching cars: $e');
      return [];
    }
  }

  static Future<CarModel> fetchCarById(String carId) async {
    final response = await http.get(Uri.parse(AppConstants.mockApiEndpoint));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      final Map<String, dynamic>? jsonCar = jsonList
          .cast<Map<String, dynamic>>()
          .firstWhere((car) => car['id'] == carId, orElse: () => <String, dynamic>{});

      if (jsonCar != null) {
        return CarModel.fromJson(jsonCar);
      } else {
        throw Exception('Car with ID $carId not found in the response');
      }
    } else {
      throw Exception('Failed to load car with ID $carId');
    }
  }
}
