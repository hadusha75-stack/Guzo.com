import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/newFlights/searched_flights_page.dart';
import 'package:booking/newFlights/when_when_clicked_page.dart';
import 'package:booking/screens/myAccounts/my_account_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/newFlights/airport_search_page.dart';
import 'package:booking/newFlights/who_flying_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FlightsPage extends StatefulWidget {
  const FlightsPage({super.key});

  @override
  State<FlightsPage> createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  final uppercontroller = Get.find<FlightDataController>();
  final conController = Get.find<FlightUpdaredController>();

  final FlightDataController apicontroller = Get.find<FlightDataController>();
  final controller = Get.find<FlightUpdaredController>();

  @override
  Widget build(BuildContext context) {
    final FlightDataController controller = Get.find<FlightDataController>();

    return Scaffold(
      backgroundColor: GuzoTheme.primaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: _buildTabBar(),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[100],
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Obx(() => _buildSearchCard(controller)),
                      const SizedBox(height: 16),
                      Obx(() => _buildDirectFlightsToggle(controller)),
                      const SizedBox(height: 8),
                      _buildPoweredBy(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(controller),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: GuzoTheme.primaryGreen,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Guzo.com',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 100,
      color: GuzoTheme.primaryGreen,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTab(Icons.hotel_outlined, 'Stays', false),
            const SizedBox(width: 8),
            _buildTab(Icons.flight, 'Flights', true),
            const SizedBox(width: 8),
            _buildTab(Icons.directions_car_outlined, 'Car rental', false),
            const SizedBox(width: 8),
            _buildTab(Icons.local_taxi, 'Taxi', false),
            const SizedBox(width: 8),

            _buildTab(Icons.local_taxi, 'Atrraction', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF003580) : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF003580) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(FlightDataController controller) {
    return Stack(
      children: [
        Container(height: 40, color: GuzoTheme.primaryGreen),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
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
                      ? controller.recievedFromToName.value
                      : controller.recievedFromFromName.value,
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
                      ? controller.recievedFromFromName.value
                      : controller.recievedFromToName.value,
                  controller.sortSelected.value,
                  index: -1,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xFFFFC107),
                  thickness: 6,
                ),
                _buildDateField(context, controller, -1),
              ],

              if (controller.selectedTripType.value == 'Multi-city') ...[
                for (
                  int i = 0;
                  i < controller.multiCitySegments.length;
                  i++
                ) ...[
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

                const Divider(
                  height: 1,
                  color: Color(0xFFFFC107),
                  thickness: 6,
                ),
                _buildAddFlightButton(controller),
              ],

              const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),
              _buildPassengerField(controller),
              const Divider(height: 1, color: Color(0xFFFFC107), thickness: 6),
              _buildSearchButton(),
            ],
          ),
        ),
      ],
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
      onTap: () => Get.to(() => AirportSearchPage(title: displayResult)),
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
                          : controller.selectedDateRaw.value
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
                    // hoverColor: Colors.transparent,
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
      onTap: () {
        if (controller.multiCitySegments.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Text(
                      "You can't add any more flights to this\n search",
                      style: TextStyle(fontSize: 17),
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
        controller.addSegment();
      },
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
              const SizedBox(width: 40, height: 50),
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
        onTap: () => controller.toggleTripType(label),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: label,
              groupValue: controller.selectedTripType.value,
              onChanged: (v) => controller.toggleTripType(v!),
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
        SizedBox(width: 20),
        Container(height: 45, width: 2, color: Colors.grey),
        const Expanded(child: Divider(indent: 55, endIndent: 10)),

        IconButton(
          onPressed: () => apicontroller.toggleSort(),
          icon: SvgPicture.network(
            "https://unpkg.com/lucide-static/icons/arrow-up-down.svg",
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSwapButtonRowsecond() => Row(
    children: [
      const SizedBox(width: 20),
      Container(height: 45, width: 2, color: Colors.grey),

      const Expanded(child: Divider(indent: 55, endIndent: 10, height: 20)),
    ],
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
              ? conController.searchFlights(
                  originCode: from,
                  destinationCode: to,
                  departureDate: date,
                  returnDate: date2,
                )
              : conController.searchFlights(
                  originCode: from,
                  destinationCode: to,
                  departureDate: date,
                );
          Get.to(() => SearchedFlightsPage());
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

  Widget _buildDirectFlightsToggle(FlightDataController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Direct flights only', style: TextStyle(fontSize: 16)),
          Switch(
            value: controller.directFlightsOnly.value,
            onChanged: (v) => controller.toggleDirectFlights(v),
            activeThumbColor: GuzoTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildPoweredBy() => const Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        Text('Flights powered by ', style: TextStyle(color: Colors.grey)),
        Text(
          'Gotogate',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildBottomNav(FlightDataController controller) {
    return BottomNavigationBar(
      currentIndex: controller.selectedIndex.value,
      onTap: (i) => controller.updateIndex(i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0071C2),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Saved',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () => Get.to(() => MyAccountPage()),
            child: const Icon(Icons.person_outline),
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
