import 'package:electro_rent/controllers/Google_sign_in_controller.dart';
import 'package:electro_rent/screens/auth_ui/sign_in_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
  Get.put(GoogleSignInController()
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appSecondaryColor,
        title: const Text('Welcome To Electro-Rent',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Lottie.asset('assets/images/splash-icons.json'),),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text("Happy Rental Shopping",
                style: TextStyle(fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: Get.height / 12,
            ),
            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Image.asset("assets/images/final-google-logo.png",
                    width: Get.width / 12,
                    height: Get.height / 12,
                  ),
                  label: const Text('Sign in with Google!',
                    style: TextStyle(
                        color: AppConstant.appTextColor),
                  ),

                  onPressed: () {
                    _googleSignInController.signInWithGoogle();
                  },


                ),
              ),
            ),

            SizedBox(
              height: Get.height / 50,
            ),

            Material(
              child: Container(
                width: Get.width / 1.2,
                height: Get.height / 12,
                decoration: BoxDecoration(
                  color: AppConstant.appSecondaryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton.icon(
                  icon: Icon(
                    Icons.email,
                    color: AppConstant.appTextColor,
                  ),
                  label: Text('Sign in with Gmail!',
                    style: TextStyle(
                        color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    Get.to(()=> const SignInScreen());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
