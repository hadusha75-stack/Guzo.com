import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/model/airport_model.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirportSearchPage extends StatefulWidget {
  final String title;
  const AirportSearchPage({super.key, required this.title});

  @override
  State<AirportSearchPage> createState() => _AirportSearchPageState();
}

class _AirportSearchPageState extends State<AirportSearchPage> {
  final controller = Get.find<FlightDataController>();

  final TextEditingController _searchController = TextEditingController();
  List<Airport> airports = [];
  List<Airport> filteredAirports = [];

  @override
  void initState() {
    super.initState();
    fetchAirports();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    filterAirports();
  }

  void fetchAirports() async {
    airports = [
      Airport(name: "Cairo International Airport", code: "CAI", city: "Cairo"),
      Airport(name: "Heathrow Airport", code: "LHR", city: "London"),
      Airport(name: "Addis Ababa air port", code: "ADD", city: "Addis Ababa"),
    Airport(name: "Dubai International Airport", code: "DXB", city: "Dubai"),
      Airport(name: "Heathrow Airport", code: "LHR", city: "London"),
      Airport(name: "JFK International Airport", code: "JFK", city: "New York"),
    
    ];

    if (mounted) {
      setState(() {
        filteredAirports = List.from(airports);
      });
    }
  }

  void filterAirports() {
    final query = _searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        filteredAirports = airports.where((airport) {
          return airport.name.toLowerCase().contains(query) ||
              airport.city.toLowerCase().contains(query) ||
              airport.code.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: GuzoTheme.primaryGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: _searchController,
              cursorColor: GuzoTheme.black,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Enter airport or city",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 18),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 45),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: GuzoTheme.primaryGreen),
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          const Divider(height: 1),
          const SizedBox(height: 17),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              "Airports near you",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAirports.length,
              itemBuilder: (context, index) {
                final airport = filteredAirports[index];
                return ListTile(
                  leading: const Icon(Icons.flight_takeoff),
                  title: Text(airport.city),
                  subtitle: Text('${airport.name} • ${airport.code}'),
                  onTap: () {
                    controller.updateSegmentLocation(
                      index,
                      airport.code,
                      airport.city,
                      widget.title == "Where to?" ? false : true,
                    );
                    Get.back(result: airport.city);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
