import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage({super.key});
  @override
  State<TaxiPage> createState() => _TaxiPageState();
}

class _TaxiPageState extends State<TaxiPage> {
  final _pickupCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  bool _isRoundTrip = false;
  DateTime? _pickupDate;
  DateTime? _returnDate;
  int _passengers = 2;

  String _fmt(DateTime? d) =>
      d == null ? 'Select date' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Book a taxi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _tripTypeChip('One way', !_isRoundTrip, () => setState(() => _isRoundTrip = false)),
                const SizedBox(width: 8),
                _tripTypeChip('Round trip', _isRoundTrip, () => setState(() => _isRoundTrip = true)),
              ],
            ),
            const SizedBox(height: 16),
            _field(Icons.my_location, 'Pick-up location', _pickupCtrl),
            const SizedBox(height: 12),
            _field(Icons.location_on_outlined, 'Destination', _destCtrl),
            const SizedBox(height: 12),
            _dateTile('Pick-up date & time', _pickupDate, () async {
              final d = await _pickDate();
              if (d != null) setState(() => _pickupDate = d);
            }),
            if (_isRoundTrip) ...[
              const SizedBox(height: 12),
              _dateTile('Return date & time', _returnDate, () async {
                final d = await _pickDate();
                if (d != null) setState(() => _returnDate = d);
              }),
            ],
            const SizedBox(height: 12),
            _counterTile('Passengers', _passengers, (v) => setState(() => _passengers = v)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuzoTheme.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Get.snackbar('Coming Soon',
                    'Taxi booking will be available soon',
                    snackPosition: SnackPosition.BOTTOM),
                child: const Text('Check price',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripTypeChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? GuzoTheme.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GuzoTheme.primaryGreen),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : GuzoTheme.primaryGreen,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _field(IconData icon, String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: GuzoTheme.primaryGreen),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: GuzoTheme.primaryGreen, width: 2),
        ),
      ),
    );
  }

  Widget _dateTile(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18, color: GuzoTheme.primaryGreen),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(_fmt(date), style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterTile(String label, int value, Function(int) onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: value > 1 ? () => onChange(value - 1) : null,
                color: GuzoTheme.primaryGreen,
              ),
              Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onChange(value + 1),
                color: GuzoTheme.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2),
      );
}

