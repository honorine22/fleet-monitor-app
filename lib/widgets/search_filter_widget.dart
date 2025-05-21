import 'package:fleet_app_monitor/models/car_model.dart';
import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final Function(CarFilter) onFilterChanged;
  final Function(String) onSearchChanged;

  const SearchFilterWidget({
    Key? key,
    required this.onFilterChanged,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  CarFilter _currentFilter = CarFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search cars...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: widget.onSearchChanged,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<CarFilter>(
              icon: const Icon(Icons.filter_list),
              onSelected: (filter) {
                setState(() => _currentFilter = filter);
                widget.onFilterChanged(filter);
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: CarFilter.all,
                      child: Text('All Cars'),
                    ),
                    const PopupMenuItem(
                      value: CarFilter.moving,
                      child: Text('Moving'),
                    ),
                    const PopupMenuItem(
                      value: CarFilter.parked,
                      child: Text('Parked'),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
