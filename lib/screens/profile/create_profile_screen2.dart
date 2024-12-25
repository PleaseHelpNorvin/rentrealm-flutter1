import 'package:flutter/material.dart';
import 'package:rentealm_flutter/models/user_model.dart';

class CreateProfileScreen2 extends StatefulWidget {
  final UserResponse user;
  final String phoneNumberController;
  final String socialMediaLinkController;

  CreateProfileScreen2({
    super.key,
    required this.user,
    required this.phoneNumberController,
    required this.socialMediaLinkController,
  });

  @override
  CreateProfileScreenState2 createState() => CreateProfileScreenState2();
}

class CreateProfileScreenState2 extends State<CreateProfileScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      child: FieldWidget(user: widget.user, formKey: _formKey),
                    ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class FieldWidget extends StatefulWidget {
  final UserResponse user;
  final GlobalKey<FormState> formKey;

  const FieldWidget({
    super.key,
    required this.user,
    required this.formKey,
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
                  decoration: const InputDecoration(
                    labelText: "test1",
                    hintText: "test1 ",
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
