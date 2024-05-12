import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/screens/user_panel/CheckOut-Screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import '../../controllers/Cart-Price-Controller.dart';
import '../../models/Cart-Model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // CART PRICE CONTROLLER
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        title: const Text(
          'Cart Screen..',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error!"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No products Found In The App!!"),
            );
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];

                // model values
                CartModel cartModel = CartModel(
                  returnTime: DateTime.fromMillisecondsSinceEpoch(
                      productData['returnTime'].millisecondsSinceEpoch),
                  productId: productData['productId'],
                  numberOfWeeks: productData['numberOfWeeks'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  rentPrice: productData['rentPrice'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productImages: productData['productImages'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                  productQuantity: productData['productQuantity'],
                  productTotalPrice: productData['productTotalPrice'],
                );

                // Extracting product details from Firestore snapshot
                String productName = productData['productName'];
                double productTotalPrice = productData['productTotalPrice'];
                int productQuantity = productData['productQuantity'];
                int numberOfWeeks = productData['numberOfWeeks'];
                List<String> productImages =
                    List<String>.from(productData['productImages']);

                // CALCULATING PRICE
                productPriceController.fetchProductPrice();

                return SwipeActionCell(
                  key: ObjectKey(cartModel.productId),
                  trailingActions: [
                    SwipeAction(
                      title: "Delete",
                      forceAlignmentToBoundary: true,
                      performsFirstActionWithFullSwipe: true,
                      onTap: (CompletionHandler handler) async {
                        print("Deleted......");

                        await FirebaseFirestore.instance
                            .collection('cart')
                            .doc(user!.uid)
                            .collection('cartOrders')
                            .doc(cartModel.productId)
                            .delete();
                      },
                    ),
                  ],
                  child: Card(
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
                            image: NetworkImage(productImages.isNotEmpty
                                ? productImages[0]
                                : ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            'Total Price: PKR: ${productTotalPrice.toStringAsFixed(2)} ',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (productQuantity > 1) {
                                    double updatedPrice = cartModel.isSale
                                        ? double.parse(cartModel.salePrice)
                                        : double.parse(cartModel.rentPrice);

                                    DateTime returnTime = DateTime.now()
                                        .add(Duration(days: 7 * numberOfWeeks));
                                    await updateCartItem(
                                        productData.id,
                                        productQuantity - 1,
                                        numberOfWeeks,
                                        updatedPrice,
                                        returnTime);
                                  }
                                },
                                child: const CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Text('-',
                                      style: TextStyle(
                                          color: AppConstant.appTextColor)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${productQuantity.toString()} - Quantity",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  double updatedPrice = cartModel.isSale
                                      ? double.parse(cartModel.salePrice)
                                      : double.parse(cartModel.rentPrice);
                                  DateTime returnTime = DateTime.now()
                                      .add(Duration(days: 7 * numberOfWeeks));
                                  await updateCartItem(
                                      productData.id,
                                      productQuantity + 1,
                                      numberOfWeeks,
                                      updatedPrice,
                                      returnTime);
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
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (numberOfWeeks > 1) {
                                    double updatedPrice = cartModel.isSale
                                        ? double.parse(cartModel.salePrice)
                                        : double.parse(cartModel.rentPrice);
                                    DateTime returnTime = DateTime.now().add(
                                        Duration(
                                            days: 7 * (numberOfWeeks - 1)));
                                    await updateCartItem(
                                        productData.id,
                                        productQuantity,
                                        numberOfWeeks - 1,
                                        updatedPrice,
                                        returnTime);
                                  }
                                },
                                child: const CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Text('-',
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
                                  double updatedPrice = cartModel.isSale
                                      ? double.parse(cartModel.salePrice)
                                      : double.parse(cartModel.rentPrice);
                                  DateTime returnTime = DateTime.now().add(
                                      Duration(days: 7 * (numberOfWeeks + 1)));
                                  await updateCartItem(
                                      productData.id,
                                      productQuantity,
                                      numberOfWeeks + 1,
                                      updatedPrice,
                                      returnTime);
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore
      //       .instance.collection('cart')
      //       .doc(user!.uid).collection('cartOrders')
      //       .snapshots(),
      //
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      //     if(snapshot.hasError){
      //       return Center(
      //         child: Text(
      //             "Error!"),
      //       );
      //     }
      //     if(snapshot.connectionState == ConnectionState.waiting){
      //       return Container(
      //         height: Get.height / 5,
      //         child: Center(
      //           child: CupertinoActivityIndicator(),
      //         ),
      //       );
      //     }
      //     if(snapshot.data!.docs.isEmpty){
      //       return Center(
      //         child: Text(
      //             "No products Found In The App!!"),
      //       );
      //     }
      //     if(snapshot.data != null){
      //       return Container(
      //         child: ListView.builder(
      //           itemCount: snapshot.data!.docs.length,
      //           shrinkWrap: true,
      //           physics: BouncingScrollPhysics(),
      //           itemBuilder: (context, index) {
      //             final productData = snapshot.data!.docs[index];
      //
      //             // model values
      //             CartModel cartModel = CartModel(
      //               productId: productData['productId'],
      //               numberOfWeeks: productData['numberOfWeeks'],
      //               categoryId: productData['categoryId'],
      //               productName: productData['productName'],
      //               categoryName: productData['categoryName'],
      //               salePrice: productData['salePrice'],
      //               rentPrice: productData['rentPrice'],
      //               deliveryTime: productData['deliveryTime'],
      //               isSale: productData['isSale'],
      //               productImages: productData['productImages'],
      //               productDescription: productData['productDescription'],
      //               createdAt: productData['createdAt'],
      //               updatedAt: productData['updatedAt'],
      //               productQuantity: productData['productQuantity'],
      //               productTotalPrice: productData['productTotalPrice'],
      //             );
      //
      //
      //             // Extracting product details from Firestore snapshot
      //             String productName = productData['productName'];
      //             double productTotalPrice = productData['productTotalPrice'];
      //             int productQuantity = productData['productQuantity'];
      //             int numberOfWeeks = productData['numberOfWeeks'];
      //             List<String> productImages = List<String>.from(productData['productImages']);
      //
      //             // CALCULATING PRICE
      //             productPriceController.fetchProductPrice();
      //
      //             return SwipeActionCell(
      //               key: ObjectKey(cartModel.productId),
      //               trailingActions: [
      //                 SwipeAction(
      //                   title: "Delete",
      //                   forceAlignmentToBoundary: true,
      //                   performsFirstActionWithFullSwipe: true,
      //                   onTap: (CompletionHandler handler) async{
      //                     print("Deleted......");
      //
      //                     await FirebaseFirestore.instance.collection('cart')
      //                         .doc(user!.uid)
      //                         .collection('cartOrders')
      //                         .doc(cartModel.productId)
      //                         .delete();
      //                   },
      //                 ),
      //               ],
      //
      //               child: Card(
      //                 elevation: 5,
      //                 color: AppConstant.appTextColor,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(15.0),
      //                 ),
      //                 child: ListTile(
      //                   leading: Container(
      //                     width: 80,
      //                     height: 80,
      //                     decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(15.0),
      //                       image: DecorationImage(
      //                         image: NetworkImage(productImages.isNotEmpty ? productImages[0] : ''),
      //                         fit: BoxFit.cover,
      //                       ),
      //                     ),
      //                   ),
      //                   title: Text(
      //                     productName,
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 16.0,
      //                     ),
      //                   ),
      //                   subtitle: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       SizedBox(height: 5),
      //                       Text(
      //                         'Total Price: PKR: ${productTotalPrice.toStringAsFixed(2)} ',
      //                         style: TextStyle(
      //                           fontSize: 14.0,
      //                           color: Colors.grey,
      //                         ),
      //                       ),
      //                       SizedBox(height: 5),
      //                       Row(
      //                         children: [
      //                           GestureDetector(
      //                             onTap: () async {
      //                               if (productQuantity > 1) {
      //                                 double updatedPrice = cartModel.isSale ? double.parse(cartModel.salePrice) : double.parse(cartModel.rentPrice);
      //                                 await FirebaseFirestore.instance
      //                                     .collection('cart')
      //                                     .doc(user!.uid)
      //                                     .collection('cartOrders')
      //                                     .doc(productData.id)
      //                                     .update({
      //                                   "productQuantity": cartModel.productQuantity - 1,
      //                                   "productTotalPrice": updatedPrice * (cartModel.productQuantity - 1), // Adjusted calculation
      //                                 });
      //                               }
      //                             },
      //                             child: const CircleAvatar(
      //                               radius: 14.0,
      //                               backgroundColor: AppConstant.appMainColor,
      //                               child: Text('-', style: TextStyle(color: AppConstant.appTextColor)),
      //                             ),
      //                           ),
      //
      //                           const SizedBox(width: 10),
      //                           Text(
      //                             "${productQuantity.toString()} - Quantity",
      //                             style: const TextStyle(
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: 16.0,
      //                             ),
      //                           ),
      //                           const SizedBox(width: 10),
      //                           GestureDetector(
      //                             onTap: () async {
      //                               if (cartModel.productQuantity > 0) {
      //                                 double updatedPrice = cartModel.isSale ? double.parse(cartModel.salePrice) : double.parse(cartModel.rentPrice);
      //                                 await FirebaseFirestore.instance
      //                                     .collection('cart')
      //                                     .doc(user!.uid)
      //                                     .collection('cartOrders')
      //                                     .doc(cartModel.productId)
      //                                     .update({
      //                                   "productQuantity": cartModel.productQuantity + 1,
      //                                   "productTotalPrice": updatedPrice * (cartModel.productQuantity + 1), // Use sale price if available
      //                                 });
      //                               }
      //                             },
      //                             child: const CircleAvatar(
      //                               radius: 14.0,
      //                               backgroundColor: AppConstant.appMainColor,
      //                               child: Text('+', style: TextStyle(color: AppConstant.appTextColor)),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(height: 10),
      //                       Row(
      //                         children: [
      //                           GestureDetector(
      //                             onTap: () async {
      //                               if (numberOfWeeks > 1) {
      //                                 // int numberOfWeeks = cartModel.numberOfWeeks - 1;
      //                                 double updatedPrice = cartModel.isSale ? double.parse(cartModel.salePrice) : double.parse(cartModel.rentPrice);
      //                                 await FirebaseFirestore.instance
      //                                     .collection('cart')
      //                                     .doc(user!.uid)
      //                                     .collection('cartOrders')
      //                                     .doc(productData.id)
      //                                     .update({
      //                                   "numberOfWeeks": cartModel.numberOfWeeks - 1,
      //                                   "productTotalPrice": updatedPrice * (cartModel.numberOfWeeks - 1),
      //                                   // Adjusted calculation
      //                                 });
      //                               }
      //                             },
      //                             child: const CircleAvatar(
      //                               radius: 14.0,
      //                               backgroundColor: AppConstant.appMainColor,
      //                               child: Text('-', style: TextStyle(color: AppConstant.appTextColor)),
      //                             ),
      //                           ),
      //
      //                           const SizedBox(width: 10),
      //                           Text(
      //                             "${numberOfWeeks.toString()} - Weeks",
      //                             style: const TextStyle(
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: 16.0,
      //                             ),
      //                           ),
      //                           const SizedBox(width: 10),
      //                           GestureDetector(
      //                             onTap: () async {
      //                               if (cartModel.numberOfWeeks > 0) {
      //                                 double updatedPrice = cartModel.isSale ? double.parse(cartModel.salePrice) : double.parse(cartModel.rentPrice);
      //                                 await FirebaseFirestore.instance
      //                                     .collection('cart')
      //                                     .doc(user!.uid)
      //                                     .collection('cartOrders')
      //                                     .doc(cartModel.productId)
      //                                     .update({
      //                                   "numberOfWeeks":  cartModel.numberOfWeeks + 1,
      //                                   "productTotalPrice": updatedPrice * (cartModel.numberOfWeeks + 1),
      //                                 });
      //                               }
      //                             },
      //                             child: const CircleAvatar(
      //                               radius: 14.0,
      //                               backgroundColor: AppConstant.appMainColor,
      //                               child: Text('+', style: TextStyle(color: AppConstant.appTextColor)),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //
      //       );
      //     }
      //
      //     return Container();
      //   },
      // ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "    Total :",
              style: TextStyle(
                  color: AppConstant.appMainColor, fontWeight: FontWeight.bold),
            ),
            Obx(
              () {
                double totalPrice = productPriceController.totalPrice.value;
                return Text(
                  "${totalPrice.toStringAsFixed(1)} : PKR",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.2,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.shopping_cart_checkout_sharp,
                      color: AppConstant.appTextColor,
                    ),
                    label: const Text(
                      'CheckOut!!',
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () {
                      if (productPriceController.totalPrice.value == 0) {
                        Get.snackbar(
                          'Error',
                          'Cart is empty.. Please add some product in cart before checking out..',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appMainColor,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.to(() => const CheckOutScreen());
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateCartItem(String productId, int quantity, int weeks,
      double updatedPrice, DateTime returnTime) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(productId)
        .update({
      "productQuantity": quantity,
      "numberOfWeeks": weeks,
      "productTotalPrice": updatedPrice * quantity * weeks,
      "returnTime": returnTime,
      // Update total price based on both quantity and weeks
    });
  }
}
