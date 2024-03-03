import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electro_rent/models/Categories-Model.dart';
import 'package:electro_rent/models/Product-Model.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: FirebaseFirestore.instance.collection('products').where('isSale', isEqualTo: true).get(),
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
            height: Get.height / 4.5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){

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
                    Padding(padding: EdgeInsets.all(5.0),
                      child: Container(
                        child: FillImageCard(
                          borderRadius: 20.0,
                          width: Get.width / 3.5,
                          heightImage: Get.height / 12,
                          imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                          ),
                          title: Center(
                            child: Text(
                              productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ),
                          footer: Row(
                            children: [
                              Text('Rs. ${productModel.salePrice}', style: TextStyle(fontSize: 10.0),
                              ),
                              const SizedBox(width: 2.0,),
                              Text('Rs. ${productModel.rentPrice}', style: TextStyle(
                                  fontSize: 10.0,
                                  color: AppConstant.appSecondaryColor,
                                  decoration: TextDecoration.lineThrough),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
