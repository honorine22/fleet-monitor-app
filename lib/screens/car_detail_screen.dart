import 'dart:async';
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

  LatLng? _currentMarkerPosition;
  Timer? _animationTimer;
  Marker? _animatedMarker;

  @override
  void dispose() {
    _mapController?.dispose();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _animateToCar(LatLng position) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  // Linear interpolation between two LatLng points
  LatLng _interpolatePosition(LatLng start, LatLng end, double t) {
    return LatLng(
      start.latitude + (end.latitude - start.latitude) * t,
      start.longitude + (end.longitude - start.longitude) * t,
    );
  }

  // Optional easing function for smoother animation
  double _easeInOut(double t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }

  // Animate the marker position smoothly
  void _animateMarkerTo(LatLng target) {
    _animationTimer?.cancel();

    const int totalSteps = 30;
    const Duration stepDuration = Duration(milliseconds: 30);

    if (_currentMarkerPosition == null) {
      _currentMarkerPosition = target;
    }

    int step = 0;
    _animationTimer = Timer.periodic(stepDuration, (timer) {
      step++;
      final t = _easeInOut(step / totalSteps);
      final interpolated = _interpolatePosition(
        _currentMarkerPosition!,
        target,
        t,
      );

      setState(() {
        _animatedMarker = Marker(
          markerId: MarkerId(widget.carId),
          position: interpolated,
          infoWindow: InfoWindow(title: "Car", snippet: "ID: ${widget.carId}"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
      });

      if (step >= totalSteps) {
        _currentMarkerPosition = target;
        timer.cancel();
      }
    });
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

    // Animate camera and marker whenever car location changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newPosition = LatLng(car.latitude, car.longitude);
      _animateToCar(newPosition);
      _animateMarkerTo(newPosition);
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
              if (_animatedMarker != null)
                _animatedMarker!
              else
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
                      backgroundColor: isTracking ? Colors.red : Colors.white,
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
