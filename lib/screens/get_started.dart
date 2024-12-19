import 'package:flutter/material.dart';
import 'auth/register.dart';

class GetstartedScreen extends StatefulWidget {
  @override
  GetStartedScreenState createState() => GetStartedScreenState();
}

class GetStartedScreenState extends State<GetstartedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Background color
      body: Center( // Using Center widget to center the entire content
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: <Widget>[
              _buildWelcomeText(),
              SizedBox(height: 20),
              _buildSubtitle(),
              SizedBox(height: 40),
              _buildGetStartedButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Welcome text
  Widget _buildWelcomeText() {
    return Text(
      "Welcome To Rent Realm:!",
      style: TextStyle(
        fontSize: 32,
        color: Colors.white,
      ),
    );
  }

  // Subtitle text
  Widget _buildSubtitle() {
    return Text(
      "Your journey starts here. Get started with a few simple steps.",
      style: TextStyle(
        fontSize: 18,
        color: Colors.white70,
      ),
    );
  }

  // Button to navigate to register screen
  Widget _buildGetStartedButton() {
    return ElevatedButton(
      onPressed: () => _redirectToRegister(),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      child: Text(
        "Get Started",
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
        ),
      ),
    );
  }

  // Method to navigate to RegisterScreen
  Future<void> _redirectToRegister() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }
}
