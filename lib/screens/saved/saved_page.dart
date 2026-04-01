import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  // Locally saved offers list
  final RxList<Map<String, dynamic>> _savedOffers = <Map<String, dynamic>>[].obs;

  String _formatTime(String? dt) {
    if (dt == null || dt.isEmpty) return '--:--';
    try {
      return DateFormat('h:mm a').format(DateTime.parse(dt));
    } catch (_) {
      return '--:--';
    }
  }

  String _formatDuration(String dur) {
    final m = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?').firstMatch(dur);
    if (m == null) return dur;
    return '${m.group(1) ?? '0'}h ${m.group(2) ?? '0'}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        automaticallyImplyLeading: false,
        title: const Text('Saved',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: Obx(() {
        if (_savedOffers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border,
                    size: 100, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No saved flights yet',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any flight\nto save it here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuzoTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                  ),
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text('Search flights',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _savedOffers.length,
          itemBuilder: (_, i) => _buildSavedCard(_savedOffers[i], i),
        );
      }),
    );
  }

  Widget _buildSavedCard(Map<String, dynamic> offer, int index) {
    final flights = offer['flights'] as List? ?? [];
    final firstFlight = flights.isNotEmpty ? flights[0] : null;
    final segs = firstFlight?['segments'] as List? ?? [];
    final firstSeg = segs.isNotEmpty ? segs.first : null;
    final lastSeg = segs.isNotEmpty ? segs.last : null;
    final airline = firstSeg?['airlineName'] ?? '';
    final airlineCode = (firstSeg?['airlineCode'] ?? '').toLowerCase();
    final dep = firstSeg?['departureAirport'] ?? '';
    final arr = lastSeg?['arrivalAirport'] ?? '';
    final depTime = _formatTime(firstSeg?['departureDateTime']);
    final arrTime = _formatTime(lastSeg?['arrivalDateTime']);
    final dur = _formatDuration(firstFlight?['duration'] ?? '');
    final stops = segs.length - 1;
    final currency = offer['pricing']?['currency'] ?? '';
    final total = offer['pricing']?['total']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Airline logo
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                'https://content.airhex.com/content/logos/airlines_${airlineCode}_350_100_r.png',
                width: 50,
                height: 25,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.flight, size: 25),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$dep → $arr',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('$depTime – $arrTime  ·  $dur',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600)),
                  Text(
                      '$airline  ·  ${stops == 0 ? 'Direct' : '$stops stop${stops > 1 ? 's' : ''}'}',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$currency $total',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: GuzoTheme.primaryGreen)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() => _savedOffers.removeAt(index));
                    Get.snackbar('Removed', 'Flight removed from saved',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2));
                  },
                  child: const Icon(Icons.favorite,
                      color: Colors.red, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Call this from outside to save an offer
  void saveOffer(Map<String, dynamic> offer) {
    if (!_savedOffers.any((o) => o['offerId'] == offer['offerId'])) {
      _savedOffers.add(offer);
    }
  }
}
