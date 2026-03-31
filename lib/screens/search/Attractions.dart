// ignore_for_file: file_names

import 'package:booking/theam/app_color.dart';
import 'package:booking/utils/location_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Attractions extends StatefulWidget {
  const Attractions({super.key});

  @override
  State<Attractions> createState() => _AttractionsState();
}

class _AttractionsState extends State<Attractions> {
  final TextEditingController _dateController = Get.put(TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 3, color: Colors.black),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.search),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Where do you wanna go',
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
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tell us when',
                        ),
                        onTap: () async {
                          final DateTimeRange? picked =
                              await showDateRangePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 2),
                                initialDateRange: DateTimeRange(
                                  start: DateTime.now(),
                                  end: DateTime.now().add(Duration(days: 1)),
                                ),
                              );
                          if (picked != null) {
                            _dateController.text =
                                '${picked.start} - ${picked.end}'
                                '-${picked.end.day}/${picked.end.month}';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: GuzoTheme.primaryGreen,
                      shape: BeveledRectangleBorder(),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              children: [
                Card(
                  color: GuzoTheme.primaryGreen,  
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Genius\n XRESXSECCTTVYBIUU\n dtdt',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
                Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
                Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
                Card(child: Text('Genius\n XRESXSECCTTVYBIUU\n dtdt')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
