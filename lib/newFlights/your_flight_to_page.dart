import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/newFlights/select_ticket_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YourFlightToPage extends StatefulWidget {
  const YourFlightToPage({super.key});

  @override
  State<YourFlightToPage> createState() => _YourFlightToPageState();
}

class _YourFlightToPageState extends State<YourFlightToPage> {
  final flightDatacontroller = Get.find<FlightDataController>();
  String formatDurationFromTimes(String depTime, String arrTime) {
    if (depTime.isEmpty || arrTime.isEmpty) return '--h --m';
    try {
      final dep = DateTime.parse(depTime);
      final arr = DateTime.parse(arrTime);
      final diff = arr.difference(dep);
      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    } catch (_) {
      return '--h --m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final offer = flightApicontroller.selectedOffer.value;

    if (offer == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GuzoTheme.primaryGreen,
          title: const Text("Your Flight"),
        ),
        body: const Center(child: Text("No flight selected")),
      );
    }

    final price = offer['pricing']?['total'] ?? '';
    final currency = offer['pricing']?['currency'] ?? '';

    return Scaffold(
      backgroundColor: GuzoTheme.White,
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Your flight to ${flightDatacontroller.recievedFromToName.value}",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: const [
          Icon(Icons.favorite_border, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.share, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Obx(() {
                  if (flightApicontroller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final selectedOffer = flightApicontroller.selectedOffer.value;
                  if (selectedOffer == null) {
                    return const Center(child: Text("No flight selected"));
                  }

                  final flightsList = selectedOffer['flights'] as List? ?? [];
                  if (flightDatacontroller.selectedTripType.value ==
                      "One-way") {}

                  return Column(
                    children: flightsList.asMap().entries.map<Widget>((entry) {
                      int flightIndex = entry.key;
                      var flightData = entry.value;
                      final segmentsList =
                          flightData['segments'] as List? ?? [];
                      final stops = segmentsList.length - 1;

                      // Use first and last segment for overall dep/arr
                      final firstSeg = segmentsList.isNotEmpty ? segmentsList.first : null;
                      final lastSeg = segmentsList.isNotEmpty ? segmentsList.last : null;
                      final totalDuration = formatDurationFromTimes(
                        firstSeg?['departureDateTime'] ?? '',
                        lastSeg?['arrivalDateTime'] ?? '',
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            flightIndex == 0
                                ? 'Flight to ${flightDatacontroller.recievedFromToName.value}'
                                : 'Flight to ${flightDatacontroller.recievedFromFromName.value}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              Text(stops == 0 ? 'Direct' : '$stops stop${stops > 1 ? 's' : ''}'),
                              Text(' . $totalDuration',
                                  style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ...segmentsList.asMap().entries.map<Widget>((segEntry) {
                            final segment = segEntry.value;
                            final depDate = segment['departureDateTime'] ?? '';
                            final depCode = segment['departureAirport'] ?? '';
                            final depCity = segment['departureAirportName'] ?? '';
                            final depTerminal = segment['departureTerminal'];
                            final arrDate = segment['arrivalDateTime'] ?? '';
                            final arrCode = segment['arrivalAirport'] ?? '';
                            final arrCity = segment['arrivalAirportName'] ?? '';
                            final titleAirline = segment['airlineName'] ?? '';
                            final airlineCode = segment['airlineCode'] ?? '';
                            final classOfService = segment['classOfService'] ?? '';
                            final flightNum = segment['flightNumber'] ?? '';
                            final duration = formatDurationFromTimes(depDate, arrDate);

                            return Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(Icons.circle_outlined, size: 20, color: Colors.black),
                                      const SizedBox(height: 5),
                                      Container(width: 1.5, height: 110, color: Colors.grey.shade300),
                                      const SizedBox(height: 5),
                                      const Icon(Icons.circle_outlined, size: 18, color: Colors.black54),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(formatTime(depDate),
                                            style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                        Text('$depCode · $depCity',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        if (depTerminal != null)
                                          Text(depTerminal, style: const TextStyle(color: Colors.black54)),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: "https://content.airhex.com/content/logos/airlines_${airlineCode}_350_100_r.png",
                                              width: 60, height: 30,
                                              errorWidget: (_, __, ___) => const Icon(Icons.flight),
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(titleAirline, style: const TextStyle(color: Colors.black54)),
                                                Text('Flight $airlineCode$flightNum · $classOfService',
                                                    style: const TextStyle(color: Colors.black54)),
                                                Text('Flight time $duration',
                                                    style: const TextStyle(color: Colors.black54)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Text(formatTime(arrDate),
                                            style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                        Text('$arrCode · $arrCity',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 30),
                Container(
                  color: GuzoTheme.White,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        "Included baggage",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Total baggage allowance for each flight",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 12),
                      PolicyItem(
                        icon: Icons.work_outline,
                        text: "1 personal item",
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35.0),
                        child: Text(
                          "include",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                      ),
                      PolicyItem(
                        icon: Icons.luggage_outlined,
                        text: "1 carry-on bag",
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35.0),
                        child: Text(
                          "include",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                      ),
                      PolicyItem(
                        icon: Icons.event_available,
                        text: "1 checked bag",
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 35.0),
                        child: Text(
                          "include",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: GuzoTheme.White,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        "Extras you might like",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Can be added for a free",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.roundabout_left_rounded),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Flexible ticket\nDate change possible\n+CAD 53.11 Add this in the next steps",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: GuzoTheme.White,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        "Need extra baggage?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.battery_0_bar_outlined),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "No move baggage can be added now-check with the airline after you book",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: SafeArea(
              child: InkWell(
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
                      final pricing = offer['pricing'] ?? {};
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setModalState) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 0),
                            height: priceDetailSelected ? 500 : 380,
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
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
                                      borderRadius: BorderRadius.circular(4),
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
                                        Text(
                                          "Adult(${flightDatacontroller.adults.value})",
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
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                if (priceDetailSelected)
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: priceDetailSelected ? 1.0 : 0.0,
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
                                          '\$${pricing['platform'] ?? '0.00'}',
                                        ),
                                      ],
                                    ),
                                  ),

                                const Divider(height: 30),

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
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$${pricing['total'] ?? '0.00'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: GuzoTheme.primaryGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Close",
                                      style: TextStyle(color: Colors.white),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$currency $price',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline, size: 16),
                      ],
                    ),
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          flightDatacontroller.setTotalPriceFromApi(price);
                          Get.to(() => SelectTicketScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GuzoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Select',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(String dateTime) {
    if (dateTime.isEmpty) return '--:--';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '--:--';
    }
  }
}

class PolicyItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const PolicyItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 27, color: Colors.black),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
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
