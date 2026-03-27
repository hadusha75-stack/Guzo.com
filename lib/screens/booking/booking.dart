import 'package:booking/controllers/BookingController.dart';
import 'package:booking/screens/booking/Active.dart';
import 'package:booking/screens/booking/canceled.dart';
import 'package:booking/screens/booking/past.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final controller = Get.put(Bookingcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              TextButton(
                onPressed: controller.showActiveBooking,
                child: const Text('Active'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: controller.showPastBooking,
                child: const Text('past'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: controller.showCanceledBooking,
                child: const Text('canceled'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.showActive.value) {
              return Active();
            } else if (controller.showPast.value) {
              return Past();
            } else {
              return Canceled();
            }
          }),
        ],
      ),
    );
  }
}
