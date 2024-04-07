import 'package:flutter/material.dart';
import '../../utils/app_constant.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
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
                  image: AssetImage('assets/images/contact_us_header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ContactInfoItem(
                    icon: Icons.email,
                    label: 'Email',
                    value: 'contact@example.com',
                    onTap: () => _sendEmail('contact@example.com'),
                  ),
                  ContactInfoItem(
                    icon: Icons.phone,
                    label: 'Phone',
                    value: '+1 (123) 456-7890',
                    onTap: () => _makePhoneCall('+11234567890'),
                  ),
                  ContactInfoItem(
                    icon: Icons.location_on,
                    label: 'Address',
                    value: '123 Main St, City, Country',
                    onTap: () => _openMap('123 Main St, City, Country'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Contact Form',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ContactForm(),
                  SizedBox(height: 20),
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: Placeholder(), // Replace Placeholder with Google Maps widget or your preferred map widget
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail(String email) {
    // Implement email sending functionality
  }

  void _makePhoneCall(String phoneNumber) {
    // Implement phone call functionality
  }

  void _openMap(String address) {
    // Implement opening map functionality
  }
}

class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const ContactInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _messageController,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Message'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _submitForm(),
          child: Text('Submit'),
        ),
      ],
    );
  }

  void _submitForm() {
    // Implement form submission logic
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;
    // Perform validation and submit the form
  }
}
