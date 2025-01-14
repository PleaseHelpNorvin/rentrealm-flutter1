import 'package:flutter/material.dart';


class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Redirect to RegisterScreen when button is pressed
            Navigator.pushNamed(context, '/register');
          },
          child: const Text('Go to Register'),
        ),
      ),
    );
  }
}