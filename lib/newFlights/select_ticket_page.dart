// ignore_for_file: unused_element_parameter

import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/ticket_controller.dart';
import 'package:booking/newFlights/flight_customize_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTicketScreen extends StatefulWidget {
  const SelectTicketScreen({super.key});

  @override
  State<SelectTicketScreen> createState() => _SelectTicketScreenState();
}

class _SelectTicketScreenState extends State<SelectTicketScreen> {
  int selectedIndex = -1;
  int selectedIndexForNavigation = 0;
  final controller = Get.put(TicketController());
  final flightDatacontroller = Get.find<FlightDataController>();

  @override
  Widget build(BuildContext context) {
    final flightApicontroller = Get.find<FlightUpdaredController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        title: const Text(
          "Select your ticket type",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  InkWell(
                    onTap: () {
                      flightDatacontroller.setPrice(403.02);
                      flightDatacontroller.setPrice31();
                      setState(() {
                        selectedIndex = 0;
                        selectedIndexForNavigation = 5;
                      });
                    },
                    child: _TicketCard(
                      context: context,
                      index: 0,
                      leading: const Icon(Icons.support_agent),
                      title: "Standard ticket",
                      price: "+ CAD 0 (CAD 403.02 per traveler)",
                      features: const [
                        "Cheapest price",
                        "No need for flexibility - you're sure about your plans",
                      ],
                      selected: selectedIndex == 0,
                    ),
                  ),

                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      flightDatacontroller.setPrice(456.13);
                      setState(() {
                        selectedIndex = 1;
                        selectedIndexForNavigation = 5;
                      });
                    },
                    child: _TicketCard(
                      context: context,
                      index: 1,
                      leading: const Icon(
                        Icons.support_agent,
                        color: Colors.amber,
                      ),
                      title: "Flexible ticket",
                      price: "+ CAD 53.11 (CAD 456.13 per traveler)",
                      features: const [
                        "Stay flexible with a time or date change",
                        "Request a change up to 24 hours before departure",
                        "No extra fees - only pay the fare difference, if any",
                      ],
                      selected: selectedIndex == 1,
                      highlight: true,
                      showExplanation: controller.showFlexibleExplanation.value,
                      onToggleExplanation: controller.toggleFlexibleExplanation,
                    ),
                  ),

                  const SizedBox(height: 10),
                  const _FlexibleNote(),
                ],
              ),
            ),

            Obx(() {
              final offer = flightApicontroller.selectedOffer.value;
              final currency = offer?['pricing']?['currency'] ?? '';
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 30,
                ),
                color: Theme.of(context).cardColor,
                child: Row(
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
                                  height: priceDetailSelected ? 500 : 380,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                '$currency ${pricing['baseFare'] ?? '0.00'}',
                                              ),
                                              _buildPriceRow(
                                                "Airline taxes and fees",
                                                '$currency ${pricing['taxes'] ?? '0.00'}',
                                              ),
                                              _buildPriceRow(
                                                "Platform service fee",
                                                '$currency ${pricing['platform'] ?? '0.00'}',
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
                                            flightDatacontroller
                                                .totalPrice
                                                .value,
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
                            "$currency ${flightDatacontroller.totalPrice.value}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.info_outline),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          backgroundColor: GuzoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () {
                          if (selectedIndexForNavigation != 5) {
                            Get.snackbar(
                              "Please select a ticket type",
                              "You need to select either standard or flexible ticket to proceed",
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.red.shade800,
                            );
                            return;
                          } else {
                            Get.to(() => FlightCustomizeScreen());
                          }
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
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
}

class _FlexibleNote extends StatelessWidget {
  const _FlexibleNote();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodySmall?.color, height: 1.4),
        children: const [
          TextSpan(
            text: "Flexible tickets are only available during booking. ",
          ),
          TextSpan(
            text:
                "View the Flexible ticket section for terms and conditions. Provided by Flight Network Ltd",
            style: TextStyle(color: GuzoTheme.primaryGreen),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _PriceRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;
  final bool bold;
  final bool discount;
  final bool positive;

  const _PriceRow(
    this.label,
    this.amount, {
    // ignore: unused_element_paramet
    this.isTotal = false,
    // ignore: unused_element_paramete
    this.bold = false,
    // ignore: unused_element_paramete
    this.discount = false,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal || bold ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal || bold ? FontWeight.w600 : FontWeight.w400,
            color: discount
                ? Colors.green.shade700
                : (positive ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyMedium?.color),
          ),
        ),
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  final BuildContext context;
  final int index;
  final Widget leading;
  final String title;
  final String price;
  final List<String> features;
  final bool selected;
  final bool highlight;
  final bool showExplanation;
  final VoidCallback? onToggleExplanation;

  const _TicketCard({
    required this.context,
    required this.index,
    required this.leading,
    required this.title,
    required this.price,
    required this.features,
    required this.selected,
    this.highlight = false,
    this.showExplanation = false,
    this.onToggleExplanation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: selected ? GuzoTheme.primaryGreen : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? GuzoTheme.primaryGreen : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(price, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
            if (highlight) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showPopularBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Popular for trips like yours",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                ),
              ),
            ),
            if (index == 1) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onToggleExplanation,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "What does this mean for me?",
                      style: TextStyle(
                        color: GuzoTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      showExplanation
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.blue.shade700,
                      size: 22,
                    ),
                  ],
                ),
              ),

              if (showExplanation) ...[
                const SizedBox(height: 12),
                const _FlexibleExplanationList(),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _showPopularBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Popular for trips like yours",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text(
                "You're seeing this badge because travelers with trips similar "
                "to yours chose flexible tickets for easy date changes – ideal if your plans might change",
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlexibleExplanationList extends StatelessWidget {
  const _FlexibleExplanationList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.flight),
          title: Text("Your change must be for the same airline and route"),
        ),
        SizedBox(height: 6),
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text(
            "You can make one change per traveler subject to availability",
          ),
        ),
        SizedBox(height: 6),
        ListTile(
          leading: Icon(Icons.psychology),
          title: Text(
            "To request a change contact our Customer Service via live chat or phone "
            "at least 24 hours before departure time",
          ),
        ),
        SizedBox(height: 6),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text(
            "We'll assist with the available flights and payment and confirm your new flight",
          ),
        ),
      ],
    );
  }
}

