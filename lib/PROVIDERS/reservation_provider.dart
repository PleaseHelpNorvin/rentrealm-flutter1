import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/pickedRoom_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/profile_provider.dart';
import 'package:rentealm_flutter/models/reservation_model.dart';

import '../networks/apiservice.dart';
import 'auth_provider.dart';

class ReservationProvider extends ChangeNotifier {
  ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  // List of reservations
  List<Reservation>? _reservationList;
  List<Reservation>? get reservationList => _reservationList;
  // Setter for reservationList
  set reservationList(List<Reservation>? reservations) {
    _reservationList = reservations;
    notifyListeners(); // Notify UI when list changes
  }

  // Single reservation
  ReservationData? _singleReservation;
  ReservationData? get singleReservation => _singleReservation;

  set singleReservation(ReservationData? reservation) {
    _singleReservation = reservation;
    notifyListeners(); // Notify UI when a single object changes
  }

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  // methods below
  Future<void> createReservation(
    BuildContext context,
    int profileId,
    int roomId,
    int pickedRoomId,
    File? paymentProof,
    String? paymentMethod,
  ) async {
    initAuthDetails(context);
    final pickedRoomProvider =
        Provider.of<PickedRoomProvider>(context, listen: false);
    if (token.isEmpty) {
      print("Error: Token is not available.");
      return;
    }

    if (paymentMethod == null) {
      print("Please select a payment method");
      return;
    }

    print("profileId: $profileId");
    print("roomId: $roomId");
    print("paymentProof.path: ${paymentProof?.path}");
    print("paymentMethod: $paymentMethod");

    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    final response = await apiService.postReservation(
      profileId: profileId,
      roomId: roomId,
      paymentProof: paymentProof,
      paymentMethod: paymentMethod,
      token: token,
    );

    _isLoading = false;

    if (response != null && response.success) {
      singleReservation = response.data; // Store the newly created reservation
      print("Reservation created successfully");
      print("createReservation(): $singleReservation");

      // final destroyPickedRoomResponse = await apiService.deletePickedRoomById(pickedRoomId: pickedRoomId, token: token);
      await pickedRoomProvider.destroyPickedRoom(
          pickedRoomId: pickedRoomId, token: token);
    } else {
      print("Failed to create reservation");
    }
  }

  Future<void> fetchReservations(context) async {
    initAuthDetails(context);
    _isLoading = true;
    notifyListeners();

    final response = await apiService.getReservationsByProfileId(token: token, profileId: profileId);

    _isLoading = false;

    if (response != null && response.success) {
      reservationList =
          response.data.reservations; // Store the list of reservations
      print("Reservations fetched successfully");
      print("fetchReservations(): ${reservationList?.length}");
    } else {
      print("Failed to fetch reservations");
    }
  }



Future<void> fetchReservationById(BuildContext context, int reservationId) async {
   _isLoading = true;
  notifyListeners();

  initAuthDetails(context);
  print("fetchReservationById(): token: $token");
  print("fetchReservationById() reservationId: $reservationId");

  final response = await apiService.showReservation(reservationId: reservationId, token: token);

  if (response != null && response.success) {
    // if (response.data.reservations.isNotEmpty) {
      singleReservation = response.data;
      print("fetchReservationById(): roomId = ${singleReservation?.reservations.first.roomId}");
    // } else {
      // print("No reservation found for ID: $reservationId");
    // }
  } else {
    print("Failed to fetch reservation");
  }

    _isLoading = false;
  notifyListeners();
}

}
