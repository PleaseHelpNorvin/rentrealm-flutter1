import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';

import 'create_tenant_screen4.dart';

class CreateTenantScreen3 extends StatefulWidget {
  final int roomId;

  //Room Details UI
  
  const CreateTenantScreen3({
    super.key,
    required this.roomId,
  });

  @override
  State<CreateTenantScreen3> createState() => _CreateTenantScreen3State();
}

class _CreateTenantScreen3State extends State<CreateTenantScreen3> {
  //for static testing
  // final List<String> imagePaths = [
  //   "assets/images/rentrealm_logo.png",
  //   "assets/images/profile_placeholder.png",
  // ];

  late List<String> imagePaths = [];
  // late List<Widget> _pages;
late List<Widget> _pages = []; 
  int _activePage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

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
    void initState() {
      super.initState();
      
      Future.microtask(() {
        final roomProvider = Provider.of<RoomProvider>(context, listen: false);
        roomProvider.fetchRoomById(context, widget.roomId).then((_) {
          setState(() {
            imagePaths = roomProvider.singleRoom?.roomPictureUrls ?? [];
            _pages = imagePaths.isNotEmpty
                ? List.generate(
                    imagePaths.length,
                    (index) => ImagePlaceHolder(imagePath: imagePaths[index]),
                  )
                : [const Center(child: Text("No images available"))]; // ✅ Fallback value
          });
        });
      });

      startTimer();
    }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final roomProvider = Provider.of<RoomProvider>(context);
     
  // Ensure that _pages is initialized and not empty
    if (_pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Test Room Details"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Room Details"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Image carousel
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
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
                    return _pages[index];
                  },
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      _pages.length,
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
                            backgroundColor: _activePage == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Text(
            roomProvider.singleRoom?.roomCode ?? 'N/A',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                   Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      roomProvider.singleRoom?.description ?? 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                   const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                   Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      roomProvider.singleRoom?.category ?? 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      roomProvider.singleRoom?.roomDetails ?? 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Room Size",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      roomProvider.singleRoom?.size ?? 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Max Capacity",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      roomProvider.singleRoom?.capacity.toString() ?? 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Current Occupants",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text(
                      roomProvider.singleRoom?.currentOccupants.toString() ?? 'N/A',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 5),

                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.08,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₱${roomProvider.singleRoom?.rentPrice?? 0}/month",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        CreateTenantScreen4(roomId: widget.roomId) 
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.18,
                      vertical: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5), 
                    child: const Text("Rent Now!"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  final String imagePath;

  const ImagePlaceHolder({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    //for static testing
    // return Image.asset(
    //   imagePath,
    //   fit: BoxFit.cover,
    // );

    return CachedNetworkImage(
      imageUrl: imagePath,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );

  }
}
