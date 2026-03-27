import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectYourSeatsInnerPage extends StatefulWidget {
  final String Title;
  const SelectYourSeatsInnerPage({super.key, required this.Title});

  @override
  State<SelectYourSeatsInnerPage> createState() =>
      _SelectYourSeatsInnerPageState();
}

class _SelectYourSeatsInnerPageState extends State<SelectYourSeatsInnerPage> {
  final flightDataController = Get.find<FlightDataController>();
  final List<String> _selectedSeats = [];
  int _maxTravelers = 3;
  final double _pricePerSeat = 200.0;

  final Color seatAvailable = const Color.fromARGB(255, 2, 144, 38);
  final Color seatUnavailable = const Color(0xFFBDBDBD);

  @override
  void initState() {
    super.initState();
    _initializeMaxTravelers();
  }

  void _initializeMaxTravelers() {
    _maxTravelers = flightDataController.numberOfTravelers.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.Title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildLegend(),
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade200, width: 6),
                  right: BorderSide(color: Colors.grey.shade200, width: 6),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                itemCount: 32,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildSeatHeader();
                  if (index > 0 && index < 11) return const SizedBox.shrink();
                  return _buildSeatRow(index);
                },
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildLegendItem(seatAvailable, "Available seat (free)"),
          _buildLegendItem(
            seatUnavailable,
            "Unavailable seat",
            isIcon: true,
            icon: Icons.close,
          ),
          _buildLegendItem(
            Colors.white,
            "Selected seat",
            border: Border.all(color: Colors.green, width: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    Color color,
    String text, {
    bool isIcon = false,
    IconData? icon,
    BoxBorder? border,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: border,
            ),
            child: isIcon ? Icon(icon, size: 16, color: Colors.black54) : null,
          ),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildSeatHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          _headerText("A"),
          const SizedBox(width: 8),
          _headerText("C"),
          const Expanded(child: SizedBox()),
          _headerText("J"),
          const SizedBox(width: 8),
          _headerText("L"),
        ],
      ),
    );
  }

  Widget _headerText(String label) => SizedBox(
    width: 45,
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 11, 176, 129),
        ),
      ),
    ),
  );

  Widget _buildSeatRow(int rowNum) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: Row(
        children: [
          _buildSeatBox(rowNum, "A"),
          const SizedBox(width: 8),
          _buildSeatBox(rowNum, "C"),
          Expanded(
            child: Center(
              child: Text(
                "$rowNum",
                style: const TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
          ),
          _buildSeatBox(rowNum, "J"),
          const SizedBox(width: 8),
          _buildSeatBox(rowNum, "L"),
        ],
      ),
    );
  }

  Widget _buildSeatBox(int rowNum, String col) {
    String seatId = "$rowNum$col";
    bool isSelected = _selectedSeats.contains(seatId);
    bool isUnavailable =
        (rowNum == 11) || (rowNum == 12 && (col == "J" || col == "L"));

    return GestureDetector(
      onTap: isUnavailable
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  _selectedSeats.remove(seatId);
                } else {
                  if (_selectedSeats.length < _maxTravelers) {
                    _selectedSeats.add(seatId);
                  } else {
                    Get.closeCurrentSnackbar();

                    Get.snackbar(
                      "Selection Limit",
                      "You can only select $_maxTravelers seats.",
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                }
              });
            },
      child: Container(
        width: 55,
        height: 50,
        decoration: BoxDecoration(
          color: isUnavailable
              ? seatUnavailable
              : (isSelected ? Colors.white : seatAvailable),
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: Colors.green, width: 2.5)
              : null,
        ),
        child: Center(
          child: isUnavailable
              ? const Icon(
                  Icons.close,
                  size: 20,
                  color: Color.fromARGB(115, 127, 9, 9),
                )
              : (isSelected
                    ? Text(
                        "T${_selectedSeats.indexOf(seatId) + 1}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    int currentSelectionCount = _selectedSeats.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$currentSelectionCount of $_maxTravelers seats selected",
                  style: const TextStyle(
                    color: Color(0xFF029026),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => Get.bottomSheet(
                    _buildOverviewSheet(),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                  ),
                  child: const Text(
                    "Overview",
                    style: TextStyle(
                      color: Color.fromARGB(255, 40, 119, 31),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
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

                        return StatefulBuilder(
                          builder:
                              (
                                BuildContext context,
                                StateSetter setModalState,
                              ) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 0),
                                  height: priceDetailSelected ? 815 : 615,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
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
                                                color: Colors.black54,
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
                                                "\$465.87",
                                              ),
                                              _buildPriceRow(
                                                "Airline taxes and fees",
                                                "\$75.87",
                                              ),
                                              _buildPriceRow("W9", "\$0.056"),
                                              _buildPriceRow("L3", "\$0.487"),
                                              _buildPriceRow(
                                                "Taxe de depart de laerport",
                                                "\$4.87",
                                              ),
                                              _buildPriceRow(
                                                "irline fuel and inurance surcharge",
                                                "\$44.87",
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
                                                "Extras",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 15),

                                              Text(
                                                "Flexible ticket",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(height: 15),

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
                                                SizedBox(height: 15),
                                                const Text(
                                                  "\$ 34.06",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(height: 15),

                                                const Text(
                                                  "\$ 36.06",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                                "Discounts",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(height: 15),
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
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                                  fontSize: 15,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 25.0,
                                            ),
                                            child: const Text(
                                              "\$400",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Spacer(),
                                      Divider(height: 1),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10.0,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 70,
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
                      const Text(
                        "CAD 989",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.info_outline),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: currentSelectionCount == _maxTravelers
                      ? () {
                          flightDataController.setSeatNumber(_maxTravelers);

                          if (Get.isSnackbarOpen ?? false) {
                            Get.closeCurrentSnackbar();
                          }

                          Get.back();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: GuzoTheme.primaryGreen,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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

  Widget _buildOverviewSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Your seat selection",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ..._selectedSeats.map((seat) {
            int idx = _selectedSeats.indexOf(seat) + 1;
            return ListTile(
              title: Text("Traveler $idx (Adult)"),
              subtitle: Text("Seat $seat"),
              trailing: Text("CAD $_pricePerSeat"),
            );
          }).toList(),
          const Divider(),
          ListTile(
            title: const Text(
              "Total",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text("CAD ${_selectedSeats.length * _pricePerSeat}"),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GuzoTheme.primaryGreen,
                foregroundColor: GuzoTheme.White,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text("Close"),
            ),
          ),
        ],
      ),
    );
  }
}
