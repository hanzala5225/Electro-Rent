import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:electro_rent/screens/user_panel/All-Categories-Screen.dart';
import 'package:electro_rent/screens/user_panel/All-Flash-Sale-Products-Screen.dart';
import 'package:electro_rent/screens/user_panel/Cart-Screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:electro_rent/widgets/Banners.dart';
import 'package:electro_rent/widgets/Custom_Drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/All-Products-Widget.dart';
import '../../widgets/Categories-Widget.dart';
import '../../widgets/Flash-Sale-Widget.dart';
import '../../widgets/Heading-Widget.dart';
import 'All-Products-Screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        centerTitle: true,
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
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: Get.height / 90.0,),
              BannerWidget(),
              HeadingWidget(
                headingTitle: "CATEGORIES..",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See More >",
              ),
              CategoriesWidget(),
              HeadingWidget(
                headingTitle: "FLASH SALE..",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllFlashSaleProductsScreen()),
                buttonText: "See More >",
              ),
              FlashSaleWidget(),
              HeadingWidget(
                headingTitle: "POPULAR PRODUCTS..",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttonText: "See More >",
              ),
              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
