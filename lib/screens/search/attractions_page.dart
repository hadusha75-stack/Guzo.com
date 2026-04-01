import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttractionsPage extends StatefulWidget {
  const AttractionsPage({super.key});
  @override
  State<AttractionsPage> createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  final _destCtrl = TextEditingController();
  DateTime? _date;
  int _people = 2;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.museum_outlined, 'label': 'Museums'},
    {'icon': Icons.park_outlined, 'label': 'Parks'},
    {'icon': Icons.restaurant_outlined, 'label': 'Food tours'},
    {'icon': Icons.directions_boat_outlined, 'label': 'Cruises'},
    {'icon': Icons.sports_outlined, 'label': 'Sports'},
    {'icon': Icons.theater_comedy_outlined, 'label': 'Shows'},
  ];

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
            const Text('Discover things to do',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _destCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: GuzoTheme.primaryGreen),
                hintText: 'Where do you want to go?',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: GuzoTheme.primaryGreen, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: InkWell(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (d != null) setState(() => _date = d);
                  },
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
                        Text(_fmt(_date), style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                )),
                const SizedBox(width: 4),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('People', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _people > 1 ? () => setState(() => _people--) : null,
                              color: GuzoTheme.primaryGreen,
                            ),
                            Text('$_people', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: IconButton(
                                icon: const Icon(Icons.add, size: 11),
                                onPressed: () => setState(() => _people++),
                                color: GuzoTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
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
                    'Attractions search will be available soon',
                    snackPosition: SnackPosition.BOTTOM),
                child: const Text('Search',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Browse by category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: _categories.map((c) => _categoryCard(c)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(Map<String, dynamic> c) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(c['icon'] as IconData, size: 32, color: GuzoTheme.primaryGreen),
          const SizedBox(height: 8),
          Text(c['label'] as String,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

