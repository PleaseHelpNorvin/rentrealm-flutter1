import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity, // Make sure it takes full width
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: const [
              Text(
                "✅", // Large emoji
                style: TextStyle(fontSize: 100),
              ),
              SizedBox(height: 20),
              Text(
                "Success!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Your payment was processed successfully.",
                textAlign: TextAlign.center, // Ensure text is centered
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.blue, width: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3)),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/'); // Go back to previous screen
          },
          child: const Text("Go Back"),
        ),
      ),
    );
  }
}