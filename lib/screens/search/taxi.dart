import 'package:booking/utils/location_popup.dart';
import 'package:flutter/material.dart';

class Taxi extends StatefulWidget {
  const Taxi({super.key});

  @override
  State<Taxi> createState() => _TaxiState();
}

class _TaxiState extends State<Taxi> {
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();

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
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  Text('Round trip'),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Icon(Icons.location_on),
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
                  Icon(Icons.location_on),
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
                    child: Text('Check Price'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: BeveledRectangleBorder(),
                    ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Genius\n XRESXSECCTTVYBIUU\n dtdt',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: const Color.fromARGB(255, 2, 41, 237),
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
}
