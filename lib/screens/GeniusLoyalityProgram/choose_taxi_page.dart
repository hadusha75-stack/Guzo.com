
import 'package:booking/theam/app_color.dart';
import 'package:booking/utils/location_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseTaxiPage extends StatefulWidget {
  const ChooseTaxiPage({super.key});

  @override
  State<ChooseTaxiPage> createState() => _ChooseTaxiPageState();
}

class _ChooseTaxiPageState extends State<ChooseTaxiPage> {
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();

  int selectedOption = 1;
  bool _isExpanded = false;

  void _toggleDrawer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    double drawerHeight = selectedOption == 2 ? 450 : 380;
    double topHeaderPadding = MediaQuery.of(context).padding.top + 95;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: GuzoTheme.White,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: topHeaderPadding, bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: const Text(
                      "Round-trip options for 2 passenger",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (var i = 0; i < 4; i++) _buildTaxiCard(),
                ],
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            top: _isExpanded
                ? MediaQuery.of(context).padding.top + 80
                : -drawerHeight,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
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
                        onChanged: (value) =>
                            setState(() => selectedOption = value!),
                      ),
                      const Text('One way'),
                      const SizedBox(width: 10),
                      Radio<int>(
                        value: 2,
                        // ignore: deprecated_member_use
                        groupValue: selectedOption,
                        // ignore: deprecated_member_use
                        onChanged: (value) =>
                            setState(() => selectedOption = value!),
                      ),
                      const Text('Round trip'),
                    ],
                  ),
                  const Divider(),
                  _buildLocationField(
                    Icons.location_on,
                    'Enter Pickup location',
                  ),
                  _buildLocationField(Icons.location_on, 'Enter Destination'),
                  const Divider(),
                  _buildDateField(
                    Icons.calendar_month_outlined,
                    'Pickup Date',
                    _pickupDateController,
                  ),
                  if (selectedOption == 2)
                    _buildDateField(
                      Icons.calendar_month_outlined,
                      'Return Date',
                      _returnDateController,
                    ),
                  const Divider(),
                  _buildSimpleField(Icons.person_2_outlined, '2 passengers'),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Material(
                      child: TextButton(
                        onPressed: () {},
                        // ignore: sort_child_properties_last
                        child: Text(
                          'Check Price',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:GuzoTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: BeveledRectangleBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 15,
                  left: 10,
                  right: 15,
                ),
                decoration: const BoxDecoration(
                  color: GuzoTheme.primaryGreen,
                  boxShadow: [BoxShadow(color: GuzoTheme.black, blurRadius: 6)],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: GuzoTheme.White,),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start Time to Destination Time',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: GuzoTheme.White,
                              ),
                            ),
                            Text(
                              'Start time to End Time ',
                              style: TextStyle(
                                fontSize: 11,
                                color: GuzoTheme.White,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: GuzoTheme.White,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxiCard() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: GuzoTheme.primaryGreen),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.car_crash, size: 40),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      "People carrier\n price of the way",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.person, size: 20),
                          Text(" 4 seats"),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.badge, size: 20),
                          Text(" 4 bags"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Driver details will be confirmed before pick-up",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Free cancellation up to 24 hours before pick-up",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField(IconData icon, String hint) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        Expanded(
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
            ),
            onTap: () => Get.bottomSheet(const LocationPopup()),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    IconData icon,
    String hint,
    TextEditingController controller,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) {
                setState(
                  () => controller.text =
                      '${picked.day}/${picked.month}/${picked.year}',
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleField(IconData icon, String hint) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 10),
            ),
          ),
        ),
      ],
    );
  }
}
