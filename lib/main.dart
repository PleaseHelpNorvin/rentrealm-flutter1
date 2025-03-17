import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';

import 'PROVIDERS/auth_provider.dart';
import 'PROVIDERS/pickedRoom_provider.dart';
import 'PROVIDERS/reservation_provider.dart';
import 'PROVIDERS/theme_provider.dart';
import 'PROVIDERS/tenant_provider.dart';
import 'PROVIDERS/property_provider.dart';
import 'PROVIDERS/profile_provider.dart';
import 'PROVIDERS/user_provider.dart';
import 'PROVIDERS/inquiry_provider.dart';
import 'PROVIDERS/notification_provider.dart';
import 'PROVIDERS/payment_provider.dart';
import 'PROVIDERS/rentalAgreement_provider.dart';
import 'PROVIDERS/room_provider.dart';

import 'SCREENS/AUTH/login.dart';
import 'SCREENS/PROFILE/UPDATE/edit_address_screen.dart';
import 'SCREENS/PROFILE/UPDATE/edit_identification_screen.dart';
import 'SCREENS/PROFILE/UPDATE/edit_profile_screen.dart';
import 'SCREENS/PROFILE/UPDATE/edit_user_screen.dart';
import 'SCREENS/PROFILE/CREATE/create_profile_screen1.dart';
import 'SCREENS/get_started.dart';
import 'SCREENS/TENANT/CREATE/create_tenant_screen1.dart';
import 'SCREENS/payment_response_screen/payment_success_screen.dart';
import 'SCREENS/payment_response_screen/payment_failed_screen.dart';
import 'screens/outer_create_tenant_screen1.dart';

/// Overrides HTTP security to allow self-signed certificates (for testing)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleInitialAndIncomingLinks();
  }

  /// Handles both initial and ongoing app links
  void _handleInitialAndIncomingLinks() async {
    try {
      // Handle initial deep link when the app starts

      Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _navigateBasedOnUri(initialLink);
      }

      // Listen for deep links when the app is running
      _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
        _navigateBasedOnUri(uri);
      }, onError: (err) {
        print("Error handling deep link: $err");
      });
    } catch (e) {
      print("Error initializing app links: $e");
    }
  }

  /// Navigates to the appropriate screen based on the received URI.
  void _navigateBasedOnUri(Uri uri) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uri.path == "/payment-success") {
        Navigator.pushNamed(context, '/payment-success');
      } else if (uri.path == "/payment-failed") {
        Navigator.pushNamed(context, '/payment-failed');
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TenantProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => InquiryProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => RentalagreementProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(
          create: (context) => PickedRoomProvider(
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Rent Realm',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: context.watch<ThemeProvider>().themeMode,
            home: const GetStartedScreen(),
            routes: {
              '/get_started': (context) => GetStartedScreen(),
              '/outercreatetenantscreen1': (context) =>
                  OuterCreateTenantScreen1(),
              '/login': (context) => LoginScreen(),
              '/edituser': (context) => EditUserScreen(),
              '/editprofile': (context) => EditProfileScreen(),
              '/editaddress': (context) => EditAddressScreen(),
              '/editidentification': (context) => EditIdentificationScreen(),
              '/createprofile1': (context) => CreateProfileScreen1(),
              '/createtenant1': (context) => CreateTenantScreen1(),
              '/payment-success': (context) => PaymentSuccessScreen(),
              '/payment-failed': (context) => PaymentFailedScreen(),
            },
          );
        },
      ),
    );
  }
}
