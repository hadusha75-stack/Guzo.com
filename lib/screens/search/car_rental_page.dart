import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarRentalPage extends StatefulWidget {
  const CarRentalPage({super.key});
  @override
  State<CarRentalPage> createState() => _CarRentalPageState();
}

class _CarRentalPageState extends State<CarRentalPage> {
  final _pickupCtrl = TextEditingController();
  final _dropoffCtrl = TextEditingController();
  DateTime? _pickupDate;
  DateTime? _returnDate;
  bool _differentDropoff = false;

  String _fmt(DateTime? d) =>
      d == null ? 'Select' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Find your perfect car',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _field(Icons.location_on_outlined, 'Pick-up location', _pickupCtrl),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Return to different location'),
              value: _differentDropoff,
              // ignore: deprecated_member_use
              activeColor: GuzoTheme.primaryGreen,
              onChanged: (v) => setState(() => _differentDropoff = v),
            ),
            if (_differentDropoff) ...[
              _field(Icons.location_on_outlined, 'Drop-off location', _dropoffCtrl),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Expanded(child: _dateTile('Pick-up date', _pickupDate, () async {
                  final d = await _pickDate();
                  if (d != null) setState(() => _pickupDate = d);
                })),
                const SizedBox(width: 12),
                Expanded(child: _dateTile('Return date', _returnDate, () async {
                  final d = await _pickDate();
                  if (d != null) setState(() => _returnDate = d);
                })),
              ],
            ),
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
                    'Car rental search will be available soon',
                    snackPosition: SnackPosition.BOTTOM),
                child: const Text('Search cars',
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
                Text(_fmt(date), style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
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

