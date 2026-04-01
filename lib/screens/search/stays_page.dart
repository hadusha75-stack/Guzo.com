import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaysPage extends StatefulWidget {
  const StaysPage({super.key});
  @override
  State<StaysPage> createState() => _StaysPageState();
}

class _StaysPageState extends State<StaysPage> {
  final _destinationCtrl = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 2;
  int _rooms = 1;

  String _fmt(DateTime? d) =>
      d == null ? '' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Where are you going?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _field(Icons.location_on_outlined, 'Destination', _destinationCtrl),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _dateTile('Check-in', _checkIn, () async {
                  final d = await _pickDate();
                  if (d != null) setState(() => _checkIn = d);
                })),
                const SizedBox(width: 12),
                Expanded(child: _dateTile('Check-out', _checkOut, () async {
                  final d = await _pickDate();
                  if (d != null) setState(() => _checkOut = d);
                })),
              ],
            ),
            const SizedBox(height: 12),
            _counterTile('Guests', _guests, (v) => setState(() => _guests = v)),
            const SizedBox(height: 8),
            _counterTile('Rooms', _rooms, (v) => setState(() => _rooms = v)),
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
                    'Stay search will be available soon',
                    snackPosition: SnackPosition.BOTTOM),
                child: const Text('Search',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
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
                Text(date == null ? 'Select' : _fmt(date),
                    style: const TextStyle(fontWeight: FontWeight.w500)),
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

