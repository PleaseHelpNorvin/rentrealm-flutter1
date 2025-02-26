import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../PROVIDERS/auth_provider.dart';
// import 'package:rentealm_flutter/controllers/user_controller.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  final int roomId;

    RegisterScreen({
  super.key,
  required this.roomId,
});
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController nameController =
      TextEditingController(text: 'Norvin Crujido');
  final TextEditingController emailController =
      TextEditingController(text: 'test@test.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'password');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize any state if needed
  }
  
   Future<void> registerUser(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      // Call registerUser method from provider
      await authProvider.registerUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        roomId: widget.roomId,
        context: context,
      );

      // Save roomId in SharedPreferences after successful registration
      // await saveRoomId(widget.roomId);
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text("Register ${widget.roomId}"),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/rentrealm_logo.png",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _isPasswordVisible = !_isPasswordVisible;
                            },
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : () => registerUser(authProvider),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit Register"),
                  ),

                  const SizedBox(height: 20),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/login');
                  //   },
                  //   child: RichText(
                  //     text: TextSpan(
                  //       text: "Already have an account? ",
                  //       style: const TextStyle(
                  //         color: Colors.black, // Default text color
                  //       ),
                  //       children: <TextSpan>[
                  //         TextSpan(
                  //           text: 'Login Here',
                  //           style: TextStyle(
                  //             color: Colors.blue,
                  //             // decoration: TextDecoration.underline, // Corrected underline
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
