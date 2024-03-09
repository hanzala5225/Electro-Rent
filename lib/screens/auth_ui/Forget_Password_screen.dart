import 'package:electro_rent/controllers/Forget_Password_controller.dart';
import 'package:electro_rent/screens/auth_ui/Sign_up_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());

  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible){
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: AppConstant.appTextColor),
              backgroundColor: AppConstant.appSecondaryColor,
              centerTitle: true,
              title: const Text("Foget Password",
                style: TextStyle(
                  color: AppConstant.appTextColor,),
              ),
            ),

            body: Container(
              child: Column(
                children: [
                  isKeyboardVisible? const Text('Please Enter Your Email...'):
                  Column(children: [
                    Lottie.asset('assets/images/splash-icons.json'),
                  ],
                  ),

                  SizedBox(
                    height: Get.height / 20,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: userEmail,
                        cursorColor: AppConstant.appSecondaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email Address!!",
                          prefixIcon: Icon(Icons.email),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: Get.height / 20,
                  ),

                  Material(
                    child: Container(
                        width: Get.width / 2,
                        height: Get.height / 18,
                        decoration: BoxDecoration(
                          color: AppConstant.appSecondaryColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextButton(
                          child: const Text('FORGET',
                            style: TextStyle(
                                color: AppConstant.appTextColor),
                          ),
                          onPressed: () async{
                            String email = userEmail.text.trim();

                            if(email.isEmpty)
                            {
                              Get.snackbar("ERROR", "PLEASE ENTER ALL THE REQUIRED DETAILS...",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                            else{
                              String email = userEmail.text.trim();
                              forgetPasswordController.ForgetPasswordMethod(email);
                            }
                          },
                        )
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }
}

