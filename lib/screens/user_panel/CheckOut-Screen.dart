import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import '../../controllers/Cart-Price-Controller.dart';
import '../../controllers/Get-Customer-Device-Token-Controller.dart';
import '../../models/Cart-Model.dart';
import '../../services/Place-Order-Service.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_image_picker.dart';

class CheckOutScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const CheckOutScreen({Key? key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  // CART PRICE CONTROLLER
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

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
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        title: const Text(
          'Check Out Screen..',
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
              child: Text(
                "Error!",
              ),
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
              child: Text(
                "No products Found In The App!!",
              ),
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
                List<String> productImages =
                    List<String>.from(productData['productImages']);

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
                            'Total Price: PKR: ${productTotalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
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
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Total :",
                style: TextStyle(
                    color: AppConstant.appMainColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              double totalPrice = productPriceController.totalPrice.value;
              return Text(
                "${totalPrice.toStringAsFixed(1)} : PKR",
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                    icon: const Icon(
                      Icons.shopping_bag,
                      color: AppConstant.appTextColor,
                    ),
                    label: const Text(
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
        builder:
            (BuildContext context, void Function(void Function()) setState) {
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
                        color: AppConstant
                            .appMainColor, // Match your app's primary color
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: phoneController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: addressController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.streetAddress,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: idNumber,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      validator: cnicValidator,
                      decoration: InputDecoration(
                        labelText: "CNIC",
                        labelStyle:
                            const TextStyle(color: AppConstant.appMainColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstant.appMainColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText(
                                "Add your CNIC image",
                                textStyle: const TextStyle(
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
                                  title: const Text(
                                    "Purpose of CNIC Image",
                                    style: TextStyle(
                                        color: AppConstant.appMainColor),
                                  ),
                                  content: const Text(
                                    "The CNIC image will be used to verify your identity during product delivery for security purposes.",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                            color: AppConstant.appMainColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.info_outline,
                            color: AppConstant.appMainColor,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CommonProfileImage(
                      onTap: () async {
                        // ignore: invalid_use_of_visible_for_testing_member
                        var imageFile = await ImagePicker.platform
                            .getImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        File tmpFile = File(imageFile.path);
                        setState(() {
                          selectedImage = tmpFile;
                        });
                      },
                      imageFile: selectedImage,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant
                            .appMainColor, // Match your app's primary color
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
                            // ignore: use_build_context_synchronously
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
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
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
