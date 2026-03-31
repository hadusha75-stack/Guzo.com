import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/newFlights/flight_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  String _formatTime(String? dt) {
    if (dt == null || dt.isEmpty) return '--:--';
    try {
      return DateFormat('h:mm a').format(DateTime.parse(dt));
    } catch (_) {
      return '--:--';
    }
  }

  String _formatDate(String? dt) {
    if (dt == null || dt.isEmpty) return '';
    try {
      return DateFormat('EEE, MMM d yyyy').format(DateTime.parse(dt));
    } catch (_) {
      return dt;
    }
  }

  String _formatDuration(String dur) {
    final m = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?').firstMatch(dur);
    if (m == null) return dur;
    final h = m.group(1) ?? '0';
    final min = m.group(2) ?? '0';
    return '${h}h ${min}m';
  }

  @override
  Widget build(BuildContext context) {
    final flightCtrl = Get.find<FlightUpdaredController>();
    final flightDataCtrl = Get.find<FlightDataController>();
    final userCtrl = Get.find<UserNameController>();

    final offer = flightCtrl.selectedOffer.value;
    final flights = offer?['flights'] as List? ?? [];
    final isRoundTrip = flightDataCtrl.selectedTripType.value == 'Round-trip';
    final currency = offer?['pricing']?['currency'] ?? '';
    final total = flightDataCtrl.totalPrice.value;
    final locator = flightCtrl.bookingLocator.value;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        color: GuzoTheme.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: GuzoTheme.accentGold,
                        size: 110,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your flight has been booked successfully. ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    _card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PNR  ',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => Text(
                              flightCtrl.airlinePnr.value.isNotEmpty
                                  ? flightCtrl.airlinePnr.value
                                  : (locator.isEmpty ? 'N/A' : locator),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: GuzoTheme.primaryGreen,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _card(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 36,
                            color: GuzoTheme.primaryGreen,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userCtrl.firstNameOf.value} ${userCtrl.lastNameOf.value}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${userCtrl.travelerType.value.isEmpty ? 'Adult' : userCtrl.travelerType.value}'
                                ' · ${userCtrl.gender.value.isEmpty ? '' : userCtrl.gender.value}'
                                ' · ${userCtrl.dateOfBirth.value.isEmpty ? '' : userCtrl.dateOfBirth.value}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    for (int i = 0; i < flights.length; i++) ...[
                      _flightCard(
                        context,
                        flight: flights[i],
                        label: flights.length == 1
                            ? 'Outbound Flight'
                            : i == 0
                            ? 'Outbound Flight'
                            : 'Return Flight',
                        from: i == 0
                            ? flightDataCtrl.recievedFromFromName.value
                            : flightDataCtrl.recievedFromToName.value,
                        to: i == 0
                            ? flightDataCtrl.recievedFromToName.value
                            : flightDataCtrl.recievedFromFromName.value,
                      ),
                      const SizedBox(height: 12),
                    ],

                    _card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total paid',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$currency $total',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: GuzoTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: GuzoTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          // ignore: deprecated_member_use
                          color: GuzoTheme.primaryGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        isRoundTrip ? 'Round Trip' : 'One Way',
                        style: const TextStyle(
                          color: GuzoTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuzoTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.offAll(() => const FlightsPage()),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _flightCard(
    BuildContext context, {
    required dynamic flight,
    required String label,
    required String from,
    required String to,
  }) {
    final segments = flight['segments'] as List? ?? [];
    final firstSeg = segments.isNotEmpty ? segments.first : null;
    final lastSeg = segments.isNotEmpty ? segments.last : null;
    final airline = firstSeg?['airlineName'] ?? '';
    final depTime = _formatTime(firstSeg?['departureDateTime']);
    final arrTime = _formatTime(lastSeg?['arrivalDateTime']);
    final depDate = _formatDate(firstSeg?['departureDateTime']);
    final duration = _formatDuration(flight['duration'] as String? ?? '');
    final stops = segments.length - 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: GuzoTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: GuzoTheme.primaryGreen,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                airline,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      depTime,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      from,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    duration,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: GuzoTheme.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      const Icon(
                        Icons.flight,
                        size: 16,
                        color: GuzoTheme.primaryGreen,
                      ),
                      Container(
                        width: 60,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stops == 0
                        ? 'Direct'
                        : '$stops stop${stops > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: stops == 0 ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      arrTime,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      to,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            depDate,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
