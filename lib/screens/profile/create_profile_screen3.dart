import 'package:flutter/material.dart';
import 'package:rentealm_flutter/models/user_model.dart';

class CreateProfileScreen3 extends StatefulWidget {
  final UserResponse user;
  final String phoneNumberController;
  final String socialMediaLinkController;
  final String occupationController;
  final String line1Controller;
  final String line2Controller;
  final String provinceController;
  final String countryController;
  final String postalCodeController;

  CreateProfileScreen3({
    super.key,
    required this.user,
    required this.phoneNumberController,
    required this.socialMediaLinkController,
    required this.occupationController,
    required this.line1Controller,
    required this.line2Controller,
    required this.provinceController,
    required this.countryController,
    required this.postalCodeController,
  });

  @override
  CreateProfileScreenState3 createState() => CreateProfileScreenState3();
}

class CreateProfileScreenState3 extends State<CreateProfileScreen3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // List of identification options
  final List<String> _identificationOptions = [
    'Select Identification Type',
    'Driver License Number',
    'National ID',
    'Passport Number',
    'Social Security Number',
  ];

  // Dynamic list to store identification types and text controllers
  List<Map<String, dynamic>> _identificationList = [
    {
      'type': 'Select Identification Type',
      'controller': TextEditingController(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill Identification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (_identificationList.length < 4) {
                    setState(() {
                      _identificationList.add({
                        'type': 'Select Identification Type',
                        'controller': TextEditingController(),
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('You can only add up to 4 identifications.'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Identification'),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _identificationList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _identificationList[index]['type'],
                          decoration: const InputDecoration(
                            labelText: "Select Identification Type",
                            border: OutlineInputBorder(),
                          ),
                          items: _identificationOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _identificationList[index]['type'] = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value == 'Select Identification Type') {
                              return 'Please select a valid identification type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _identificationList[index]['controller'],
                          decoration: InputDecoration(
                            labelText: _getFieldLabel(
                                _identificationList[index]['type']),
                            hintText: _getFieldHint(
                                _identificationList[index]['type']),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_identificationList[index]['type'] ==
                                'Select Identification Type') {
                              return 'Please select an identification type first';
                            }
                            if (value == null || value.isEmpty) {
                              return 'Please enter a ${_getFieldLabel(_identificationList[index]['type'])}';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Collect and process all identification data
                    for (var idData in _identificationList) {
                      print(
                          'Type: ${idData['type']}, Value: ${idData['controller'].text}');
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All Data Submitted!')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to return the field label
  String _getFieldLabel(String selectedOption) {
    switch (selectedOption) {
      case 'Driver License Number':
        return 'Driver License Number';
      case 'National ID':
        return 'National ID';
      case 'Passport Number':
        return 'Passport Number';
      case 'Social Security Number':
        return 'Social Security Number';
      default:
        return 'Identification';
    }
  }

  // Helper method to return the field hint
  String _getFieldHint(String selectedOption) {
    switch (selectedOption) {
      case 'Driver License Number':
        return 'Enter your driver license number';
      case 'National ID':
        return 'Enter your national ID';
      case 'Passport Number':
        return 'Enter your passport number';
      case 'Social Security Number':
        return 'Enter your social security number';
      default:
        return 'Enter identification details';
    }
  }
}
