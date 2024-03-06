import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
      body: Container(
        child: ListView.builder(
          itemCount: 15,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context,index){
            return Card(
              elevation: 10,
              color: AppConstant.appTextColor,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppConstant.appMainColor,
                  child: Text("H",
                  style: TextStyle(
                      color: AppConstant.appTextColor),
                ),
                ),
                title: Text("Rent out AC as your need"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("500 PKR"),
                  SizedBox(width: Get.width / 3.0,),
                  CircleAvatar(
                    radius: 14.0,
                    backgroundColor: AppConstant.appMainColor,
                    child: Text("-",
                    style: TextStyle(
                        color: AppConstant.appTextColor),
                  ),

                  ),
                  SizedBox(width: Get.width / 20.0,),
                  CircleAvatar(
                    radius: 14.0,
                    backgroundColor: AppConstant.appMainColor,
                    child: Text("+",
                      style: TextStyle(
                          color: AppConstant.appTextColor),
                    ),
                  ),
                ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" Total: ",
              style: TextStyle(fontWeight: FontWeight.bold,
                color: AppConstant.appMainColor),
            ),
            Text(" 12,000 PKR",
            style: TextStyle(fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 17,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.shopping_cart_checkout_sharp,
                      color: AppConstant.appTextColor,
                    ),
                    label: Text('CheckOut!',
                      style: TextStyle(
                          color: AppConstant.appTextColor),
                    ),
                    onPressed: () { },
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
