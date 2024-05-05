import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:electro_rent/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubTitle;
  final VoidCallback onTap;
  final String buttonText;
  final bool animateSubtitle;
  final Color titleColor;

  const HeadingWidget({
    required this.headingTitle,
    required this.headingSubTitle,
    required this.onTap,
    required this.buttonText,
    this.animateSubtitle = false,
    this.titleColor = AppConstant.appMainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: 200, // Adjust the width as needed
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          headingSubTitle,
                          colors: [
                            Colors.red,
                            Colors.yellow,
                            Colors.pink,
                            Colors.blue,
                            Colors.green,
                            Colors.purple,
                          ],
                          textStyle: TextStyle(fontSize: 12.0),
                          textAlign: TextAlign.start,
                        ),
                      ],
                      repeatForever: true,
                      totalRepeatCount: 3,
                      pause: const Duration(milliseconds: 100),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: AppConstant.appSecondaryColor,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    color: AppConstant.appSecondaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
