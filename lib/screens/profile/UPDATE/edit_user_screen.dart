import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../MODELS/user_model.dart';

import '../../../PROVIDERS/user_provider.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({
    super.key,
  });

  @override
  EditUserScreenState createState() => EditUserScreenState();
}

class EditUserScreenState extends State<EditUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user?.data?.token ?? '';
    final name = userProvider.user?.data?.user.name ?? '';
    final email = userProvider.user?.data?.user.email ?? '';

    // Set the initial text values for the controllers
    _nameController.text = name;
    _emailController.text = email;

    print('editUserScreen: $_nameController');
    print('editUserScreen: $_emailController');
    print('editUserScreen: $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Edit User"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: FieldWidget(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
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
                  String name = _nameController.text.trim();
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  print("this is password: $name");
                  print("this is password: $email");
                  print("this is password: $password");

                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  userProvider.onUpdateUser(context, name, email, password);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Set text color to white
                minimumSize: const Size(
                    double.infinity, 50), // Set full width and height to 50
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                ),
              ),
              child: const Text('Update User'),
            ),
          ),
        ],
      ),
    );
  }
}

class FieldWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const FieldWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  FieldWidgetState createState() => FieldWidgetState();
}

class FieldWidgetState extends State<FieldWidget> {
  bool _isPasswordVisible = false;
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
                  controller: widget.nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Enter you new Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your new Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget.passwordController,
                  obscureText:
                      !_isPasswordVisible, // Toggles password visibility
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your new Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
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
