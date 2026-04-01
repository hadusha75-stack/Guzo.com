import 'package:booking/screens/auth/login_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageGoogle extends StatelessWidget {
  const LoginPageGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Guzo.com",
          style: TextStyle(
            color: GuzoTheme.White,
            fontWeight: FontWeight.bold,
            fontSize: 33,
          ),
        ),
        backgroundColor: GuzoTheme.primaryGreen,
        leading: Icon(Icons.clear, color: GuzoTheme.White,),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Sign in for easier access to your trip details',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: GuzoTheme.primaryGreen, width: 2),
                ),
              ),
              child: Row(
                children: [
                  // Image.network(
                  //   'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/512px-Google_%22G%22_Logo.svg.png',
                  //   height: 20,
                  // ),
                  Text(
                    'G',
                    style: TextStyle(
                      fontSize: 30,
                      color: const Color.fromARGB(255, 255, 49, 221),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: GuzoTheme.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 22,
                ), // optional
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color:GuzoTheme.primaryGreen, width: 2),
                ),
              ),
              child: Row(
                children: [
                  // Image.network(
                  //   'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                  //   height: 2,
                  //   color: AppColors.white, // optional, to match button color
                  // ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  Text(
                    'f',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Continue with Facebook",
                    style: TextStyle(
                      color: GuzoTheme.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              height: 90,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(LoginPage());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuzoTheme.primaryGreen,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: GuzoTheme.primaryGreen, width: 2),
                  ),
                ),
                child: Text(
                  "Continue with Email",
                  style: TextStyle(
                    color: GuzoTheme.White,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text("By singing in or creating an account, you agree with"),
            Text(" our Teams & Conditions and Privacy Statemeent"),
            Text("© 2006-2026 Booking.com"),
          ],
        ),
      ),
    );
  }
}

