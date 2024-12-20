import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProfileCardWidget(),
          // GridView without Expanded as GridView takes care of layout itself
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0 , 16 , 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 1, // Horizontal spacing between grid items
              mainAxisSpacing: 1, // Vertical spacing between grid items
              childAspectRatio: 1, // Aspect ratio of grid items (square in this case)
            ),
            itemCount: 2, // Number of items in the grid (now set to 2 for both cards)
            itemBuilder: (context, index) {
              if (index == 0) {
                return PaymentCardWidget(); // Display PaymentCardWidget at index 0
              } else {
                return RentCardWidget(); // Display RentCardWidget at index 1
              }
            },
            shrinkWrap: true, // Makes GridView take only as much space as needed
            physics: NeverScrollableScrollPhysics(), // Disable scrolling if needed
          ),
        ],
      ),
    );
  }
}

class ProfileCardWidget extends StatefulWidget {
  @override
  _ProfileCardWidgetState createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  String name = "John Doe";
  String email = "johndoe@example.com";
  String profilePictureUrl =
      "https://www.w3schools.com/w3images/avatar2.png";


  void _onCardTap() {
    print("Profile Card Tapped");
    Navigator.pushNamed(
      context,
      '/creteprofile1'
    );
    // You can add navigation or other logic here
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: GestureDetector(
        onTap: _onCardTap,  // Handles the tap
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profilePictureUrl),
                  onBackgroundImageError: (exception, stackTrace) {
                    print("Failed to load image");
                  },
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(email),
                    SizedBox(height: 10),
                    Text("Bio or Additional Info"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCardWidget extends StatefulWidget {
  @override
  _PaymentCardWidgetState createState() => _PaymentCardWidgetState();
}

class _PaymentCardWidgetState extends State<PaymentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Payment Card Widget Tapped");
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.payment,
                size: 40,
                color: Colors.green,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class RentCardWidget extends StatefulWidget {
  @override
  _RentCardWidgetState createState() => _RentCardWidgetState();
}

class _RentCardWidgetState extends State<RentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Rent Card Widget Tapped");
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.home,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
