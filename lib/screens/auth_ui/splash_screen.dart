import 'dart:async';
import 'package:electro_rent/controllers/Get_User_Data_Controller.dart';
import 'package:electro_rent/screens/admin_panel/Admin_Main_Screen.dart';
import 'package:electro_rent/screens/auth_ui/welcome_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../user_panel/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState(){
    super.initState();
  Timer(const Duration(seconds: 6), () {
    loggedIn(context);
  });
  }

  Future<void> loggedIn(BuildContext context) async{
    if(user != null){
      final GetUserDataController getUserDataController = Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if(userData[0]['isAdmin'] == true){
        Get.offAll(() => AdminMainScreen());
      }
      else{
        Get.offAll(() => MainScreen());
      }

    } else{
      Get.to(()=> WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Lottie.asset('assets/images/splash-icons.json'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            width: Get.width,
            alignment: Alignment.center,
            child: Text(AppConstant.appPoweredBy,
            style: const TextStyle(color: AppConstant.appTextColor,
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),),
    );
  }
}