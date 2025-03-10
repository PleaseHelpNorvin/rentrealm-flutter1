import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/NETWORKS/apiservice.dart';
import 'package:rentealm_flutter/PROVIDERS/profile_provider.dart';

import 'auth_provider.dart';

class ReservationProvider extends ChangeNotifier {
  ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String token;
  late int? profileId;

  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  // methods below
  Future<void> createReservation(BuildContext context, int profileId,
      int roomId, File? paymentProof) async {
    print("profileId: $profileId");
    print("roomId: $roomId");
    print("paymentProof.path: ${paymentProof?.path}");
  }
}
