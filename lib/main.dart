import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//personal screens
import './screens/home.dart';
import './screens/get_started.dart';
import './screens/auth/login.dart';
import './screens/auth/register.dart';



//personal providers
import 'controllers/user_controller.dart';
import 'controllers/profile_controller.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserController>(create: (_) => UserController()),
        // ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Rent Realm',
      initialRoute: '/', // This can help to set an initial route
      routes: <String, WidgetBuilder>{
        '/': (context) => GetstartedScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }

}
