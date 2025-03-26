import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/reservation_provider.dart';
import 'package:rentealm_flutter/models/reservation_model.dart';

class ReservationDetails extends StatefulWidget {
  final int reservationId;
  const ReservationDetails({super.key, required this.reservationId});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReservationProvider>(context, listen: false)
          .fetchReservationById(context, widget.reservationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<ReservationProvider>(
          builder: (context, reservationProvider, child) {
            final singleReservation = reservationProvider.singleReservation; 
            final isLoading = reservationProvider.isLoading;

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (singleReservation == null) {
              return const Center(child: Text("No reservation found."));
            }

            // Assuming your model has a `reservations` list
            final firstReservation = singleReservation.reservations.isNotEmpty
                ? singleReservation.reservations.first
                : null;

            if (firstReservation == null) {
              return const Center(child: Text("No reservation details available."));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reservation Code: ${singleReservation.reservations.first.reservationCode}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Payment Method: ${singleReservation.reservations.first.paymentMethod}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Status: ${singleReservation.reservations.first.status}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text("Room ID: ${firstReservation.roomId}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text("Room ID: ${firstReservation.approvedBy} on ${firstReservation.approvalDate}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
