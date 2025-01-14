import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../PROVIDERS/profile_provider.dart';
// import 'package:rentealm_flutter/models/user_model.dart';
import '../../../MODELS/user_model.dart';
import '../../../PROVIDERS/user_provider.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({
    super.key,
  });

  @override
  EditAddressScreenState createState() => EditAddressScreenState();
}

class EditAddressScreenState extends State<EditAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _line1Controller = TextEditingController();
  final TextEditingController _line2Controller = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final line1 = profileProvider.userProfile?.data.line_1 ?? '';
    final line2 = profileProvider.userProfile?.data.line_2 ?? '';
    final province = profileProvider.userProfile?.data.province ?? '';
    final country = profileProvider.userProfile?.data.country ?? '';
    final postalCode = profileProvider.userProfile?.data.postalCode ?? '';

    _line1Controller.text = line1;
    _line2Controller.text = line2;
    _provinceController.text = province;
    _countryController.text = country;
    _postalCodeController.text = postalCode;

    print('editAddressScreen: $_line1Controller');
    print('editAddressScreen: $_line2Controller');
    print('editAddressScreen: $_provinceController');
    print('editAddressScreen: $_countryController');
    print('editAddressScreen: $_postalCodeController');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   title: Text("Edit Address"),
      // ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: FieldWidget(
                  formKey: _formKey,
                  line1Controller: _line1Controller,
                  line2Controller: _line2Controller,
                  provinceController: _provinceController,
                  countryController: _countryController,
                  postalCodeController: _postalCodeController),
            ),
          ),
          Expanded(
            child: Container(), // Empty container to fill up space
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  String line1Controller = _line1Controller.text.trim();
                  String line2Controller = _line2Controller.text.trim();
                  String provinceController = _provinceController.text.trim();
                  String countryController = _countryController.text.trim();
                  String postalCodeController =
                      _postalCodeController.text.trim();

                  final profileProvider =
                      Provider.of<ProfileProvider>(context, listen: false);
                  profileProvider.onUpdateUserAddress(
                    context,
                    line1Controller,
                    line2Controller,
                    provinceController,
                    countryController,
                    postalCodeController,
                  );
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
  final TextEditingController line1Controller;
  final TextEditingController line2Controller;
  final TextEditingController provinceController;
  final TextEditingController countryController;
  final TextEditingController postalCodeController;

  const FieldWidget({
    super.key,
    required this.formKey,
    required this.line1Controller,
    required this.line2Controller,
    required this.provinceController,
    required this.countryController,
    required this.postalCodeController,
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
                  maxLines: 3,
                  controller: widget.line1Controller,
                  decoration: const InputDecoration(
                    labelText: "new Line 1",
                    hintText: "Enter your new Line 1",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 3,
                  controller: widget.line2Controller,
                  decoration: const InputDecoration(
                    labelText: "new Line 2",
                    hintText: "Enter your new Line 2",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.provinceController,
                  decoration: const InputDecoration(
                    labelText: "Province",
                    hintText: "Enter your Province",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.countryController,
                  decoration: const InputDecoration(
                    labelText: "Country",
                    hintText: "Enter your Country",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.postalCodeController,
                  decoration: const InputDecoration(
                    labelText: "Postal Code",
                    hintText: "Enter your Postal Code",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
