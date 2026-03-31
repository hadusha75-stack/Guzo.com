import 'package:booking/controllers/FlightsController.dart'
    show FlightDataController;
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/newFlights/airport_search_page.dart';
import 'package:booking/newFlights/when_when_clicked_page.dart';
import 'package:booking/newFlights/who_flying_page.dart';
import 'package:booking/newFlights/your_flight_to_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';

import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SearchedFlightsPage extends StatefulWidget {
  const SearchedFlightsPage({super.key});

  @override
  State<SearchedFlightsPage> createState() => _SearchedFlightsPageState();
}

class _SearchedFlightsPageState extends State<SearchedFlightsPage> {
  final FlightDataController uppercontroller = Get.find<FlightDataController>();
  final flightApicontroller = Get.find<FlightUpdaredController>();
  String formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return "-05:--07:PM-";
    }

    try {
      DateTime dt = DateTime.parse(time);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return "--:--";
    }
  }

  String formatDuration(String duration) {
    RegExp regExp = RegExp(r'PT(\d+)H(\d+)M');
    final match = regExp.firstMatch(duration);

    if (match != null) {
      final hours = match.group(1);
      final minutes = match.group(2);
      return "${hours}h ${minutes}m";
    }

    return duration;
  }

  int selectedOption = 1;
  bool _isExpanded = false;
  String selectedTripType = 'Round-trip';
  bool _isAlertEnabled = false;

  void _toggleDrawer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FlightDataController flightDataController =
        Get.find<FlightDataController>();

    double drawerHeight = selectedTripType == 'Multi-city' ? 600 : 520;
    double topHeaderPadding = MediaQuery.of(context).padding.top + 90;

    Switch(
      value: _isAlertEnabled,
      onChanged: (val) {
        setState(() {
          _isAlertEnabled = val;
        });
      },
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Obx(() {
              if (flightApicontroller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (flightDataController.selectedTripType.value == "One-way") {
                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: topHeaderPadding + 20,
                    bottom: 20,
                  ),

                  itemCount: flightApicontroller.filteredOffers.length,
                  itemBuilder: (context, index) {
                    var offer = flightApicontroller.filteredOffers[index];
                    final flights = offer['flights'] as List? ?? [];
                    final provider = offer['provider'] ?? 'Unknown';

                    final firstFlight = flights.isNotEmpty ? flights[0] : null;
                    final segments = firstFlight?['segments'] as List? ?? [];
                    final firstSegment = segments.isNotEmpty
                        ? segments.first
                        : null;

                    final airlineCode = firstSegment?['airlineCode'] ?? '';

                    final airlineName =
                        firstSegment?['airlineName'] ?? provider;
                    final duration =
                        firstFlight?['duration'] ?? 'unknown duration N/A';

                    final departureTime = firstSegment?['departureDateTime'];
                    final arrivalTime = firstSegment?['arrivalDateTime'];
                    final stops = segments.length - 1;

                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 150),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15,
                                top: 15,
                              ),
                              child: const Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Please review any travel advisories provided by your government to make an informed decision about your travel to this area, which may be considered conflict-affected.",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                top: 10,
                              ),
                              child: Text(
                                "${flightApicontroller.filteredOffers.length} of ${flightApicontroller.offers.length} flights found",
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          "Best",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          "Cheapest",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          "Fastest",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green.shade500,
                                          ),
                                        ),
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
                    return InkWell(
                      onTap: () async {
                        flightApicontroller.selectedOffer.value = offer;
                        await flightApicontroller.selectOfferAndGetPrice(offer);
                        Get.to(() => YourFlightToPage());
                      },
                      child: Card(
                        color: Colors.white,

                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "https://content.airhex.com/content/logos/airlines_${airlineCode}_350_100_r.png",
                                            width: 60,
                                            height: 30,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.flight),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${formatTime(departureTime)} - ${formatTime(arrivalTime)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              "${flightDataController.recievedFromFrom.value} - ${flightDataController.recievedFromTo.value}",

                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 28),
                                          _buildActionColumn(
                                            stops == 0
                                                ? 'Direct'
                                                : '$stops stop${stops > 1 ? 's' : ''}',
                                            formatDuration(duration),
                                          ),

                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    airlineName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Divider(height: 1),
                                SizedBox(height: 10),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),

                                  leading: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        _buildBaggageIcon(Icons.backpack),
                                        const SizedBox(width: 4),
                                        _buildBaggageIcon(Icons.work_outline),
                                        const SizedBox(width: 4),
                                        _buildBaggageIcon(Icons.luggage),
                                      ],
                                    ),
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            builder: (BuildContext context) {
                                              bool priceDetailSelected = false;
                                              final pricing =
                                                  offer['pricing'] ?? {};
                                              return StatefulBuilder(
                                                builder:
                                                    (
                                                      BuildContext context,
                                                      StateSetter setModalState,
                                                    ) {
                                                      return AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 0,
                                                            ),
                                                        height:
                                                            priceDetailSelected
                                                            ? 500
                                                            : 380,
                                                        padding:
                                                            const EdgeInsets.all(
                                                              20,
                                                            ),
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(
                                                                      20,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                height: 6,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey[400],
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),

                                                            const Text(
                                                              "Price details",
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            const Text(
                                                              "Flight",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),

                                                            InkWell(
                                                              onTap: () {
                                                                setModalState(() {
                                                                  priceDetailSelected =
                                                                      !priceDetailSelected;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12.0,
                                                                    ),
                                                                child: Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Adult(2)",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    const Text(
                                                                      "\$111.09",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Icon(
                                                                      priceDetailSelected
                                                                          ? Icons.keyboard_arrow_up
                                                                          : Icons.keyboard_arrow_down,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            if (priceDetailSelected)
                                                              AnimatedOpacity(
                                                                duration:
                                                                    const Duration(
                                                                      milliseconds:
                                                                          300,
                                                                    ),
                                                                opacity:
                                                                    priceDetailSelected
                                                                    ? 1.0
                                                                    : 0.0,
                                                                child: Column(
                                                                  children: [
                                                                    _buildPriceRow(
                                                                      "Flight fare",
                                                                      '\$${pricing['baseFare'] ?? '0.00'}',
                                                                    ),
                                                                    _buildPriceRow(
                                                                      "Airline taxes and fees",
                                                                      '\$${pricing['taxes'] ?? '0.00'}',
                                                                    ),
                                                                    _buildPriceRow(
                                                                      "Platform service fee",
                                                                      pricing['platformFee'] ??
                                                                          '0.00',
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                            const Divider(
                                                              height: 30,
                                                            ),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Total",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "Includes taxes and fees",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[600],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '\$${pricing['total'] ?? '0.00'}',
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        24,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            const Spacer(),

                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 60,
                                                              child: ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      GuzoTheme
                                                                          .primaryGreen,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  "Close",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              offer["pricing"]["total"]
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Icon(
                                              Icons.info_outline,
                                              size: 20,
                                              color: Colors.grey[600],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: topHeaderPadding + 20,
                    bottom: 20,
                  ),

                  itemCount: flightApicontroller.filteredOffers.length,
                  itemBuilder: (context, index) {
                    var offer = flightApicontroller.filteredOffers[index];
                    final flights = offer['flights'] as List? ?? [];
                    final provider = offer['provider'] ?? 'Unknown';

                    final firstFlight = flights.isNotEmpty ? flights[0] : null;
                    final firstSegments =
                        firstFlight?['segments'] as List? ?? [];
                    final firstSegment = firstSegments.isNotEmpty
                        ? firstSegments[0]
                        : null;
                    final firstAirlineCode =
                        (firstSegment?['airlineCode'] ?? '').toLowerCase();
                    final firstAirlineName =
                        firstSegment?['airlineName'] ?? provider;
                    final firstDuration =
                        firstFlight?['duration'] ?? 'unknown duration N/A';
                    final firstDepartureTime =
                        firstSegment?['departureDateTime'];
                    final firstArrivalTime = firstSegment?['arrivalDateTime'];
                    final firstStops = firstSegments.length - 1;

                    final secondFlight = flights.length > 1 ? flights[1] : null;
                    final secondSegments =
                        secondFlight?['segments'] as List? ?? [];
                    final secondSegment = secondSegments.isNotEmpty
                        ? secondSegments[0]
                        : null;
                    final secondAirlineCode =
                        (secondSegment?['airlineCode'] ?? '').toLowerCase();
                    final secondDuration =
                        secondFlight?['duration'] ?? 'unknown duration N/A';
                    final secondDepartureTime =
                        secondSegment?['departureDateTime'];
                    final secondArrivalTime = secondSegment?['arrivalDateTime'];
                    final secondStops = secondSegments.length - 1;

                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 150),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15,
                                top: 15,
                              ),
                              child: const Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.black,
                                        size: 28,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "Please review any travel advisories provided by your government to make an informed decision about your travel to this area, which may be considered conflict-affected.",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                top: 10,
                              ),
                              child: Text(
                                "${flightApicontroller.filteredOffers.length} of ${flightApicontroller.offers.length} flights found",
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          "Best",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          "Cheapest",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          "Fastest",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green.shade500,
                                          ),
                                        ),
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
                    return InkWell(
                      onTap: () async {
                        flightApicontroller.selectedOffer.value = offer;

                        await flightApicontroller.selectOfferAndGetPrice(offer);
                       
                        if (flightApicontroller.offerPriceId.value.isNotEmpty &&
                            flightApicontroller.executionId.value.isNotEmpty) {
                        Get.to(() => YourFlightToPage());
                        }
                      },
                      child: Card(
                        color: Colors.white,

                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "https://content.airhex.com/content/logos/airlines_${firstAirlineCode}_350_100_r.png",
                                            width: 60,
                                            height: 30,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.flight),
                                          ),
                                          SizedBox(height: 12),
                                          CachedNetworkImage(
                                            imageUrl:
                                                "https://content.airhex.com/content/logos/airlines_${secondAirlineCode}_350_100_r.png",
                                            width: 60,
                                            height: 30,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.flight),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${formatTime(firstDepartureTime)} - ${formatTime(firstArrivalTime)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${uppercontroller.recievedFromFrom.value} - ${uppercontroller.recievedFromTo.value}",

                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),

                                            const SizedBox(height: 12),
                                            Text(
                                              "${formatTime(secondDepartureTime)} - ${formatTime(secondArrivalTime)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${uppercontroller.recievedFromTo.value} - ${uppercontroller.recievedFromFrom.value}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildActionColumn(
                                            firstStops == 0
                                                ? 'Direct'
                                                : '$firstStops stop${firstStops > 1 ? 's' : ''}',
                                            formatDuration(firstDuration),
                                          ),

                                          const SizedBox(height: 8),
                                          _buildActionColumn(
                                            secondStops == 0
                                                ? 'Direct'
                                                : '$secondStops stop${secondStops > 1 ? 's' : ''}',
                                            formatDuration(secondDuration),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    firstAirlineName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Divider(height: 1),
                                SizedBox(height: 10),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),

                                  leading: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        _buildBaggageIcon(Icons.backpack),
                                        const SizedBox(width: 4),
                                        _buildBaggageIcon(Icons.work_outline),
                                        const SizedBox(width: 4),
                                        _buildBaggageIcon(Icons.luggage),
                                      ],
                                    ),
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                            ),
                                            builder: (BuildContext context) {
                                              bool priceDetailSelected = false;
                                              final pricing =
                                                  offer['pricing'] ?? {};
                                              return StatefulBuilder(
                                                builder:
                                                    (
                                                      BuildContext context,
                                                      StateSetter setModalState,
                                                    ) {
                                                      return AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 0,
                                                            ),
                                                        height:
                                                            priceDetailSelected
                                                            ? 500
                                                            : 380,
                                                        padding:
                                                            const EdgeInsets.all(
                                                              20,
                                                            ),
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(
                                                                      20,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                height: 6,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .grey[400],
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),

                                                            const Text(
                                                              "Price details",
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            const Text(
                                                              "Flight",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),

                                                            InkWell(
                                                              onTap: () {
                                                                setModalState(() {
                                                                  priceDetailSelected =
                                                                      !priceDetailSelected;
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12.0,
                                                                    ),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Adult(${uppercontroller.adults.value})",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const Spacer(),
                                                                    const Text(
                                                                      "\$111.09",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Icon(
                                                                      priceDetailSelected
                                                                          ? Icons.keyboard_arrow_up
                                                                          : Icons.keyboard_arrow_down,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            if (priceDetailSelected)
                                                              AnimatedOpacity(
                                                                duration:
                                                                    const Duration(
                                                                      milliseconds:
                                                                          300,
                                                                    ),
                                                                opacity:
                                                                    priceDetailSelected
                                                                    ? 1.0
                                                                    : 0.0,
                                                                child: Column(
                                                                  children: [
                                                                    _buildPriceRow(
                                                                      "Flight fare",
                                                                      '\$${pricing['baseFare'] ?? '0.00'}',
                                                                    ),
                                                                    _buildPriceRow(
                                                                      "Airline taxes and fees",
                                                                      '\$${pricing['taxes'] ?? '0.00'}',
                                                                    ),
                                                                    _buildPriceRow(
                                                                      "Platform service fee",
                                                                      "\$14.87",
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                            const Divider(
                                                              height: 30,
                                                            ),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      "Total",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "Includes taxes and fees",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[600],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '\$${pricing['total'] ?? '0.00'}',
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        24,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            const Spacer(),

                                                            SizedBox(
                                                              width: double
                                                                  .infinity,
                                                              height: 60,
                                                              child: ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      GuzoTheme
                                                                          .primaryGreen,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  "Close",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                              );
                                            },
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              offer["pricing"]["total"]
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Icon(
                                              Icons.info_outline,
                                              size: 20,
                                              color: Colors.grey[600],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
          if (_isExpanded)
            GestureDetector(
              onTap: _toggleDrawer,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5),
              ),
            ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 15,
                ),
                decoration: const BoxDecoration(
                  color: GuzoTheme.White,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFFFC107),
                                  width: 6,
                                ),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                  Expanded(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => Row(
                                          children: [
                                            Text(
                                              flightDataController
                                                  .recievedFromFromName
                                                  .value,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                              ),
                                              child: Icon(
                                                Icons.swap_horiz,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                            ),
                                            Text(
                                              flightDataController
                                                  .recievedFromToName
                                                  .value,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Obx(() {
                                        final isRound = uppercontroller.selectedTripType.value == "Round-trip";
                                        final dateText = isRound
                                            ? "${flightDataController.selectedDateRoundTripStart.value} - ${flightDataController.selectedDateRoundTripend.value} · ${uppercontroller.adults.value} adult · ${uppercontroller.cabinClass.value}"
                                            : "${flightDataController.selectedDateOneWay.value} · ${uppercontroller.adults.value} adult · ${uppercontroller.cabinClass.value}";
                                        return Text(
                                          dateText,
                                          style: const TextStyle(fontSize: 11, color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        );
                                      }),
                                    ],
                                  ),
                                  ), // close Expanded
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: () => _showSortSheet(context),
                            child: Row(
                              children: [
                                Icon(Icons.swap_vert),
                                SizedBox(width: 8),
                                Text("Sort"),
                                const SizedBox(width: 4),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 12,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          OutlinedButton(
                            onPressed: () => _showFilterSheet(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.tune, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  "Filter",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 12,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(
                                      height: 4,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 17),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Divider(height: 1),
                    ),
                    SizedBox(height: 20),

                    InkWell(
                      onTap: () {},
                      hoverColor: const Color.fromARGB(115, 160, 150, 150),
                      child: ListTile(
                        leading: Icon(
                          Icons.stacked_line_chart,
                          color: Colors.blue[800],
                        ),
                        title: Text(
                          'Genius benefit',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text(
                          'Get price alerts on your device',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Switch(
                          value: _isAlertEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              _isAlertEnabled = value;
                            });
                            if (value == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Genius benefit unlocked!\nPrice alert added to\n Saved',
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 15),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "Manage alert",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 4),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.grey[800],
                                ),
                              );
                            }
                            if (value == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Price alert removed from \n Saved',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Manage alert",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 4),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.grey[800],
                                ),
                              );
                            }
                          },
                          // ignore: deprecated_member_use
                          activeColor: Colors.green,
                          activeTrackColor: Colors.green,
                          activeThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[500],
                          inactiveThumbColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                  ],
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            top: _isExpanded ? 0 : -drawerHeight - 1400,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _toggleDrawer,
                        icon: const Icon(
                          Icons.clear,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        "Edit your search",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  Obx(() => _buildSearchCard(flightDataController)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 15)),
          Text(price, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildActionColumn(String label, String time) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              backgroundColor: Colors.green[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          time,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSearchCard(FlightDataController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFC107), width: 6),
      ),
      child: Column(
        children: [
          _buildTripTypeSelector(controller),
          const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),

          if (controller.selectedTripType.value != 'Multi-city') ...[
            _buildLocationField(
              controller,
              controller.sortSelected.value
                  ? Icons.flight_land
                  : Icons.flight_takeoff,
              controller.sortSelected.value
                  ? controller.recievedFromTo.value
                  : controller.recievedFromFrom.value,
              !controller.sortSelected.value,
              index: -1,
            ),
            _buildSwapButtonRow(controller),
            _buildLocationField(
              controller,
              controller.sortSelected.value
                  ? Icons.flight_takeoff
                  : Icons.flight_land,
              controller.sortSelected.value
                  ? controller.recievedFromFrom.value
                  : controller.recievedFromTo.value,
              controller.sortSelected.value,
              index: -1,
            ),
            const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),
            _buildDateField(context, controller, -1),
          ],

          if (controller.selectedTripType.value == 'Multi-city') ...[
            for (int i = 0; i < controller.multiCitySegments.length; i++) ...[
              if (i > 0)
                const Divider(
                  height: 1,
                  color: Color(0xFFFFC107),
                  thickness: 6,
                ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(""),
                    if (controller.multiCitySegments.length > 2)
                      GestureDetector(
                        onTap: () => controller.removeSegment(i),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.clear,
                            color: Color.fromARGB(255, 46, 45, 45),
                            size: 25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              _buildLocationField(
                controller,
                Icons.flight_takeoff,
                controller.multiCitySegments[i].from.value,
                true,
                index: i,
              ),
              _buildSwapButtonRowsecond(),
              _buildLocationField(
                controller,
                Icons.flight_land,
                controller.multiCitySegments[i].to.value,
                false,
                index: i,
              ),
              const Divider(height: 1, indent: 55),
              _buildDateField(context, controller, i),
            ],

            const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),
            _buildAddFlightButton(controller),
          ],

          const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),
          _buildPassengerField(controller),
          const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildLocationField(
    FlightDataController controller,
    IconData icon,
    String text,
    bool isFromField, {
    required int index,
  }) {
    String displayResult = text.isEmpty
        ? (isFromField ? "Where From?" : "Where to?")
        : text;

    return InkWell(
      onTap: () => Get.to(() => AirportSearchPage(
            title: displayResult,
            isFrom: isFromField,
            segmentIndex: index,
          )),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 41, 42, 42)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                displayResult,
                style: TextStyle(
                  fontSize: 16,
                  color: displayResult.contains('?')
                      ? Colors.grey
                      : Colors.black,
                  fontWeight: displayResult.contains('?')
                      ? FontWeight.normal
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    FlightDataController controller,
    int index,
  ) {
    return InkWell(
      onTap: () async {
        if (controller.selectedTripType.value == 'Round-trip') {
          _showCustomRangePicker(context, controller);
        } else {
          Get.to(
            () => WhenWhenClickedPage(index: index),
            transition: Transition.downToUp,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 20),
            const SizedBox(width: 16),
            Obx(
              () => Text(
                index == -1
                    ? controller.selectedTripType.value == "Round-trip"
                          ? controller.selectedDate.value
                          : controller.selectedDateOneWay.value
                    : controller.multiCitySegments[index].date.value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomRangePicker(
    BuildContext context,
    FlightDataController controller,
  ) {
    var tempStart = "".obs;
    var tempEnd = "".obs;
    PickerDateRange? selectedRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "\nWhen?",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: GuzoTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SfDateRangePicker(
                  backgroundColor: Colors.white,
                  // hoverColor: Colors.transparent,
                  navigationDirection:
                      DateRangePickerNavigationDirection.vertical,
                  enableMultiView: true,
                  navigationMode: DateRangePickerNavigationMode.scroll,
                  selectionMode: DateRangePickerSelectionMode.range,
                  showNavigationArrow: false,

                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  selectionRadius: 30,
                  monthCellStyle: const DateRangePickerMonthCellStyle(
                    cellDecoration: BoxDecoration(color: Colors.white),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    todayTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006D5B),
                    ),
                    leadingDatesTextStyle: TextStyle(color: Colors.grey),
                    trailingDatesTextStyle: TextStyle(color: Colors.grey),
                  ),

                  selectionTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),

                  rangeTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),

                  headerStyle: const DateRangePickerHeaderStyle(
                    backgroundColor: Colors.white,
                    // hoverColor: Colors.transparent,
                    textAlign: TextAlign.left,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    viewHeaderHeight: 80,
                    dayFormat: 'EEE',
                    enableSwipeSelection: false,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // ignore: deprecated_member_use
                  rangeSelectionColor: Colors.grey.withOpacity(0.12),
                  startRangeSelectionColor: const Color(0xFF006D5B),
                  endRangeSelectionColor: const Color(0xFF006D5B),
                  todayHighlightColor: Colors.white,

                  minDate: DateTime.now(),
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          selectedRange = args.value;
                          tempStart.value = selectedRange?.startDate != null
                              ? DateFormat(
                                  'EEE, MMM dd',
                                ).format(selectedRange!.startDate!)
                              : "";
                          tempEnd.value = selectedRange?.endDate != null
                              ? DateFormat(
                                  'EEE, MMM dd',
                                ).format(selectedRange!.endDate!)
                              : "";
                        }
                      },
                ),
              ),

              _buildPickerFooter(context, controller, tempStart, tempEnd, () {
                if (selectedRange?.startDate != null &&
                    selectedRange?.endDate != null) {
                  controller.updateDateRange(
                    selectedRange!.startDate!,
                    selectedRange!.endDate!,
                  );
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                    "Selection Required",
                    "Please select both departure and return dates.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                }
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerFooter(
    BuildContext context,
    FlightDataController controller,
    RxString start,
    RxString end,
    VoidCallback onDone,
  ) {
    return Material(
      elevation: 20,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPickerFooterRound(
                    "Departure date",
                    start,
                    "Departure",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPickerFooterRound("Return date", end, "Return"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: const Color(0xFF006D5B),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerFooterRound(String label, RxString dateObs, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
        ),
        const SizedBox(height: 10),
        Obx(
          () => SizedBox(
            height: 60,

            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: dateObs.value.isEmpty ? hint : dateObs.value,
                hintStyle: TextStyle(
                  color: dateObs.value.isEmpty ? Colors.grey : Colors.black,
                ),
                prefixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddFlightButton(FlightDataController controller) {
    return InkWell(
      onTap: () => controller.addSegment(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Center(
          child: Text(
            'Add a flight',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF006D5B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector(FlightDataController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              _buildRadioOption(controller, 'Round-trip'),
              const Spacer(),
              _buildRadioOption(controller, 'One-way'),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildRadioOption(controller, 'Multi-city'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(FlightDataController controller, String label) {
    return Obx(
      () => InkWell(
        onTap: () => uppercontroller.toggleTripType(label),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: label,
              // ignore: deprecated_member_use
              groupValue: uppercontroller.selectedTripType.value,
              // ignore: deprecated_member_use
              onChanged: (v) => uppercontroller.toggleTripType(v!),
              activeColor: const Color.fromARGB(255, 2, 89, 16),
              visualDensity: VisualDensity.compact,
            ),
            Text(label, style: const TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwapButtonRow(FlightDataController controller) {
    return Row(
      children: [
        const Expanded(child: Divider(indent: 55, endIndent: 10)),

        IconButton(
          onPressed: () => uppercontroller.toggleSort(),
          icon: SvgPicture.network(
            "https://unpkg.com/lucide-static/icons/arrow-up-down.svg",
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSwapButtonRowsecond() => const Row(
    children: [Expanded(child: Divider(indent: 55, endIndent: 10, height: 20))],
  );

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String from = uppercontroller.recievedFromFrom.value;
          String to = uppercontroller.recievedFromTo.value;
          String date = uppercontroller.selectedDateRaw.value;
          String date2 = uppercontroller.selectedDateRaw2.value;

          if (from.isEmpty || to.isEmpty || date.isEmpty) {
            Get.snackbar(
              "Missing Information",
              "Please select origin, destination and date",
              snackPosition: SnackPosition.BOTTOM,
            );

            return;
          }
          uppercontroller.selectedTripType.value == "Round-trip"
              ? flightApicontroller.searchFlights(
                  originCode: from,
                  destinationCode: to,
                  departureDate: date,
                  returnDate: date2,
                )
              : flightApicontroller.searchFlights(
                  originCode: from,
                  destinationCode: to,
                  departureDate: date,
                );
          Get.to(() => SearchedFlightsPage());

          _toggleDrawer();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006D5B),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: const RoundedRectangleBorder(),
        ),
        child: const Text(
          'Search',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerField(FlightDataController controller) {
    return InkWell(
      onTap: () => Get.to(() => const WhoFlyingPage()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: Color(0xFF006D5B)),
            const SizedBox(width: 16),
            Obx(
              () => Text(
                controller.passengerSummary.value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaggageIcon(IconData icon) {
    return Stack(
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Obx(() {
          final ctrl = flightApicontroller;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort by',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                for (final option in [
                  ('best', 'Best', Icons.star_outline),
                  ('cheapest', 'Cheapest', Icons.attach_money),
                  ('fastest', 'Fastest', Icons.bolt_outlined),
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(option.$3),
                    title: Text(option.$2),
                    trailing: ctrl.sortMode.value == option.$1
                        ? const Icon(Icons.check, color: GuzoTheme.primaryGreen)
                        : null,
                    onTap: () {
                      ctrl.setSortMode(option.$1);
                      Get.back();
                    },
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    final ctrl = flightApicontroller;
    final airlines = ctrl.availableAirlines;
    final maxDur = ctrl.maxDurationHours;

    // local state
    int? tempStops = ctrl.filterMaxStops.value;
    double tempDur = ctrl.filterMaxDurationHours.value ?? maxDur;
    var tempDepSlots = Set<int>.from(ctrl.filterDepSlots);
    var tempArrSlots = Set<int>.from(ctrl.filterArrSlots);
    var tempAirlines = Set<String>.from(ctrl.filterAirlines);
    int flightTimesTab = 0; // 0 = departing, 1 = return

    final fromCode = uppercontroller.recievedFromFrom.value;
    final toCode = uppercontroller.recievedFromTo.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final depCounts = ctrl.depSlotCounts;
          final arrCounts = ctrl.arrSlotCounts;
          final resultCount = ctrl.filteredOffers.length;

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.92,
            maxChildSize: 0.95,
            builder: (_, scrollCtrl) => Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.close),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setSheet(() {
                            tempStops = null;
                            tempDur = maxDur;
                            tempDepSlots = {};
                            tempArrSlots = {};
                            tempAirlines = {};
                          });
                          ctrl.clearFilters();
                        },
                        child: const Text(
                          'Reset all',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Filter by',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 40),
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const Text(
                        'Number of stops',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final entry in [
                        (0, 'Direct only'),
                        (1, 'Max 1 stop per flight'),
                        (2, 'Max 2 stops per flight'),
                      ]) ...[
                        InkWell(
                          onTap: () => setSheet(
                            () => tempStops = tempStops == entry.$1
                                ? null
                                : entry.$1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${entry.$2} (${ctrl.stopsCount(entry.$1)})',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        'From ${ctrl.stopsMinPrice(entry.$1)} per adult',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Radio<int?>(
                                  value: entry.$1,
                                  // ignore: deprecated_member_use
                                  groupValue: tempStops,
                                  activeColor: Colors.blue,
                                  // ignore: deprecated_member_use
                                  onChanged: (v) =>
                                      setSheet(() => tempStops = v),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                      const SizedBox(height: 20),

                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Maximum travel time (hours)',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${tempDur.toStringAsFixed(0)} hours',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Slider(
                        value: tempDur,
                        min: 1,
                        max: maxDur,
                        divisions: maxDur.toInt(),
                        activeColor: Colors.blue,
                        onChanged: (v) => setSheet(() => tempDur = v),
                      ),
                      const Divider(height: 24),

                      const Text(
                        'Flight times',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tab bar
                      Row(
                        children: [
                          for (final t in [
                            (0, 'Departing flight'),
                            (1, 'Return flight'),
                          ])
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setSheet(() => flightTimesTab = t.$1),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        t.$2,
                                        style: TextStyle(
                                          color: flightTimesTab == t.$1
                                              ? Colors.blue
                                              : Colors.black54,
                                          fontWeight: flightTimesTab == t.$1
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      color: flightTimesTab == t.$1
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        flightTimesTab == 0
                            ? 'Departs from $fromCode'
                            : 'Arrives to $toCode',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (int i = 0; i < 4; i++) ...[
                        Builder(
                          builder: (_) {
                            final slots = flightTimesTab == 0
                                ? tempDepSlots
                                : tempArrSlots;
                            final counts = flightTimesTab == 0
                                ? depCounts
                                : arrCounts;
                            final label = ctrl.timeSlotLabels[i];
                            final checked = slots.contains(i);
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '$label (${counts[i]})',
                                style: const TextStyle(fontSize: 14),
                              ),
                              value: checked,
                              activeColor: Colors.blue,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (v) => setSheet(() {
                                if (flightTimesTab == 0) {
                                  v == true
                                      ? tempDepSlots.add(i)
                                      : tempDepSlots.remove(i);
                                } else {
                                  v == true
                                      ? tempArrSlots.add(i)
                                      : tempArrSlots.remove(i);
                                }
                              }),
                            );
                          },
                        ),
                        const Divider(height: 1),
                      ],
                      const SizedBox(height: 20),

                      if (airlines.isNotEmpty) ...[
                        const Text(
                          'Airlines',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () =>
                                  setSheet(() => tempAirlines = {}),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                              ),
                              child: const Text(
                                'Select all',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: () => setSheet(
                                () => tempAirlines = airlines
                                    .map((a) => a['code']!)
                                    .toSet(),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                              ),
                              child: Text(
                                'Reset',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                        for (final a in airlines) ...[
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              '${a['name']} (${ctrl.airlineOfferCount(a['code']!)})',
                              style: const TextStyle(fontSize: 14),
                            ),
                            value:
                                tempAirlines.isEmpty ||
                                tempAirlines.contains(a['code']),
                            activeColor: Colors.blue,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (checked) => setSheet(() {
                              if (tempAirlines.isEmpty) {
                                tempAirlines = airlines
                                    .map((x) => x['code']!)
                                    .toSet();
                                if (checked != true) {
                                  tempAirlines.remove(a['code']);
                                }
                              } else if (checked == true) {
                                tempAirlines.add(a['code']!);
                                if (tempAirlines.length == airlines.length) {
                                  tempAirlines = {};
                                }
                              } else {
                                tempAirlines.remove(a['code']);
                              }
                            }),
                          ),
                          const Divider(height: 1),
                        ],
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ctrl.setFilterStops(tempStops);
                        ctrl.setFilterMaxDuration(
                          tempDur >= maxDur ? null : tempDur,
                        );
                        ctrl.setFilterDepSlots(tempDepSlots);
                        ctrl.setFilterArrSlots(tempArrSlots);
                        ctrl.setFilterAirlines(tempAirlines);
                        Get.back();
                      },
                      child: Text(
                        'Show $resultCount results',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
