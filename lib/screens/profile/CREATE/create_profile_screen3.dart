import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rentealm_flutter/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../../controllers/profile_controller.dart';
import '../../../PROVIDERS/profile_provider.dart';

class CreateProfileScreen3 extends StatefulWidget {
  final String userToken;
  final int userId;
  final String phoneNumberController;
  final String socialMediaLinkController;
  final String occupationController;
  final String line1Controller;
  final String line2Controller;
  final String provinceController;
  final String countryController;
  final String postalCodeController;
  int? roomId;


  CreateProfileScreen3({
    super.key,
    required this.userId,
    required this.userToken,
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
  Future<void> _getRoomId() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    widget.roomId = prefs.getInt('roomId'); // Retrieve the stored roomId
  });
}


  @override
void initState() {
  super.initState();
  _getRoomId();
}


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
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   title: const Text("Fill Identification"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room ID: ${widget.roomId ?? "Not Available"}'),

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
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text('Add Identification'),
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
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.all(20.0), // Add padding to all edges
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

                              // Check if the selected value already exists
                              int occurrences = _identificationList
                                  .where((item) => item['type'] == value)
                                  .length;
                              if (occurrences > 1) {
                                return 'This identification type has already been selected';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _identificationList[index]
                                ['controller'],
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

                    final profileProvider =
                        Provider.of<ProfileProvider>(context, listen: false);

                    profileProvider.onCreateUserProfile(
                        context,
                        widget.phoneNumberController,
                        widget.socialMediaLinkController,
                        widget.occupationController,
                        widget.line1Controller,
                        widget.line2Controller,
                        widget.provinceController,
                        widget.countryController,
                        widget.postalCodeController,
                        widget.roomId!.toInt(),
                        _identificationList);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All Data Submitted!')),
                    );
                  }
                },
                child: const Text('Submit'),
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
