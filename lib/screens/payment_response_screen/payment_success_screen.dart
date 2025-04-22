import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/billing_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final int billingId;

  const PaymentSuccessScreen({super.key, required this.billingId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();

    // Debugging: Print billingId when screen initializes
    print("initState: Received billingId = ${widget.billingId}");

    // final billingProvider = Provider.of<BillingProvider>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   print("Fetching billing details for ID: ${widget.billingId}");
    // await billingProvider.fetchBillingDetails(context, widget.billingId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<BillingProvider>(context, listen: false);

    // Debugging: Print billingId inside build method
    // print("build: widget.billingId = ${widget.billingId}");

    // Prevent crash if billings list is empty
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Received BillingId: ${widget.billingId}"),
              // Text("Fetched BillingId: $billingId"),
              Text(
                "✅",
                style: TextStyle(fontSize: 100),
              ),
              SizedBox(height: 20),
              Text(
                "Success!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Your payment was processed successfully.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.blue, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          onPressed: () {
            passBillingIdToRetrievePaymongoDetails(widget.billingId);
          },
          child: const Text("Go Back"),
        ),
      ),
    );
  }

  void passBillingIdToRetrievePaymongoDetails(int billingId) async {
    Provider.of<PaymentProvider>(context, listen: false)
        .fetchRetrievePayment(context, billingId: billingId);
  }
}
