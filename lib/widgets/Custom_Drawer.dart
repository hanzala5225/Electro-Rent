import 'package:electro_rent/screens/auth_ui/welcome_screen.dart';
import 'package:electro_rent/screens/user_panel/All-Orders-Screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/user_panel/Contact-Us-Screen.dart';
import '../screens/user_panel/Terms-And-Condition-Screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )
        ),

        child: Wrap(
          runSpacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Hanzala', style: TextStyle(color: AppConstant.appTextColor),),
                subtitle: Text('Version: 1.0.1', style: TextStyle(color: AppConstant.appTextColor),),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: AppConstant.appMainColor,
                  child: Text('H', style: TextStyle(color: AppConstant.appTextColor),),
                ),
              ),
            ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Home', style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.home, color: AppConstant.appTextColor),
                trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Products', style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.production_quantity_limits, color: AppConstant.appTextColor),
                trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Orders', style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.shopping_bag, color: AppConstant.appTextColor),
                trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                onTap: (){
                  Get.back();
                  Get.to(()=> AllOrdersScreen());
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Contact Us', style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.help, color: AppConstant.appTextColor),
                trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                onTap: (){
                  Get.back();
                  Get.to(()=> ContactUsScreen());
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Terms And Conditions', style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.gavel_outlined, color: AppConstant.appTextColor),
                trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
                onTap: (){
                  Get.back();
                  Get.to(()=> TermsAndConditionsScreen());
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0),
              child: ListTile(
                onTap: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  await googleSignIn.signOut();
                  Get.offAll(()=> WelcomeScreen()
                  );
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Logout', style: TextStyle(color: AppConstant.appTextColor),),
                leading: Icon(Icons.logout, color: AppConstant.appTextColor),
                trailing: Icon(Icons.arrow_forward, color: AppConstant.appTextColor),
              ),
            ),
          ],
        ),
        backgroundColor: AppConstant.appSecondaryColor,
      ),
    );
  }
}
