import 'package:flutter/material.dart';

class CarSearchFilter extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFilterChanged;

  const CarSearchFilter({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                onChanged: onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by name or ID',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: 'All',
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All')),
                  DropdownMenuItem(value: 'Moving', child: Text('Moving')),
                  DropdownMenuItem(value: 'Parked', child: Text('Parked')),
                ],
                onChanged: onFilterChanged,
                decoration: const InputDecoration(
                  labelText: 'Filter',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
