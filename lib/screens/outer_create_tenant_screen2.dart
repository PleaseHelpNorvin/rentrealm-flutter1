import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';
import 'package:rentealm_flutter/screens/outer_create_tenant_screen3.dart';

import '../MODELS/room_model.dart';

// import '../models/room_model.dart';
// import '..//room_model.dart';

class OuterCreateTenantScreen2 extends StatefulWidget {
  final int propertyId;

  const OuterCreateTenantScreen2({super.key, required this.propertyId,});

  @override
  State<OuterCreateTenantScreen2> createState() =>
      _OuterCreateTenantScreen2State();
}

class _OuterCreateTenantScreen2State extends State<OuterCreateTenantScreen2> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<RoomProvider>(context, listen: false ).fetchRoom(context, widget.propertyId));
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Location.",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.white),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12), // Adjust padding here
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Adjusts modal height dynamically
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Prevents unnecessary stretching
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Gender",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("test"),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to Rent Realm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Divider(),
              ListTile(
                leading: Icon(Icons.login, color: Colors.blue),
                title: Text("Login"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.app_registration, color: Colors.green),
                title: Text("Register"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/register');
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

Widget _buildRoomCard(Room rooms, BuildContext context) {
  return GestureDetector(
    onTap: () {
      print("Card tapped");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OuterCreateTenantScreen3(roomId: rooms.id ,),
        ),
      );
    },
    child: SizedBox(
      width: 350,
      child: Card(
        color: Colors.blue,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section on the Left
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: rooms.roomPictureUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: rooms.roomPictureUrls.first,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Text(
                            'Failed to load image',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/rentrealm_logo.png',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 180,
                      ),
              ),
              SizedBox(width: 9), // Space between image and text

              // Text Section on the Right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes Rent Price to bottom
                  children: [
                    Text(
                      rooms.roomCode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Category: ${rooms.category}",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Room Status: ${rooms.status}",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Rent Price: ₱123/month",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildRoomList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Consumer<RoomProvider>(
          builder: (context, roomProvider, child) {
          final rooms = roomProvider.rooms;

          if(roomProvider.isLoading) {
            return Center(child: CircularProgressIndicator(),);
          }

          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No Rooms found",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ); 
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return _buildRoomCard(rooms[index], context);
            },
          );
        }
        ),
      ),  
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rooms ${widget.propertyId}"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            // _buildSearchBar(),
            // Padding(
            //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Room",
            //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            _buildRoomList()
          ],
        ),
      ),
    );
  }
}
