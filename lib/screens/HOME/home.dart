import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../PROVIDERS/profile_provider.dart';
import '../../PROVIDERS/tenant_provider.dart';
import '../../PROVIDERS/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // You can change this name based on user login data
  String userName = "User";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false);
      Provider.of<UserProvider>(context, listen: false).fetchUser(context);

    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate data fetching
    setState(() {}); // Rebuild the widget
  }


Widget _buildNoDataCard() {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: Colors.orange.shade50,
    child: const SizedBox(
      width: double.infinity,
      height: 300, // Increased height to 300px
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center( // Center everything inside the Card
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
              children: [
                Icon(Icons.reviews, size: 40, color: Colors.orange),
                SizedBox(height: 8),
                Text(
                  'Thank you for inquiring. The admins are reviewing your inquiry.',
                  textAlign: TextAlign.center, // Center text
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Admins may contact you once they have reviewed your inquiry.',
                  textAlign: TextAlign.center, // Center text
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Please check your notifications or be available for a possible call.',
                  textAlign: TextAlign.center, // Center text
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildNoDataCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
