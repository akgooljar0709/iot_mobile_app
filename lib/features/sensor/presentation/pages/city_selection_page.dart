import 'package:flutter/material.dart';

class CitySelectionPage extends StatefulWidget {
  final String? currentCity;

  const CitySelectionPage({
    super.key,
    this.currentCity,
  });

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocus;

  final List<Map<String, String>> _popularCities = [
    {'name': 'Pamplemousses', 'country': 'Mauritius', 'id': 'pamplemousses'},
    {'name': 'Port Louis', 'country': 'Mauritius', 'id': 'port-louis'},
    {'name': 'London', 'country': 'United Kingdom', 'id': 'london'},
    {'name': 'New York', 'country': 'United States', 'id': 'new-york'},
    {'name': 'Tokyo', 'country': 'Japan', 'id': 'tokyo'},
    {'name': 'Paris', 'country': 'France', 'id': 'paris'},
    {'name': 'Dubai', 'country': 'United Arab Emirates', 'id': 'dubai'},
    {'name': 'Singapore', 'country': 'Singapore', 'id': 'singapore'},
    {'name': 'Sydney', 'country': 'Australia', 'id': 'sydney'},
    {'name': 'Berlin', 'country': 'Germany', 'id': 'berlin'},
    {'name': 'Toronto', 'country': 'Canada', 'id': 'toronto'},
    {'name': 'Mumbai', 'country': 'India', 'id': 'mumbai'},
    {'name': 'Bangkok', 'country': 'Thailand', 'id': 'bangkok'},
    {'name': 'Barcelona', 'country': 'Spain', 'id': 'barcelona'},
    {'name': 'Amsterdam', 'country': 'Netherlands', 'id': 'amsterdam'},
  ];

  late List<Map<String, String>> _filteredCities;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    _filteredCities = _popularCities;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = _popularCities;
      } else {
        _filteredCities = _popularCities
            .where((city) =>
                city['name']!.toLowerCase().contains(query.toLowerCase()) ||
                city['country']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select City'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              onChanged: _filterCities,
              decoration: InputDecoration(
                hintText: 'Search cities...',
                prefixIcon: const Icon(Icons.location_on_outlined),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterCities('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Cities List
          Expanded(
            child: _filteredCities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No cities found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = city['name'] == widget.currentCity;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey[400],
                          ),
                          title: Text(
                            city['name']!,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.blue : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            city['country']!,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              : null,
                          onTap: () {
                            Navigator.of(context).pop(city['name']);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
