import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/inquiry_provider.dart';
import 'package:rentealm_flutter/screens/outer_create_tenant_screen1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PROVIDERS/room_provider.dart';
import 'TENANT/CREATE/create_tenant_screen3.dart';
import 'outer_create_tenant_screen3.dart';

class OuterCreateTenantScreen4 extends StatefulWidget {
  final int roomId;
  final int profileId;

  const OuterCreateTenantScreen4({
    super.key,
    required this.roomId,
    required this.profileId,
  });

  @override
  State<OuterCreateTenantScreen4> createState() =>
      _OuterCreateTenantScreen4State();
}

class _OuterCreateTenantScreen4State extends State<OuterCreateTenantScreen4> {

  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<RoomProvider>(context, listen: false)
        .fetchRoomById(context, widget.roomId));

    _saveProfileId(); // Call the method when the screen loads


  }

  Future<void> _saveProfileId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profileId', widget.profileId);
    // await prefs.setInt('roomId', widget.roomId);
  }


  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final room = roomProvider.singleRoom; 
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm your Inquiry"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: const Color(0xff2196F3),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // Replace this with an actual room object if necessary
                            child: room?.roomPictureUrls.first != null
                           ? CachedNetworkImage(
                                imageUrl: room!.roomPictureUrls.first,
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  room!.roomCode,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDAEFFF),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  room.roomDetails,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFDAEFFF),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "₱ ${room.rentPrice} / Month",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDAEFFF),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                       SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.setInt('roomId', widget.roomId); // Save roomId
                                              await prefs.setInt('profileId', widget.profileId); // Save profileId

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OuterCreateTenantScreen1(
                                            // roomId: widget.roomId,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    child: const Text("Select Another"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// **Using Consumer for InquiryProvider**
          Consumer<InquiryProvider>(
            builder: (context, inquiryProvider, child) {
              return Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    inquiryProvider.storeInquiry(
                      context,
                      widget.roomId,
                      widget.profileId,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: const Text("Submit Inquiry"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
