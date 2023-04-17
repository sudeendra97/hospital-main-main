import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hospital/modular/modular_methods.dart';
import 'package:hospital/screens/home_page.dart';
import 'package:hospital/screens/sign_up.dart';

import '../constants/app_constants.dart';
import '../providers/api_calls.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});

  static const routeName = '/LogInPage';

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ApiCalls calls = Get.find();
    return GestureDetector(
      onTap: () {
        ModularMethods.removeFocus(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hospital Management'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                textField(userNameController, size, 'User Name'),
                textField(passwordController, size, 'Password'),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: () {
                      EasyLoading.show();
                      calls.logIn(AppConstants.logIn, {
                        "username": userNameController.text,
                        "password": passwordController.text,
                      }).then((value) {
                        EasyLoading.dismiss();
                        if (value == 200 || value == 201) {
                          Get.snackbar('', 'Successfully signed up');
                          Get.offAndToNamed(HomePage.routeName);
                        }
                      });
                    },
                    child: const Text('Submit'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Or',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Get.toNamed(SignUpPage.routeName);
                    },
                    child: const Text('Sign Up'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, Size size, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width * 0.8,
          height: 40,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20),
              hintText: name,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ),
    );
  }
}
