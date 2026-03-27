import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeniusLoyalityProgramPage extends StatelessWidget {
  const GeniusLoyalityProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: GuzoTheme.primaryGreen,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Genius loyalty program",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderImage(),

                _buildProgressCard(context),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 20),
                  child: Text(
                    "Booking.com is better with Genius",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Enjoy a lifetime of discounts and travel rewards on hundreds of thousands of stays and renatl cars worldwide with Booking.com's loyality program.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                _buildBenefitsSection(),

                _buildFAQSection(),

                const SizedBox(height: 100),
              ],
            ),
          ),

          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=1000&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Get rewarded for being you",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Genius",
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Booking.com's loyalty program",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -70),
      child: Container(
        height: 350,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "       , you're at Level 1!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Complete 5 bookings within 2 years to unlock Level 2 discounts and rewards.",
              style: TextStyle(color: GuzoTheme.black, fontSize: 20),
            ),
            const Text(
              "Every booking counts!",
              style: TextStyle(fontSize: 20, color: GuzoTheme.black),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) => _buildDashedCircle()),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text(
                "How to progress in Genius",
                style: TextStyle(
                  color: GuzoTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedCircle() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:GuzoTheme.primaryGreen,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Easy to find",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF003580),
            ),
          ),
          const Text(
            "Once signed in, Look for the blue Genius label to find your rewards.",
          ),
          const Divider(height: 30),
          const Text(
            "Easy to keep",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF003580),
            ),
          ),
          const Text(
            "After unloking each Genius level, the rewards are yours to enjoy for life,",
          ),
          const Divider(height: 30),
          const Text(
            "Easy to grow",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF003580),
            ),
          ),
          const Text(
            "The more you book, the more you get - every booking counts toward your progress.",
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "Genius FAQs",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
        ),
        _buildExpansionTile("How to progress in Genius"),
        _buildExpansionTile("Which bookings contribute to my progress?"),
        _buildExpansionTile("Where can I use my Genius discount?"),
      ],
    );
  }

  Widget _buildExpansionTile(String title) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Here is the detailed answer about the loyalty program rules...",
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: GuzoTheme.White,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GuzoTheme.primaryGreen,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {},
          child: const Text(
            "Find your next stay",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
