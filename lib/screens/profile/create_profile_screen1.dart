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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Global key for form validation

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
                automaticallyImplyLeading: false,

        title: Text('Create Profile'),
      ),
      body: Column(
        children: <Widget>[
          // The scrollable content above the button
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  PictureWidget(user: user),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Form(
                      key: _formKey, // Pass the form key to FieldWidget
                      child: FieldWidget(user: user, formKey: _formKey), // Pass form key
                    ),
                  ),
                ],
              ),
            ),
          ),
          // The button always stays at the bottom
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                // Trigger validation on button press
                if (_formKey.currentState?.validate() ?? false) {
                  // If form is valid, perform your desired action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Valid!')),
                  );
                } else {
                  // If the form is not valid, show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out the field!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set text color to white
              minimumSize: Size(double.infinity, 50), // Set minimum width to make it full width, and height to 50
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Optional: rounded corners
              ),
            ),
              child: const Text('Submit'),
            ),
          ),
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
  final GlobalKey<FormState> formKey;

  const FieldWidget({super.key, required this.user, required this.formKey});

  @override
  _FieldWidgetState createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  final TextEditingController _testController1 = TextEditingController();
  final TextEditingController _testController2 = TextEditingController();
  final TextEditingController _testController3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _testController1, // Attach controller
                  decoration: const InputDecoration(
                    labelText: "Test 1",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Test 1 is required";
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _testController2, // Attach controller
                  decoration: const InputDecoration(
                    labelText: "Test 2",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Test 2 is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _testController3, // Attach controller
                  decoration: const InputDecoration(
                    labelText: "Test 3",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Test 3 is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Add some spacing between form fields
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _testController1.dispose();
    _testController2.dispose();
    _testController3.dispose();
    super.dispose();
  }
}
