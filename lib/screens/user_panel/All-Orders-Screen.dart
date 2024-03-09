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
import '../../models/Order-Model.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreen();
}

class _AllOrdersScreen extends State<AllOrdersScreen> {
  // CART PRICE CONTROLLER
  final ProductPriceController productPriceController = Get.put(ProductPriceController());

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text('All Orders',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore
            .instance.collection('orders')
            .doc(user!.uid).collection('confirmOrders')
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
                  "No orders Found In The App!!"),
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
                  OrderModel orderModel = OrderModel(
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
                    createdAt: DateTime.now(),
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(productData['productTotalPrice'].toString(),),
                    customerId: productData['customerId'],
                    status: productData['status'],
                    customerName: productData['customerName'],
                    customerPhone: productData['customerPhone'],
                    customerDeviceToken: productData['customerDeviceToken'],
                    customerAddress: productData['customerAddress'],
                  );

                  // Extracting product details from Firestore snapshot
                  String productName = productData['productName'];
                  double productTotalPrice = productData['productTotalPrice'];
                  int productQuantity = productData['productQuantity'];
                  List<String> productImages = List<String>.from(productData['productImages']);

                  // CALCULATING PRICE
                  productPriceController.fetchProductPrice();

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
                          SizedBox(width: 11.0,),

                          orderModel.status != true?
                          Text("Pending..", style: TextStyle(color: Colors.green),):
                          Text("Delivered.!", style: TextStyle(color: Colors.red),)
                        ],
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
    );
  }
}