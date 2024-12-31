import 'package:flutter/material.dart';

class EditAddressScreen extends StatefulWidget {
  @override
  EditAddressScreenState createState() => EditAddressScreenState();
}

class EditAddressScreenState extends State<EditAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Edit Adress"),
      ),
      body: Column(),
    );
  }
}
