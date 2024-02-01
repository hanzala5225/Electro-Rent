import 'package:electro_rent/controllers/Get_User_Data_Controller.dart';
import 'package:electro_rent/controllers/Sign_in_controller.dart';
import 'package:electro_rent/screens/admin_panel/Admin_Main_Screen.dart';
import 'package:electro_rent/screens/auth_ui/Forget_Password_screen.dart';
import 'package:electro_rent/screens/auth_ui/Sign_up_screen.dart';
import 'package:electro_rent/screens/user_panel/main_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController = Get.put(GetUserDataController());

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appSecondaryColor,
            centerTitle: true,
            title: Text("Sign In..",
              style: TextStyle(
                  color: AppConstant.appTextColor,),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                isKeyboardVisible? const Text('Wecome To Electro-Rent'):
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



                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(()=> TextFormField(
                      controller: userPassword,
                      obscureText: signInController.isPasswordVisible.value,
                      cursorColor: AppConstant.appSecondaryColor,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password!!",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            signInController.isPasswordVisible.toggle();
                          },

                            child:signInController.isPasswordVisible.value?
                            const Icon(Icons.visibility_off) :
                            const Icon(Icons.visibility)
                        ),

                        contentPadding: const EdgeInsets.only(top: 2.0, left: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: ()=> Get.to(() => ForgetPasswordScreen()),
                    child: const Text("Forgot Password?",
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                      fontWeight: FontWeight.bold),
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
                      child: const Text('SIGN IN',
                        style: TextStyle(
                            color: AppConstant.appTextColor),
                      ),
                      onPressed: () async{
                        String email = userEmail.text.trim();
                        String password = userPassword.text.trim();

                        if(email.isEmpty || password.isEmpty)
                        {
                          Get.snackbar("ERROR", "PLEASE ENTER ALL THE REQUIRED DETAILS...",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        }
                        else{
                        UserCredential? userCredential =
                        await signInController.signInMethod(
                        email,
                        password,
                        );
                        var userData = await getUserDataController.getUserData(userCredential!.user!.uid);


                        if (userCredential != null){
                          if(userCredential.user!.emailVerified){

                            if(userData[0]['isAdmin'] == true)
                              {
                                Get.offAll(()=> AdminMainScreen());
                                Get.snackbar("SUCCESS ADMIN LOGIN", "LOGIN SUCCESSFULLY...",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appSecondaryColor,
                                  colorText: AppConstant.appTextColor,
                                );
                              } else{
                              Get.offAll(()=> MainScreen());
                              Get.snackbar("SUCCESS USER LOGIN", "LOGIN SUCCESSFULLY...",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                          }
                          else{
                            Get.snackbar("ERROR", "PLEASE VERIFY YOUR EMAIL BEFORE LOGIN...",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appSecondaryColor,
                              colorText: AppConstant.appTextColor,
                            );
                          }
                        }
                        else{
                          Get.snackbar("ERROR", "PLEASE TRY AGAIN...",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        }
                      }
                      },
                    )
                  ),
                ),

                SizedBox(
                  height: Get.height / 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const Text("Dont have an account? ",
                    style: TextStyle(color: AppConstant.appSecondaryColor),
                  ),
                  GestureDetector(
                  onTap: ()=> Get.offAll(() => SignUpScreen()),
                  child: Text("Sign Up",
                    style: TextStyle(color: AppConstant.appSecondaryColor,
                        fontWeight: FontWeight.bold),
                  ),)
                ],)
          ],
            ),
          ),
        );
      }
    );
  }
}

