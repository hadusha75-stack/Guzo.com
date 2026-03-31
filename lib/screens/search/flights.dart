import 'package:booking/theam/app_color.dart';
import 'package:booking/utils/location_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Flight extends StatefulWidget {
  const Flight({super.key});

  @override
  State<Flight> createState() => _FlightState();
}

class _FlightState extends State<Flight> {
  final TextEditingController _pickupDateController = Get.put(
    TextEditingController(),
  );
  final TextEditingController _returnDateController = Get.put(
    TextEditingController(),
  );

  int selectedOption = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.black,
              style: BorderStyle.solid,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Radio<int>(
                    value: 1,
                    // ignore: deprecated_member_use
                    groupValue: selectedOption,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  Text('One way'),
                  SizedBox(width: 10),
                  Radio<int>(
                    value: 2,
                    // ignore: deprecated_member_use
                    groupValue: selectedOption,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  Text('Round trip'),
                  SizedBox(width: 10),
                  Radio<int>(
                    value: 3,
                    // ignore: deprecated_member_use
                    groupValue: selectedOption,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  Text('Multi City'),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.airplanemode_on),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Enter Pickup location',
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const BeveledRectangleBorder(),
                            builder: (context) => const LocationPopup(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.airplanemode_on),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Destination',
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const BeveledRectangleBorder(),
                            builder: (context) => const LocationPopup(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Icon(Icons.calendar_month_outlined),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: TextField(
                        controller: _pickupDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Pickup Date',
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 2),
                          );
                          if (picked != null) {
                            _pickupDateController.text =
                                '${picked.day}/${picked.month}/${picked.year}';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (selectedOption == 2) roundTrip(),
              if (selectedOption == 3) multiCity(),

              const Divider(),
              const Row(
                children: [
                  Icon(Icons.person_2_outlined),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '2 passengers',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Material(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: GuzoTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: BeveledRectangleBorder(),
                    ),
                    child: Text('Check Price'),
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: GuzoTheme.primaryGreen,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Genius\n XRESXSECCTTVYBIUU\n dtdt',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
              Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
              Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
            ],
          ),
        ),
      ],
    );
  }

  Widget roundTrip() {
    return Column(
      children: [
        if (selectedOption == 1) build(context),
        Row(
          children: [
            Icon(Icons.calendar_month_outlined),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: TextField(
                  controller: _returnDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Return Date',
                  ),
                  onTap: () async {
                    final DateTime? due = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (due != null) {
                      _returnDateController.text =
                          '${due.day}/${due.month}/${due.year}';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget multiCity() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Divider(),
          Row(
            children: [
              Icon(Icons.airplanemode_on),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: ' Enter Pickup location',
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const BeveledRectangleBorder(),
                        builder: (context) => const LocationPopup(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.airplanemode_on),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Destination',
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const BeveledRectangleBorder(),
                        builder: (context) => const LocationPopup(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: TextField(
                    controller: _pickupDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Pickup Date',
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 2),
                      );
                      if (picked != null) {
                        _pickupDateController.text =
                            '${picked.day}/${picked.month}/${picked.year}';
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
