// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/user_provider.dart';
// import 'package:rentealm_flutter/MODELS/user_model.dart';

import '../../../PROVIDERS/auth_provider.dart';
import '../../../PROVIDERS/profile_provider.dart';

import 'create_profile_screen2.dart';

class CreateProfileScreen1 extends StatefulWidget {
  @override
  CreateProfileScreenState1 createState() => CreateProfileScreenState1();
}

class CreateProfileScreenState1 extends State<CreateProfileScreen1> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Global key for form validation
  final TextEditingController _phoneNumberController =
      TextEditingController(text: "09454365069");
  final TextEditingController _socialMediaLinkController =
      TextEditingController(text: "Norvin S Crujido - Facebook");
  final TextEditingController _occupationController =
      TextEditingController(text: "Developer");

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.userId;
    final userToken = authProvider.token;

    if (userToken == null || userId == null) {
      return Center(child: Text("User is not logged in."));
    }

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   title: Text('Create Profile'),
      // ),
      body: Column(
        children: <Widget>[
          // The scrollable content above the button
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  PictureWidget(userId: userId, userToken: userToken),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Form(
                      key: _formKey, // Pass the form key to FieldWidget
                      child: FieldWidget(
                        userId: userId,
                        userToken: userToken,
                        formKey: _formKey,
                        phoneNumberController: _phoneNumberController,
                        socialMediaLinkController: _socialMediaLinkController,
                        occupationController: _occupationController,
                      ), // Pass form key
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
                  String phoneNumber = _phoneNumberController.text;
                  String socialMediaLink = _socialMediaLinkController.text;
                  String occupation = _occupationController.text;

                  print("Social Media Link: $socialMediaLink");
                  print("Phone number: $phoneNumber");
                  print("Occupation: $occupation");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProfileScreen2(
                        userId: userId,
                        userToken: userToken,
                        phoneNumberController: phoneNumber,
                        socialMediaLinkController: socialMediaLink,
                        occupationController: occupation,
                      ),
                    ),
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Valid!')),
                  // );
                } else {
                  // If the form is not valid, show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill out the field!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Set text color to white
                minimumSize: Size(double.infinity,
                    50), // Set minimum width to make it full width, and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class PictureWidget extends StatefulWidget {
  final String userToken;
  final int userId;
  PictureWidget({
    required this.userToken,
    required this.userId,
  });

  @override
  _PictureWidgetState createState() => _PictureWidgetState();
}

class _PictureWidgetState extends State<PictureWidget> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    // print("User token: ${widget.user.data?.token??'no user token'}");
    print("User ID: ${widget.userId}");
    print("user TOKEN: ${widget.userId}");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              profileProvider.pickImage(context, ImageSource.camera);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                profileProvider.image == null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage('assets/images/profile_placeholder.png'),
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(profileProvider.image!),
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
  final String userToken;
  final int userId;
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneNumberController;
  final TextEditingController socialMediaLinkController;
  final TextEditingController occupationController;

  const FieldWidget({
    super.key,
    required this.userToken,
    required this.userId,
    required this.formKey,
    required this.phoneNumberController,
    required this.socialMediaLinkController,
    required this.occupationController,
  });

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                    controller:
                        widget.phoneNumberController, // Attach controller
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      hintText: "ex: 09454365069",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required";
                      }

                      // Remove any spaces or non-numeric characters
                      String cleanedValue = value.replaceAll(RegExp(r'\D'), '');

                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return "Phone number must only contain numeric characters";
                      }

                      // Check if it's the right length (11 digits without country code, 13 with country code)
                      if (cleanedValue.length != 11 &&
                          cleanedValue.length != 13) {
                        return "Phone number must be 11 digits (local) or 13 digits (with +63 country code)";
                      }

                      // Check if the phone number starts with +63 or 09
                      if (!(cleanedValue.startsWith('09') ||
                          cleanedValue.startsWith('63'))) {
                        return "Phone number must start with '09' or '+63' for the Philippines";
                      }

                      // If valid, return null
                      return null;
                    }),
                SizedBox(height: 20),
                TextFormField(
                  controller:
                      widget.socialMediaLinkController, // Attach controller
                  decoration: const InputDecoration(
                    labelText: "Social Media Link",
                    hintText: "ex: Norvin S Crujido - Platform",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Social Media Link is required";
                    }
                    // Example of validating the format of the social media link (adjust as needed)
                    final socialMediaRegex =
                        RegExp(r'^[a-zA-Z0-9 ]+\s-\s[a-zA-Z0-9 ]+$');
                    if (!socialMediaRegex.hasMatch(value)) {
                      return "Please enter a valid social media link (e.g., John Doe - Facebook)";
                    }
                    return null;
                  },
                ), // Add some spacing between form fields
                SizedBox(height: 20),
                TextFormField(
                  controller: widget.occupationController, // Attach controller
                  decoration: const InputDecoration(
                    labelText: "Occupation",
                    hintText: "e.g., Developer",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Occupation is required";
                    }

                    // Validate that the occupation does not exceed 20 characters
                    if (value.length > 20) {
                      return "Occupation must be 20 characters or less";
                    }

                    // Validate the format of the occupation (e.g., Developer or John Doe - Facebook)
                    final occupationRegex = RegExp(r'^[a-zA-Z0-9 ]+$');
                    if (!occupationRegex.hasMatch(value)) {
                      return "Please enter a valid occupation (e.g., Developer)";
                    }

                    return null;
                  },
                )
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
    widget.phoneNumberController.dispose();
    widget.socialMediaLinkController.dispose();
    super.dispose();
  }
}
