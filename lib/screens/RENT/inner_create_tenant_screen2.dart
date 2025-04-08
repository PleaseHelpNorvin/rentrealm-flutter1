import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/pickedRoom_provider.dart';
import 'package:rentealm_flutter/SCREENS/outer_create_tenant_screen4.dart';
import 'package:rentealm_flutter/models/tenant_model.dart';

import '../../MODELS/room_model.dart';
import '../../PROVIDERS/reservation_provider.dart';
import '../../PROVIDERS/room_provider.dart';

class InnerCreateTenantScreen2 extends StatefulWidget {
  final int roomId;
  const InnerCreateTenantScreen2({super.key, required this.roomId});

  @override
  State<InnerCreateTenantScreen2> createState() => _InnerCreateTenantScreen2State();
}

class _InnerCreateTenantScreen2State extends State<InnerCreateTenantScreen2> {
  late List<String> imagePaths = [];
  int _activePage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    Future.microtask(() async {
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);
      await roomProvider.fetchRoomById(context, widget.roomId);
      
      if (mounted) {
        setState(() {
          imagePaths = List<String>.from(roomProvider.singleRoom?.roomPictureUrls ?? []);
        });
      }
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.page == imagePaths.length - 1) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
 
  @override
Widget build(BuildContext context) {
  final roomProvider = Provider.of<RoomProvider>(context, listen: false);
  final room = roomProvider.singleRoom;

  return Scaffold(
    body: Stack(
      children: [
        Column(
          children: <Widget>[
            _buildCarousel(), // The image placeholder
            SizedBox(height: 10),
            Expanded(child: _buildTextPart()), // Makes content scrollable
          ],
        ),

        // Fixed Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
          left: 10, 
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context); // Same function as the AppBar back button
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent, // Semi-transparent background
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: room == null ? SizedBox() : _buildBottomBar(room),
  );
} 
void showStatusDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    ),
  );
}

  Widget _buildBottomBar(Room room) {
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
    color: Color(0xFFF8F9FF),
    child: Padding(
      padding: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rent Price: ₱${room.rentPrice.toString()}",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<PickedRoomProvider>(context,listen: false).addRoomForUser(widget.roomId);
              final reservationProvider = Provider.of<ReservationProvider>(context, listen:  false);
              final int? profileId = reservationProvider.profileId;
              if (profileId == null) {
                print("no profileId found in inner_create_tenant_screen2");
                return;
              }
              final int? userId = Provider.of<AuthProvider>(context, listen:false).userId;
              if (userId == null) {
                print("no userId found on inner_create_tenant_screen2");
                return;
              }

              final String? token = Provider.of<AuthProvider>(context, listen: false).token;
              if (token == null) {
                print("no userId found on inner_create_tenant_screen2");
                return;
              }

              await Provider.of<PickedRoomProvider>(context,listen: false).fetchPickedRooms(userProfileUserId: userId, token: token);
              final int? pickedRoomId = Provider.of<PickedRoomProvider>(context, listen: false).singlePickedRoom?.id;
              
              if(pickedRoomId == null )
              {
                print("no singlePickedRoom on inner_create_tenant_screen2");
                return;
              }
              if (room.status == 'reserved') {
                showStatusDialog(context, 'Room Reserved', 'Sorry, this room is already reserved.');
                return;
              } else if (room.status == 'occupied') {
                showStatusDialog(context, 'Room Occupied', 'Sorry, this room is already occupied.');
                return;
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OuterCreateTenantScreen4(
                      roomId: widget.roomId,
                      profileId: profileId,
                      pickedRoomId: pickedRoomId,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.12,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
                side: BorderSide(
                  color: Colors.blue,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: const Text("Rent Now"),
            ),
          ),
        ],
      ),
    ),
  );
}

    Widget _buildCarousel() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imagePaths.length,
            onPageChanged: (value) {
              setState(() {
                _activePage = value;
              });
            },
            itemBuilder: (context, index) {
              return ImagePlaceHolder(imagePath: imagePaths[index]);
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                imagePaths.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor:
                          _activePage == index ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextPart() {
    final roomProvider = Provider.of<RoomProvider>(context,listen: false);
    final room = roomProvider.singleRoom;
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 5),
      child: Column(
        children: [
          // Title - Fixed (Not Scrollable)
          Text(
            room!.roomCode,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),

          // Divider - Fixed (Not Scrollable)
          Divider(thickness: 2, color: Colors.black),
          SizedBox(height: 5),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("This part is scrollable."),
                  Text("More text..."),
                  for (int i = 0; i < 15; i++)
                    Text(
                      "Even more text... ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss",
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  final String imagePath;

  const ImagePlaceHolder({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: BoxFit.cover, 
    );
  }
}

// class ImagePlaceHolder extends StatelessWidget {
//   final String imagePath;

//   const ImagePlaceHolder({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CachedNetworkImage(
//           imageUrl: imagePath,
//           fit: BoxFit.cover,
//           width: double.infinity,
//           height: double.infinity,
//         ),

//         // Back button inside the image
//         Positioned(
//           top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
//           left: 10, 
//           child: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
//             onPressed: () {
//               Navigator.pop(context); // Same function as the AppBar back button
//             },
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.black54, // Semi-transparent background
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

