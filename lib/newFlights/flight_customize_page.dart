import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/ticket_controller.dart';
import 'package:booking/newFlights/choose_cover.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightCustomizeScreen extends StatefulWidget {
  const FlightCustomizeScreen({super.key});

  @override
  State<FlightCustomizeScreen> createState() => _FlightCustomizeScreenState();
}

class _FlightCustomizeScreenState extends State<FlightCustomizeScreen> {
  final flightDataController = Get.find<FlightDataController>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TicketController());
    final RxInt selectedFastTrack = 1.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: GuzoTheme.primaryGreen,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          titleSpacing: 0,
          title: const Text(
            'Customize your flights',
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
                  _buildStep(true, false, isCurrent: true),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildLine(),
                  ),
                  _buildStep(false, false),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildLine(),
                  ),
                  _buildStep(false, false),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: _buildLine(),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Luggage",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Traveler 1 (Adult)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildLuggageCard(
                    icon: Icons.card_travel,
                    title: "1 personal item",
                    subtitle: "Fits under the seat in front of you",
                    included: true,
                  ),
                  const SizedBox(height: 12),
                  _buildLuggageCard(
                    icon: Icons.luggage,
                    title: "1 carry-on bag (7 kg)",
                    subtitle: "23 x 40 x 55 cm - Up to 7 kg each",
                    included: true,
                  ),
                  const SizedBox(height: 12),
                  _buildLuggageCard(
                    icon: Icons.work,
                    title: "1 checked bag (20 kg total)",
                    subtitle: "Max weight 20 kg",
                    included: true,
                  ),

                  const SizedBox(height: 40),
                  const Text(
                    "Fast Track",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Use the fast lane at airport security to save time and stress less.",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),

                  Obx(
                    () => Column(
                      children: [
                        _buildFastTrackCard(
                          index: 0,
                          isSelected: selectedFastTrack.value == 0,
                          icon: Icons.cancel_outlined,
                          title: "No Fast Track",
                          subtitle: "€ 0",
                          onTap: () => selectedFastTrack.value = 0,
                        ),
                        const SizedBox(height: 12),
                        _buildFastTrackCard(
                          index: 1,
                          isSelected: selectedFastTrack.value == 1,
                          icon: Icons.keyboard_double_arrow_right,
                          title: "Fast Track",
                          subtitle: "€ 41.99 for all travelers",
                          onTap: () => selectedFastTrack.value = 1,
                          details: _buildFastTrackDetails(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Fast Track is non-refundable unless covered by your cancellation policy. Fast Track is non-transferable and can't be used by another person. It's offered by OY SRG Finland Ab in collaboration with Airobot and Passnfly.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "How it works",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildStickyBottomBar(controller),
    );
  }

  Widget _buildFastTrackCard({
    required int index,
    required bool isSelected,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? details,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? GuzoTheme.primaryGreen : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: isSelected ? GuzoTheme.primaryGreen : Colors.black54,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<int>(
                  value: index,
                  // ignore: deprecated_member_use
                  groupValue: isSelected ? index : -1,
                  activeColor: GuzoTheme.primaryGreen,
                  // ignore: deprecated_member_use
                  onChanged: (val) => onTap(),
                ),
              ],
            ),
            if (isSelected && details != null) details,
          ],
        ),
      ),
    );
  }

  Widget _buildFastTrackDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Divider(height: 32),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: const Text(
            "Limited availability - add for DXB . Dubai International Airport only",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureRow(
          "Get your Fast Track pass sent to you before you fly and at your fingertips",
        ),
        _buildFeatureRow(
          "Skip the line at airport security by showing your Fast Track pass",
        ),
        _buildFeatureRow(
          "Enjoy more time to relax, shop, and dine in Departures",
        ),
      ],
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottomBar(TicketController controller) {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final flightDatacontroller = Get.find<FlightDataController>();

    return Obx(() {
      final offer = flightApicontroller.selectedOffer.value;
      final currency = offer?['pricing']?['currency'] ?? '';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
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
                                    priceDetailSelected = !priceDetailSelected;
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
                                    flightDataController.totalPrice.value,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.info_outline),
                ],
              ),
            ),
            SizedBox(
              width: 140,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuzoTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () => Get.to(() => TravelProtectionScreen()),
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
    });
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

  Widget _buildLine() {
    return SizedBox(
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

  Widget _buildLuggageCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool included,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 238, 238),
        border: Border.all(
          width: 3,
          color: const Color.fromARGB(255, 208, 204, 204),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF003087)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  "Included",
                  style: TextStyle(
                    color: GuzoTheme.primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (included)
            const Icon(
              Icons.check_box,
              color: Color.fromARGB(255, 193, 192, 192),
              size: 28,
            ),
        ],
      ),
    );
  }
}

class PriceDetailsSheet extends StatefulWidget {
  const PriceDetailsSheet({super.key});

  @override
  State<PriceDetailsSheet> createState() => _PriceDetailsSheetState();
}

class _PriceDetailsSheetState extends State<PriceDetailsSheet> {
  bool _isFlightExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _buildSectionTitle("Flight"),

                InkWell(
                  onTap: () =>
                      setState(() => _isFlightExpanded = !_isFlightExpanded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Adult (1)",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "CAD 409.43",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            _isFlightExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isFlightExpanded) ...[
                  const SizedBox(height: 10),
                  _buildPriceRow("  Flight fare", "CAD 322.79"),
                  _buildPriceRow("  Airline taxes and fees", "CAD 86.64"),
                ],

                const Divider(height: 32),
                _buildSectionTitle("Extras"),
                _buildPriceRow("Flexible ticket", "CAD 53.23"),

                const Divider(height: 32),
                _buildSectionTitle("Discounts"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Booking.com pays",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "CAD -5.54",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "CAD 457.12",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Includes taxes and fees",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GuzoTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(amount),
        ],
      ),
    );
  }
}
