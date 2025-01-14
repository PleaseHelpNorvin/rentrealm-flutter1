import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../PROVIDERS/profile_provider.dart';
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
      Provider.of<ProfileProvider>(context, listen: false)
        .loadUserProfile(context);

      Provider.of<UserProvider> (context, listen: false)
      .fetchUser(context);

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Make the whole body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: <Widget>[
              // Welcome Back Text
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Welcome Back, $userName!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Row of Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // First Card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightBlue.shade50,
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      height: 150,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people, size: 40, color: Colors.blue),
                            SizedBox(height: 8),
                            Text(
                              'Total Users',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '1,250',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Second Card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.green.shade50,
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      height: 150,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text(
                              'Total Orders',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '450',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Card under the Row of Cards (Maintenance Requests Card)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.orange.shade50,
                child: const SizedBox(
                  width: double.infinity,
                  height: 1000, // Increased height to 200px
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView( // Make content scrollable
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.handyman, size: 40, color: Colors.orange),
                          SizedBox(height: 8),
                          Text(
                            'Your Maintenance Requests',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          // Static Data for Maintenance Request
                          SizedBox(height: 8),
                          // Adding some static values inside the card
                          Text(
                            'Request ID: 12345',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Scheduled: Tomorrow, 2:00 PM',
                            style: TextStyle(fontSize: 14),
                          ),
                          // You can add more content to make it scrollable
                          SizedBox(height: 8),
                          Text(
                            'Details: This is a static detail for the maintenance request.',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Handyman Accepted: John Doe',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
