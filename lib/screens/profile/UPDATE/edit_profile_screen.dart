import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/controllers/profile_controller.dart';
import 'package:rentealm_flutter/models/user_model.dart';

import '../../../controllers/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({
    super.key,
  });

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _socialMediaLinksController =
      TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    final phoneNumber = profileController.userProfile?.data.phoneNumber ?? '';
    final SocialMediaLinks =
        profileController.userProfile?.data.socialMediaLinks ?? '';
    final occupation = profileController.userProfile?.data.occupation ?? '';

    _phoneNumberController.text = phoneNumber;
    _socialMediaLinksController.text = SocialMediaLinks;
    _occupationController.text = occupation;

    print('editAddressScreen: $_phoneNumberController');
    print('editAddressScreen: $_socialMediaLinksController');
    print('editAddressScreen: $_occupationController');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Edit Address"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: FieldWidget(
                formKey: _formKey,
                phoneNumberController: _phoneNumberController,
                socialMediaLinksController: _socialMediaLinksController,
                occupationController: _occupationController,
              ),
            ),
          ),
          Expanded(
            child: Container(), // Empty container to fill up space
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  String phoneNumberController =
                      _phoneNumberController.text.trim();
                  String socialMediaLinksController =
                      _socialMediaLinksController.text.trim();
                  String occupationController =
                      _occupationController.text.trim();

                  final profileController =
                      Provider.of<ProfileController>(context, listen: false);
                  profileController.onUpdateUserProfile(
                      context,
                      phoneNumberController,
                      socialMediaLinksController,
                      occupationController);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Set text color to white
                minimumSize: Size(
                    double.infinity, 50), // Set full width and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                ),
              ),
              child: const Text('Update Adress'),
            ),
          ),
        ],
      ),
    );
  }
}

class FieldWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneNumberController;
  final TextEditingController socialMediaLinksController;
  final TextEditingController occupationController;

  const FieldWidget({
    super.key,
    required this.formKey,
    required this.phoneNumberController,
    required this.socialMediaLinksController,
    required this.occupationController,
  });

  @override
  FieldWidgetState createState() => FieldWidgetState();
}

class FieldWidgetState extends State<FieldWidget> {
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
                  controller: widget.phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: "new Phone Number",
                    hintText: "Enter your new Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.socialMediaLinksController,
                  decoration: const InputDecoration(
                    labelText: "new Phone Number",
                    hintText: "Enter your new Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.occupationController,
                  decoration: const InputDecoration(
                    labelText: "new Occupation",
                    hintText: "Enter your new Occupation",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
