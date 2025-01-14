import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rentrealm_flutter2/PROVIDERS/auth_provider.dart';
import '../PROVIDERS/auth_provider.dart';
import '../PROVIDERS/user_provider.dart';
import '../SCREENS/HOME/home.dart';
import '../SCREENS/PROFILE/profile.dart';

class HomeLoggedScreen extends StatefulWidget {
  const HomeLoggedScreen({super.key});

  @override
  HomeLoggedScreenState createState() => HomeLoggedScreenState();
}

class HomeLoggedScreenState extends State<HomeLoggedScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;
      final userId = authProvider.userId;

      if (token != null && userId != null) {
        Provider.of<UserProvider>(context, listen: false)
            .fetchUser(context);
      } else {
        print("Token or userId is null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of screens to switch between
    final List<Widget> screens = [
      const HomeScreen(), // Home screen widget
      const ProfileScreen(), // Profile screen widget
    ];

    final List<String> titles = [
      'Home Screen', // Title for HomeScreen
      'Profile Screen', // Title for ProfileScreen
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(titles[_currentIndex]),
        automaticallyImplyLeading: false,
      ),
      
      // Dynamically switch between screens
      body: screens[_currentIndex],
      backgroundColor: const Color(0xFFF6F7FD), // Transparent background for the whole scaffold
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue, // Icon background circle color
        backgroundColor: Colors.transparent, // Transparent background outside icon circle
        items: <Widget>[
          // Home icon
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: _currentIndex == 0 ? 0.0 : 15.0, // Adjust the position for non-selected icon
                ),
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: _currentIndex == 0 ? Colors.white : Colors.white70,
                ),
              ),
              // Show label only if not selected
              if (_currentIndex != 0)
                const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
            ],
          ),
          // Profile icon
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: _currentIndex == 1 ? 0.0 : 15.0, // Adjust the position for non-selected icon
                ),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: _currentIndex == 1 ? Colors.white : Colors.white70,
                ),
              ),
              // Show label only if not selected
              if (_currentIndex != 1)
                const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
            ],
          ),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
