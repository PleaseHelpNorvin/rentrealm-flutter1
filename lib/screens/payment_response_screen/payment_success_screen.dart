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
  bool _isLoading = false; // Step 1

  @override
  void initState() {
    super.initState();
    print("initState: Received billingId = ${widget.billingId}");
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<BillingProvider>(context, listen: false);

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
              Text("✅", style: TextStyle(fontSize: 100)),
              SizedBox(height: 20),
              Text("Success!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Your payment was processed successfully.",
                  textAlign: TextAlign.center),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          ),
          onPressed: _isLoading
              ? null
              : () {
                  setState(() => _isLoading = true); // Step 2
                  passBillingIdToRetrievePaymongoDetails(widget.billingId);
                },
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Text("Go Back"),
        ),
      ),
    );
  }

  Future<void> passBillingIdToRetrievePaymongoDetails(int billingId) async {
    await Provider.of<PaymentProvider>(context, listen: false)
        .fetchRetrievePayment(context, billingId: billingId);

    // Optional: Navigate or do something else after loading
    setState(() => _isLoading = false);
  }
}
