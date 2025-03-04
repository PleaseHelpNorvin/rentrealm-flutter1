import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';

import '../../PROVIDERS/inquiry_provider.dart';
import '../../MODELS/room_model.dart';

class CheckoutScreen extends StatefulWidget {
  final String signatureSvgString;
  final int inquiryId;
  const CheckoutScreen({
    super.key,
    required this.inquiryId,
    required this.signatureSvgString, 
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int personCount = 1; // Default value of 1 person

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inquiryProvider = Provider.of<InquiryProvider>(context, listen: false);
      inquiryProvider.fetchInquiryById(context, widget.inquiryId).then((_) {
        final int? inquiryRoomId = inquiryProvider.inquiry?.data.inquiries.single.roomId;
        if (inquiryRoomId != null) {
          Provider.of<RoomProvider>(context, listen: false).fetchRoomById(context, inquiryRoomId);
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider =
        Provider.of<InquiryProvider>(context, listen: false);
    final int? inquiryRoomId =
        inquiryProvider.inquiry?.data.inquiries.single.roomId;

    if (inquiryRoomId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRoomCard(),
              _buildTextCard(),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
        child: SizedBox(
          width: double.infinity, // Full width
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button background color
              foregroundColor: Colors.white, // Text color
              side: BorderSide(
                color: Colors.blue, // Border color set to blue
                width: 1, // Border width set to 1px
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            onPressed: () {},
            child: Text("Pay"),
          ),
        ),
      ),
    ],
  ),

    );
  }

Widget _buildTextCard() {
  final roomProvider = Provider.of<RoomProvider>(context, listen: false); 
  final room = roomProvider.singleRoom;

  final inquiryProvider = Provider.of<InquiryProvider>(context, listen: false);
  final inquiry = inquiryProvider.inquiry;

  double totalPrice = ((room?.rentPrice ?? 0) as num).toDouble() * personCount;

  return SizedBox(
    width: double.infinity,
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xff2196F3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "Inquiry Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(thickness: 1),

            _buildRow("Rent Start Date:", "${inquiry?.data.inquiries.single.acceptedAt}"),
            const Divider(),

            _buildPersonCounter(room), // ✅ Updated person counter
            const Divider(),

            _buildRow("Total Price per Month:", "₱${totalPrice.toStringAsFixed(2)}", isBold: true), // ✅ Display updated price
          ],
        ),
      ),
    ),
  );
}

  /// **Widget for Person Counter**
Widget _buildPersonCounter(Room? room) {
  int maxCapacity = room?.capacity ?? 1;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Maximum Room Capacity: $maxCapacity",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Persons:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () {
                    if (personCount > 1) {
                      setState(() {
                        personCount--;
                      });
                    }
                  },
                ),
                Text(
                  "$personCount",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    if (personCount < maxCapacity) { 
                      setState(() {
                        personCount++;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        if (personCount >= maxCapacity)
          const Text(
            "Limit Reached!",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
      ],
    ),
  );
}

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard() {
  return Consumer<RoomProvider>(
    builder: (context, roomProvider, child) {
      final room = roomProvider.singleRoom;
      if (room == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Card(
        color: const Color(0xff2196F3),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/rentrealm_logo.png',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "₱ ${room.rentPrice.toString()} / Month",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDAEFFF),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}




  

  Widget _buildBoldText(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
