import 'package:flutter/material.dart';

class reservationDetails extends StatefulWidget {
  const reservationDetails({super.key});

  @override
  State<reservationDetails> createState() => _reservationDetailsState();
}

class _reservationDetailsState extends State<reservationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test reservation Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(

          ),
        ),
      
      ),
    );
  }
}