import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhoFlyingPage extends StatefulWidget {
  const WhoFlyingPage({super.key});

  @override
  State<WhoFlyingPage> createState() => _WhoFlyingPageState();
}

class _WhoFlyingPageState extends State<WhoFlyingPage> {
  final flightDataController = Get.find<FlightDataController>();

  final RxInt adults = 1.obs;
  final RxInt children = 0.obs;
  final RxString selectedClass = 'Economy'.obs;
  final RxList<int> childrenAges = <int>[].obs;

  String getOrdinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "${number}th";
    }
    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: GuzoTheme.primaryGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
            child: const Text(
              "Who's flying?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Travelers",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: _buildCounterRow(
                        "Adults",
                        adults.value,
                        (val) => adults.value = val,
                      ),
                    ),
                  ),

                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: _buildCounterRow("Children", children.value, (
                        val,
                      ) {
                        children.value = val;
                        if (childrenAges.length < val) {
                          childrenAges.addAll(
                            List.generate(val - childrenAges.length, (_) => 0),
                          );
                        } else if (childrenAges.length > val) {
                          childrenAges.removeRange(val, childrenAges.length);
                        }
                      }),
                    ),
                  ),

                  Obx(() {
                    if (children.value == 0) return const SizedBox(height: 20);
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: children.value,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${getOrdinal(index + 1)} Child's age",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () =>
                                      _openBookingStyleAgePicker(index),
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue.shade700,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          childrenAges[index].toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Select the age this child will be on the date of your final flight",
                                ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "Cabin class",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Obx(
                    () => Column(
                      children:
                          [
                                'Economy',
                                'Premium economy',
                                'Business',
                                'First-class',
                              ]
                              .map(
                                (mode) => RadioListTile<String>(
                                  title: Text(mode),
                                  value: mode,
                                  // ignore: deprecated_member_use
                                  groupValue: selectedClass.value,
                                  activeColor: GuzoTheme.primaryGreen,
                                  // ignore: deprecated_member_use
                                  onChanged: (val) {
                                    if (val != null) selectedClass.value = val;
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuzoTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  flightDataController.setAdults(
                    adults.value.toString(),
                    children.value.toString(),
                    selectedClass.value,
                    childrenAges.toList(),
                  );
                  Get.back();
                },
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterRow(String title, int value, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 60,
            width: 180,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.blue),
                  onPressed: value > 0 ? () => onChanged(value - 1) : null,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () => onChanged(value + 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openBookingStyleAgePicker(int index) {
    int localSelectedAge = childrenAges[index];

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height - 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 5,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 18,
                      itemBuilder: (context, age) {
                        final bool isSelected = localSelectedAge == age;
                        return InkWell(
                          onTap: () =>
                              setModalState(() => localSelectedAge = age),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  age.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                childrenAges[index] = 0;
                                childrenAges.refresh();
                                Get.back();
                              },
                              child: const Text(
                                "Clear",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GuzoTheme.primaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                childrenAges[index] = localSelectedAge;
                                childrenAges.refresh();
                                Get.back();
                              },
                              child: const Text(
                                "Done",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
