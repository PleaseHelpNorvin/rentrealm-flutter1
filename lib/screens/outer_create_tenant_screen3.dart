import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';
import 'package:rentealm_flutter/screens/auth/register.dart';

class OuterCreateTenantScreen3 extends StatefulWidget {
  final int roomId;


  const OuterCreateTenantScreen3({super.key, 
    required this.roomId,
  });

  @override
  State<OuterCreateTenantScreen3> createState() =>
      _OuterCreateTenantScreen3State();
}

class _OuterCreateTenantScreen3State extends State<OuterCreateTenantScreen3> {
  // ✅ Static Images
  // final List<String> imagePaths = [
  //   "assets/images/rentrealm_logo.png",
  //   "assets/images/profile_placeholder.png",
  // ];
  //dynamic approach

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
      padding: EdgeInsets.all(10),
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

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context,listen: false);
    final room = roomProvider.singleRoom;
      return Scaffold(
          appBar: AppBar(
            title: const Text("Room Details"),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: room == null
              ? Center(child: CircularProgressIndicator()) // Show loader if room is null
              : Column(
                  children: <Widget>[
                    _buildCarousel(),
                    SizedBox(height: 10),
                    Expanded(child: _buildTextPart()), // Makes content scrollable
                  ],
                ),
          bottomNavigationBar: room == null
              ? SizedBox() // Hide bottom navigation if room is not loaded yet
              :  Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rent Price: ₱${room?.rentPrice}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, 
                      MaterialPageRoute(builder: (context) => 
                        RegisterScreen(roomId: widget.roomId)
                      )
                    );
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
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: const Text("Enquire Now"),
                  ),
                ),
              ],
            ),
          ),
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
