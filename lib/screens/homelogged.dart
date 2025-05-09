import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/pickedRoom_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/profile_provider.dart';
import 'package:rentealm_flutter/SCREENS/PROFILE/UPDATE/edit_address_screen.dart';
import 'package:rentealm_flutter/screens/CONTRACT/contract.dart';
import 'package:rentealm_flutter/screens/NOTIFICATIONS/notifications.dart';
import 'package:rentealm_flutter/screens/RENT/rent.dart';
import 'package:rentealm_flutter/screens/profile/UPDATE/edit_identification_screen.dart';
import '../PROVIDERS/auth_provider.dart';
import '../PROVIDERS/user_provider.dart';
import '../SCREENS/HOME/home.dart';
import '../SCREENS/PROFILE/profile.dart';
import 'PAYMENT/rental_agreement.dart';
import 'PROFILE/UPDATE/edit_user_screen.dart';
import 'PROFILE/UPDATE/edit_profile_screen.dart';

class HomeLoggedScreen extends StatefulWidget {
  const HomeLoggedScreen({super.key});

  @override
  HomeLoggedScreenState createState() => HomeLoggedScreenState();
}

class HomeLoggedScreenState extends State<HomeLoggedScreen> {
  int _currentIndex = 2;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;
      final userId = authProvider.userId;
      print("UserID from HOMELOGGED() $userId");
      // final profileProvider =
      //     // Provider.of<ProfileProvider>(context, listen: false);
      //     Provider.of<ProfileProvider>(context, listen: false)
      //         .loadUserProfile(context);

      // Provider.of<TenantProvider>(context, listen: false).fetchTenant(context);

      if (token != null && userId != null) {
        Provider.of<UserProvider>(context, listen: false).fetchUser(context);
        // Provider.of<PickedroomProvider>(context, listen: false).addRoomForUser()
      } else {
        print("Token or userId is null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Contracts',
      'Rent',
      'Home',
      'Notification',
      'Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(titles[_currentIndex]),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            Widget page = const HomeScreen();
            switch (settings.name) {
              case '/':
                if (_currentIndex == 0) {
                  page = ContractScreen();
                } else if (_currentIndex == 1) {
                  page = RentScreen();
                } else if (_currentIndex == 2) {
                  page = const HomeScreen();
                } else if (_currentIndex == 3) {
                  page = const NotificationScreen();
                } else if (_currentIndex == 4) {
                  page = const ProfileScreen();
                }
                break;
              case '/edituser':
                page = const EditUserScreen();
                break;
              case '/editprofile':
                page = const EditProfileScreen();
                break;
              case '/editaddress':
                page = const EditAddressScreen();
                break;
              case '/editidentification':
                page = const EditIdentificationScreen();
                break;
              case '/rentalAgreement':
                final args = settings.arguments as Map<String, dynamic>?;
                page = RentalAgreementScreen(
                    notifNotifiableReservationId:
                        args?['notifNotifiableReservationId']);
                break;
              // case '':
              default:
                if (_currentIndex == 0) {
                  page = ContractScreen();
                } else if (_currentIndex == 1) {
                  page = RentScreen();
                } else if (_currentIndex == 2) {
                  page = const HomeScreen();
                } else if (_currentIndex == 3) {
                  page = const NotificationScreen();
                } else if (_currentIndex == 4) {
                  page = const ProfileScreen();
                }
            }
            return MaterialPageRoute(builder: (_) => page);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF6F7FD),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        backgroundColor: Colors.transparent,
        items: const <Widget>[
          Icon(Icons.description, size: 30, color: Colors.white),
          Icon(Icons.apartment, size: 30, color: Colors.white),
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _navigatorKey.currentState!.pushNamed('/'); // Reset to the main tab
          });
        },
      ),
    );
  }
}
