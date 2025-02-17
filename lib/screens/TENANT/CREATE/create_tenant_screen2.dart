import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentealm_flutter/MODELS/room_model.dart';
import 'package:rentealm_flutter/PROVIDERS/property_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';
import 'package:rentealm_flutter/SCREENS/TENANT/CREATE/create_tenant_screen3.dart';

class CreateTenantScreen2 extends StatefulWidget {
  final int propertyId;
  //Room List by Property Id UI

  const CreateTenantScreen2({
    super.key, 
    required this.propertyId
  });

  @override
  State<CreateTenantScreen2> createState() => _CreateTenantScreen2State();
}

class _CreateTenantScreen2State extends State<CreateTenantScreen2> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<RoomProvider>(context, listen: false)
      .fetchRoom(context, widget.propertyId),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Room"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child:  Column(
                children: <Widget>[
                  // Text("test2")
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search Room...",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      color: Color(0xFFDAEFFF),
                      child: Consumer<RoomProvider>(
                        builder: (context, roomProvider, child) {
                          if (roomProvider.room.isEmpty) {
                            return Center(child: Text("No rooms available"));
                          }

                          return ListView.builder(
                            itemCount: roomProvider.room.length,
                            itemBuilder: (context, index) {
                              final room = roomProvider.room[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                color: Color(0xff2196F3),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Container(
                                        width: 150,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: room.roomPictureUrls.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: room.roomPictureUrls.first, // Loads the first image in the list
                                                fit: BoxFit.cover,
                                                width: 150,
                                                height: 180,
                                                placeholder: (context, url) => Center(
                                                  child: CircularProgressIndicator(), // Loading indicator
                                                ),
                                                errorWidget: (context, url, error) => Center(
                                                  child: Text(
                                                    'Failed to load image',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 12, color: Colors.red),
                                                  ),
                                                ),
                                                fadeInDuration: Duration(milliseconds: 500), // Smooth fade-in effect
                                              )
                                            : Image.asset(
                                                "assets/images/rentrealm_logo.png",
                                                fit: BoxFit.cover,
                                                width: 150,
                                                height: 180,
                                              ),
                                      ),

                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: 
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              room.roomCode,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFDAEFFF),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                              Text(
                                                "Category: ${room.category}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFDAEFFF),
                                                ),
                                              ),
                                            SizedBox(height: 5),
                                              Text(
                                                "Room Status ${room.status}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFDAEFFF),
                                                ),
                                              ),
                                            SizedBox(height: 5),
                                              Text(
                                                "Capacity: ${room.capacity.toString()}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFDAEFFF),
                                                ),
                                              ),
                                            SizedBox(height: 5),
                                              Text(
                                                "Occupants: ${room.currentOccupants.toString()}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFDAEFFF),
                                                ),
                                              ),
                                            SizedBox(height: 5),
                                              Text(
                                                "Rent Price: ₱${room.rentPrice} / Month",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFFDAEFFF),
                                                ),
                                              ),

                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(child: ElevatedButton(
                                                    onPressed: () {

                                                      roomProvider.fetchRoomById(context, room.id);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => 
                                                          CreateTenantScreen3(roomId: room.id)
                                                        )
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: 10),
                                                      backgroundColor: 
                                                      Color(0xFFDAEFFF),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      )
                                                    ),
                                                    child: Text("View Details")))
                                                ],
                                              )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ) , 
            )
          )
        ],
      ),
    );
  }
}