import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/screens/flightsPage/airport_search_page.dart';
import 'package:booking/screens/flightsPage/searched_flights_page.dart';
import 'package:booking/screens/flightsPage/when_when_clicked_page.dart';
import 'package:booking/screens/flightsPage/who_flying_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:booking/controllers/FlightsController.dart';

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

            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
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
    );
  }

  Widget _buildSearchCard(FlightDataController controller) {
    return Stack(
      children: [
        Container(height: 40, color: GuzoTheme.primaryGreen),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
      onTap: () => Get.to(
        () => AirportSearchPage(
          title: displayResult,
          isFrom: isFromField,
          segmentIndex: index,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                displayResult,
                style: TextStyle(
                  fontSize: 16,
                  color: displayResult.contains('?')
                      ? Colors.grey
                      : Theme.of(context).textTheme.bodyLarge?.color,
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
    DateTime? depDate;
    DateTime? retDate;
    bool selectingReturn = false;

    Get.to(
      () => StatefulBuilder(
        builder: (ctx, setS) {
          final months = List.generate(
            18,
            (i) => DateTime(DateTime.now().year, DateTime.now().month + i, 1),
          );

          bool inRange(DateTime d) {
            if (depDate == null || retDate == null) return false;
            return d.isAfter(depDate!) && d.isBefore(retDate!);
          }

          void onTap(DateTime d) {
            if (d.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
              return;
            }
            setS(() {
              if (!selectingReturn) {
                depDate = d;
                retDate = null;
                selectingReturn = true;
              } else {
                if (d.isBefore(depDate!)) {
                  depDate = d;
                  retDate = null;
                } else {
                  retDate = d;
                  selectingReturn = false;
                }
              }
            });
          }

          Widget buildMonth(DateTime m) {
            final days = DateUtils.getDaysInMonth(m.year, m.month);
            final firstDay = DateTime(m.year, m.month, 1).weekday % 7;
            final rows = ((days + firstDay) / 7).ceil();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    DateFormat('MMMM yyyy').format(m),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                for (int row = 0; row < rows; row++)
                  Container(
                    color: row.isOdd
                        // ignore: deprecated_member_use
                        ? Theme.of(ctx).dividerColor.withOpacity(0.3)
                        : Theme.of(ctx).scaffoldBackgroundColor,
                    child: Row(
                      children: List.generate(7, (col) {
                        final idx = row * 7 + col;
                        if (idx < firstDay || idx >= days + firstDay) {
                          return const Expanded(child: SizedBox(height: 52));
                        }
                        final day = idx - firstDay + 1;
                        final date = DateTime(m.year, m.month, day);
                        final isDep =
                            depDate != null &&
                            DateUtils.isSameDay(date, depDate);
                        final isRet =
                            retDate != null &&
                            DateUtils.isSameDay(date, retDate);
                        final range = inRange(date);
                        final past = date.isBefore(
                          DateTime.now().subtract(const Duration(days: 1)),
                        );
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => onTap(date),
                            child: Container(
                              height: 52,
                              // ignore: deprecated_member_use
                              color: range
                                  // ignore: deprecated_member_use
                                  ? Colors.green.withOpacity(0.12)
                                  : Colors.transparent,
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: (isDep || isRet)
                                        ? GuzoTheme.primaryGreen
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$day',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: past
                                            ? Colors.grey.shade400
                                            : (isDep || isRet)
                                            ? Colors.white
                                            : Theme.of(
                                                ctx,
                                              ).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            );
          }

          return Scaffold(
            backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
              elevation: 0,
              leading: const SizedBox(),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: GuzoTheme.primaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'When?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                        .map(
                          (d) => SizedBox(
                            width: 42,
                            child: Center(
                              child: Text(
                                d,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: months.length,
                    itemBuilder: (_, i) => buildMonth(months[i]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).cardColor,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _pickerDateBox('Departure date', depDate),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _pickerDateBox('Return date', retDate),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GuzoTheme.primaryGreen,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: depDate != null && retDate != null
                              ? () {
                                  controller.updateDateRange(
                                    depDate!,
                                    retDate!,
                                  );
                                  Get.back();
                                }
                              : null,
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      transition: Transition.downToUp,
    );
  }

  Widget _pickerDateBox(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                date == null ? '--' : DateFormat('EEE, MMM d').format(date),
                style: TextStyle(
                  fontSize: 13,
                  color: date == null
                      ? Colors.grey
                      : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: date == null
                      ? FontWeight.normal
                      : FontWeight.w500,
                ),
              ),
            ],
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
        onTap: () => controller.toggleTripType(label),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: label,
              // ignore: deprecated_member_use
              groupValue: controller.selectedTripType.value,
              // ignore: deprecated_member_use
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
        Container(height: 45, width: 2, color: Theme.of(context).dividerColor),
        const Expanded(child: Divider(indent: 55, endIndent: 10)),
        IconButton(
          onPressed: () => apicontroller.toggleSort(),
          icon: SvgPicture.network(
            "https://unpkg.com/lucide-static/icons/arrow-up-down.svg",
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color ?? Colors.black,
              BlendMode.srcIn,
            ),
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
}
