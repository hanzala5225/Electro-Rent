import 'package:electro_rent/firebase_options.dart';
import 'package:electro_rent/screens/auth_ui/Sign_up_screen.dart';
import 'package:electro_rent/screens/auth_ui/sign_in_screen.dart';
import 'package:electro_rent/screens/auth_ui/splash_screen.dart';
import 'package:electro_rent/screens/auth_ui/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'screens/user_panel/main_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Electro Rent',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

