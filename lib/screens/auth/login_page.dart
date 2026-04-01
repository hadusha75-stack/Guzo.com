import 'package:booking/controllers/login_controller.dart';
import 'package:booking/controllers/user_name_controller.dart';
import 'package:booking/main_screen.dart';
import 'package:booking/theam/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());
  final userNameController = Get.find<UserNameController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Guzo.com",
          style: TextStyle(
            color: GuzoTheme.White,
            fontSize: 33,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        backgroundColor: GuzoTheme.primaryGreen,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Enter your email address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We'll use this to sign you in or create an account if you don't have one yet",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 30),
              const Text(
                "Email address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 70,
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: GuzoTheme.primaryGreen),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: GuzoTheme.primaryGreen,
                        width: 2,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "Enter your email address",
                    border: OutlineInputBorder(),
                  ),
                  validator: controller.validateEmail,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextFormField(
                  controller: passwordController,
                  obscureText: controller.obscurePassword.value,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: GuzoTheme.primaryGreen),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: GuzoTheme.primaryGreen,
                        width: 2,
                      ),
                    ),
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                  validator: controller.validatePassword,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final box = GetStorage();

                      box.write('isLoggedIn', true);

                      userNameController.setEmail(emailController.text);
                      Get.offAll(() => const MainScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GuzoTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
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
