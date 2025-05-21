import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_model.dart';

class CarDetailScreen extends StatelessWidget {
  final CarModel car;

  const CarDetailScreen({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(car.name)),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(car.latitude, car.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(car.id),
                  position: LatLng(car.latitude, car.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    car.status == 'Moving'
                        ? BitmapDescriptor.hueGreen
                        : BitmapDescriptor.hueRed,
                  ),
                  infoWindow: InfoWindow(title: car.name, snippet: car.status),
                ),
              },
              polylines: {
                if (car.route.length > 1)
                  Polyline(
                    polylineId: PolylineId('route_${car.id}'),
                    points: car.route,
                    color: car.status == 'Moving' ? Colors.blue : Colors.grey,
                    width: 4,
                  ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildCarDetails(car),
          ),
        ],
      ),
    );
  }

  Widget _buildCarDetails(CarModel car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ID: ${car.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Status: ${car.status}'),
        const SizedBox(height: 8),
        Text('Speed: ${car.speed.toStringAsFixed(1)} km/h'),
        const SizedBox(height: 8),
        Text(
          'Location: (${car.latitude.toStringAsFixed(5)}, ${car.longitude.toStringAsFixed(5)})',
        ),
      ],
    );
  }
}
