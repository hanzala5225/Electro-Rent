import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/models/Product-Model.dart';
import 'package:electro_rent/screens/user_panel/Products-Detail-Screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';

class AllSingleCategoryProductScreen extends StatefulWidget {
  String categoryId;
  AllSingleCategoryProductScreen({super.key, required this.categoryId});

  @override
  State<AllSingleCategoryProductScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllSingleCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      iconTheme: IconThemeData(color: AppConstant.appTextColor),
      backgroundColor: AppConstant.appMainColor,
      title: Text('Products', style: TextStyle(color: AppConstant.appTextColor),),
    ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId).get(),
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
                  "No category Found In The App!!"),
            );
          }
          if(snapshot.data != null){
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1.19,
              ), itemBuilder: (context, index){

                final productData = snapshot.data!.docs[index];

              // model values
              ProductModel productModel = ProductModel(
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
              );

              return Row(
                children: [
                  GestureDetector(
                  onTap: () => Get.to(() => ProductDetailsScreen(productModel: productModel),),
                    child: Padding(padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 2.3,
                          heightImage: Get.height / 10,
                          imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),
                          title: Center(
                            child: Text(
                              productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
