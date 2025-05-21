import 'package:fleet_app_monitor/core/utils/carFilterProvider.dart';
import 'package:fleet_app_monitor/core/utils/searchQueryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/car_model.dart';
import '../providers/car_provider.dart';
import '../screens/car_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  bool _mapReady = false;
  bool _isFittingBounds = false;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<CarModel> _lastFilteredCars = [];

  MapType _currentMapType = MapType.normal;
  bool _showTrafficLayer = false;

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(-1.9706, 30.1044),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    final cars = ref.watch(carProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final filter = ref.watch(carFilterProvider);

    final filteredCars = _filterCars(cars, searchQuery, filter);

    if (_mapReady && _lastFilteredCars != filteredCars) {
      _lastFilteredCars = filteredCars;
      _updateMarkersAndPolylines(filteredCars);
      _fitBoundsToCars(filteredCars);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet Monitoring'),
        actions: [
          IconButton(
            icon: Icon(
              _showTrafficLayer ? Icons.traffic : Icons.traffic_outlined,
            ),
            onPressed: () {
              setState(() {
                _showTrafficLayer = !_showTrafficLayer;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: () {
              setState(() {
                _currentMapType =
                    _currentMapType == MapType.normal
                        ? MapType.satellite
                        : MapType.normal;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            polylines: _polylines,
            mapType: _currentMapType,
            trafficEnabled: _showTrafficLayer,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              _mapReady = true;
              _updateMarkersAndPolylines(filteredCars);
              _fitBoundsToCars(filteredCars);
            },
          ),

          // Floating Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black26),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search cars...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),
          ),

          // Filter Dropdown
          Positioned(
            top: 80,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Colors.black26),
                ],
              ),
              child: DropdownButton<CarFilter>(
                value: filter,
                underline: const SizedBox.shrink(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(carFilterProvider.notifier).state = value;
                  }
                },
                items:
                    CarFilter.values.map((CarFilter filter) {
                      return DropdownMenuItem<CarFilter>(
                        value: filter,
                        child: Text(filter.name.toUpperCase()),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CarModel> _filterCars(
    List<CarModel> cars,
    String searchQuery,
    CarFilter filter,
  ) {
    return cars.where((car) {
      final matchesQuery = car.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesStatus = switch (filter) {
        CarFilter.all => true,
        CarFilter.moving => car.status.toLowerCase() == 'moving',
        CarFilter.parked => car.status.toLowerCase() == 'parked',
      };

      return matchesQuery && matchesStatus;
    }).toList();
  }

  void _updateMarkersAndPolylines(List<CarModel> cars) {
    final markers = <Marker>{};
    final polylines = <Polyline>{};

    for (final car in cars) {
      markers.add(
        Marker(
          markerId: MarkerId(car.id),
          position: LatLng(car.latitude, car.longitude),
          infoWindow: InfoWindow(
            title: car.name,
            snippet: 'Status: ${car.status}',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(car: car),
              ),
            );
          },
        ),
      );

      if (car.route.isNotEmpty) {
        polylines.add(
          Polyline(
            polylineId: PolylineId(car.id),
            points:
                car.route
                    .map((loc) => LatLng(loc.latitude, loc.longitude))
                    .toList(),
            color: Colors.blue,
            width: 3,
          ),
        );
      }
    }

    setState(() {
      _markers = markers;
      _polylines = polylines;
    });
  }

  Future<void> _fitBoundsToCars(List<CarModel> cars) async {
    if (_mapController == null || cars.isEmpty) return;
    if (_isFittingBounds) return;
    _isFittingBounds = true;

    try {
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

      final southwest = LatLng(minLat, minLng);
      final northeast = LatLng(maxLat, maxLng);
      final bounds = LatLngBounds(southwest: southwest, northeast: northeast);
      final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);

      await _mapController!.animateCamera(cameraUpdate);
    } catch (e) {
      debugPrint('Error fitting bounds: $e');
    } finally {
      _isFittingBounds = false;
    }
  }
}
