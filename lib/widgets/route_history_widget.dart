import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_model.dart';

class RouteHistoryWidget extends StatelessWidget {
  final CarModel car;

  const RouteHistoryWidget({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Total Points',
                          '${car.route.length}',
                          Icons.place,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Distance',
                          '${_calculateTotalDistance(car.route).toStringAsFixed(1)} km',
                          Icons.timeline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Duration',
                          '${_estimateDuration(car.route)} mins',
                          Icons.timer,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Status',
                          car.status,
                          car.status == 'Moving'
                              ? Icons.play_arrow
                              : Icons.pause,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Locations',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: car.route.length > 10 ? 10 : car.route.length,
                      itemBuilder: (context, index) {
                        final point = car.route[car.route.length - 1 - index];
                        final isLatest = index == 0;
                        return _buildLocationItem(
                          context,
                          point,
                          index,
                          isLatest,
                        );
                      },
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

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLocationItem(
    BuildContext context,
    LatLng point,
    int index,
    bool isLatest,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  isLatest
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  isLatest
                      ? const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      )
                      : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLatest ? 'Current Location' : 'Location ${index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (isLatest)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _calculateTotalDistance(List<LatLng> route) {
    if (route.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 1; i < route.length; i++) {
      totalDistance += _distanceBetween(route[i - 1], route[i]);
    }
    return totalDistance;
  }

  double _distanceBetween(LatLng point1, LatLng point2) {
    // Simple distance calculation (not accurate for large distances)
    const double earthRadius = 6371; // km
    final double lat1Rad = point1.latitude * (3.14159 / 180);
    final double lat2Rad = point2.latitude * (3.14159 / 180);
    final double deltaLat =
        (point2.latitude - point1.latitude) * (3.14159 / 180);
    final double deltaLng =
        (point2.longitude - point1.longitude) * (3.14159 / 180);

    final double a =
        (deltaLat / 2) * (deltaLat / 2) +
        (deltaLng / 2) * (deltaLng / 2) * (lat1Rad) * (lat2Rad);
    final double c = 2 * (a.clamp(0.0, 1.0));

    return earthRadius * c;
  }

  int _estimateDuration(List<LatLng> route) {
    // Estimate based on route points (assuming updates every 30 seconds)
    return route.length * 30 ~/ 60; // convert to minutes
  }
}
