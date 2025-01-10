import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/components/alert_utils.dart';
import 'package:rentealm_flutter/controllers/auth_controller.dart';

import '../controllers/profile_controller.dart';
import '../controllers/user_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    profileController.loadUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Home Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProfileCardWidget(),
          // GridView without Expanded as GridView takes care of layout itself
          GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              crossAxisSpacing: 1, // Horizontal spacing between grid items
              mainAxisSpacing: 1, // Vertical spacing between grid items
              childAspectRatio:
                  1, // Aspect ratio of grid items (square in this case)
            ),
            itemCount:
                2, // Number of items in the grid (now set to 2 for both cards)
            itemBuilder: (context, index) {
              if (index == 0) {
                return PaymentCardWidget(); // Display PaymentCardWidget at index 0
              } else {
                return RentCardWidget(); // Display RentCardWidget at index 1
              }
            },
            shrinkWrap:
                true, // Makes GridView take only as much space as needed
            physics:
                NeverScrollableScrollPhysics(), // Disable scrolling if needed
          ),
        ],
      ),
    );
  }
}

class ProfileCardWidget extends StatelessWidget {
  void onNavigatetoCreateProfile1(BuildContext context) {
    print("Profile Card Tapped");
    Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final profileController = Provider.of<ProfileController>(context);
    // File? profilePictureFile = profileController.image;
    String profilePictureFile =
        profileController.userProfile?.data.profilePictureUrl ??
            "https://www.w3schools.com/w3images/avatar2.png";

    File? profilePicture = profileController.image;

    print('profilePictureFile: $profilePictureFile');

    // final profilePictureUrl = profilePictureFile != null
    //     ? profilePictureFile.path // Use file path if the File object exists
    //     : "https://www.w3schools.com/w3images/avatar2.png"; // Default profile picture

    final name = userController.user?.data?.user.name ?? "Loading...";
    final email = userController.user?.data?.user.email ?? "Loading...";

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: GestureDetector(
        onTap: () => onNavigatetoCreateProfile1(context), // Handles the tap
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePicture != null
                      ? FileImage(
                          profilePicture!) // Use FileImage if a local file is picked
                      : NetworkImage(profilePictureFile) as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) {
                    print("Failed to load image: $exception");
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
  PaymentCardWidgetState createState() => PaymentCardWidgetState();
}

class PaymentCardWidgetState extends State<PaymentCardWidget> {
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

class RentCardWidget extends StatefulWidget {
  @override
  RentCardWidgetState createState() => RentCardWidgetState();
}

class RentCardWidgetState extends State<RentCardWidget> {
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
