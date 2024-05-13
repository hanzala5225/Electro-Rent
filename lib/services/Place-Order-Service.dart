import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/screens/user_panel/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/Order-Model.dart';
import '../../services/Generate-Order-ID-Service.dart';
import '../../utils/app_constant.dart';
import '../utils/upload_image_to_firebase.dart';

void placeOrder(
    {required BuildContext context,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required File cnic,
    required String cnicNumber,
    required String customerDeviceToken}) async {
  final user = FirebaseAuth.instance.currentUser;

  EasyLoading.show(status: "Please Wait..");

  if (user != null) {
    try {
      String cnicUrl = await uploadXImage(XFile(cnic.path),
          storageFolderName: 'users-cnic-storage');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        //Order Model
        OrderModel orderModel = OrderModel(
          numberOfWeeks: int.parse(data['numberOfWeeks'].toString()),
          returnTime: DateTime.fromMillisecondsSinceEpoch(
              data['returnTime'].millisecondsSinceEpoch),
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          rentPrice: data['rentPrice'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productImages: data['productImages'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          cnicNumber: cnicNumber,
          cnincImage: cnicUrl,
          customerName: customerName,
          customerPhone: customerPhone,
          customerDeviceToken: customerDeviceToken,
          customerAddress: customerAddress,
        );
        print(orderModel.toMap().toString() + 'dkndfjbvdjfbv');
        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set({
            'uId': user.uid,
            'customerName': customerName,
            'customerPhone': customerPhone,
            'customerAddress': customerAddress,
            'customerDeviceToken': customerDeviceToken,
            'orderStatus': false,
            'createdAt': DateTime.now(),
          });
          // upload Orders...........
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(orderModel.toMap());

          // delete Orders...........

          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(orderModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete Cart Products $orderModel.productId.toString()');
          });
        }
      }
      print("Order Confirmed..!!");
      Get.snackbar(
        "Order Confirmed.!",
        "Thank You For Your Order..",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppConstant.appSecondaryColor,
        colorText: AppConstant.appTextColor,
        borderRadius: 10.0, // Border radius of the snackbar
        margin: EdgeInsets.all(10.0), // Margin around the snackbar
        maxWidth: Get.width - 20.0, // Maximum width of the snackbar
        animationDuration:
            Duration(milliseconds: 500), // Duration of snackbar animation
        duration:
            Duration(seconds: 5), // Duration for which snackbar is visible
        isDismissible: true, // Whether the snackbar can be dismissed by user
        dismissDirection:
            DismissDirection.horizontal, // Dismiss direction of the snackbar
        snackStyle: SnackStyle.FLOATING, // Animation curve of the snackbar
        forwardAnimationCurve:
            Curves.easeOutBack, // Forward animation curve of the snackbar
        reverseAnimationCurve:
            Curves.easeInBack, // Reverse animation curve of the snackbar
        overlayBlur: 2.0, // Blur level of the snackbar overlay
        overlayColor: Colors.black.withOpacity(0.5),
        icon: Icon(Icons.offline_pin_rounded,
            color: Colors.green), // Icon displayed on the snackbar
        shouldIconPulse: true, // Whether the icon should pulse or not
        leftBarIndicatorColor: Colors.green,
      );
      EasyLoading.dismiss();
      Get.offAll(() => MainScreen());
    } catch (e) {
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

void updateOrder(
  OrderModel orderModel,
) {
  FirebaseFirestore.instance
      .collection('orders')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('confirmOrders')
      .where('productId', isEqualTo: orderModel.productId)
      .get()
      .then((value) {
    for (var element in value.docs) {
      print(orderModel.numberOfWeeks);
      element.reference.update(orderModel.toMap());
    }
  });
}
