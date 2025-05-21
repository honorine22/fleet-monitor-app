import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarStatsWidget extends StatelessWidget {
  final CarModel car;

  const CarStatsWidget({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatCard(context, 'Performance Metrics', [
            _StatItem(
              'Current Speed',
              '${car.speed.toInt()} km/h',
              Icons.speed,
            ),
            _StatItem(
              'Max Speed Today',
              '${(car.speed * 1.2).toInt()} km/h',
              Icons.trending_up,
            ),
            _StatItem(
              'Average Speed',
              '${(car.speed * 0.8).toInt()} km/h',
              Icons.analytics,
            ),
            _StatItem(
              'Distance Traveled',
              '${(car.speed * 2.5).toInt()} km',
              Icons.route,
            ),
          ]),
          const SizedBox(height: 16),
          _buildStatCard(context, 'Vehicle Status', [
            _StatItem(
              'Engine Status',
              car.status == 'Moving' ? 'Running' : 'Idle',
              Icons.power,
            ),
            _StatItem(
              'Fuel Level',
              '${85 + (car.speed * 0.1).toInt()}%',
              Icons.local_gas_station,
            ),
            _StatItem('Battery', '98%', Icons.battery_full),
            _StatItem(
              'Signal Strength',
              'Excellent',
              Icons.signal_cellular_4_bar,
            ),
          ]),
          const SizedBox(height: 16),
          _buildStatCard(context, 'Location Details', [
            _StatItem(
              'Latitude',
              car.latitude.toStringAsFixed(6),
              Icons.location_on,
            ),
            _StatItem(
              'Longitude',
              car.longitude.toStringAsFixed(6),
              Icons.location_on,
            ),
            _StatItem('Altitude', '1,567 m', Icons.terrain),
            _StatItem(
              'Heading',
              '${(car.speed * 4).toInt() % 360}°',
              Icons.navigation,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    List<_StatItem> items,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.icon,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              Text(
                                item.value,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;

  _StatItem(this.label, this.value, this.icon);
}
