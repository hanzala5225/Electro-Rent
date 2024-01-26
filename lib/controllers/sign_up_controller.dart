import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for password visibility

var isPasswordVisible = false.obs;

Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,
    String userDeviceToken,

    ) async {
  try{} on FirebaseAuthException catch(e) {
    Get.snackbar(
        "Error",
        "$e",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppConstant.appSecondaryColor,
    );
  }
}
}