import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//personal screens
import './screens/home.dart';
import './screens/get_started.dart';
import './screens/auth/login.dart';
import './screens/auth/register.dart';
import './screens/profile/create_profile_screen1.dart';


//personal providers
import 'controllers/user_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/auth_controller.dart';
// import '.';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<UserController>(create: (_) => UserController()),
        ChangeNotifierProvider<ProfileController>(create: (_) => ProfileController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rent Realm',
      initialRoute: '/', 
      routes: <String, WidgetBuilder>{
        '/': (context) => GetstartedScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/createprofile1' : (context) => CreateProfileScreen1(),
      },
    );
  }
}