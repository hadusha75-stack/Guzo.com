import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/screens/booking/booking.dart';
import 'package:booking/screens/myAccounts/my_account_page.dart';
import 'package:booking/screens/flightsPage/flight_page.dart';
import 'package:booking/screens/saved/saved_page.dart';
import 'package:booking/screens/search/attractions_page.dart';
import 'package:booking/screens/search/car_rental_page.dart';
import 'package:booking/screens/search/stays_page.dart';
import 'package:booking/screens/search/taxi_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late TabController _searchTabCtrl;

  static const _searchTabs = [
    (Icons.hotel_outlined, 'Stays'),
    (Icons.flight, 'Flights'),
    (Icons.directions_car_outlined, 'Car Rental'),
    (Icons.local_taxi, 'Taxi'),
    (Icons.attractions, 'Attractions'),
  ];

  @override
  void initState() {
    super.initState();
    _searchTabCtrl = TabController(
      length: _searchTabs.length,
      vsync: this,
      initialIndex: 1, 
    );
  }

  @override
  void dispose() {
    _searchTabCtrl.dispose();
    super.dispose();
  }

  Widget _searchBody() {
    return Column(
      children: [
        // AppBar area
        Container(
          color: GuzoTheme.primaryGreen,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Guzo.com',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Category tab bar
                TabBar(
                  controller: _searchTabCtrl,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  indicatorWeight: 3,
                  tabs: _searchTabs
                      .map((t) => Tab(icon: Icon(t.$1, size: 20), text: t.$2))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _searchTabCtrl,
            children: const [
              StaysPage(),
              _FlightsTab(),
              CarRentalPage(),
              TaxiPage(),
              AttractionsPage(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _currentPage() {
    switch (_navIndex) {
      case 1: return const SavedPage();
      case 2: return const Booking();
      case 3: return MyAccountPage();
      default: return _searchBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0071C2),
        backgroundColor: Theme.of(context).cardColor,
        onTap: (i) => setState(() => _navIndex = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Saved',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              final email = Get.find<UserNameController>().email.value;
              final letter = email.isNotEmpty ? email[0].toUpperCase() : '?';
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFC107), width: 2),
                ),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: GuzoTheme.primaryGreen,
                  child: Text(letter,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
              );
            }),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// Wrapper so FlightsPage doesn't need onTabTap anymore
class _FlightsTab extends StatelessWidget {
  const _FlightsTab();

  @override
  Widget build(BuildContext context) => const FlightsPage();
}
