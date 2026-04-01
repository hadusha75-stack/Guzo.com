import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/model/airport_model.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirportSearchPage extends StatefulWidget {
  final String title;
  final bool isFrom;
  final int segmentIndex;
  const AirportSearchPage({
    super.key,
    required this.title,
    required this.isFrom,
    this.segmentIndex = -1,
  });

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
  Airport(name: "Addis Ababa Bole International Airport", code: "ADD", city: "Addis Ababa"),
  Airport(name: "Dire Dawa International Airport", code: "DIR", city: "Dire Dawa"),
  Airport(name: "Bahir Dar Airport", code: "BJR", city: "Bahir Dar"),
   Airport(name: "Dubai International Airport", code: "DXB", city: "Dubai"),

  Airport(name: "Abu Dhabi International Airport", code: "AUH", city: "Abu Dhabi"),
  Airport(name: "Al Bateen Executive Airport", code: "AZI", city: "Abu Dhabi"),

  Airport(name: "Sharjah International Airport", code: "SHJ", city: "Sharjah"),

  Airport(name: "Ras Al Khaimah International Airport", code: "RKT", city: "Ras Al Khaimah"),

  Airport(name: "Fujairah International Airport", code: "FJR", city: "Fujairah"),

  Airport(name: "Al Ain International Airport", code: "AAN", city: "Al Ain"),
  Airport(name: "Mekelle Airport", code: "MQX", city: "Mekelle"),
  Airport(name: "Hawassa Airport", code: "AWA", city: "Hawassa"),

  Airport(name: "Heathrow Airport", code: "LHR", city: "London"),
  Airport(name: "Gatwick Airport", code: "LGW", city: "London"),
  Airport(name: "Manchester Airport", code: "MAN", city: "Manchester"),
  Airport(name: "Birmingham Airport", code: "BHX", city: "Birmingham"),
  Airport(name: "Edinburgh Airport", code: "EDI", city: "Edinburgh"),

  Airport(name: "Frankfurt Airport", code: "FRA", city: "Frankfurt"),
  Airport(name: "Munich Airport", code: "MUC", city: "Munich"),
  Airport(name: "Berlin Brandenburg Airport", code: "BER", city: "Berlin"),
  Airport(name: "Hamburg Airport", code: "HAM", city: "Hamburg"),
  Airport(name: "Düsseldorf Airport", code: "DUS", city: "Düsseldorf"),

  Airport(name: "John F. Kennedy International Airport", code: "JFK", city: "New York"),
  Airport(name: "Los Angeles International Airport", code: "LAX", city: "Los Angeles"),
  Airport(name: "O'Hare International Airport", code: "ORD", city: "Chicago"),
  Airport(name: "Dallas/Fort Worth International Airport", code: "DFW", city: "Dallas"),
  Airport(name: "Hartsfield–Jackson Atlanta International Airport", code: "ATL", city: "Atlanta"),
  Airport(name: "San Francisco International Airport", code: "SFO", city: "San Francisco"),
  Airport(name: "Miami International Airport", code: "MIA", city: "Miami"),
  Airport(name: "Seattle-Tacoma International Airport", code: "SEA", city: "Seattle"),

  Airport(name: "Toronto Pearson International Airport", code: "YYZ", city: "Toronto"),
  Airport(name: "Vancouver International Airport", code: "YVR", city: "Vancouver"),
  Airport(name: "Montréal-Trudeau International Airport", code: "YUL", city: "Montreal"),

  Airport(name: "Charles de Gaulle Airport", code: "CDG", city: "Paris"),
  Airport(name: "Orly Airport", code: "ORY", city: "Paris"),
  Airport(name: "Nice Côte d'Azur Airport", code: "NCE", city: "Nice"),

  Airport(name: "Leonardo da Vinci–Fiumicino Airport", code: "FCO", city: "Rome"),
  Airport(name: "Malpensa Airport", code: "MXP", city: "Milan"),
  Airport(name: "Venice Marco Polo Airport", code: "VCE", city: "Venice"),

  Airport(name: "Adolfo Suárez Madrid–Barajas Airport", code: "MAD", city: "Madrid"),
  Airport(name: "Barcelona-El Prat Airport", code: "BCN", city: "Barcelona"),

  Airport(name: "Dubai International Airport", code: "DXB", city: "Dubai"),
  Airport(name: "Abu Dhabi International Airport", code: "AUH", city: "Abu Dhabi"),

  Airport(name: "Hamad International Airport", code: "DOH", city: "Doha"),

  Airport(name: "Istanbul Airport", code: "IST", city: "Istanbul"),

  Airport(name: "Indira Gandhi International Airport", code: "DEL", city: "New Delhi"),
  Airport(name: "Chhatrapati Shivaji Maharaj International Airport", code: "BOM", city: "Mumbai"),
  Airport(name: "Kempegowda International Airport", code: "BLR", city: "Bangalore"),

  Airport(name: "Beijing Capital International Airport", code: "PEK", city: "Beijing"),
  Airport(name: "Shanghai Pudong International Airport", code: "PVG", city: "Shanghai"),
  Airport(name: "Guangzhou Baiyun International Airport", code: "CAN", city: "Guangzhou"),

  Airport(name: "Tokyo Haneda Airport", code: "HND", city: "Tokyo"),
  Airport(name: "Narita International Airport", code: "NRT", city: "Tokyo"),

  Airport(name: "Singapore Changi Airport", code: "SIN", city: "Singapore"),

  Airport(name: "Jomo Kenyatta International Airport", code: "NBO", city: "Nairobi"),
  Airport(name: "O. R. Tambo International Airport", code: "JNB", city: "Johannesburg"),
  Airport(name: "Cairo International Airport", code: "CAI", city: "Cairo"),
  Airport(name: "Murtala Muhammed International Airport", code: "LOS", city: "Lagos"),
  Airport(name: "Kotoka International Airport", code: "ACC", city: "Accra"),
  Airport(name: "Kigali International Airport", code: "KGL", city: "Kigali"),
  Airport(name: "Entebbe International Airport", code: "EBB", city: "Entebbe"),
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
                      widget.segmentIndex,
                      airport.code,
                      airport.city,
                      widget.isFrom,
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
