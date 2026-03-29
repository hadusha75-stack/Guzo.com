import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardWalletPage extends StatelessWidget {
  const RewardWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: GuzoTheme.primaryGreen,
        title: Text(
          'Reward & Wallet',
          style: TextStyle(color: GuzoTheme.White, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: GuzoTheme.primaryGreen,
                  width: double.infinity,
                  height: 80,
                ),
                Column(
                  children: [_buildGeniusRewardCard(), SizedBox(height: 15)],
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Got a coupon code? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Add coupon into Wallet",
                          style: TextStyle(
                            fontSize: 15,
                            color: GuzoTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Text(
                        "What's Rewards & Wallet?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _texts(
                  Icons.confirmation_num,
                  "Book and earn travel rewards",
                  "Credits,vouchers,you name it! These are all",
                  " spendable on your next Booking.com trip.",
                ),
                SizedBox(height: 20),
                _texts(
                  Icons.phone_android_outlined,
                  "Track everthing at a glance",
                  "Your Wallet keeps all rewards safe,while",
                  "updating you about your earing and spendings.",
                ),
                SizedBox(height: 20),
                _texts(
                  Icons.connect_without_contact_outlined,
                  "Pay with Wallet to save money",
                  "If a booking accepts any rewards in your Wallet,",
                  "it'll apear during payment for spendings.",
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    bottom: 60,
                    right: 15,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        side: const BorderSide(
                          color: GuzoTheme.primaryGreen,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ), // height
                      ),
                      child: const Text(
                        "Need help? Visit FAQs",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: GuzoTheme.primaryGreen,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _texts(
  IconData paraIcon,
  String label,
  String secondLabel,
  String thirdLabel,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align icon with top of text
      children: [
        Icon(paraIcon, size: 40, color: GuzoTheme.primaryGreen),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$secondLabel$thirdLabel",
                style: const TextStyle(fontSize: 20, color: Colors.black87),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildGeniusRewardCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
          blurRadius: 10,
        ),
      ],
    ),
    child: Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Icon(
            Icons.account_balance_wallet_outlined,
            color:GuzoTheme.primaryGreen,
            size: 50,
          ),
          title: const Text(
            "Wallet balance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("Include all spendable rewards"),
          trailing: Text(
            "ETB 0  ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const Divider(height: 1),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Credits", style: TextStyle(fontSize: 15)),
                  SizedBox(width: 7),
                  Icon(Icons.info_outline, color: GuzoTheme.primaryGreen),
                ],
              ),
              Text("ETB 0"),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16, left: 2),
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Browse Rewards and Wallet activity",
                  style: TextStyle(
                    color: GuzoTheme.primaryGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
