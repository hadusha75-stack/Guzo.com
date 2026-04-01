import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/screens/personalDetails/address_page.dart';
import 'package:booking/screens/personalDetails/display_name_page.dart';
import 'package:booking/screens/personalDetails/name_page.dart';
import 'package:booking/screens/personalDetails/passport_detail_page.dart';
import 'package:booking/screens/personalDetails/phone_number_page.dart';
import 'package:booking/theam/app_color.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userNameController = Get.find<UserNameController>();
    final userNameController = Get.find<UserNameController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Personal details',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
            Text(
            "We'll remember this info to make it faster when you book.",
            style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          const SizedBox(height: 20),

          Obx(
            () => _buildDetailTile(
              "Name",
              userNameController.firstNameOf.value.isEmpty
                  ? "Enter your name"
                  : "${userNameController.firstNameOf.value} "
                        "${userNameController.lastNameOf.value}",
              () {
                Get.to(() => const NamePage());
              },
            ),
          ),
          Obx(
            () => _buildDetailTile(
              "Gender",
              userNameController.gender.value.isEmpty
                  ? "Select your gender"
                  : userNameController.gender.value,
              () {
                Get.defaultDialog(
                  title: "Select Gender",
                  content: Column(
                    children: [
                      ListTile(
                        title: const Text("Male"),
                        onTap: () {
                          userNameController.gender.value = "Male";
                          Get.back();
                        },
                      ),
                      ListTile(
                        title: const Text("Female"),
                        onTap: () {
                          userNameController.gender.value = "Female";
                          Get.back();
                        },
                      ),
                      ListTile(
                        title: const Text("Other"),
                        onTap: () {
                          userNameController.gender.value = "Other";
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  radius: 6,
                );
              },
            ),
          ),

          Obx(
            () => _buildDetailTile(
              "Date of birth",
              userNameController.dateOfBirth.value.isEmpty
                  ? "Enter your date of birth"
                  : userNameController.dateOfBirth.value,
              () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  String formattedDate =
                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  userNameController.setDateOfBirth(formattedDate);
                }
              },
            ),
          ),

          Obx(
            () => _buildDetailTile(
              "Passport details",
              userNameController.passportNumber.value.isEmpty
                  ? "Not provided"
                  : userNameController.passportNumber.value,
              () {
                Get.to(() => PassportDetailPage());
              },
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Contact details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Properties or providers you book with will use this info if they need to contact you.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Obx(() => _buildEmailTile(userNameController.email.value)),

          Obx(
            () => _buildDetailTile(
              "Phone number",
              userNameController.phoneNumber.value.isEmpty
                  ? " your phone number"
                  : userNameController.phoneCode.value +
                        userNameController.phoneNumber.value,
              () {
                Get.to(() => PhoneNumberPage());
              },
            ),
          ),
          Obx(
            () => _buildDetailTile(
              "Address",
              userNameController.streetName.value.isEmpty
                  ? "Add your address"
                  : userNameController.streetName.value,
              () {
                Get.to(() => AddressPage());
              },
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "How you appear",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "This info will be shown next to reviews you write and any forum posts you make.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final initial = userNameController.firstNameOf.value.isEmpty
                ? "?"
                : userNameController.firstNameOf.value[0].toUpperCase();
            return _buildProfilePictureTile(initial);
          }),

          Obx(
            () => _buildDetailTile(
              "Display name",
              userNameController.displayName.value.isEmpty
                  ? "Choose a display name"
                  : userNameController.displayName.value,
              () {
                Get.to(() => DisplayNamePage());
              },
            ),
          ),

          Obx(
            () => _buildDetailTile(
              "Nationality",
              userNameController.nationality.value.isEmpty
                  ? "Select nationality"
                  : "${userNameController.countryFlage.value} "
                        "  "
                        "${userNameController.nationality.value}",
              () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: false,
                  onSelect: (country) {
                    userNameController.setNationality(
                      country.name,
                      country.flagEmoji,
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
              const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTile(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailTile(
          "Email address",
          email.isEmpty ? "Add email" : email,
          () {},
        ),
        if (email.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: GuzoTheme.primaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "Verified",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildProfilePictureTile(String upperCase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: GuzoTheme.primaryGreen,
            child: Text(
              upperCase,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

