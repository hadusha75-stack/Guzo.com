import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingDevicePreferancePage extends StatefulWidget {
  const SettingDevicePreferancePage({super.key});

  @override
  State<SettingDevicePreferancePage> createState() =>
      _SettingDevicePreferancePageState();
}

class _SettingDevicePreferancePageState
    extends State<SettingDevicePreferancePage> {
  final box = GetStorage();

  static const _languages = [
    {'name': 'English (US)', 'code': 'en', 'country': 'US'},
    {'name': 'Amharic', 'code': 'am', 'country': 'ET'},
    {'name': 'Arabic', 'code': 'ar', 'country': 'SA'},
    {'name': 'French', 'code': 'fr', 'country': 'FR'},
    {'name': 'Swahili', 'code': 'sw', 'country': 'KE'},
  ];

  late String _selectedLangCode;
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _selectedLangCode = box.read('langCode') ?? 'en';
    _isDark = box.read('isDark') ?? false;
  }

  String get _selectedLangName =>
      _languages.firstWhere((l) => l['code'] == _selectedLangCode,
          orElse: () => _languages.first)['name']!;

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(alignment: Alignment.centerLeft,
              child: Text('Select Language',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 8),
          ..._languages.map((lang) => ListTile(
            title: Text(lang['name']!),
            trailing: _selectedLangCode == lang['code']
                ? const Icon(Icons.check, color: GuzoTheme.primaryGreen)
                : null,
            onTap: () {
              setState(() => _selectedLangCode = lang['code']!);
              box.write('langCode', lang['code']);
              box.write('countryCode', lang['country']);
              Get.updateLocale(Locale(lang['code']!, lang['country']!));
              Get.back();
            },
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _toggleTheme(bool value) {
    setState(() => _isDark = value);
    box.write('isDark', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    // Force full app rebuild to apply theme to all pages
    Get.forceAppUpdate();
  }

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
        title: const Text('Settings',
            style: TextStyle(color: GuzoTheme.White, fontWeight: FontWeight.w500)),
      ),
      body: ListView(
        children: [
          _sectionHeader('Device settings'),
          ListTile(
            title: const Text('Language'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selectedLangName,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: _pickLanguage,
          ),
          ListTile(
            title: const Text('Appearance'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_isDark ? 'Dark theme' : 'Light theme',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Switch(
                  value: _isDark,
                  activeColor: GuzoTheme.primaryGreen,
                  onChanged: _toggleTheme,
                ),
              ],
            ),
          ),
          const Divider(),
          _sectionHeader('About'),
          _simpleTile('Privacy Policy'),
          _simpleTile('Car Rentals Privacy Statement'),
          _simpleTile('Manage privacy settings'),
          _simpleTile('Exercise your data rights'),
          _simpleTile('Terms and Conditions'),
          _simpleTile('Open-source licenses'),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('v 1.0.0', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
        child: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );

  Widget _simpleTile(String title) => ListTile(title: Text(title));
}
