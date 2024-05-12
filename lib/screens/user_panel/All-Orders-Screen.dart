import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/services/Place-Order-Service.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../../controllers/Cart-Price-Controller.dart';
import '../../models/Order-Model.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreen();
}

class _AllOrdersScreen extends State<AllOrdersScreen> {
  // CART PRICE CONTROLLER
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  User? user = FirebaseAuth.instance.currentUser;
  int numberOfWeeks = 0;
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        title: const Text(
          'All Orders',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return SizedBox(
          //     height: Get.height / 5,
          //     child: const Center(
          //       child: CupertinoActivityIndicator(),
          //     ),
          //   );
          // }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No orders Found In The App!!"),
            );
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                OrderModel orderModel = OrderModel.fromMap(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                // CALCULATING PRICE
                productPriceController.fetchProductPrice();

                // return SwipeActionCell(
                //   key: ObjectKey(orderModel.productId),
                //   trailingActions: [
                //     SwipeAction(
                //       title: "Delete",
                //       forceAlignmentToBoundary: true,
                //       performsFirstActionWithFullSwipe: true,
                //       onTap: (CompletionHandler handler) async {
                //         if (orderModel.status == true) {
                //           // Order is delivered, allow deletion
                //           await FirebaseFirestore.instance
                //               .collection('cart')
                //               .doc(user!.uid)
                //               .collection('cartOrders')
                //               .doc(orderModel.productId)
                //               .delete();
                //
                //           // Show a message indicating that the order has been deleted
                //           Get.snackbar(
                //             'Order Deleted',
                //             'Order has been deleted from history..',
                //             snackPosition: SnackPosition.BOTTOM,
                //             backgroundColor: Colors.red,
                //             colorText: Colors.white,
                //           );
                //         } else {
                //           Get.snackbar(
                //             'Order Can Not Be Deleted',
                //             'Order can not be deleted until it has been delivered. If you wish to cancel the order kindly contact us on our email..',
                //             snackPosition: SnackPosition.BOTTOM,
                //             backgroundColor: Colors.red,
                //             colorText: Colors.white,
                //           );
                //         }
                //       },
                //     ),
                //   ],
                Timestamp timestamp = orderModel.returnTime;
                DateTime dateTime = timestamp.toDate();
                DateTime now = DateTime.now();
                Duration returnTime = dateTime.difference(now);

                return Card(
                  elevation: 5,
                  color: AppConstant.appTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: NetworkImage(
                              orderModel.productImages[0].toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderModel.status == false
                            ? const SizedBox.shrink()
                            : returnTime.inMinutes == 0
                                ? const Text('Time Over')
                                : SlideCountdown(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    duration: returnTime,
                                    slideDirection: SlideDirection.down,
                                    separator: ":",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                        Text(
                          orderModel.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'Total Price: PKR: ${returnTime.inHours < 24 && totalPrice != 0 ? totalPrice : orderModel.productTotalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 11.0,
                        ),
                        orderModel.status != true
                            ? const Text(
                                "Pending..",
                                style: TextStyle(color: Colors.green),
                              )
                            : const Text(
                                "Delivered.!",
                                style: TextStyle(color: Colors.red),
                              ),
                        // returnTime.inHours < 24
                        //     ?
                        returnTime.inHours < 24
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        if (numberOfWeeks > 0) {
                                          numberOfWeeks--;
                                          final double salePrice =
                                              double.tryParse(orderModel
                                                      .salePrice
                                                      .toString()) ??
                                                  0.0;
                                          final double newPrice =
                                              salePrice + (salePrice * 0.05);

                                          final double price =
                                              newPrice * numberOfWeeks;
                                          totalPrice = price +
                                              orderModel.productTotalPrice;
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: numberOfWeeks > 0
                                          ? AppConstant.appMainColor
                                          : Colors.grey.shade400,
                                      child: const Text('-',
                                          style: TextStyle(
                                              color: AppConstant.appTextColor)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${numberOfWeeks.toString()} - Weeks",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        numberOfWeeks++;
                                        final double salePrice =
                                            double.tryParse(orderModel.salePrice
                                                    .toString()) ??
                                                0.0;
                                        final double newPrice =
                                            salePrice * 0.05 + salePrice;
                                        final double price =
                                            newPrice * numberOfWeeks;
                                        totalPrice = price +
                                            orderModel.productTotalPrice;
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: AppConstant.appMainColor,
                                      child: Text('+',
                                          style: TextStyle(
                                              color: AppConstant.appTextColor)),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 10),
                        returnTime.inHours < 24
                            ? InkWell(
                                onTap: () {
                                  if (numberOfWeeks == 0) {
                                    Get.snackbar(
                                      'Select Weeks',
                                      'Please select the number of weeks to update the order..',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }
                                  DateTime returnTime = DateTime.now().add(
                                      Duration(days: 7 * (numberOfWeeks + 1)));
                                  updateOrder(OrderModel.fromMap({
                                    ...orderModel.toMap(),
                                    'numberOfWeeks': 5,
                                    'returnTime': returnTime,
                                    'productTotalPrice': totalPrice,
                                    'status': false,
                                  }));
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 60),
                                    child: Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: AppConstant.appMainColor,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Update',
                                          style: TextStyle(
                                            color: AppConstant.appTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        // : const SizedBox.shrink()
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
