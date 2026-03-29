import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/newFlights/checkout_Page.dart';
import 'package:booking/newFlights/contact_datails_page.dart';
import 'package:booking/newFlights/travaler_details_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactWhoFlyingPage extends StatefulWidget {
  const ContactWhoFlyingPage({super.key});

  @override
  State<ContactWhoFlyingPage> createState() => _ContactWhoFlyingPageState();
}

class _ContactWhoFlyingPageState extends State<ContactWhoFlyingPage> {
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  final userNameController = Get.find<UserNameController>();
  final flightDataController = Get.find<FlightDataController>();

  @override
  Widget build(BuildContext context) {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final offer = flightApicontroller.selectedOffer.value;
    final price = offer?['pricing']?['total'] ?? '';
    final currency = offer?['pricing']?['currency'] ?? '';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          centerTitle: false,
          backgroundColor: GuzoTheme.primaryGreen,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          titleSpacing: 0,
          title: const Text(
            "Who's flying",
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
                  _buildStep(true, true),
                  _buildLine(true),
                  _buildStep(true, true),
                  _buildLine(true),
                  _buildStep(true, true),
                  _buildLine(true),
                  _buildStep(true, false, isCurrent: true),

                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _buildLineDotted(),
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
          Column(
            children: [
              InkWell(
                onTap: () =>
                    Get.to(() => TravelerDetailsPage(travelerNumber: 2)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  color: GuzoTheme.White,
                  child: Row(
                    children: [
                      Obx(() {
                        bool isComplete =
                            userNameController.firstNameOf.isNotEmpty &&
                            userNameController.gender.isNotEmpty;
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                bottom: 8,
                              ),
                              child: const Icon(
                                Icons.person_3_outlined,
                                size: 50,
                                color: Colors.black,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: isComplete
                                      ? Colors.greenAccent.withOpacity(0.25)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isComplete
                                      ? null
                                      : Border.all(
                                          color: isComplete
                                              ? Colors.grey.shade300
                                              : Colors.white,
                                        ),
                                ),
                                child: isComplete
                                    ? Icon(
                                        Icons.check_rounded,
                                        size: 20,
                                        color: isComplete
                                            ? Colors.black
                                            : Colors.transparent,
                                      )
                                    : Icon(
                                        Icons.clear,
                                        color: isComplete
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              bool hasData =
                                  userNameController.lastNameOf.isNotEmpty &&
                                  userNameController.firstNameOf.isNotEmpty;

                              return hasData
                                  ? Text(
                                      "${capitalize(userNameController.firstNameOf.value)} ${capitalize(userNameController.lastNameOf.value)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      "Traveler ${1}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                            }),
                            const SizedBox(height: 4),
                            Obx(() {
                              final type =
                                  userNameController.travelerType.value.isEmpty
                                  ? "Adult"
                                  : userNameController.travelerType.value;
                              final gender = userNameController.gender;
                              final dob = userNameController.dateOfBirth;

                              return Text(
                                "$type${gender.isNotEmpty ? ' • $gender' : ''}${dob.isNotEmpty ? ' • $dob' : ''}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),

          SizedBox(height: 15),
          InkWell(
            onTap: () {
              Get.to(() => ContactDetailsPage());
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: Container(
                color: GuzoTheme.White,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                  child: Obx(() {
                    bool iscomplete =
                        userNameController.phoneNumber.value.isNotEmpty &&
                        userNameController.email.value.isNotEmpty;
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10.0,
                                      bottom: 10,
                                    ),
                                    child: Icon(
                                      Icons.mobile_friendly_outlined,
                                      size: 40,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: iscomplete
                                            ? Colors.greenAccent.withOpacity(
                                                0.25,
                                              )
                                            : Colors.red[100],

                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: iscomplete
                                          ? Icon(Icons.check_rounded, size: 20)
                                          : Icon(
                                              Icons.clear,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Contact details",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(userNameController.email.value),
                                  iscomplete
                                      ? Text(
                                          userNameController.phoneCode.value +
                                              userNameController
                                                  .phoneNumber
                                                  .value,
                                        )
                                      : Text(
                                          "Add contact detail ",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          // SizedBox(width: 130),
                          Icon(Icons.keyboard_arrow_right, size: 30),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          const Spacer(),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 12, right: 12),
            child: Container(
              height: 100,
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
                                height: priceDetailSelected ? 800 : 615,
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
                                              '\$$currency ${pricing['baseFare'] ?? '0.00'}',
                                            ),
                                            _buildPriceRow(
                                              "Airline taxes and fees",
                                              '\$$currency ${pricing['taxes'] ?? '0.00'}',
                                            ),
                                            _buildPriceRow("W9", "\$0.056"),
                                            _buildPriceRow("L3", "\$0.487"),
                                            _buildPriceRow(
                                              "Taxe de depart de laerport",
                                              "\$4.87",
                                            ),
                                            _buildPriceRow(
                                              "Airline fuel and inurance surcharge",
                                              "\$44.87",
                                            ),
                                          ],
                                        ),
                                      ),

                                    const Divider(height: 10),
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
                                            SizedBox(height: 7),

                                            Text(
                                              "Flexible ticket",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 7),

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
                                              SizedBox(height: 7),
                                              const Text(
                                                "\$ 34.06",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              SizedBox(height: 7),

                                              const Text(
                                                "\$ 36.06",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 10),

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
                                            SizedBox(height: 7),
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
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 10),

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
                                            SizedBox(height: 6),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 25.0,
                                          ),
                                          child: Text(
                                            "$currency ${flightDataController.totalPrice.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),
                                    Divider(height: 1),
                                    // SizedBox(height: 25),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20.0,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 55,
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 15),
                      child: Row(
                        children: [
                          Text(
                            "$currency ${flightDataController.totalPrice.value}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.info_outline),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 140,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GuzoTheme.primaryGreen,
                          foregroundColor: GuzoTheme.White,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () {
                          (userNameController.firstNameOf.value.isEmpty ||
                                  userNameController.lastNameOf.value.isEmpty ||
                                  userNameController.phoneNumber.value.isEmpty)
                              ? Get.snackbar(
                                  'Error',
                                  'Please fill the contact information: ',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: GuzoTheme.accentGold,
                                  colorText: Colors.black,
                                )
                              : Get.to(() => CheckoutPage());
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildLineDotted() {
    return Container(
      width: 40,
      child: Row(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(left: 2.0, bottom: 10),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.39),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStep(bool isCompleted, bool isPast, {bool isCurrent = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
      width: 16,
      height: 16,
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
    ),
  );
}

Widget _buildLine(bool isActive, {bool isDotted = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
      width: 30,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isDotted ? null : (isActive ? Colors.white : Colors.white54),
      child: Text(""),
    ),
  );
}
