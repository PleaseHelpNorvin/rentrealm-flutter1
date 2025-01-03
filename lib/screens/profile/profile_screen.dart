import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/controllers/profile_controller.dart';
import 'package:rentealm_flutter/controllers/user_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Profile"),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          ProfilePicture(),
          const SizedBox(
              height: 20), // Add space between Profile Picture and ListTiles
          ListTiles(),
        ],
      ),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  @override
  ProfilePictureState createState() => ProfilePictureState();
}

class ProfilePictureState extends State<ProfilePicture> {
  @override
  void initState() {
    super.initState();
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    profileController.loadUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    String profilePictureFile =
        profileController.userProfile?.data.profilePictureUrl ??
            "https://www.w3schools.com/w3images/avatar2.png";
    final userController = Provider.of<UserController>(context, listen: false);
    String email = userController.user?.data?.user.email ?? 'no name fetched';
    File? profilePicture = profileController.image;
    print("ProfilePictureState: ${profilePicture?.path}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print("CircleAvatar tapped!");
            setState(() {
              profileController.pickImage(context, ImageSource.camera);
              profileController.loadUserProfile(context);
            }); // Add your logic here, such as navigation or showing a dialog.
          },
          child: CircleAvatar(
            radius: 100.0, // Set the radius of the circle
            // backgroundImage:
                // NetworkImage(profilePictureFile), // Image from assets
         backgroundImage: profilePicture != null
        ? FileImage(profilePicture) // Use FileImage if a local file is picked
        : NetworkImage(profilePictureFile), 
          ),

        ),
        SizedBox(height: 10), // Space between the image and the text
        Text(
          email, // User's name or any other text you want to display
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ListTiles extends StatefulWidget {
  @override
  ListTilesState createState() => ListTilesState();
}

class ListTilesState extends State<ListTiles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Padding outside the container
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Blue background color
          borderRadius: BorderRadius.circular(8.0), // Optional: rounded corners
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: Text('Edit User Data'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/edituser');
              },
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: Text('Edit User Profile'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editprofile');
              },
            ),
            Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: Text('Edit Address'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editaddress');
              },
            ),

            Divider(), // Adds a divider between items
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: Text('Edit Identifications'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editidentification');
              },
            ),
            Divider(),
            ListTile(
              textColor: Colors.red,
              iconColor: Colors.red,
              title: Text('Logout'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                final userController =
                    Provider.of<UserController>(context, listen: false);
                userController.logoutUser(context); // Pass token here
              },
            ),
          ],
        ),
      ),
    );
  }
}
