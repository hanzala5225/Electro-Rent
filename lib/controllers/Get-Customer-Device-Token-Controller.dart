import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../utils/app_constant.dart';

Future<String> getCustomerDeviceToken() async{
  try{
    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      return token;
    }
    else{
      throw Exception("Error!");
    }
  }
      catch(e){
        Get.snackbar(
          "Error",
          "$e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appSecondaryColor,
          colorText: AppConstant.appTextColor,
        );
        throw Exception("Error!");
      }
}
