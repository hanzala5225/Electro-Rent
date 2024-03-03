import 'package:electro_rent/screens/user_panel/All-Categories-Screen.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:electro_rent/widgets/Banners.dart';
import 'package:electro_rent/widgets/Custom_Drawer.dart';
import 'package:electro_rent/widgets/Heading-Widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/Categories-Widget.dart';
import '../../widgets/Flash-Sale-Widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName, style: const TextStyle(color: AppConstant.appTextColor),),
        centerTitle: true,
      ),

      // calling Drawer Widget
      drawer: const DrawerWidget(),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
          SizedBox(height: Get.height / 90.0,),

              // calling banners Widget
              BannerWidget(),

              // calling heading Widget
              HeadingWidget(
                headingTitle: "Categories..",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See More >",
              ),

          // calling categories Widget
              CategoriesWidget(),

              HeadingWidget(
                headingTitle: "Flash Sale..",
                headingSubTitle: "According to your budget",
                onTap: () {},
                buttonText: "See More >",
              ),

          // calling flash-sale Widget
              FlashSaleWidget(),
        ],
          ),
        ),
      ),
    );
  }
}
