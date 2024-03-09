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
import '../../controllers/Get-Customer-Device-Token-Controller.dart';
import '../../models/Cart-Model.dart';
import '../../services/Place-Order-Service.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CheckOutScreen> {
  // CART PRICE CONTROLLER
  final ProductPriceController productPriceController = Get.put(ProductPriceController());

  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text('Check Out Screen..',
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
                      showCustomBottomSheet();
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
  void showCustomBottomSheet(){
    Get.bottomSheet(
        Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: "Name: ",
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "Phone: ",
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    height: 55.0,
                    child: TextFormField(
                      controller: addressController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(labelText: "Address: ",
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  onPressed: () async {
                    if (nameController.text != "" &&
                        phoneController.text != '' &&
                        addressController.text != '') {
                      String name = nameController.text.trim();
                      String phone = phoneController.text.trim();
                      String address = addressController.text.trim();

                      String customerToken = await getCustomerDeviceToken();


                      // Place Order Service
                      placeOrder(
                        context: context,
                        customerName: name,
                        customerPhone: phone,
                        customerAddress: address,
                        customerDeviceToken: customerToken,
                      );
                    }
                    else {
                      print("Please Fill all details....");
                    };
                  },

                  child: Text("Place Your Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        elevation:6,
        );
    }
}
