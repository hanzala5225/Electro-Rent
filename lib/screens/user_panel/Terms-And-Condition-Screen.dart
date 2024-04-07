import 'package:flutter/material.dart';

import '../../utils/app_constant.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/terms_header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Our E-Commerce App!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please read these terms and conditions carefully before using our app.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _buildTermsSections(),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement action when "Accept" button is pressed
                        },
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.appMainColor,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement action when "Decline" button is pressed
                        },
                        child: Text('Decline'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTermsSection('1. Introduction', 'These Terms and Conditions govern your use of our e-commerce app. By accessing and using the app, you agree to be bound by these terms.'),
        _buildTermsSection('2. Account Registration', 'To access certain features of the app, you may be required to register for an account. You must provide accurate and complete information during the registration process.'),
        _buildTermsSection('3. Purchases', 'All purchases made through the app are subject to our Terms of Sale. Please review our Terms of Sale carefully before making a purchase.'),
        _buildTermsSection('4. User Conduct', 'You agree to use the app in accordance with all applicable laws and regulations. You may not engage in any conduct that restricts or inhibits any other user from using the app.'),
        _buildTermsSection('5. Privacy Policy', 'Your use of the app is also governed by our Privacy Policy. Please review our Privacy Policy to understand how we collect, use, and disclose your information.'),
      ],
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(content),
        ),
      ],
    );
  }
}
