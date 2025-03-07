import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PROVIDERS/reservation_provider.dart';
import '../PROVIDERS/room_provider.dart';
import '../MODELS/room_model.dart';

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
  final TextEditingController _amountController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<RoomProvider>(context, listen: false)
          .fetchRoomById(context, widget.roomId));

    _saveProfileId();
  }

  Future<void> _saveProfileId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('profileId', widget.profileId);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedFile = File(pickedImage.path);
      });
    }
  }

  void _submitReservation() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount")),
      );
      return;
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a payment proof")),
      );
      return;
    }

    // Call reservation provider to handle the reservation
    Provider.of<ReservationProvider>(context, listen: false)
    .createReservation(
      context,
      widget.profileId, // Pass as int
      widget.roomId, // Pass as int
      double.tryParse(_amountController.text) ?? 0.0, // Convert String to double
      _selectedFile, // Ensure _selectedFile is nullable
    );


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reservation submitted successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Reservation"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<RoomProvider>(
                builder: (context, roomProvider, child) {
                  final room = roomProvider.singleRoom;

                  if (room == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRoomCard(room),
                      const SizedBox(height: 10),

                      /// **Amount Input Field**
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// **File Upload Button**
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Upload Payment Proof"),
                      ),

                      /// **File Preview**
                      if (_selectedFile != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Selected file: ${_selectedFile!.path.split('/').last}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

          /// **Reservation Button**
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _submitReservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: const Text("Submit Reservation"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room) {
    return Card(
      color: const Color(0xff2196F3),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// **Room Image**
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: room.roomPictureUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: room.roomPictureUrls.first,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error, color: Colors.red)),
                    )
                  : Image.asset(
                      'assets/images/rentrealm_logo.png',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
            ),
            const SizedBox(width: 10),

            /// **Room Details**
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    room.roomCode,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
