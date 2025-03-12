import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';  // For formatting dates
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';
import '../../MODELS/room_model.dart';
import '../../PROVIDERS/reservation_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final File signaturePngString;
  final int reservationId;

  const CheckoutScreen({
    super.key,
    required this.reservationId,
    required this.signaturePngString,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _additionalPersonDescController = TextEditingController();
  DateTime? selectedDate; // Store selected date
  int personCount = 1; // Default value of 1 person fuc
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
      
      await reservationProvider.fetchReservationById(context, widget.reservationId);
      
      if (!mounted) return;

      final int? reservationRoomId = reservationProvider.singleReservation?.reservations.first.roomId;
      print("Reservation Room ID: $reservationRoomId");

      if (reservationRoomId != null) {
        final roomProvider = Provider.of<RoomProvider>(context, listen: false);
        
        await roomProvider.fetchRoomById(context, reservationRoomId);
        
        if (mounted) {
          setState(() {}); // Ensures UI updates after fetching room data
        }

        // Initialize PaymentProvider AFTER data fetching
        Future.microtask(() {
          try {
            final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
            paymentProvider.initAuthDetails(context);
          } catch (e) {
            print("Error accessing PaymentProvider: $e");
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _additionalPersonDescController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final room = roomProvider.singleRoom;
    setState(() {
      totalPrice = ((room?.rentPrice ?? 0) as num).toDouble() * personCount;
    });
  }

  // **Improved Date Picker Function**
  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Prevent selection of past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _callProcessPayment() {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false); 
    final rentalagreementProvider = Provider.of<RentalagreementProvider>(context, listen: false);
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
    final reservation= reservationProvider.singleReservation?.reservations.first;

    if (reservation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reservation details not available.")),
      );
      return;
    }
    
    int reservationId = reservation.id;
    int roomId = reservation.roomId;
    String startDate = selectedDate != null
        ? DateFormat("yyyy-MM-dd").format(selectedDate!)
        : DateFormat("yyyy-MM-dd").format(DateTime.now());
    int persons = personCount;

    paymentProvider.processPayment(context, reservationId, roomId, startDate, persons, widget.signaturePngString, totalPrice);
    rentalagreementProvider.storeRentalAgreement(context, reservationId, roomId, startDate, persons, widget.signaturePngString, totalPrice, _additionalPersonDescController.text);
  }
  

@override
Widget build(BuildContext context) {
  return Consumer<ReservationProvider>(
    builder: (context, reservationProvider, child) {
      final singleReservation = reservationProvider.singleReservation;

      // 🛑 Ensure reservation data is loaded
      if (singleReservation == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // ❗ Prevent 'No Element' Error
      if (singleReservation.reservations.isEmpty) {
        return const Scaffold(
          body: Center(child: Text("No Reservations Found")),
        );
      }

      final int reservationRoomId = singleReservation.reservations.first.roomId;

      return Scaffold(
        appBar: AppBar(title: const Text("Rent Payment")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                  ),
                  onPressed: () {
                    // _callProcessPayment();
                  },
                  child: const Text("Pay"),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  Widget _buildTextCard() {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final room = roomProvider.singleRoom;

    totalPrice = ((room?.rentPrice ?? 0) as num).toDouble() * personCount;

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
              const Center(
                child: Text(
                  "Rent Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                ),
              ),
              const Divider(thickness: 3),

              // **Improved Date Picker UI**
              const Text("Rent Start Date:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? "Select a date"
                            : DateFormat("MMMM dd, yyyy").format(selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),

              const Divider(),

              _buildPersonCounter(room),
              const Divider(),

              _buildRow("Total Price per Month:", "₱${totalPrice.toStringAsFixed(2)}", isBold: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonCounter(Room? room) {
    int maxCapacity = room?.capacity ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Maximum Room Capacity: $maxCapacity", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Persons:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: () {
                    if (personCount > 1) {
                      setState(() {
                        personCount--;
                        totalPrice = ((room?.rentPrice ?? 0) as num).toDouble() * personCount;
                      });
                    }
                  },
                ),
                Text("$personCount", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () {
                    if (personCount < maxCapacity) {
                      setState(() {
                        personCount++;
                        totalPrice = ((room?.rentPrice ?? 0) as num).toDouble() * personCount;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        // Show text input field when personCount is greater than 1
        if (personCount > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _additionalPersonDescController,
              decoration: InputDecoration(
                labelText: "whats your relationship of the added person?",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle the input change if needed
                print("Additional Person Details: $value");
              },
            ),
          ),
        if (personCount >= maxCapacity)
          const Text("Limit Reached!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: Colors.black),
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
              children: [
                room.roomPictureUrls.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: room.roomPictureUrls.first,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 180,
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
                    height: 150,
                  ),
                const SizedBox(width: 10),

                // Column to display roomCode and rentPrice vertically
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomCode,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing between text
                    Text(
                      "Rent Price: ₱${room.rentPrice.toString()}", // Display price with currency
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
