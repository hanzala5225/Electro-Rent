import 'package:electro_rent/controllers/Google_sign_in_controller.dart';
import 'package:electro_rent/screens/auth_ui/welcome_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              await googleSignIn.signOut();

              Get.offAll(()=> WelcomeScreen());
            },

            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.logout),
            ),
          )
        ],

      ),
    );
  }
}
