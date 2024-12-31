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
      backgroundColor: Colors.blueAccent,
      body: Stack(
        // Use Stack to layer the circles behind the content
        children: <Widget>[
          // Custom painted circles in the background
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: BackgroundPainter(),
          ),
          // Content of the screen (text and button)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildWelcomeText(),
                    SizedBox(height: 20),
                    _buildSubtitle(),
                  ],
                ),
              ),
              Spacer(),
              _buildGetStartedButton(),
              SizedBox(height: 20)
            ],
          ),
        ],
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

// Custom painter to draw the background circles
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.2) // Light color for the circles
      ..style = PaintingStyle.fill;

    // Draw circles at random positions
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 100, paint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 150, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 80, paint);

    // You can add more circles or change their size, opacity, or positions as needed
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // We don't need to repaint for this case
  }
}
