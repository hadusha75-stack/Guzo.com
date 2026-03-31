import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/screens/auth/login_page_google.dart';
import 'package:booking/screens/devicePreferances/setting_device_preferance_page.dart';
import 'package:booking/screens/myAccounts/payment_details_page.dart';
import 'package:booking/screens/myAccounts/personal_details_page.dart';
import 'package:booking/screens/myAccounts/reward_wallet_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get_storage/get_storage.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final userNameController = Get.find<UserNameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuzoTheme.primaryGreen,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: GuzoTheme.primaryGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 100,
        title: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF00A698),
              child: Text(
                userNameController.email.value[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hi, ${userNameController.email.value.split('@')[0]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Genius Level 1',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          _buildAppBarAction(SimpleLineIcons.bubble, () {
            // Get.to(NotificationPage());
          }, "2"),
          _buildAppBarAction(Icons.notifications_none, () {
            // Get.to(NotificationPage());
          }, '3'),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(height: 240, color: GuzoTheme.primaryGreen),
                Column(
                  children: [_buildGeniusRewardCard(), _buildWalletCard()],
                ),
              ],
            ),

            _buildSection("Payment info", [
              _buildRow(
                Icons.account_balance_wallet_outlined,
                "Rewards & Wallet",
                () {
                  Get.to(() => const RewardWalletPage());
                },
              ),
              _buildRow(Icons.credit_card_outlined, "Payment methods", () {
                Get.to(() => const PaymentDetailsPage());
              }),
              _buildRow(Icons.list_alt_outlined, "Transactions", () {
                // Get.to(() => const HomePage());
              }),
            ]),

            _buildSection("Manage account", [
              _buildRow(Icons.person_outline, "Personal details", () {
                Get.to(() => const PersonalDetailsPage());
              }),
              _buildRow(Icons.lock_outline, "Security settings", () {
                // Get.to(() => const HomePage());
              }),
              _buildRow(Icons.people_outline, "Other travelers", () {
                // Get.to(() => const HomePage());
              }),
            ]),

            _buildSection("Preferences", [
              _buildRow(Icons.settings_outlined, "Device preferences", () {
                Get.to(() => const SettingDevicePreferancePage());
              }),
              _buildRow(Icons.tune, "Travel preferences", () {
                // Get.to(() => const HomePage());
              }),
              _buildRow(Icons.chat_outlined, "Communication preferences", () {
                // Get.to(() => const HomePage());
              }),
            ]),

            _buildSection("Travel activity", [
              _buildRow(Icons.chat_bubble_outline, "My reviews", () {
                // Get.to(() => HomePage());
              }),
              _buildRow(
                Icons.help_center_outlined,
                "My questions to properties",
                () {
                  // Get.to(() => const HomePage());
                },
              ),
            ]),

            _buildSection("Help and support", [
              _buildRow(Icons.help_outline, "Contact Customer Service", () {
                // Get.to(() => const HomePage());
              }),
              _buildRow(
                Icons.coronavirus_outlined,
                "Safety resource center",
                () {
                  // Get.to(() => const HomePage());
                },
              ),
              _buildRow(Icons.handshake_outlined, "Dispute resolution", () {
                // Get.to(() => const HomePage());
              }),
            ]),

            _buildSection("Legal and privacy", [
              _buildRow(
                Icons.verified_user_outlined,
                "Privacy and data management",
                () {
                  // Get.to(() => const HomePage());
                },
              ),
              _buildRow(Icons.assignment_outlined, "Content guidelines", () {
                // Get.to(() => const HomePage());
              }),
            ]),

            _buildSection("Discover", [
              _buildRow(Icons.percent, "Deals", () {
                // Get.to(() => const HomePage());
              }),
            ]),

            _buildSection("Manage your property", [
              _buildRow(Icons.home_work_outlined, "List your property", () {
                // Get.to(() => const HomePage());
              }),
            ]),
            Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final box = GetStorage();
                      await box.erase();
                      Get.offAll(() => LoginPageGoogle());
                    },
                    child: const Text(
                      "Sign out",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(color: Theme.of(context).cardColor, width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarAction(IconData icon, VoidCallback tap, String? count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white, size: 28),
          onPressed: tap,
        ),
        if (count != null)
          Positioned(
            right: 8,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFFD32F2F),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> rows) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(children: rows),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).textTheme.bodyMedium?.color, size: 24),
      title: Text(
        label,
        style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildGeniusRewardCard() {
    return Stack(
      children: [
        Container(height: 165, color: GuzoTheme.primaryGreen),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              // ignore: deprecated_member_use
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Image.network(
                  'https://cf.bstatic.com/static/img/genius/genius_level_1/7d8995a9735d97f223b2023078a16867373f71f1.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.card_giftcard,
                      size: 50,
                      color: Color(0xFF0071C2),
                    );
                  },
                ),
                title: const Text(
                  "You have 2 Genius rewards",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("10% discounts and so much more!"),
                trailing: const Icon(Icons.chevron_right),
              ),
              const Divider(height: 1),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text("You're ", style: TextStyle(fontSize: 13)),
                    Text(
                      "5 bookings away ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("from Genius Level 2", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard() {
    return Stack(
      children: [
        Container(color: GuzoTheme.primaryGreen, height: 75),
        Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 19,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "No Credits or vouchers yet",
                style: TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Text(
                    "ETB 0",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

