

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/profile_provider.dart';
import 'package:rentealm_flutter/networks/apiservice.dart';
import 'package:rentealm_flutter/screens/PAYMENT/payment.dart';

import '../models/billing_model.dart';
import '../models/payment_model.dart';
import '../models/paymongo_model.dart';

class PaymentProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 🔹 Store authentication details as instance variables
  late String token;
  late int? profileId;

  /// 🔹 Private variable to store checkout_url
  String? _checkoutUrl;
  /// ✅ Getter to retrieve checkout_url
  String? get checkoutUrl => _checkoutUrl;
  /// ✅ Setter to update checkout_url and notify listeners
  void setCheckoutUrl(String url) {
    _checkoutUrl = url;
    notifyListeners(); // Notify UI of the change
  }
  
  // private list 
  List<Billing> _billings = [];
  // getter
  List<Billing> get billings => _billings;
  // setter
  set billings(List<Billing> newBillings) {
    _billings = newBillings;
    print("setBillings() REACHED!");
    notifyListeners();
  }
  // private variable to store 
  RetrievePaymongoPaymentResponse? _paymongoPaymentResponse;
  //getter to retrieve 
  RetrievePaymongoPaymentResponse? get paymongoPaymentResponse => _paymongoPaymentResponse;
  // setter to update and notifyListeners
  set paymongoPaymentResponse(RetrievePaymongoPaymentResponse? newResponse) {
    _paymongoPaymentResponse = newResponse;
    notifyListeners();  // Notify UI about the update
  }

    ReceiptsResponse ? _receiptResponse;
    ReceiptsResponse ? get receiptResponse => _receiptResponse;

    set receiptResponse(ReceiptsResponse ? newReceiptResponse) {
      _receiptResponse = newReceiptResponse;
      notifyListeners();
    }

    List<Receipt> _receipts = [];
    List<Receipt> get receipts => _receipts;
    set receipts(List<Receipt> newReceipts) { // Setter
      _receipts = newReceipts;
      notifyListeners();
    }

  /// ✅ Initialize token and profileId (Call this in the beginning)
  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;
  }

  Future<void> processPayment(
    BuildContext context,
    int reservationId,
    int roomId,
    int rentalagreementId,
    String startDate,
    int persons,
    // File signatureStringSvg,
    double totalPrice,
    String paymentDescription,
  ) async {
    initAuthDetails(context);

    print("PROCESSPAYMENT REACHED!!!!");

    print("from processPayment()");
    print('Token: $token, Profile ID: $profileId');

    print("reservationId: $reservationId");
    print("roomId: $roomId");
    print("startDate: $startDate");
    print("persons: $persons");
    print("rentalagreementId: $rentalagreementId");
    // print("signatureStringSvg.path: ${signatureStringSvg.path}");
    // print("persons: $persons");
    print("totalPrice: $totalPrice");
    if (token == 'no token' || profileId == null) {
      print("Error: Missing authentication details");
      return;
    }

    final response = await apiService.getBillingForRentalAgreement(
        token: token, rentalagreementId: rentalagreementId);

    if (response != null && response.success) {
      print("BILLABLE ID ${response.data.billings.single.billableId}");
      int billingId = response.data.billings.single.billableId;

      final procressPaymentResponse = await apiService.postPaymongo(
        token: token,
        billingId: billingId,
        amount: totalPrice,
        paymentDescription: paymentDescription,
      );

      if (procressPaymentResponse != null && procressPaymentResponse.success) {
        print("Success PayMongo");
        print("Checkout URL: ${procressPaymentResponse.data.checkoutUrl}");

        /// 🔹 Update checkout URL
        setCheckoutUrl(procressPaymentResponse.data.checkoutUrl);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PaymentScreen(billingId: billingId)));
      } else {
        print("payment failed");
      }
    }
  }

  Future<void> fetchRetrievePayment(BuildContext context,{required int billingId}) async {
    initAuthDetails(context);
    print("from fetchPaymongoDetails(): $billingId");
    print("from fetchPaymongoDetails(): $token");

    _isLoading = true;
    notifyListeners();

    final response = await apiService.getRetrievePaymongoPayment(billingId: billingId, token: token);
    if(response != null) {
      Navigator.pushNamed(context, '/');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchReceiptsByProfileId(BuildContext context) async {
    initAuthDetails(context);
    print("from fetchReceiptsByProfileId(): $profileId");
    print("from fetchReceiptsByProfileId(): $token");

    _isLoading = true;
    notifyListeners();

    final response = await apiService.getReceiptByProfileId(token: token, profileId: profileId);
    
    if (response != null && response.success) {
      _receipts = response.receipts;
      notifyListeners(); 
    }
    _isLoading = false;
    notifyListeners();
  }
}

