import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/theam/app_color.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassportDetailPage extends StatefulWidget {
  const PassportDetailPage({super.key});

  @override
  State<PassportDetailPage> createState() => _PassportDetailPageState();
}

class _PassportDetailPageState extends State<PassportDetailPage> {
  final userNameController = Get.find<UserNameController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passportNumberController = TextEditingController();
  final expiredDateController = TextEditingController();
  final issuingCountryController = TextEditingController();
  // RxBool isBlank = false.obs;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passportNumberController.dispose();
    expiredDateController.dispose();
    issuingCountryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: GuzoTheme.White),
        ),
        backgroundColor: GuzoTheme.primaryGreen,
        title: const Text(
          "Passport details",
          style: TextStyle(color: GuzoTheme.White),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Save your passport details for use when booking your next stay, flight, or attraction.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "First name *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            _buildTextField(
              controller: firstNameController,
              hint: "Enter your first name",
            ),
            const SizedBox(height: 15),
            const Text(
              "Last name *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            _buildTextField(
              controller: lastNameController,
              hint: "Enter your last name",
            ),
            const SizedBox(height: 15),
            const Text(
              "Passport number *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            _buildTextField(
              controller: passportNumberController,
              hint: "Enter passport number",
            ),
            const SizedBox(height: 15),
            const Text(
              "Expiry date *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: expiredDateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Select expiry date",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: GuzoTheme.primaryGreen,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: GuzoTheme.primaryGreen,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                suffixIcon: const Icon(Icons.calendar_month),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  expiredDateController.text =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),

            const SizedBox(height: 15),
            const Text(
              "Issuing country *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: issuingCountryController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Select issuing country",
                suffixIcon: const Icon(Icons.arrow_drop_down),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: GuzoTheme.primaryGreen,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: GuzoTheme.primaryGreen,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: false,
                  onSelect: (country) {
                    issuingCountryController.text = country.name;
                  },
                );
              },
            ),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "I consent to booking.com storing my passport information in accordance with the privacy statement.",
                    softWrap: true,
                  ),
                ),
                // Obx( () =>
                Checkbox(
                  value: isBlank,
                  onChanged: (value) {
                    // isBlank.value = value!;
                  },
                ),
                // ),
              ],
            ),
            Text("Privacy Statement"),
            SizedBox(height: 30),
            Divider(height: 1),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GuzoTheme.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  userNameController.setPassportDetail(
                    firstNameController.text,
                    lastNameController.text,
                    passportNumberController.text,
                    expiredDateController.text,
                    issuingCountryController.text,
                  );
                  Get.back();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: GuzoTheme.White,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: GuzoTheme.primaryGreen, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: GuzoTheme.primaryGreen, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
