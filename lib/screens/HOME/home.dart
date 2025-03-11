import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/SCREENS/PROFILE/CREATE/create_profile_screen1.dart';
import 'package:rentealm_flutter/models/profile_model.dart';
import '../../PROVIDERS/pickedRoom_provider.dart';
import '../../PROVIDERS/profile_provider.dart';
import '../outer_create_tenant_screen4.dart';

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
    _profileCheckFuture =
        Future.value(false); // Prevent LateInitializationError

    Future.microtask(() {
      if (mounted) {
        setState(() {
          _profileCheckFuture =
              Provider.of<ProfileProvider>(context, listen: false)
                  .loadUserProfile(context);
        });
      }
    });
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

  Widget _buildWithDataCard() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _profileCheckFuture =
              Provider.of<ProfileProvider>(context, listen: false)
                  .loadUserProfile(context);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Consumer2<ProfileProvider, PickedRoomProvider>(
          builder: (context, profileProvider, pickedRoomProvider, child) {
            final singlePickedRoom = pickedRoomProvider.singlePickedRoom;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (singlePickedRoom != null)
                    _buildContinueReservationPayment(
                        context, profileProvider, singlePickedRoom),
                  if (singlePickedRoom == null) _buildShowReservationSent(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWithTenantData() {
    return Expanded(
      child: Column(
        children: [
          Text("THIS IS TENANT DATA"),
        ],
      ),
    );
  }

  Widget _buildContinueReservationPayment(
      BuildContext context, ProfileProvider profileProvider, singlePickedRoom) {
    return GestureDetector(
      onTap: () {
        if (singlePickedRoom?.room.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OuterCreateTenantScreen4(
                roomId: singlePickedRoom!.room.id,
                profileId: profileProvider.userProfile?.data.id ?? 0,
                pickedRoomId: singlePickedRoom.id,
              ),
            ),
          );
          print("Room ID: ${singlePickedRoom?.room.id}");
        } else {
          print("No room selected.");
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Continue to Reservation Payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Room ID: ${singlePickedRoom?.room.id ?? 'N/A'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Room Details: ${singlePickedRoom?.room.roomDetails ?? 'No details available'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowReservationSent() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Reservation Sent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please wait for a possible call from management.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Also, check your notifications for updates.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget shown when the user doesn't have a profile
  Widget _buildNoDataCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.orange.shade50,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("No profile Detected!"),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
