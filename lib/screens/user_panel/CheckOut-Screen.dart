import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
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
import '../../utils/validator.dart';
import '../../widgets/custom_image_picker.dart';
import 'Check-Out_Dialouge-Screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  // CART PRICE CONTROLLER
  final ProductPriceController productPriceController = Get.put(ProductPriceController());

  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController idNumber = TextEditingController();

  File? selectedImage;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    idNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text(
          'Check Out Screen..',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cart').doc(user!.uid).collection('cartOrders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text(
                "Error!",
              ),
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
                "No products Found In The App!!",
              ),
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                "Total :",
                style: TextStyle(color: AppConstant.appMainColor, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              double totalPrice = productPriceController.totalPrice.value;
              return Text(
                "${totalPrice.toStringAsFixed(1)} : PKR",
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }),
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
                      Icons.shopping_bag,
                      color: AppConstant.appTextColor,
                    ),
                    label: Text(
                      'CheckOut!!',
                      style: TextStyle(color: AppConstant.appTextColor),
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

  void showCustomBottomSheet() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Container(
            height: Get.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Place Your Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appMainColor, // Match your app's primary color
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: addressController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: idNumber,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      validator: cnicValidator,
                      decoration: InputDecoration(
                        labelText: "CNIC",
                        labelStyle: TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText(
                                "Add your CNIC image",
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                colors: [
                                  AppConstant.appMainColor,
                                  Colors.purple,
                                  Colors.blue,
                                  Colors.yellow,
                                  Colors.pink,
                                ],
                              ),
                            ],
                            isRepeatingAnimation: true,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Purpose of CNIC Image",
                                    style: TextStyle(color: AppConstant.appMainColor),
                                  ),
                                  content: Text(
                                    "The CNIC image will be used to verify your identity during product delivery for security purposes.",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(color: AppConstant.appMainColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            color: AppConstant.appMainColor,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CommonProfileImage(
                      onTap: () async {
                        var imageFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        File tmpFile = File(imageFile.path);
                        setState(() {
                          selectedImage = tmpFile;
                          print('Path: ${selectedImage?.path}');
                        });
                      },
                      imageFile: selectedImage,
                    ),
                  ),

                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.appMainColor, // Match your app's primary color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            idNumber.text.isEmpty ||
                            selectedImage == null) {
                          Get.snackbar(
                            'Error',
                            'All fields are required.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        } else {
                          String name = nameController.text.trim();
                          String phone = phoneController.text.trim();
                          String address = addressController.text.trim();
                          String id = idNumber.text.trim();
                          String customerToken = await getCustomerDeviceToken();

                          // Place Order Service
                          placeOrder(
                            context: context,
                            customerName: name,
                            customerPhone: phone,
                            customerAddress: address,
                            cnic: selectedImage!,
                            cnicNumber: id,
                            customerDeviceToken: customerToken,
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Place Your Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}
