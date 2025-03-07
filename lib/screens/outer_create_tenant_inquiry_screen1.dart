import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../PROVIDERS/inquiry_provider.dart';

class OuterCreateTenantInquiryScreen1 extends StatefulWidget {
  final String roomCode;
  final int roomId;
  const OuterCreateTenantInquiryScreen1({
    super.key,
    required this.roomCode,
    required this.roomId,
  });

  @override
  State<OuterCreateTenantInquiryScreen1> createState() =>
      _OuterCreateTenantInquiryScreen1State();
}

class _OuterCreateTenantInquiryScreen1State
    extends State<OuterCreateTenantInquiryScreen1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Validation for Name Field
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // Validation for PH Contact Number
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number is required';
    }
    if (!RegExp(r'^09\d{9}$').hasMatch(value)) {
      return 'Enter a valid PH contact number (09XXXXXXXXX)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make A Room Inquiry"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push content up
          children: [
            Form(
              key: _formKey, // Associate the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Room Code: ${widget.roomCode}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Room ID: ${widget.roomId}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),

                  // Name Input Field
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                  ),
                  SizedBox(height: 20),

                  // Contact Number Input
                  TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validatePhoneNumber,
                  ),
                  SizedBox(height: 20),

                  // Message Box (Multiline Text Field)
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4, // 3-4 rows
                    decoration: InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            // Push button to bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20), // Adjust bottom space
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final inquiryProvider = Provider.of<InquiryProvider>(context, listen: false);
                      inquiryProvider.storeInquiry(
                        context,
                        widget.roomId,
                        _nameController.text,
                        _contactNumberController.text,
                        _messageController.text,
                      );

                      // Debugging prints
                      // print("Inquiry sent to the admin");
                      // print("Name: ${_nameController.text}");
                      // print("Contact number: ${_contactNumberController.text}");
                      // print("Message: ${_messageController.text}");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text("Make an Inquiry"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
