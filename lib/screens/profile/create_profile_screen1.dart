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

  print('from profile main widget: ${user.data?.user.id}');
  print('from profile main widget: ${user.data?.user.name}');
  print('from profile main widget: ${user.data?.user.email}');
  print('from profile main widget: ${user.data?.user.role}');
  print('from profile main widget: ${user.data?.user.createdAt}');
  print('from profile main widget: ${user.data?.token}');
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          PictureWidget(user: user),
          FieldWidget(user : user),
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

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    // print("User token: ${widget.user.data?.token??'no user token'}"); 
    print("User ID: ${widget.user.data?.user.id}");

        return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              profileController.pickImage(context, ImageSource.camera);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                profileController.image == null
                  ? CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                    )
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(profileController.image!),
                    ),
                Positioned(
                  child: Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
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

class FieldWidget extends StatefulWidget {
  final UserResponse user;

  const FieldWidget({super.key, required this.user});

  @override
  _FieldWidgetState createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
        ],
      ),
    );
  }
}
