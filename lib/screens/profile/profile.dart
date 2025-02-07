import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../PROVIDERS/user_provider.dart';
import '../../PROVIDERS/profile_provider.dart';
import 'UPDATE/edit_user_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../API/rest.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          ProfilePicture(),
          const SizedBox(height: 20),
          ListTiles(),
        ],
      ),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false)
          .loadUserProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileProvider>(context);
    final userController = Provider.of<UserProvider>(context, listen: false);

    String profilePictureUrl =
        profileController.userProfile?.data.profilePictureUrl ??
            "https://www.w3schools.com/w3images/avatar2.png";

    String email = userController.user?.data?.user.email ?? 'No email fetched';
    String address = profileController.userProfile?.data.address != null
        ? '${profileController.userProfile?.data.address.line1}, ${profileController.userProfile?.data.address.line2}, ${profileController.userProfile?.data.address.province}, ${profileController.userProfile?.data.address.country}, ${profileController.userProfile?.data.address.postalCode}'
        : 'No address available';

    File? profilePicture = profileController.image;
    bool isLoading = profileController.isLoading;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            profileController.pickImage(context, ImageSource.camera);
          },
          child: CircleAvatar(
            radius: 100.0,
            backgroundImage: profilePicture != null
                ? FileImage(profilePicture)
                : CachedNetworkImageProvider(profilePictureUrl),
            // : NetworkImage(profilePictureUrl),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator()) // Show loading spinner
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            address,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ListTiles extends StatelessWidget {
  const ListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: const Text('Edit User Data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => EditUserScreen()),
                // );
                // Navigator.of(context).pushNamed('/edituser');

                Navigator.pushNamed(context, '/edituser');
              },
            ),
            const Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: const Text('Edit User Profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editprofile');
              },
            ),
            const Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: const Text('Edit Address'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editaddress');
              },
            ),
            const Divider(),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              title: const Text('Edit Identifications'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/editidentification');
              },
            ),
            const Divider(),
            ListTile(
              textColor: Colors.red,
              iconColor: Colors.red,
              title: const Text('Logout'),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () {
                Provider.of<UserProvider>(context, listen: false)
                    .logoutUser(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
