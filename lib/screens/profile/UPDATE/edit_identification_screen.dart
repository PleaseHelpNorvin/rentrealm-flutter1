import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/models/user_model.dart';

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
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FieldWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const FieldWidget({super.key, required this.formKey});

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
                  decoration: const InputDecoration(
                    labelText: "test1",
                    hintText: "test1",
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
