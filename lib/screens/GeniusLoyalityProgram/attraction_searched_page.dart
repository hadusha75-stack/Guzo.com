
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';

class AttractionSearchedPage extends StatelessWidget {
  const AttractionSearchedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        // title: ElevatedButton(onPressed: () {}, child: Text('  data ')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip("Filter by keyword", Icons.search, () {}),
                _buildFilterChip("free cancellation", Icons.cancel, () {}),
                _buildFilterChip(
                  "location",
                  Icons.local_activity_rounded,
                  () {},
                ),
                _buildFilterChip("Review Score", Icons.score, () {}),
                _buildFilterChip("Category", Icons.category, () {}),
                _buildFilterChip("Language", Icons.language_sharp, () {}),
                _buildFilterChip(
                  "Deals & Discounts",
                  Icons.discount_rounded,
                  () {},
                ),
                _buildFilterChip(
                  "Time of day",
                  Icons.time_to_leave_outlined,
                  () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=1000&auto=format&fit=crop",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Imperial palace or Endo Castle Time Trip Learning Walking Tour\n* 4.0(1 review)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From 2.81\nAvailable starting Febrary 26"),
                  Text(
                    "  Free cancellation available",
                    style: TextStyle(color: GuzoTheme.accentGold),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1000&auto=format&fit=crop",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Imperial palace or Endo Castle Time Trip Learning Walking Tour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From 2.81\nAvailable starting Febrary 26"),
                  Text(
                    "  Free cancellation available",
                    style: TextStyle(color: GuzoTheme.primaryGreen,)
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=1000&auto=format&fit=crop",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Imperial palace or Endo Castle Time Trip Learning Walking Tour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From 2.81\nAvailable starting Febrary 26"),
                  Text(
                    "  Free cancellation available",
                    style: TextStyle(color: GuzoTheme.primaryGreen),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=1000&auto=format&fit=crop",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Imperial palace or Endo Castle Time Trip Learning Walking Tour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From 2.81\nAvailable starting Febrary 26"),
                  Text(
                    "  Free cancellation available",
                    style: TextStyle(color: GuzoTheme.primaryGreen),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1541336032412-2048a678540d?q=80&w=1000&auto=format&fit=crop",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Imperial palace or Endo Castle Time Trip Learning Walking Tour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From 2.81\nAvailable starting Febrary 26"),
                  Text(
                    "  Free cancellation available",
                    style: TextStyle(color: GuzoTheme.primaryGreen),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    width: 170,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                      image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1000&auto=format&fit=crop",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Imperial palace or Endo Castle Time Trip Learning Walking Tour",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFilterChip(String label, IconData icon, VoidCallback tap) {
  return InkWell(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
