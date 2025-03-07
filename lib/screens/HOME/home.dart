import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/SCREENS/PROFILE/CREATE/create_profile_screen1.dart';
import '../../PROVIDERS/profile_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> _profileCheckFuture;

  @override
  void initState() {
    super.initState();
    _profileCheckFuture = Provider.of<ProfileProvider>(context, listen: false).loadUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _profileCheckFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasData && !snapshot.data!) {
            return _buildNoDataCard();
          }

          return _buildWithDataCard();
        },
      ),
    );
  }

  /// Widget that displays the main home screen content
  Widget _buildWithDataCard() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _profileCheckFuture = Provider.of<ProfileProvider>(context, listen: false)
              .loadUserProfile(context);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: const [
                  Text("Welcome to Home Screen!"), // Home screen content
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Widget shown when the user doesn't have a profile
  Widget _buildNoDataCard() {
    return Center(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.orange.shade50,
        child: SizedBox(
          width: double.infinity,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProfileScreen1(),
                        ),
                      );
                    },
                    child: const Text('Continue Creating Profile'),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.reviews, size: 40, color: Colors.orange),
                  const SizedBox(height: 8),
                  const Text(
                    'Thank you for inquiring. The admins are reviewing your inquiry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Admins may contact you once they have reviewed your inquiry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please check your notifications or be available for a possible call.',
                    textAlign: TextAlign.center,
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
}
