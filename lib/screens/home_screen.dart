import 'dart:async';
import 'package:fleet_app_monitor/providers/tracking_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_model.dart';
import '../providers/car_provider.dart';
import 'car_detail_screen.dart';

enum CarFilter { all, moving, parked }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;

  String _searchQuery = '';
  CarFilter _selectedFilter = CarFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(carProvider.notifier)
          .startFetchingCars(); // Fetch from API after build
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  List<CarModel> _filterCars(List<CarModel> cars) {
    var filtered = cars;

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (car) =>
                    car.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    }

    switch (_selectedFilter) {
      case CarFilter.moving:
        filtered =
            filtered
                .where((car) => car.status.toLowerCase() == 'moving')
                .toList();
        break;
      case CarFilter.parked:
        filtered =
            filtered
                .where((car) => car.status.toLowerCase() == 'parked')
                .toList();
        break;
      case CarFilter.all:
        break;
    }

    return filtered;
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
      // Ignore if map not ready
    }
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
                      _fitBoundsToCars(_filterCars(cars));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter cars',
                  onPressed: () async {
                    final selected = await showModalBottomSheet<CarFilter>(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              CarFilter.values.map((filter) {
                                return RadioListTile<CarFilter>(
                                  title: Text(
                                    filter.name[0].toUpperCase() +
                                        filter.name.substring(1),
                                  ),
                                  value: filter,
                                  groupValue: _selectedFilter,
                                  onChanged: (value) {
                                    Navigator.pop(context, value);
                                  },
                                );
                              }).toList(),
                        );
                      },
                    );

                    if (selected != null && selected != _selectedFilter) {
                      setState(() {
                        _selectedFilter = selected;
                      });
                      _fitBoundsToCars(_filterCars(ref.read(carProvider)));
                    }
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
          await _fitBoundsToCars(filteredCars); // Fit on map after creation
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
