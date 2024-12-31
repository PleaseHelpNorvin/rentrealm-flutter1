import 'package:flutter/material.dart';
import 'package:rentealm_flutter/models/user_model.dart';
import 'create_profile_screen3.dart';

class CreateProfileScreen2 extends StatefulWidget {
  final UserResponse user;
  final String phoneNumberController;
  final String socialMediaLinkController;
  final String occupationController;

  CreateProfileScreen2({
    super.key,
    required this.user,
    required this.phoneNumberController,
    required this.socialMediaLinkController,
    required this.occupationController,
  });

  @override
  CreateProfileScreenState2 createState() => CreateProfileScreenState2();
}

class CreateProfileScreenState2 extends State<CreateProfileScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _line1Controller =
      TextEditingController(text: "Saac 1 Buaya");

  final TextEditingController _line2Controller =
      TextEditingController(text: "Lapu Lapu City");

  final TextEditingController _provinceController =
      TextEditingController(text: "Cebu");

  final TextEditingController _countryController =
      TextEditingController(text: "Philippines");

  final TextEditingController _postalCodeController =
      TextEditingController(text: "6015");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Fill Address"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: Form(
                        key: _formKey,
                        child: FieldWidget(
                          user: widget.user,
                          formKey: _formKey,
                          line1Controller: _line1Controller,
                          line2Controller: _line2Controller,
                          provinceController: _provinceController,
                          countryController: _countryController,
                          postalCodeController: _postalCodeController,
                        ),
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  String line1Controller = _line1Controller.text;
                  String line2Controller = _line2Controller.text;
                  String provinceController = _provinceController.text;
                  String countryController = _countryController.text;
                  String postalCodeController = _postalCodeController.text;

                  print("line1 Controller $line1Controller");
                  print("line2 Controller $line2Controller");
                  print("province Controller $provinceController");
                  print("country Controller $countryController");
                  print("postal code Controller $postalCodeController");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateProfileScreen3(
                              user: widget.user,
                              phoneNumberController:
                                  widget.phoneNumberController,
                              socialMediaLinkController:
                                  widget.socialMediaLinkController,
                              occupationController: widget.occupationController,
                              //address part
                              line1Controller: line1Controller,
                              line2Controller: line2Controller,
                              provinceController: provinceController,
                              countryController: countryController,
                              postalCodeController: postalCodeController)));
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Set text color to white
                minimumSize: Size(double.infinity,
                    50), // Set minimum width to make it full width, and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
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

class FieldWidget extends StatefulWidget {
  final UserResponse user;
  final GlobalKey<FormState> formKey;
  final TextEditingController line1Controller;
  final TextEditingController line2Controller;
  final TextEditingController provinceController;
  final TextEditingController countryController;
  final TextEditingController postalCodeController;

  const FieldWidget({
    super.key,
    required this.user,
    required this.formKey,
    required this.line1Controller,
    required this.line2Controller,
    required this.provinceController,
    required this.countryController,
    required this.postalCodeController,
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
                  controller: widget.line1Controller,
                  decoration: const InputDecoration(
                    labelText: "Line 1",
                    hintText: "ex: Saac 1 Buaya",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Line 1 is required";
                    }

                    if (value.length > 20) {
                      return "Line 1 must be 20 characters or less";
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.line2Controller,
                  decoration: const InputDecoration(
                    labelText: "Line 2",
                    hintText: "ex: Lapu-Lapu City",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Line 2 is required";
                    }

                    if (value.length > 20) {
                      return "Line 2 must be 20 characters or less";
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.provinceController,
                  decoration: const InputDecoration(
                    labelText: "Province",
                    hintText: "ex: Cebu City",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.countryController,
                  decoration: const InputDecoration(
                    labelText: "Country",
                    hintText: "ex: Philippines",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Country is required";
                    }

                    if (value.length > 20) {
                      return "Country must be 20 characters or less";
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.postalCodeController,
                  decoration: const InputDecoration(
                    labelText: "Postal Code",
                    hintText: "ex: 6015",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Postal Code is required";
                    }

                    if (value.length != 4) {
                      return "Postal Code must be exact 4 characters";
                    }

                    if (!RegExp(r'[0-9]+$').hasMatch(value)) {
                      return "Postal Code must only contain numeric charaters";
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.line1Controller.dispose();
    widget.line2Controller.dispose();
    widget.provinceController.dispose();
    widget.countryController.dispose();
    widget.postalCodeController.dispose();
    super.dispose();
  }
}
