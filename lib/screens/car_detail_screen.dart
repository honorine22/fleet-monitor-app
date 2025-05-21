import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/car_provider.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  final String carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _animateToCar(LatLng position) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = ref.watch(
      carProvider.select(
        (cars) => cars.firstWhere((c) => c.id == widget.carId),
      ),
    );

    final isTracking = ref.watch(
      carProvider.notifier.select((notifier) => notifier.isTracking(car.id)),
    );

    // Animate camera whenever car location changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateToCar(LatLng(car.latitude, car.longitude));
    });

    return Scaffold(
      appBar: AppBar(title: Text(car.name)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(car.latitude, car.longitude),
              zoom: 16,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId(car.id),
                position: LatLng(car.latitude, car.longitude),
                infoWindow: InfoWindow(
                  title: car.name,
                  snippet: 'ID: ${car.id}',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  car.status == 'Moving'
                      ? BitmapDescriptor.hueGreen
                      : BitmapDescriptor.hueRed,
                ),
              ),
            },
            polylines: {
              if (car.route.length > 1)
                Polyline(
                  polylineId: const PolylineId('route'),
                  points: car.route,
                  color: car.status == 'Moving' ? Colors.blue : Colors.grey,
                  width: 4,
                ),
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _infoRow('ID', car.id),
                  _infoRow('Name', car.name),
                  _infoRow('Latitude', car.latitude.toStringAsFixed(4)),
                  _infoRow('Longitude', car.longitude.toStringAsFixed(4)),
                  _infoRow('Status', car.status),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      final notifier = ref.read(carProvider.notifier);
                      if (isTracking) {
                        notifier.stopTracking();
                      } else {
                        notifier.startTrackingCar(car.id);
                      }
                      setState(() {}); // Refresh UI
                    },
                    icon: Icon(
                      isTracking
                          ? Icons.stop_circle_outlined
                          : Icons.location_searching,
                    ),
                    label: Text(
                      isTracking ? "Stop Tracking" : "Track This Car",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isTracking ? Colors.red : Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
