import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class DeviceTokenController extends GetxController{
  String? deviceToken;

  @override
  void onInit(){
    super.onInit();

    getDeviceToken();
  }

  Future<void> getDeviceToken() async{

    try{
      String? token = await FirebaseMessaging.instance.getToken();

      if(token!=null){
        deviceToken = token;
        print("Token : $deviceToken");
        update();
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
      }
    }
}