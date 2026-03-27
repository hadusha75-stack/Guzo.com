import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/theam/app_color.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final userNameController = Get.find<UserNameController>();
  final phoneNumberController = TextEditingController();
  final phoneNumberInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load existing phone number if available
    phoneNumberInputController.text = userNameController.phoneNumber.value;
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    phoneNumberInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: GuzoTheme.White,
          ),
        ),
        backgroundColor: GuzoTheme.primaryGreen,
        title: const Text(
          "Phone number",
          style: TextStyle(
            color: GuzoTheme.White,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Phone number *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              Obx(() => Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (country) {
                                userNameController.phoneCode.value = country.phoneCode;
                                userNameController.countryFlage.value = country.flagEmoji;
                              },
                            );
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: phoneNumberController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: userNameController.countryFlage.value.isEmpty
                                    ? "🌍"
                                    : userNameController.countryFlage.value,
                                hintStyle: const TextStyle(fontSize: 24),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: GuzoTheme.primaryGreen,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: GuzoTheme.primaryGreen,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: phoneNumberInputController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              width: 70,
                              alignment: Alignment.center,
                              child: Text(
                                userNameController.phoneCode.value.isEmpty
                                    ? "+1"
                                    : "+${userNameController.phoneCode.value}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            hintText: "Enter phone number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: GuzoTheme.primaryGreen,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: GuzoTheme.primaryGreen,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length < 6) {
                              return 'Phone number is too short';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
              
              const SizedBox(height: 25),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "We'll save this number so you can use it during the booking process.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              const Divider(height: 1),
              const SizedBox(height: 20),
              
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuzoTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (userNameController.phoneCode.value.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please select a country code",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      userNameController.setPhoneNumber(
                        phoneNumberInputController.text,
                      );
                      
                      Get.back();
                      
                      Get.snackbar(
                        "Success",
                        "Phone number saved successfully",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: GuzoTheme.primaryGreen,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: GuzoTheme.White,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
