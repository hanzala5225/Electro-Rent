import 'dart:ffi';

import 'package:electro_rent/controllers/sign_up_controller.dart';
import 'package:electro_rent/screens/auth_ui/sign_in_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {

  // adding signup controller in this screen
  final SignUpController signUpController = Get.put(SignUpController());

  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppConstant.appSecondaryColor,
              centerTitle: true,
              title: const Text("Sign Up..",
                style: TextStyle(
                  color: AppConstant.appTextColor,),
              ),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height / 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text('Wecome To Electro-Rent',
                        style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontWeight: FontWeight.bold, fontSize: 16.0,
                        ),
                      ),
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

                          // giving controller to each field to store data
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

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(

                          // giving controller to each field to store data
                          controller: username,

                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: "User Name!!",
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(

                          // giving controller to each field to store data
                          controller: userPhone,

                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Phone Number!!",
                            prefixIcon: Icon(Icons.phone),
                            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(

                          // giving controller to each field to store data
                          controller: userCity,

                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            hintText: "City!!",
                            prefixIcon: Icon(Icons.location_pin),
                            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(()=> TextFormField(

                          // giving controller to each field to store data
                          controller: userPassword,

                          obscureText: signUpController.isPasswordVisible.value,

                          cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: "Password!!",
                            prefixIcon: Icon(Icons.password),

                            // making icon clickable
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  signUpController.isPasswordVisible.toggle();
                                },
                                child: signUpController.isPasswordVisible.value ?
                                Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)
                            ),


                            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                          child: const Text('SIGN UP',
                            style: TextStyle(
                                color: AppConstant.appTextColor),
                          ),

                          onPressed: () async {
                            String name = username.text.trim();
                            String email = userEmail.text.trim();
                            String phone = userPhone.text.trim();
                            String city = userCity.text.trim();
                            String password = userPassword.text.trim();
                            String userDeviceToken = '';

                            if(name.isEmpty || email.isEmpty || phone.isEmpty || city.isEmpty || phone.isEmpty || password.isEmpty)
                            {
                              Get.snackbar("ERROR", "PLEASE ENTER ALL THE REQUIRED DETAILS...",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                            else{
                              UserCredential? userCredential =
                              await signUpController.signUpMethod(
                                  name,
                                  email,
                                  phone,
                                  city,
                                  password,
                                  userDeviceToken
                              );
                              if(userCredential != null){
                                Get.snackbar("VERIFICATION EMAIL SENT!!", "PLEASE CHECK YOUR EMAIL...",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appSecondaryColor,
                                  colorText: AppConstant.appTextColor,
                                );
                                FirebaseAuth.instance.signOut();
                                Get.offAll(()=> const SignInScreen());
                              }
                            }
                          },

                        ),
                      ),
                    ),

                    SizedBox(
                      height: Get.height / 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                          style: TextStyle(
                              color: AppConstant.appSecondaryColor),
                        ),
                        GestureDetector(
                          onTap: ()=> Get.offAll(() => SignInScreen()),
                          child: const Text("Sign In",
                            style: TextStyle(
                                color: AppConstant.appSecondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],)
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}