import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/newFlights/select_your_seats_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelProtectionScreen extends StatefulWidget {
  const TravelProtectionScreen({super.key});

  @override
  State<TravelProtectionScreen> createState() => _TravelProtectionScreenState();
}

class _TravelProtectionScreenState extends State<TravelProtectionScreen> {
  int selectedOption = -1;
  bool showAdultBreakdown = false;
  int selectedOptionForPassingTonextPage = 0;
  final flightDatacontroller = Get.find<FlightDataController>();

  @override
  Widget build(BuildContext context) {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final offer = flightApicontroller.selectedOffer.value;
    final currency = offer?['pricing']?['currency'] ?? '';
    final flightDatacontroller = Get.find<FlightDataController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: GuzoTheme.primaryGreen,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          titleSpacing: 0,
          title: Text(
            'Choose your cover',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(36),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep(true, true),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: _buildLine(true),
                  ),
                  _buildStep(false, false, isCurrent: true),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildLineDotted(),
                  ),
                  _buildStep(false, false),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildLineDotted(),
                  ),
                  _buildStep(false, false),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildLineDotted(),
                  ),
                  _buildStep(false, false),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Travel protection",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Protect yourself from the unexpected. XCover's Travel Protection covers flight costs and more.",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () {
                      flightDatacontroller.setPrice2(0);
                      flightDatacontroller.setPrice3();
                      setState(() {
                        selectedOption = 0;
                        selectedOptionForPassingTonextPage = 5;
                      });
                    },
                    child: _optionCard(
                      index: 0,
                      title: "No travel protection",
                      subtitle: "€ 0 per traveler",
                      icon: Icons.shield_outlined,
                    ),
                  ),

                  const SizedBox(height: 12),

                  InkWell(
                    onTap: () {
                      flightDatacontroller.setPrice2(36.84);
                      flightDatacontroller.setPrice3();
                      setState(() {
                        selectedOption = 1;
                        selectedOptionForPassingTonextPage = 5;
                      });
                    },
                    child: _protectionCard(),
                  ),
                  const SizedBox(height: 15),

                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                            text: "I confirm that I've read and agree to the ",
                          ),
                          TextSpan(
                            text: "Policy Terms",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const TextSpan(text: ", "),
                          TextSpan(
                            text: "Insurance Product Information Document",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const TextSpan(text: ", and "),
                          TextSpan(
                            text: "DIP Danni",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const TextSpan(
                            text:
                                ", and that all insured travelers are residents of Italy.",
                          ),
                          const TextSpan(
                            text:
                                "This insurance is provided by Cover Genius Europe B.V. and underwritten by Steadfast Insurance Partners Ltd. (previously Cowen Insurance Company Ltd.), which is authorized by the Malta Financial Services Authority",
                            style: TextStyle(),
                          ),
                          const TextSpan(
                            text:
                                "Cover Genius Europe B.V., trading as XCover, is regulated by the AFM (No. 12046177).",
                          ),
                          const TextSpan(
                            text:
                                "Booking.com B.V. is an Ancillary Insurance Intermediary of Cover Genius Europe B.V.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(.08),
                  ),
                ],
              ),
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
                      final pricing = offer?['pricing'] ?? {};
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
                                          '\$$currency ${pricing['baseFare'] ?? '0.00'}',
                                        ),
                                        _buildPriceRow(
                                          "Airline taxes and fees",
                                          '\$$currency ${pricing['taxes'] ?? '0.00'}',
                                        ),
                                        _buildPriceRow(
                                          "Platform service fee",
                                          '\$$currency ${pricing['platform'] ?? '0.00'}',
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
                                      '$currency ${flightDatacontroller.totalPrice.value}',
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
                  children: [
                    Text(
                      "$currency ${flightDatacontroller.totalPrice.value}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),
                    SizedBox(
                      width: 160,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GuzoTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () {
                          if (selectedOptionForPassingTonextPage == 5) {
                            Get.to(() => SelectYourSeatsPage());
                          } else {
                            Get.snackbar(
                              "Please select an option",
                              "You must select either 'No travel protection' or 'Travel protection' to proceed.",
                              backgroundColor: GuzoTheme.accentGold,
                              colorText: Colors.black,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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

  Widget _buildLine(bool isActive, {bool isDotted = false}) {
    return Container(
      width: 30,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isDotted ? null : (isActive ? Colors.white : Colors.white54),
      child: Text(""),
    );
  }

  Widget _optionCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedOption == index;

    return GestureDetector(
      // onTap: () => setState(() => selectedOption = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Radio(
              value: index,
              groupValue: selectedOption,
              onChanged: (v) => setState(() => selectedOption = v as int),
            ),
          ],
        ),
      ),
    );
  }

  Widget _protectionCard() {
    final isSelected = selectedOption == 1;

    return GestureDetector(
      // onTap: () => setState(() => selectedOption = 1),
      child: Container(
        // padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.green),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Travel protection",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "€ 36.84 per traveler",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Radio(
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (v) => setState(() => selectedOption = v as int),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (isSelected)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Divider(color: Colors.grey, thickness: 0.3),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12.0,
                        bottom: 12,
                        left: 12,
                      ),
                      child: const Text(
                        "Added for all travelers",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.grey, thickness: 0.3),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Trip cancellation",
                "Up to 100% of flight ticket costs back if you cancel or cut short your trip due to illness, injury, or other covered events",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Emergency medical",
                "Up to €5,000,000 emergency medical treatment and \$ 250 emergency dental treatment (international trips only)",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "24/7 emergency assistance",
                "Get help if anything goes wrong on your trip",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Prepaid trip costs",
                "Up to €250 back on stays and 500 back on attractions if you cancel or cut short your trip due to coved events",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Personal items",
                "Up to €1000 if lost or damaged",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Personal items",
                "Up to €1000 if your things are lost or damaged",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Missed flights",
                "Up to €750 to get you to your location ",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _feature(
                "Flight delays",
                "Up to €400 for baggage food,and hotel cost",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 10, right: 12),
              child: _featuree(
                "Pre - existing medical conditions are \n not covered ",
                "  ",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feature(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$title - ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: desc, style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuree(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.close, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$title – ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isCompleted, bool isPast, {bool isCurrent = false}) {
    return Container(
      width: 17,
      height: 17,
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

  Widget _buildLineDotted() {
    return Container(
      width: 40,
      child: Row(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  231,
                  229,
                  229,
                ).withOpacity(0.39),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
