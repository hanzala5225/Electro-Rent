import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/models/Cart-Model.dart';
import 'package:electro_rent/models/Product-Model.dart';
import 'package:electro_rent/screens/user_panel/Cart-Screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // GETTING CURRENT USER'S  UID
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Product Details..",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Products Images
            SizedBox(height: Get.height / 60,),
            CarouselSlider(
              items: widget.productModel.productImages.map((imageUrls) => ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: imageUrls,
                  fit: BoxFit.cover,
                  width: Get.width - 10,
                  placeholder: (context, url) => ColoredBox(
                    color: Colors.white,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              ).toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 2.5,
                viewportFraction: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    // Widget for displaying product details
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              "Product:  ",
                              style: TextStyle(color: AppConstant.appMainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 29),
                            Text(
                              widget.productModel.productName,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              widget.productModel.isSale && widget.productModel.salePrice.isNotEmpty
                                  ? "Sale Price: "
                                  : "Rent Price: ",
                              style: TextStyle(
                                color: AppConstant.appMainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              widget.productModel.isSale && widget.productModel.salePrice.isNotEmpty
                                  ? widget.productModel.salePrice.toString() + " PKR   per week"
                                  : widget.productModel.rentPrice.toString() + " PKR   per week",
                            ),
                          ],
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              "Category:  ",
                              style: TextStyle(color: AppConstant.appMainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 24),
                            Text(
                              widget.productModel.categoryName,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description:  ",
                              style: TextStyle(color: AppConstant.appMainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8), // Adding some spacing between the bold text and the description
                            Expanded(
                              child: Text(
                                widget.productModel.productDescription,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // WhatsApp Button
                          Material(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              width: Get.width / 2.7,
                              height: Get.height / 16,
                              decoration: BoxDecoration(
                                color: AppConstant.appSecondaryColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton.icon(
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: AppConstant.appTextColor,
                                ),
                                label: Text(
                                  'Whatsapp!',
                                  style: TextStyle(color: AppConstant.appTextColor),
                                ),
                                onPressed: () {
                                  sendMessageOnWhatsapp(
                                    productModel: widget.productModel,
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 13.0,),

                          // Add to Cart Button
                          Material(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              width: Get.width / 2.7,
                              height: Get.height / 16,
                              decoration: BoxDecoration(
                                color: AppConstant.appSecondaryColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton.icon(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  color: AppConstant.appTextColor,
                                ),
                                label: Text(
                                  'Add To Cart',
                                  style: TextStyle(color: AppConstant.appTextColor),
                                ),
                                onPressed: () async {
                                  // Get.to(()=> const SignInScreen());
                                  await checkProductExistence(uId: user!.uid);
                                  showAddToCartMessage();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  static Future<void> sendMessageOnWhatsapp({
    required ProductModel productModel,
  }) async {
    final number = "+923185673831";
    final message =
        "Hello *Electro-Rent* \n\n"
        "I want to rent this product \n\n"
        "*Product Name:* ${productModel.productName} \n"
        "*Product ID:* ${productModel.productId} \n\n"
        "Kindly give me details of it and what procedures do I have to follow \n\n"
        "*Thank You!!*";

    final url = "https://wa.me/$number?text=${Uri.encodeComponent(message)}";
    
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Could Not Launch $url";
    }
  }

// CHECKING IF PRODUCT EXITS OR NOT....................

  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async{
    final DocumentReference documentReference = FirebaseFirestore
        .instance.collection('cart')
        .doc(uId).collection('cartOrders')
        .doc(widget.productModel.productId.toString()
    );
    DocumentSnapshot snapshot = await documentReference.get();

    if(snapshot.exists){
      int productQuantity = snapshot['productQuantity'];
      int updatedQuantity = productQuantity + quantityIncrement;
      double totalPrice = double.parse(
          widget.productModel.isSale ?
          widget.productModel.salePrice :
          widget.productModel.rentPrice) * updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice,
      });

      print('Product Already Exists In The Cart....');

    }else{
      await FirebaseFirestore
          .instance.collection('cart')
          .doc(uId)
          .set(
          {
            'uId': uId,
            'createdAt': DateTime.now(),
          });

      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        numberOfWeeks: 1,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        rentPrice: widget.productModel.rentPrice,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productImages: widget.productModel.productImages,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale ?
        widget.productModel.salePrice :
        widget.productModel.rentPrice),
      );

      await documentReference.set(cartModel.toMap());

      print('Product Added To The Cart....');
    }
  }

  // FUNCTION TO SHOW ADD TO CART MESSAGE
  void showAddToCartMessage() {
    Get.snackbar(
      'Product Added to Cart', // Title of the snackbar
      'Please Check', // Message of the snackbar
      snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
      backgroundColor: AppConstant.appSecondaryColor, // Background color of the snackbar
      colorText: AppConstant.appTextColor, // Text color of the snackbar
      borderRadius: 10.0, // Border radius of the snackbar
      margin: EdgeInsets.all(10.0), // Margin around the snackbar
      maxWidth: Get.width - 20.0, // Maximum width of the snackbar
      animationDuration: Duration(milliseconds: 500), // Duration of snackbar animation
      duration: Duration(seconds: 3), // Duration for which snackbar is visible
      isDismissible: true, // Whether the snackbar can be dismissed by user
      dismissDirection: DismissDirection.horizontal, // Dismiss direction of the snackbar
      snackStyle: SnackStyle.FLOATING, // Animation curve of the snackbar
      forwardAnimationCurve: Curves.easeOutBack, // Forward animation curve of the snackbar
      reverseAnimationCurve: Curves.easeInBack, // Reverse animation curve of the snackbar
      overlayBlur: 2.0, // Blur level of the snackbar overlay
      overlayColor: Colors.black.withOpacity(0.5), // Color of the snackbar overlay
      icon: Icon(Icons.check_circle_outline, color: Colors.green), // Icon displayed on the snackbar
      shouldIconPulse: true, // Whether the icon should pulse or not
      leftBarIndicatorColor: Colors.green, // Color of the left bar indicator
      mainButton: TextButton( // Main button displayed on the snackbar
        onPressed: () {
          // Action to be performed when main button is pressed
        },
        child: GestureDetector(
          onTap: ()=> Get.to(()=> CartScreen()),
          child: Text(
            'View Cart', // Text of the main button
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Padding of the snackbar
    );
  }
}