// ignore_for_file: sized_box_for_whitespace

import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/newFlights/contact_who_flying_page.dart';
import 'package:booking/newFlights/select_your_seats_inner_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectYourSeatsPage extends StatefulWidget {
  const SelectYourSeatsPage({super.key});

  @override
  State<SelectYourSeatsPage> createState() => _SelectYourSeatsPageState();
}

class _SelectYourSeatsPageState extends State<SelectYourSeatsPage> {
  final flightDataController = Get.find<FlightDataController>();
  // ignore: unused_field
  int _maxTravelers = 3;
  var _numberOfSelectedSeat = 0;
  // ignore: unused_field
  var _numberOfSelectedSeat2 = 0;
  final double _pricePerSeat = 200.0;

  double get totalPrice {
    if (flightDataController.numberOfTravelers.value == 0) {
      return _pricePerSeat;
    }
    return _numberOfSelectedSeat * _pricePerSeat;
  }

  @override
  void initState() {
    super.initState();
    _initializeMaxTravelers();
  }

  void _initializeMaxTravelers() {
    _maxTravelers = flightDataController.numberOfTravelers.value;
    _numberOfSelectedSeat = flightDataController.numberOfselectedSeats.value;
    _numberOfSelectedSeat2 = flightDataController.numberOfselectedSeats2.value;
  }

  @override
  Widget build(BuildContext context) {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final offer = flightApicontroller.selectedOffer.value;
    final currency = offer?['pricing']?['currency'] ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),

        child: AppBar(
          backgroundColor: GuzoTheme.primaryGreen,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'Select your seats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep(true, true),
                  _buildLine(true),
                  _buildStep(true, true),
                  _buildLine(true),
                  _buildStep(true, false, isCurrent: true),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildLineDotted(),
                  ),
                  _buildStep(false, false),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildLineDotted(),
                  ),
                  _buildStep(false, false),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                // Build a SeatFlightGroup for each flight in the offer
                ...() {
                  final flights = flightApicontroller.selectedOffer.value?['flights'] as List? ?? [];
                  final fromName = flightDataController.recievedFromFromName.value;
                  final toName = flightDataController.recievedFromToName.value;
                  return List.generate(flights.length, (i) {
                    final flight = flights[i] as Map<String, dynamic>;
                    final segs = flight['segments'] as List? ?? [];
                    final firstSeg = segs.isNotEmpty ? segs.first : null;
                    final airline = firstSeg?['airlineName'] ?? '';
                    final dur = flight['duration'] as String? ?? '';
                    final durMatch = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?').firstMatch(dur);
                    final durStr = durMatch != null
                        ? '${durMatch.group(1) ?? '0'}h ${durMatch.group(2) ?? '0'}m'
                        : dur;
                    final origin = i == 0 ? fromName : toName;
                    final dest = i == 0 ? toName : fromName;
                    final travelers = flightDataController.numberOfTravelers.value;
                    final selected = i == 0
                        ? flightDataController.numberOfselectedSeats.value
                        : flightDataController.numberOfselectedSeats2.value;
                    return SeatFlightGroup(
                      mainTitle: 'Flight to $dest',
                      route: '$origin to $dest',
                      details: '$durStr · $airline',
                      selectionStatus: '$selected of $travelers seat selected . \$0.0',
                    );
                  });
                }(),
              ],
            ),
          ),
                       Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          bool priceDetailSelected = false;
                          final pricing = offer?['pricing'] ?? {};

                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setModalState) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 0),
                                height: priceDetailSelected ? 800 : 615,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 6,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    const Text(
                                      "Price details",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Flight",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Adult(2)",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const Spacer(),
                                            const Text(
                                              "\$111.09",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              priceDetailSelected
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Theme.of(context).iconTheme.color,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    if (priceDetailSelected)
                                      AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        opacity: priceDetailSelected
                                            ? 1.0
                                            : 0.0,
                                        child: Column(
                                          children: [
                                            _buildPriceRow(
                                              "Flight fare",
                                              '\$$currency ${pricing['baseFare'] ?? '0.00'}',
                                            ),
                                            _buildPriceRow(
                                              "Airline taxes and fees",
                                              '\$$currency ${pricing['taxes'] ?? '0.00'}',
                                            ),
                                            _buildPriceRow("W9", "\$0.056"),
                                            _buildPriceRow("L3", "\$0.487"),
                                            _buildPriceRow(
                                              "Taxe de depart de laerport",
                                              "\$4.87",
                                            ),
                                            _buildPriceRow(
                                              "Airline fuel and inurance surcharge",
                                              "\$44.87",
                                            ),
                                          ],
                                        ),
                                      ),

                                    const Divider(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Extras",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 7),

                                            Text(
                                              "Flexible ticket",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 7),

                                            Text(
                                              "Travel protection",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 30.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(""),
                                              SizedBox(height: 7),
                                              const Text(
                                                "\$ 34.06",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              SizedBox(height: 7),

                                              const Text(
                                                "\$ 36.06",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 10),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Discounts",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              "Guzo.com pays",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 30.0,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(""),
                                              SizedBox(height: 15),
                                              const Text(
                                                "\$ -4.06",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 10),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Total",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              "Includes taxes and fees",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 25.0,
                                          ),
                                          child: Text(
                                            "$currency ${flightDataController.totalPrice.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),
                                    Divider(height: 1),
                                    // SizedBox(height: 25),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20.0,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 55,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                GuzoTheme.primaryGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            "Close",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
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
                          '$currency ${flightDataController.totalPrice.value}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.info_outline,
                          size: 22,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => ContactWhoFlyingPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GuzoTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  Widget _buildPriceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 15)),
          Text(price, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildLineDotted() {
    return Container(
      width: 40,
      child: Row(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.39),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStep(bool isCompleted, bool isPast, {bool isCurrent = false}) {
  return Container(
    width: 16,
    height: 16,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isCurrent
          ? Colors.transparent
          : (isCompleted ? Colors.orange : Colors.transparent),
      border: Border.all(
        color: isCurrent
            ? Colors.orange
            : (isCompleted ? Colors.orange : Colors.white),
        width: isCurrent ? 3 : 1.5,
      ),
    ),
    child: isCurrent
        ? Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          )
        : null,
  );
}

Widget _buildLine(bool isActive, {bool isDotted = false}) {
  return Container(
    width: 30,
    height: 3,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    color: isDotted ? null : (isActive ? Colors.white : Colors.white54),
    child: Text(""),
  );
}

class SeatFlightGroup extends StatelessWidget {
  final String mainTitle, route, details, selectionStatus;

  const SeatFlightGroup({
    super.key,
    required this.mainTitle,
    required this.route,
    required this.details,
    required this.selectionStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            mainTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        details,
                        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectionStatus,
                        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => SelectYourSeatsInnerPage(
                        Title: "Addis ababa to Arba Munch",
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Change seat",
                          style: TextStyle(
                            color: GuzoTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        // SizedBox(width: 180),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color.fromARGB(255, 22, 236, 72),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}