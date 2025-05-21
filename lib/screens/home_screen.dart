import 'dart:async';
import 'package:fleet_app_monitor/providers/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_model.dart';
import '../providers/car_provider.dart';
import 'car_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Start fetching cars after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(carProvider.notifier).startFetchingCars();
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _fitBoundsToCars(List<CarModel> cars) async {
    if (_mapController == null || cars.isEmpty) return;

    double minLat = cars.first.latitude;
    double maxLat = cars.first.latitude;
    double minLng = cars.first.longitude;
    double maxLng = cars.first.longitude;

    for (final car in cars) {
      if (car.latitude < minLat) minLat = car.latitude;
      if (car.latitude > maxLat) maxLat = car.latitude;
      if (car.longitude < minLng) minLng = car.longitude;
      if (car.longitude > maxLng) maxLng = car.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      // Ignore errors if map not ready yet
    }
  }

  // Filter cars by name (case-insensitive)
  List<CarModel> _filterCars(List<CarModel> cars) {
    if (_searchQuery.isEmpty) {
      return cars;
    }
    return cars
        .where(
          (car) => car.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cars = ref.watch(carProvider);
    final filteredCars = _filterCars(cars);
    final trackingCarId = ref.watch(trackingCarIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fleet Monitoring"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search cars by name...',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                      // Optionally fit bounds on search change:
                      _fitBoundsToCars(_filterCars(cars));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Example filter button placeholder
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter (not implemented)',
                  onPressed: () {
                    // You can add your filter dialog or options here later
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter button tapped')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 2,
        ),
        onMapCreated: (controller) async {
          _mapController = controller;
          // Fit bounds once map is ready and cars are loaded
          await _fitBoundsToCars(filteredCars);
        },
        markers:
            filteredCars.map((car) {
              final isTracked = trackingCarId == car.id;
              return Marker(
                markerId: MarkerId(car.id),
                position: LatLng(car.latitude, car.longitude),
                icon:
                    isTracked
                        ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        )
                        : BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: car.name,
                  snippet: 'Tap for details',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CarDetailScreen(carId: car.id),
                      ),
                    );
                  },
                ),
              );
            }).toSet(),
      ),
    );
  }
}
