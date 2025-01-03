import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/models/user_model.dart';

import '../../../controllers/profile_controller.dart';
import '../../../controllers/user_controller.dart';

class EditIdentificationScreen extends StatefulWidget {
  EditIdentificationScreen({
    super.key,
  });

  @override
  EditIdentificationScreenState createState() =>
      EditIdentificationScreenState();
}

class EditIdentificationScreenState extends State<EditIdentificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _driverLicenseNumberController =
      TextEditingController();
  final TextEditingController _nationalIdNumberController =
      TextEditingController();
  final TextEditingController _passportNumberController =
      TextEditingController();
  final TextEditingController _socialSecuritySystemNumberController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileController =
        Provider.of<ProfileController>(context, listen: false);
    profileController.loadUserProfile(context);
    final driverLicenseNumber =
        profileController.userProfile?.data.driverLicenseNumber ?? '';
    final nationalIdNumber =
        profileController.userProfile?.data.nationalId ?? '';
    final passportNumber =
        profileController.userProfile?.data.passportNumber ?? '';
    final socialSecuritySystemNumber =
        profileController.userProfile?.data.socialSecurityNumber ?? '';

    _driverLicenseNumberController.text = driverLicenseNumber;
    _nationalIdNumberController.text = nationalIdNumber;
    _passportNumberController.text = passportNumber;
    _socialSecuritySystemNumberController.text = socialSecuritySystemNumber;

    // print('editIdentification: $_driverLicenseNumberController');
    // print('editIdentification: $_nationalIdNumberController');
    // print('editIdentification: $_passportNumberController');
    // print('editIdentification: $_socialSecuritySystemNumberController');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Edit Identifications"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: FieldWidget(
                formKey: _formKey,
                driverLicenseNumber: _driverLicenseNumberController,
                nationalIdNumber: _nationalIdNumberController,
                passportNumber: _passportNumberController,
                socialSecuritySystemNumber:
                    _socialSecuritySystemNumberController,
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
                  // String
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
              child: const Text('Update Your Identifications'),
            ),
          ),
        ],
      ),
    );
  }
}

class FieldWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController driverLicenseNumber;
  final TextEditingController nationalIdNumber;
  final TextEditingController passportNumber;
  final TextEditingController socialSecuritySystemNumber;
  const FieldWidget({
    super.key,
    required this.formKey,
    required this.driverLicenseNumber,
    required this.nationalIdNumber,
    required this.passportNumber,
    required this.socialSecuritySystemNumber,
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
                  controller: widget.driverLicenseNumber,
                  decoration: const InputDecoration(
                    labelText: "Driver License Number",
                    hintText:
                        "Enter your new Driver License Number if Available ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.nationalIdNumber,
                  decoration: const InputDecoration(
                    labelText: "National Id Number",
                    hintText: "Enter your new National Id Number if Available ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.passportNumber,
                  decoration: const InputDecoration(
                    labelText: "Passport Number",
                    hintText: "Enter your new Passport Number if Available",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.socialSecuritySystemNumber,
                  decoration: const InputDecoration(
                    labelText: "Social Security System Number",
                    hintText:
                        "Enter your new Social Security System Number if Available",
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
