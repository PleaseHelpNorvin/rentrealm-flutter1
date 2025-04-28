import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/auth_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/billing_provider.dart';
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
  late int userId;

  Billing? _billing;

  // Getter: Get the billing object
  Billing? get billing => _billing;

  // Setter: Update the billing object
  set billing(Billing? newBilling) {
    _billing = newBilling;
    notifyListeners();
  }

  /// 🔹 Private variable to store checkout_url
  String? _checkoutUrl;

  /// ✅ Getter to retrieve checkout_url
  String? get checkoutUrl => _checkoutUrl;

  /// ✅ Setter to update checkout_url and notify listeners
  void setCheckoutUrl(String url) {
    _checkoutUrl = url;
    print("new ChechoutUrl: $_checkoutUrl");
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
  RetrievePaymongoPaymentResponse? get paymongoPaymentResponse =>
      _paymongoPaymentResponse;
  // setter to update and notifyListeners
  set paymongoPaymentResponse(RetrievePaymongoPaymentResponse? newResponse) {
    _paymongoPaymentResponse = newResponse;
    notifyListeners(); // Notify UI about the update
  }

  ReceiptsResponse? _receiptResponse;
  ReceiptsResponse? get receiptResponse => _receiptResponse;

  set receiptResponse(ReceiptsResponse? newReceiptResponse) {
    _receiptResponse = newReceiptResponse;
    notifyListeners();
  }

  List<Receipt> _receipts = [];
  List<Receipt> get receipts => _receipts;
  set receipts(List<Receipt> newReceipts) {
    // Setter
    _receipts = newReceipts;
    notifyListeners();
  }

  CheckFailPaymentAgreement? _checkFailPaymentAgreement;
  CheckFailPaymentAgreement? get checkFailPaymentAgreement =>
      _checkFailPaymentAgreement;

  CheckFailPaymentBilling? _checkFailPaymentBilling;
  CheckFailPaymentBilling? get checkFailPaymentBilling =>
      _checkFailPaymentBilling;

  /// ✅ Initialize token and profileId (Call this in the beginning)
  void initAuthDetails(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    token = authProvider.token ?? 'no token';
    profileId = profileProvider.userProfile?.data.id;

    if (authProvider.userId == null) {
      throw Exception('User ID is null. Cannot proceed.');
    }

    userId = authProvider.userId!;

    // userId = authProvider.userId ?? 0;
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
      print("BILLABLE ID ${response.data.billings.single.id}");
      int billingId = response.data.billings.single.id;

      print("calling fetchCheckFailPayment()");
      fetchCheckFailPayment(context);

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
            context,
            MaterialPageRoute(
                builder: (context) => PaymentScreen(billingId: billingId)));
      } else {
        print("payment failed");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment failed. Please try again.")),
        );
      }
    }
  }

  Future<void> fetchRetrievePayment(BuildContext context,
      {required int billingId}) async {
    initAuthDetails(context);
    print("from fetchPaymongoDetails(): $billingId");
    print("from fetchPaymongoDetails(): $token");

    _isLoading = true;
    notifyListeners();

    final response = await apiService.getRetrievePaymongoPayment(
        billingId: billingId, token: token);
    if (response != null) {
      Navigator.pushNamed(context, '/');
    } else {
      print("${response}");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCheckFailPayment(
    BuildContext context,
  ) async {
    initAuthDetails(context);
    print("from fetchcheckFailPayment() userId: $userId)");

    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await apiService.checkFailPaymentCall(token: token, userid: userId);
      if (response != null && response.success) {
        print("fetchCheckFailPayment success");

        _checkFailPaymentAgreement = response.data.checkFailPaymentAgreement;
        _checkFailPaymentBilling = response.data.checkFailPaymentBilling;
      } else {
        print("fetchCheckFailPayment failed");
      }
    } catch (e) {
      print("EXCEPTION $e");
      return;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReceiptsByProfileId(BuildContext context) async {
    initAuthDetails(context);
    print("from fetchReceiptsByProfileId(): $profileId");
    print("from fetchReceiptsByProfileId(): $token");

    _isLoading = true;
    notifyListeners();

    final response = await apiService.getReceiptByProfileId(
        token: token, profileId: profileId);

    if (response != null && response.success) {
      _receipts = response.receipts;
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> processRentPaymongoPayment(BuildContext context) async {
    initAuthDetails(context);
    print("from processRentPaymongoPayment() token: $token ");
    print("from processRentPaymongoPayment() profileId: $profileId ");
    print("from processRentPaymongoPayment() userId: $userId ");

    final billingProvider =
        Provider.of<BillingProvider>(context, listen: false);
    final billing = billingProvider.billing;

    double billingTotalAmount = billing!.totalAmount.toDouble();
    String billingDescription = billing.billingTitle;
    int billingId = billing.id;

    print("from processRentPaymongoPayment billing Id: $billingId");
    print(
        "from processRentPaymongoPayment billingTotalAmount: $billingTotalAmount");
    print(
        "from processRentPaymongoPayment billingDescription: $billingDescription");
    final postPaymongoResponse = await apiService.postPaymongo(
      token: token,
      amount: billingTotalAmount,
      billingId: billingId,
      paymentDescription: billingDescription,
    );

    if (postPaymongoResponse != null && postPaymongoResponse.success) {
      setCheckoutUrl(postPaymongoResponse.data.checkoutUrl);
    }

    print(
        'from processRentPaymongoPayment single Billing getter : ${billing?.billingMonth}');
  }

  Future<void> processAdvanceRentPaymongoPayment(
      BuildContext context, totalAmount, selectedMonths) async {
    initAuthDetails(context);
    final billingProvider =
        Provider.of<BillingProvider>(context, listen: false);
    final billing = billingProvider.billing;

    // double billingTotalAmount = billing!.totalAmount.toDouble();
    String billingDescription = billing!.billingTitle;
    int billingId = billing.id;
    print("from processAdvanceRentPaymongoPayment billing Id: $billingId");
    // print(
    // "from processAdvanceRentPaymongoPayment billingDescription: $billingDescription");
    print("from processAdvanceRentPaymongoPayment totalAmount: $totalAmount");

    print(
        "from processAdvanceRentPaymongoPayment selectedMonths: $selectedMonths");

    try {
      final response = await apiService.postPaymongo(
        token: token,
        billingId: billingId,
        amount: totalAmount,
        paymentDescription: "Advance Payment",
        selectedMonthsToPay: selectedMonths,
      );

      if (response != null && response.success) {
        print("Success PayMongo");
        print("Checkout URL: ${response.data.checkoutUrl}");

        /// 🔹 Update checkout URL
        setCheckoutUrl(response.data.checkoutUrl);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentScreen(billingId: billingId)));
      }
    } catch (e) {
      print("failed processAdvanceRentPaymongoPayment(): $e");
      return;
    }
  }
}
