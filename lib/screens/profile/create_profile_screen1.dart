import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/controllers/auth_controller.dart';
import 'package:rentealm_flutter/models/user_model.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/user_controller.dart';
class CreateProfileScreen1 extends StatefulWidget{
  
  // CreateProfileScreen1({
  //   required String token,
  //   required int userId,
  // });

  @override
  CreateProfileScreenState1 createState() => CreateProfileScreenState1(); 
}

class CreateProfileScreenState1 extends State<CreateProfileScreen1> {
  @override
  Widget build(BuildContext context) {
  final userController = Provider.of<UserController>(context);
  final user = userController.user; // Fetch the logged-in user

  if (user == null) {
    return Center(child: Text("User is not logged in."));
  }

  print('from main widget: ${user.data?.user.id}');
  print('from main widget: ${user.data?.user.name}');
  print('from main widget: ${user.data?.user.email}');
  print('from main widget: ${user.data?.user.role}');
  print('from main widget: ${user.data?.user.createdAt}');



    
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          PictureWidget(user: user),
          
        ],
      ),
    );
  }
}

class PictureWidget extends StatefulWidget {
  final UserResponse user;

  PictureWidget({required this.user});

  @override
  _PictureWidgetState createState() => _PictureWidgetState();
}

class _PictureWidgetState extends State<PictureWidget> {
  File? _image;

  final picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    
      // Access the ProfileController via Provider
      final profileController = Provider.of<ProfileController>(context, listen: false);

      // Call imageConversion and pass the image
      // await profileController.imageConversion(
      //   context,
      //   "your_token_here", // Replace with actual token
      //   123, // Replace with actual userId
      //   _image!,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("User token: ${widget.user.data?.token??'no user token'}");
    print("User ID: ${widget.user.data?.user.id}");

    return Center( // Center the entire Column
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Vertically center the children
        crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center the children
        children: <Widget>[
          GestureDetector(
            onTap: _pickImage, // Trigger the image picker when tapped
            child: Stack(
              alignment: Alignment.center, // Center the icon inside the CircleAvatar
              children: [
                _image == null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(_image!),
                      ),
                Positioned(
                  // center: 10, // Adjust the position of the icon (you can change this value)
                  child: Icon(
                    Icons.camera_alt,
                    size: 30, // Icon size
                    color: Colors.white, // Icon color
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

 
