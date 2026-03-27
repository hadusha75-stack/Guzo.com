import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationPopup extends StatefulWidget {
  const LocationPopup({super.key});

  @override
  State<LocationPopup> createState() => _LocationPopupState();
}

class _LocationPopupState extends State<LocationPopup> {
  final List<Map<String, String>> allCities = [
    {
      'name': 'Milan Malpensa',
      'code': 'MXP',
      'city': 'Milan',
      'country': 'Italy',
    },
    {
      'name': 'Milan Linate',
      'code': 'LIN',
      'city': 'Milan',
      'country': 'Italy',
    },
    {
      'name': 'Milan Bergamo',
      'code': 'BGY',
      'city': 'Milan',
      'country': 'Italy',
    },
    {
      'name': 'Addis Ababa Bole',
      'code': 'ADD',
      'city': 'Addis Ababa',
      'country': 'Ethiopia',
    },
    {
      'name': 'Rome Fiumicino',
      'code': 'FCO',
      'city': 'Rome',
      'country': 'Italy',
    },
    {
      'name': 'Paris Charles de Gaulle',
      'code': 'CDG',
      'city': 'Paris',
      'country': 'France',
    },
    {
      'name': 'London Heathrow',
      'code': 'LHR',
      'city': 'London',
      'country': 'UK',
    },
    {
      'name': 'Dubai International',
      'code': 'DXB',
      'city': 'Dubai',
      'country': 'UAE',
    },
    {
      'name': 'Frankfurt Airport',
      'code': 'FRA',
      'city': 'Frankfurt',
      'country': 'Germany',
    },
    {
      'name': 'Amsterdam Schiphol',
      'code': 'AMS',
      'city': 'Amsterdam',
      'country': 'Netherlands',
    },
    {
      'name': 'Istanbul Airport',
      'code': 'IST',
      'city': 'Istanbul',
      'country': 'Turkey',
    },
    {
      'name': 'Barcelona El Prat',
      'code': 'BCN',
      'city': 'Barcelona',
      'country': 'Spain',
    },
    {
      'name': 'Zurich Airport',
      'code': 'ZRH',
      'city': 'Zurich',
      'country': 'Switzerland',
    },
    {
      'name': 'Tokyo Narita',
      'code': 'NRT',
      'city': 'Tokyo',
      'country': 'Japan',
    },
    {
      'name': 'Singapore Changi',
      'code': 'SIN',
      'city': 'Singapore',
      'country': 'Singapore',
    },
  ];

  List<Map<String, String>> filteredCities = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCities = allCities;
    searchController.addListener(_filterCities);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCities);
    searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCities = allCities;
      } else {
        filteredCities = allCities.where((city) {
          return city['name']!.toLowerCase().contains(query) ||
              city['code']!.toLowerCase().contains(query) ||
              city['city']!.toLowerCase().contains(query) ||
              city['country']!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  final destinationController = TextEditingController();
  final pickupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Airport',

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search airport, city, or code',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  '${filteredCities.length} airports found',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List of cities
          Expanded(
            child: filteredCities.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No airports found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      final city = filteredCities[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            city['code']![0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        title: Text(city['name']!),
                        subtitle: Text(
                          '${city['city']}, ${city['country']} (${city['code']})',
                        ),
                        onTap: () {
                          // Return the selected airport data
                          Navigator.pop(context, city);
                        },
                      );
                    },
                  ),
          ),
          const Text(
            'Enter destination',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: destinationController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search city, hotel, landmark',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: GuzoTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              if (pickupController.text.isEmpty ||
                  destinationController.text.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Please enter all values",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
               
                Get.back();
              }
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: GuzoTheme.White,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
