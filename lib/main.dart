import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//personal screens
import './screens/home.dart';
import './screens/get_started.dart';
import './screens/auth/login.dart';
import './screens/auth/register.dart';
import 'screens/profile/CREATE/create_profile_screen1.dart';
import 'screens/profile/CREATE/create_profile_screen2.dart';
import './screens/profile/UPDATE/edit_user_screen.dart';
import './screens/profile/UPDATE/edit_address_screen.dart';
import './screens/profile/UPDATE/edit_identification_screen.dart';
//personal providers
import 'controllers/user_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/auth_controller.dart';
import 'screens/profile/profile_screen.dart';
// import '.';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<UserController>(create: (_) => UserController()),
        ChangeNotifierProvider<ProfileController>(
            create: (_) => ProfileController()),
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
        '/createprofile1': (context) => CreateProfileScreen1(),
        '/profile': (context) => ProfileScreen(),
        '/edituser': (context) => EditUserScreen(),
        '/editaddress': (context) => EditAddressScreen(),
        '/editidentification': (context) => EditIdentificationScreen(),
      },
    );
  }
}
