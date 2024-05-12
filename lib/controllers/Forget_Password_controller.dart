import 'package:electro_rent/screens/auth_ui/sign_in_screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> forgetPasswordMethod(
    String userEmail,
  ) async {
    try {
      EasyLoading.show(status: "Please Wait..");

      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
        "REQUEST SENT SUCCESSFULLY...",
        "PASSWORD RESET LINK SENT TO $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor,
      );

      Get.offAll(() => const SignInScreen());

      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();

      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor,
      );
    }
  }
}
