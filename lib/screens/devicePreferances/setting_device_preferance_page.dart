import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingDevicePreferancePage extends StatelessWidget {
  const SettingDevicePreferancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: GuzoTheme.White, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader("Device settings"),
          _buildSettingTile("Language", () {}, trailingText: "English (US)"),
          _buildSettingTile("Currency", () {}),
          _buildSettingTile(
            "Units",
            () {},
            trailingText: "Imperial (miles, ft2)",
          ),
          _buildAppearanceTile(),
          const Divider(),
          _buildSectionHeader("About"),
          _buildSettingTile("Privacy Policy", () {}, showChevron: false),
          _buildSettingTile(
            "Car Rentals Privacy Statement",
            () {},
            showChevron: false,
          ),
          _buildSettingTile(
            "Manage privacy settings",
            () {},
            showChevron: false,
          ),
          _buildSettingTile(
            "Exercise your data rights",
            () {},
            showChevron: false,
          ),
          _buildSettingTile("Terms and Conditions", () {}, showChevron: false),
          _buildSettingTile("Open-source licenses", () {}, showChevron: false),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "v 62.8.1",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    VoidCallback tap, {
    String? trailingText,
    bool showChevron = true,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white70 : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (showChevron) const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: tap,
    );
  }

  Widget _buildAppearanceTile() {
    final box = GetStorage();
    final isDark = Get.isDarkMode;

    return ListTile(
      title: const Text("Appearance"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isDark ? "Dark theme" : "Light theme",
            style: TextStyle(
              color: Get.isDarkMode ? Colors.white70 : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isDark,
            onChanged: (value) {
              box.write("isDark", value);
              Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
    );
  }
}
