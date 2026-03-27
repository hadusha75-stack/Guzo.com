import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayNamePage extends StatelessWidget {
  const DisplayNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: GuzoTheme.White),
        ),
        backgroundColor: GuzoTheme.primaryGreen,
        title: Text("Display name", style: TextStyle(color: GuzoTheme.White)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Display name *"),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GuzoTheme.primaryGreen,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: GuzoTheme.primaryGreen, width: 4),
                ),
              ),
            ),
            SizedBox(height: 40),
            const Divider(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuzoTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "save",
                  style: TextStyle(color: GuzoTheme.White, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
