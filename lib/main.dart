
import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/login_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/newFlights/flight_page.dart';
import 'package:booking/screens/auth/login_page_google.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  Get.put(FlightDataController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(UserNameController(), permanent: true);
  Get.put(FlightUpdaredController(), permanent: true);

  await GetStorage.init();

  runApp(DevicePreview(enabled: kIsWeb, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final isLoggIn = box.read('isLoggedIn') ?? false;

    return GetMaterialApp(
      title: 'Guzo.com',
      debugShowCheckedModeBanner: false,
      locale: kIsWeb ? DevicePreview.locale(context) : null,
      builder: kIsWeb ? DevicePreview.appBuilder : null,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: isLoggIn ? FlightsPage() : LoginPageGoogle(),
    );
  }
}
