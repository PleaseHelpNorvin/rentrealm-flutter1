import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../MODELS/user_model.dart';
import '../../../PROVIDERS/profile_provider.dart';
import '../../../PROVIDERS/user_provider.dart';

class EditIdentificationScreen extends StatefulWidget {
  const EditIdentificationScreen({
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
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.loadUserProfile(context);
    final driverLicenseNumber =
        profileProvider.userProfile?.data.driverLicenseNumber ?? '';
    final nationalIdNumber =
        profileProvider.userProfile?.data.nationalId ?? '';
    final passportNumber =
        profileProvider.userProfile?.data.passportNumber ?? '';
    final socialSecuritySystemNumber =
        profileProvider.userProfile?.data.socialSecurityNumber ?? '';

    _driverLicenseNumberController.text = driverLicenseNumber;
    _nationalIdNumberController.text = nationalIdNumber;
    _passportNumberController.text = passportNumber;
    _socialSecuritySystemNumberController.text = socialSecuritySystemNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   title: Text("Edit Identifications"),
      // ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Attach the form key
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
                  String driverLicenseNumber =
                      _driverLicenseNumberController.text.trim();
                  String nationalIdNumber =
                      _nationalIdNumberController.text.trim();
                  String passportNumber =
                      _passportNumberController.text.trim();
                  String socialSecurityNumber =
                      _socialSecuritySystemNumberController.text.trim();

                  // Debugging print statements to check if the data is being populated
                  print("Driver License Number: $driverLicenseNumber");
                  print("National ID Number: $nationalIdNumber");
                  print("Passport Number: $passportNumber");
                  print("Social Security Number: $socialSecurityNumber");

                  // Call the method to update identifications
                  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                  profileProvider.onUpdateIdentifications(
                    context,
                    driverLicenseNumber,
                    nationalIdNumber,
                    passportNumber,
                    socialSecurityNumber,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Set text color to white
                minimumSize: Size(double.infinity, 50), // Set full width and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Optional: rounded corners
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Driver License Number';
                    }
                    return null; // Valid input
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.nationalIdNumber,
                  decoration: const InputDecoration(
                    labelText: "National Id Number",
                    hintText: "Enter your new National Id Number if Available ",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your National ID Number';
                    }
                    return null; // Valid input
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.passportNumber,
                  decoration: const InputDecoration(
                    labelText: "Passport Number",
                    hintText: "Enter your new Passport Number if Available",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Passport Number';
                    }
                    return null; // Valid input
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Social Security Number';
                    }
                    return null; // Valid input
                  },
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
