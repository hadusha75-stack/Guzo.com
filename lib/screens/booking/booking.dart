import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        automaticallyImplyLeading: false,
        title: const Text('Bookings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past'),
            Tab(text: 'Canceled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ActiveTab(),
          _PastTab(),
          _CanceledTab(),
        ],
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  const _ActiveTab();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FlightUpdaredController>();
    return Obx(() {
      final locator = ctrl.bookingLocator.value;
      final offer = ctrl.selectedOffer.value;

      if (locator.isEmpty || offer == null) {
        return _emptyState(
          context,
          Icons.flight_takeoff,
          'Where to next?',
          "You haven't started a trip yet.\nOnce you make a booking, it'll appear here.",
        );
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [_buildBookingCard(context, ctrl, offer, locator)],
      );
    });
  }

  Widget _buildBookingCard(BuildContext context, FlightUpdaredController ctrl,
      Map<String, dynamic> offer, String locator) {
    final flights = offer['flights'] as List? ?? [];
    final currency = offer['pricing']?['currency'] ?? '';
    final total = offer['pricing']?['total']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GuzoTheme.primaryGreen,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Confirmed',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(locator,
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final flight in flights) ...[
                  _flightRow(context, flight),
                  const SizedBox(height: 8),
                ],
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('$currency $total',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: GuzoTheme.primaryGreen)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _flightRow(BuildContext context, dynamic flight) {
    final segs = flight['segments'] as List? ?? [];
    final first = segs.isNotEmpty ? segs.first : null;
    final last = segs.isNotEmpty ? segs.last : null;
    final dep = first?['departureAirport'] ?? '';
    final arr = last?['arrivalAirport'] ?? '';
    final depTime = _fmt(first?['departureDateTime']);
    final airline = first?['airlineName'] ?? '';

    return Row(
      children: [
        const Icon(Icons.flight_takeoff, color: GuzoTheme.primaryGreen, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text('$dep → $arr  ·  $depTime  ·  $airline',
              style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  String _fmt(String? dt) {
    if (dt == null) return '';
    try {
      return DateFormat('EEE, MMM d').format(DateTime.parse(dt));
    } catch (_) {
      return dt;
    }
  }
}

class _PastTab extends StatelessWidget {
  const _PastTab();

  @override
  Widget build(BuildContext context) => _emptyState(
        context,
        Icons.history,
        'Revisit Past Trips',
        'Here you can refer to all past trips and get\ninspiration for your upcoming trips.',
      );
}

class _CanceledTab extends StatelessWidget {
  const _CanceledTab();

  @override
  Widget build(BuildContext context) => _emptyState(
        context,
        Icons.cancel_outlined,
        'Change of Plan?',
        'Here you can refer to all canceled trips.',
      );
}

Widget _emptyState(BuildContext context, IconData icon, String title, String subtitle) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 100, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    ),
  );
}
