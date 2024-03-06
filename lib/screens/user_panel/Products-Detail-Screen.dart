import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:electro_rent/models/Product-Model.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      backgroundColor: AppConstant.appMainColor,
        title: Text("Product Details..",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
    ),
      body: Container(
        child: Column(
          children: [

            // Products Images
            SizedBox(height: Get.height / 60,),
        CarouselSlider(
        items: widget.productModel.productImages
            .map((imageUrls) => ClipRRect(borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: imageUrls,
              fit: BoxFit.cover,
              width: Get.width - 10,
              placeholder: (context,url) => ColoredBox(
              color: Colors.white,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
              ),
              errorWidget: (
                  context, url, error)=> Icon(Icons.error),
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
            Padding(padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                ),
                  child: Column(
                    children: [
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
                                    ? widget.productModel.salePrice.toString() + " PKR"
                                    : widget.productModel.rentPrice.toString() + " PKR",
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
                            Material(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: Get.width / 2.8,
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
                                  label: Text('Whatsapp!',
                                    style: TextStyle(
                                        color: AppConstant.appTextColor),
                                  ),
                                  onPressed: () {
                                    // Get.to(()=> const SignInScreen());
                                  },
                                ),
                              ),
                            ),

                            SizedBox(width: 20.0,),

                            //whatsapp Button
                            Material(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                width: Get.width / 2.8,
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
                                  label: Text('Add To Cart!',
                                    style: TextStyle(
                                        color: AppConstant.appTextColor),
                                  ),
                                  onPressed: () {
                                    // Get.to(()=> const SignInScreen());
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
}
