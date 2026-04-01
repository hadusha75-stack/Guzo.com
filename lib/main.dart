
import 'package:booking/controllers/FlightsController.dart';
import 'package:booking/controllers/flights_with_api_controller.dart';
import 'package:booking/controllers/login_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/main_screen.dart';
import 'package:booking/screens/auth/login_page_google.dart';
import 'package:booking/theam/app_color.dart';
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
  final box = GetStorage();
  final isDark = box.read('isDark') ?? false;
  final langCode = box.read('langCode') ?? 'en';
  final countryCode = box.read('countryCode') ?? 'US';

  runApp(DevicePreview(
    enabled: kIsWeb,
    builder: (context) => MyApp(
      isDark: isDark,
      locale: Locale(langCode, countryCode),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Locale locale;
  MyApp({super.key, this.isDark = false, this.locale = const Locale('en', 'US')});
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final isLoggIn = box.read('isLoggedIn') ?? false;

    return GetMaterialApp(
      title: 'Guzo.com',
      debugShowCheckedModeBanner: false,
      locale: kIsWeb ? DevicePreview.locale(context) : locale,
      builder: kIsWeb
          ? DevicePreview.appBuilder
          : (context, child) => MediaQuery(
                data: MediaQuery.of(context),
                child: child!,
              ),
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white70,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white60),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        dividerColor: Colors.white12,
        iconTheme: const IconThemeData(color: Colors.white70),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          hintStyle: const TextStyle(color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GuzoTheme.primaryGreen,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: isLoggIn ? const MainScreen() : LoginPageGoogle(),
    );
  }
}
