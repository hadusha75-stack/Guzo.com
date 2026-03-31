// ignore_for_file: file_names

import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/newFlights/payment_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final flightApicontroller = Get.find<FlightUpdaredController>();
  String formatTime(String? time) {
    if (time == null || time.isEmpty) {
      return "-05:--07:PM-";
    }

    try {
      DateTime dt = DateTime.parse(time);
      return DateFormat('h:mm a').format(dt);
    } catch (e) {
      return "--:--";
    }
  }

  String formatDuration(String duration) {
    RegExp regExp = RegExp(r'PT(\d+)H(\d+)M');
    final match = regExp.firstMatch(duration);

    if (match != null) {
      final hours = match.group(1);
      final minutes = match.group(2);
      return "${hours}h ${minutes}m";
    }

    return duration;
  }

  final flightDatacontroller = Get.find<FlightDataController>();

  final userNameController = Get.find<UserNameController>();
  bool _isExpanded = false;
  var selectedPaymentMethodd = "";
  bool saveAccount = false;
  bool saveAccountPayPal = true;

  @override
  Widget build(BuildContext context) {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final offer = flightApicontroller.selectedOffer.value;
    final flights = offer?['flights'] as List? ?? [];

    final firstFlight = flights.isNotEmpty ? flights[0] : null;
    final firstSegments = firstFlight?['segments'] as List? ?? [];
    final firstSegment = firstSegments.isNotEmpty ? firstSegments[0] : null;
    final firstDuration = firstFlight?['duration'] ?? 'unknown duration N/A';
    final firstDepartureTime = firstSegment?['departureDateTime'];
    final firstArrivalTime = firstSegment?['arrivalDateTime'];
    final firstStops = firstSegments.length - 1;
    final currency = offer?['pricing']?['currency'] ?? '';

    final secondFlight = flights.length > 1 ? flights[1] : null;
    final secondSegments = secondFlight?['segments'] as List? ?? [];
    final secondSegment = secondSegments.isNotEmpty ? secondSegments[0] : null;
    final secondDuration = secondFlight?['duration'] ?? 'unknown duration N/A';
    final secondDepartureTime = secondSegment?['departureDateTime'];
    final secondArrivalTime = secondSegment?['arrivalDateTime'];
    final secondStops = secondSegments.length - 1;

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
          title: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: const Text(
              "Check out and pay",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
                  _buildStep(true, true),

                  _buildLine(true),
                  _buildStep(true, false, isCurrent: true),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(title: 'Payment'),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Choose a payment method",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (selectedPaymentMethodd == "paypal") ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 20),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethodd = "";
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Stack(
                                              children: [
                                                Icon(
                                                  Icons.paypal_outlined,
                                                  size: 60,
                                                  color: GuzoTheme.primaryGreen,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Icon(
                                        Icons.check_box,
                                        size: 35,
                                        color: GuzoTheme.primaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "PayPal",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: SwitchListTile(
                                title: Text(
                                  "Save your PayPal account for faster payment next time",
                                ),
                                value: saveAccountPayPal,
                                onChanged: (bool value) {
                                  setState(() => saveAccountPayPal = value);
                                },
                                contentPadding: EdgeInsets.zero,
                                activeThumbColor: GuzoTheme.accentGold,
                                // ignore: deprecated_member_use
                                activeColor: GuzoTheme.primaryGreen,
                              ),
                            ),
                            Divider(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ] else if (selectedPaymentMethodd == "google pay") ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 20),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethodd = "";
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  width: 75,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    border: Border.all(
                                                      color: GuzoTheme
                                                          .primaryGreen,
                                                      width: 1.5,
                                                    ),
                                                    color: Theme.of(context).cardColor,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.g_mobiledata,
                                                        size: 30,
                                                        color: GuzoTheme
                                                            .primaryGreen,
                                                      ),

                                                      Text(
                                                        "Pay ",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Icon(
                                        Icons.check_box,
                                        size: 35,
                                        color: GuzoTheme.primaryGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Google pay",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Divider(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          Get.to(() => const PaymentPage());
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 5.0,
                                    bottom: 14,
                                  ),
                                  child: Icon(
                                    Icons.note_alt_outlined,
                                    size: 40,
                                    color: GuzoTheme.primaryGreen,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 10,
                                      color: GuzoTheme.primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethodd = "google pay";
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 75,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: GuzoTheme.primaryGreen,
                                      width: 1.5,
                                    ),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.g_mobiledata,
                                        size: 30,
                                        color: GuzoTheme.primaryGreen,
                                      ),

                                      Text(
                                        "Pay ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethodd = "paypal";
                          });
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    Icon(
                                      Icons.paypal_outlined,
                                      size: 60,
                                      color: GuzoTheme.primaryGreen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                    ],
                  ),
                  SizedBox(height: 15),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(width: 20),
                        Text("New card"),
                    
                        // SizedBox(width: 89),
                        Text("Google Pay"),
                    
                        // SizedBox(width: 75),
                        Text("PayPal"),
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 15),
            if (flightDatacontroller.selectedTripType.value ==
                "Round-trip") ...[
              Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.airline_seat_flat_angled_rounded,
                            size: 60,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  " ${flightDatacontroller.recievedFromFromName.value} (${flightDatacontroller.recievedFromFrom.value}) to ${flightDatacontroller.recievedFromToName.value}\n (${flightDatacontroller.recievedFromTo.value})   ",

                                  style: TextStyle(
                                    color: GuzoTheme.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                "${formatTime(firstDepartureTime)} - ${formatTime(firstArrivalTime)}",
                                style: TextStyle(
                                  color: GuzoTheme.black,
                                  fontSize: 17,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    firstStops == 0
                                        ? 'Direct'
                                        : '$firstStops stop${firstStops > 1 ? 's' : ''}',

                                    style: TextStyle(
                                      color: GuzoTheme.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    " - ${formatDuration(firstDuration)}",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Divider(height: 1),
                    SizedBox(height: 30),
                    Center(
                      child: InkWell(
                        onTap: () =>
                            _showFlightDetailsSheet(context, firstFlight),
                        child: Text(
                          "View flight details",
                          style: TextStyle(
                            color: GuzoTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(height: 15),

              Container(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.airline_seat_flat_angled_rounded,
                            size: 60,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                " ${flightDatacontroller.recievedFromToName.value} (${flightDatacontroller.recievedFromTo.value}) to ${flightDatacontroller.recievedFromFromName.value}\n (${flightDatacontroller.recievedFromFrom.value})   ",
                                style: TextStyle(
                                  color: GuzoTheme.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "${formatTime(secondDepartureTime)} - ${formatTime(secondArrivalTime)}",
                                style: TextStyle(
                                  color: GuzoTheme.black,
                                  fontSize: 17,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    secondStops == 0
                                        ? 'Direct'
                                        : '$secondStops stop${secondStops > 1 ? 's' : ''}',
                                    style: TextStyle(
                                      color: GuzoTheme.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    " - ${formatDuration(secondDuration)}",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Divider(height: 1),
                      SizedBox(height: 20),

                      Center(
                        child: InkWell(
                          onTap: () =>
                              _showFlightDetailsSheet(context, secondFlight),
                          child: Text(
                            "View flight details",
                            style: TextStyle(
                              color: GuzoTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ] else ...[
              Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.airline_seat_flat_angled_rounded,
                            size: 60,
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(
                                  " ${flightDatacontroller.recievedFromFromName.value} (${flightDatacontroller.recievedFromFrom.value}) to ${flightDatacontroller.recievedFromToName.value}\n (${flightDatacontroller.recievedFromTo.value})   ",

                                  style: TextStyle(
                                    color: GuzoTheme.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Text(
                                "${formatTime(firstDepartureTime)} - ${formatTime(firstArrivalTime)}",
                                style: TextStyle(
                                  color: GuzoTheme.black,
                                  fontSize: 17,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    firstStops == 0
                                        ? 'Direct'
                                        : '$firstStops stop${firstStops > 1 ? 's' : ''}',

                                    style: TextStyle(
                                      color: GuzoTheme.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    " - ${formatDuration(firstDuration)}",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Divider(height: 1),
                    SizedBox(height: 30),
                    Center(
                      child: InkWell(
                        onTap: () =>
                            _showFlightDetailsSheet(context, firstFlight),
                        child: Text(
                          "View flight details",
                          style: TextStyle(
                            color: GuzoTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],
            SizedBox(height: 15),
            Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "Traveler details",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Obx(() {
                      final fName = userNameController.firstNameOf.value;
                      final lName = userNameController.lastNameOf.value;

                      return Row(
                        children: [
                          const Icon(Icons.person_2_outlined, size: 60),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    (fName.isEmpty && lName.isEmpty)
                                        ? "Enter Name"
                                        : "$fName $lName",

                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${userNameController.travelerType.value.isEmpty ? 'Adult' : userNameController.travelerType.value} . "
                                  "${userNameController.gender.value.isEmpty ? 'Gender' : userNameController.gender.value} . "
                                  "${userNameController.dateOfBirth.value.isEmpty ? 'Date of Birth' : userNameController.dateOfBirth.value}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),

            Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "Traveler details",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.mobile_friendly_sharp, size: 60),

                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "${userNameController.phoneCode.value} ${userNameController.phoneNumber.value}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              userNameController.email.value,
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),

            const SizedBox(height: 4),
            Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luggage',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 20,
                        bottom: 8,
                      ),
                      child: _buildLuggageTile(
                        icon: Icons.inventory_2_outlined,
                        title: '1 personal item',
                        subtitle: 'Fits under the seat in front of you',
                      ),
                    ),

                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 8,
                      ),
                      child: _buildLuggageTile(
                        icon: Icons.luggage_outlined,
                        title: '1 carry-on bag',
                        subtitle: '23 x 40 x 55 cm · Up to 7 kg each',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,

                        bottom: 20,
                      ),
                      child: _buildLuggageTile(
                        icon: Icons.luggage_outlined,
                        title: '2 checked bags',
                        subtitle: 'Up to 23 kg each',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isDismissible: true,
                          enableDrag: true,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.35,
                              minChildSize: 0.3,
                              maxChildSize: 0.95,
                              builder: (context, scrollController) {
                                return Container(
                                  decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Center(
                                        child: Container(
                                          width: 60,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                        ),
                                        child: Text(
                                          "Flight to ${flightDatacontroller.recievedFromToName.value}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          top: 8,
                                        ),
                                        child: Text(
                                          "Luggage allowance for this trip",
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
                      child: Text(
                        "See details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: GuzoTheme.primaryGreen,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 20,
                  right: 15,
                  bottom: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Seats",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Flight to ${flightDatacontroller.recievedFromToName.value}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.event_seat,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No seats assigned for this flight',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Flight to ${flightDatacontroller.recievedFromFromName.value}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.event_seat,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No seats assigned for this flight',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 20,
                      bottom: 20,
                    ),
                    child: Text(
                      "Flexibility and protection",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.landslide_outlined),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Flexible ticket",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "Standard ticket (x1)",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "View details",
                              style: TextStyle(
                                color: GuzoTheme.primaryGreen,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(Icons.landslide_outlined),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Travel protection",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text("1 ingured", style: TextStyle(fontSize: 16)),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: true,
                                  enableDrag: true,
                                  builder: (context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 0.35,
                                      minChildSize: 0.3,
                                      maxChildSize: 0.95,
                                      builder: (context, scrollController) {
                                        return Container(
                                          decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 12),
                                              Center(
                                                child: Container(
                                                  width: 60,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                ),
                                                child: Text(
                                                  "Travel protection",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  top: 8,
                                                ),
                                                child: Text(
                                                  "Your trip is protected against delay and cancellation",
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 15,
                                                  left: 15.0,
                                                  right: 15,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      userNameController
                                                          .email
                                                          .value,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text("Not insured"),
                                                  ],
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
                              child: Text(
                                "View details",
                                style: TextStyle(
                                  color: GuzoTheme.primaryGreen,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flight",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildExpandableSection(),

                  Divider(height: 32),
                  Text(
                    "Extras",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  _priceRow("Flexible ticket", "\$ 34.06"),
                  _priceRow("Travel protection", "\$ 36.06"),

                  Divider(height: 32),
                  Text(
                    "Discounts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  _priceRow("Guzo.com pays", "- \$ 4.06", color: Colors.blue),

                  Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Includes taxes and fees",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(
                        "$currency ${flightDatacontroller.totalPrice.value}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Taxes and charges may be refundable separately from fare refunds if you didn't board your flight. For details, view airline terms.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "This Booking counts!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Stays, flights, rental cars, taxes,and attractions - every booking you complet counts toward your progress in Gunuis.",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 16),
                      Divider(height: 1),
                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Guzo.com's loyality program"),
                          Text(
                            "Genius",
                            style: TextStyle(
                              color: GuzoTheme.primaryGreen,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              height: priceDetailSelected ? 880 : 695,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.vertical(
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
                                        borderRadius: BorderRadius.circular(4),
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
                                          Text(
                                            "Adult(${flightDatacontroller.adults.value})",
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
                                            color: Colors.grey,
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
                                      opacity: priceDetailSelected ? 1.0 : 0.0,
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
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 15),

                                          Text(
                                            "Travel protection",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
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
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            SizedBox(height: 15),

                                            const Text(
                                              "\$ 36.06",
                                              style: TextStyle(fontSize: 15),
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
                                              color: Colors.grey,
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
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 25.0,
                                        ),
                                        child: Text(
                                          "$currency ${flightDatacontroller.totalPrice.value}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Taxes and charges may be refendable separately from fare refunds if you did n't board your flight. For details, view airline terms.",
                                  ),
                                  const Spacer(),
                                  Divider(height: 1),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 20.0,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 70,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              GuzoTheme.primaryGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Close",
                                          style: TextStyle(color: Colors.white),
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
                      Text(
                        '$currency ${flightDatacontroller.totalPrice.value}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.info_outline, size: 30),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 60,
                width: 140,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: flightApicontroller.isLoading.value
                        ? null
                        : () async {
                            try {
                              // Ensure pricing is loaded before holding
                              if (flightApicontroller
                                  .executionId
                                  .value
                                  .isEmpty) {
                                final offer =
                                    flightApicontroller.selectedOffer.value ??
                                    (flightApicontroller.offers.isNotEmpty
                                        ? flightApicontroller.offers.first
                                              as Map<String, dynamic>
                                        : null);
                                if (offer == null) {
                                  Get.snackbar(
                                    'Error',
                                    'No flight selected.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                await flightApicontroller
                                    .selectOfferAndGetPrice(offer);
                              }

                              // holdFlight reads passenger data from UserNameController internally
                              await flightApicontroller.holdFlight([]);

                              if (flightApicontroller
                                  .bookingLocator
                                  .value
                                  .isNotEmpty) {
                                Get.to(() => const PaymentPage());
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Hold failed. Please try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Something went wrong: $e',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: GuzoTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Obx(
                      () => flightApicontroller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Hold Flight",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection() {
    final flightApicontroller = Get.find<FlightUpdaredController>();
    final offer = flightApicontroller.selectedOffer.value;
    final currency = offer?['pricing']?['currency'] ?? '';

    final pricing = offer?['pricing'] ?? {};
    final flightDatacontroller = Get.find<FlightDataController>();
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: EdgeInsets.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adult(${flightDatacontroller.adults.value})",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Row(
                  children: [
                    Text(
                      "\$111.09",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                _priceRow(
                  "Flight fare",
                  '$currency ${pricing['baseFare'] ?? '0.00'}',
                  isSubItem: true,
                ),
                _priceRow(
                  "Airline taxes and fees",
                  '$currency ${pricing['taxes'] ?? '0.00'}',
                  isSubItem: true,
                ),
                _priceRow("W9", "\$0.056", isSubItem: true),
                _priceRow("L3", "\$0.487", isSubItem: true),
                _priceRow(
                  "Taxe de depart de laerport",
                  "\$4.87",
                  isSubItem: true,
                ),
                _priceRow(
                  "airline fuel and insurance surcharge",
                  "\$44.87",
                  isSubItem: true,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 15)),
          Text(price, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  void _showFlightDetailsSheet(BuildContext context, dynamic flight) {
    if (flight == null) return;
    final segments = flight['segments'] as List? ?? [];
    final duration = flight['duration'] as String? ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (ctx, scrollCtrl) {
            return Container(
              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 60,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Flight details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatDuration(duration),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: segments.length,
                      itemBuilder: (ctx, i) {
                        final seg = segments[i] as Map<String, dynamic>;
                        final airline =
                            seg['airlineName'] ?? seg['airlineCode'] ?? '';
                        final flightNum = seg['flightNumber'] ?? '';
                        final depAirport = seg['departureAirport'] ?? '';
                        final depName =
                            seg['departureAirportName'] ?? depAirport;
                        final arrAirport = seg['arrivalAirport'] ?? '';
                        final arrName = seg['arrivalAirportName'] ?? arrAirport;
                        final depTime = formatTime(seg['departureDateTime']);
                        final arrTime = formatTime(seg['arrivalDateTime']);
                        final cabin = seg['classOfService'] ?? '';
                        final rbd = seg['rbd'] ?? '';

                        // layover between segments
                        Widget? layover;
                        if (i > 0) {
                          final prevArr =
                              segments[i - 1]['arrivalDateTime'] as String?;
                          final thisDep = seg['departureDateTime'] as String?;
                          if (prevArr != null && thisDep != null) {
                            final diff = DateTime.tryParse(thisDep)?.difference(
                              DateTime.tryParse(prevArr) ?? DateTime.now(),
                            );
                            if (diff != null) {
                              final h = diff.inHours;
                              final m = diff.inMinutes % 60;
                              layover = Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Layover: ${h}h ${m}m in $depAirport',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ?layover,
                            Row(
                              children: [
                                const Icon(
                                  Icons.flight_takeoff,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$airline  $flightNum',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const Spacer(),
                                if (cabin.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '$cabin${rbd.isNotEmpty ? ' ($rbd)' : ''}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Timeline
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // dot-line-dot
                                  Column(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: GuzoTheme.primaryGreen,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          depTime,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '$depAirport  $depName',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          arrTime,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '$arrAirport  $arrName',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (i < segments.length - 1)
                              const Divider(height: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15),
          child: Text(
            title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildLuggageTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 35, color: Colors.grey.shade900),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade900),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _priceRow(
  String label,
  String value, {
  bool isSubItem = false,
  Color? color,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isSubItem ? Colors.grey : Colors.black87,
              fontSize: isSubItem ? 14 : 15,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isSubItem ? FontWeight.normal : FontWeight.w400,
            color: color ?? Colors.black,
          ),
        ),
      ],
    ),
  );
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




