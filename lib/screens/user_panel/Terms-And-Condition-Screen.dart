import 'package:flutter/material.dart';

import '../../utils/app_constant.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        title: Text('Terms And Conditions..',
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                color: AppConstant.appMainColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTermsSection('Introduction', 'These Terms and Conditions govern your use of our e-commerce app. By accessing and using the app, you agree to be bound by these terms.'),
            _buildTermsSection('Account Registration', 'To access certain features of the app, you may be required to register for an account. You must provide accurate and complete information during the registration process.'),
            _buildTermsSection('Purchases', 'All purchases made through the app are subject to our Terms of Sale. Please review our Terms of Sale carefully before making a purchase.'),
            _buildTermsSection('User Conduct', 'You agree to use the app in accordance with all applicable laws and regulations. You may not engage in any conduct that restricts or inhibits any other user from using the app.'),
            _buildTermsSection('Privacy Policy', 'Your use of the app is also governed by our Privacy Policy. Please review our Privacy Policy to understand how we collect, use, and disclose your information.'),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 14,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            content,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
