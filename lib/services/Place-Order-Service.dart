import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/app_constant.dart';
import 'Generate-Order-ID-Service.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken
    }) async {
  final user = FirebaseAuth.instance.currentUser;

  try{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders').get();

    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for(var doc in documents){
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

      String orderId = generateOrderId();
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
