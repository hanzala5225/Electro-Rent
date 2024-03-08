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
  final ProductPriceController productPriceController = Get.put(ProductPriceController());

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          iconTheme: IconThemeData(color: AppConstant.appTextColor),
          title: Text('Cart Screen..',
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore
              .instance.collection('cart')
              .doc(user!.uid).collection('cartOrders')
              .snapshots(),

          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text(
                    "Error!"),
              );
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            if(snapshot.data!.docs.isEmpty){
              return Center(
                child: Text(
                    "No products Found In The App!!"),
              );
            }
            if(snapshot.data != null){
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];

                    // model values
                    CartModel cartModel = CartModel(
                      productId: productData['productId'],
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
                    List<String> productImages = List<String>.from(productData['productImages']);

                    // CALCULATING PRICE
                    productPriceController.fetchProductPrice();

                    return SwipeActionCell(
                      key: ObjectKey(cartModel.productId),
                      trailingActions: [
                        SwipeAction(
                          title: "Delete",
                          forceAlignmentToBoundary: true,
                          performsFirstActionWithFullSwipe: true,
                          onTap: (CompletionHandler handler) async{
                            print("Deleted......");

                            await FirebaseFirestore.instance.collection('cart')
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
                                image: NetworkImage(productImages.isNotEmpty ? productImages[0] : ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            productName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                'Total Price: PKR: ${productTotalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
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
                                        double updatedPrice = cartModel.isSale ? double.parse(cartModel.salePrice) : double.parse(cartModel.rentPrice);
                                        await FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrders')
                                            .doc(productData.id)
                                            .update({
                                          "productQuantity": cartModel.productQuantity - 1,
                                          "productTotalPrice": updatedPrice * (cartModel.productQuantity - 1), // Adjusted calculation
                                        });
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: AppConstant.appMainColor,
                                      child: Text('-', style: TextStyle(color: AppConstant.appTextColor)),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Text(
                                    productQuantity.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      if (cartModel.productQuantity > 0) {
                                        double updatedPrice = cartModel.isSale ? double.parse(cartModel.salePrice) : double.parse(cartModel.rentPrice);
                                        await FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrders')
                                            .doc(cartModel.productId)
                                            .update({
                                          "productQuantity": cartModel.productQuantity + 1,
                                          "productTotalPrice": updatedPrice * (cartModel.productQuantity + 1), // Use sale price if available
                                        });
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: AppConstant.appMainColor,
                                      child: Text('+', style: TextStyle(color: AppConstant.appTextColor)),
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
                ),

              );
            }

            return Container();
          },
        ),
        bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("    Total :", style: TextStyle(
                    color: AppConstant.appMainColor,
                    fontWeight: FontWeight.bold),
                ),
                Obx(() {
                  double totalPrice = productPriceController.totalPrice.value;
                  return Text(
                    "${totalPrice.toStringAsFixed(1)} : PKR",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                        icon: Icon(
                          Icons.shopping_cart_checkout_sharp,
                          color: AppConstant.appTextColor,
                        ),
                        label: Text('CheckOut!!',
                          style: TextStyle(
                              color: AppConstant.appTextColor),
                        ),
                        onPressed: () {
                          Get.to(()=> CheckOutScreen());
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
}