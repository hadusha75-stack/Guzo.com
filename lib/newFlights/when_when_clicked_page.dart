import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:booking/controllers/FlightsController.dart'; 

class WhenWhenClickedPage extends StatefulWidget {
  final int index; 

  const WhenWhenClickedPage({super.key, this.index = -1});

  @override
  // ignore: library_private_types_in_public_api
  _WhenWhenClickedPageState createState() => _WhenWhenClickedPageState();
}

class _WhenWhenClickedPageState extends State<WhenWhenClickedPage> {
  final FlightDataController controller = Get.find<FlightDataController>();
  DateTime? tempSelectedDate;
  final DateTime today = DateTime.now();

  List<DateTime> _getMonths() {
    return List.generate(18, (i) => DateTime(today.year, today.month + i, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.green,
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
                "When?",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildWeekdayHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _getMonths().length,
              itemBuilder: (context, mIndex) =>
                  _buildMonthGrid(_getMonths()[mIndex]),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((d) => Text(d, style: const TextStyle(color: Colors.grey)))
          .toList(),
    );
  }

  Widget _buildMonthGrid(DateTime monthDate) {
    int daysInMonth = DateUtils.getDaysInMonth(monthDate.year, monthDate.month);
    int firstWeekday = DateTime(monthDate.year, monthDate.month, 1).weekday % 7;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            DateFormat('MMMM yyyy').format(monthDate),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
          ),
          itemCount: daysInMonth + firstWeekday,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox();
            int day = index - firstWeekday + 1;
            DateTime date = DateTime(monthDate.year, monthDate.month, day);
            bool isSelected = tempSelectedDate == date;
            bool isToday =
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
            return GestureDetector(
              onTap: date.isBefore(today) ? null : () => setState(() => tempSelectedDate = date),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 2, 106, 35)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday && !isSelected
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: date.isBefore(today)
                          ? Colors.grey.shade400
                          : isSelected
                              ? Colors.white
                              : (isToday ? Colors.green : Theme.of(context).textTheme.bodyLarge?.color),
                      fontWeight: isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    String formattedText = tempSelectedDate == null
        ? "Choose departure date"
        : DateFormat('EEE, MMM d').format(tempSelectedDate!);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 40),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formattedText, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: tempSelectedDate == null
                  ? null
                  : () {
                      String dateString = DateFormat(
                        'EEE, MMM d',
                      ).format(tempSelectedDate!);

                      if (widget.index == -1) {
                        controller.updateDate(tempSelectedDate!);
                      } else {
                        controller.updateSegmentDate(widget.index, dateString);
                      }
                      Get.back();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006D5B),
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
