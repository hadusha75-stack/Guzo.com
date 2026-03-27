import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/theam/app_color.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final userNameController = Get.find<UserNameController>();
  final addressController = TextEditingController();
  final townCityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GuzoTheme.primaryGreen,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: GuzoTheme.White,),
        ),
        title: Text("address", style: TextStyle(color: GuzoTheme.White,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Address *",
                style: TextStyle(
                  color: GuzoTheme.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 7),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Your street name and house/apartment number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: GuzoTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: GuzoTheme.primaryGreen,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Town/city *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              TextFormField(
                controller: townCityController,
                decoration: InputDecoration(
                  hintText: "your city",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: GuzoTheme.primaryGreen,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: GuzoTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Zip code *", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              TextFormField(
                controller: zipCodeController,
                decoration: InputDecoration(
                  hintText: "Your zip code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: GuzoTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: GuzoTheme.primaryGreen,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Country/Region",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    onSelect: (country) {
                      countryController.text = country.name;
                    },
                  );
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: countryController,
                    readOnly: true, // combo box behavior
                    decoration: InputDecoration(
                      hintText: "Select your country",
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                      ), // combo box icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: GuzoTheme.primaryGreen,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: GuzoTheme.primaryGreen,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 90),
              Divider(height: 1),
              SizedBox(height: 17),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(4),
                    ),
                    backgroundColor: GuzoTheme.primaryGreen,
                  ),
                  onPressed: () {
                    userNameController.setAddressTownZipCountry(
                      addressController.text,
                      townCityController.text,
                      zipCodeController.text,
                      countryController.text,
                    );
                    Get.back();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: GuzoTheme.White,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
