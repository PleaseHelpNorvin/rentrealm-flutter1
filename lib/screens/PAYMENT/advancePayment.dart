import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';

import '../../PROVIDERS/billing_provider.dart';

class AdvancePaymentScreen extends StatefulWidget {
  const AdvancePaymentScreen({super.key});

  @override
  State<AdvancePaymentScreen> createState() => _AdvancePaymentScreenState();
}

class _AdvancePaymentScreenState extends State<AdvancePaymentScreen> {
  int selectedMonths = 1; // default
  double monthlyRent = 0; // assume ₱5000 per month

  @override
  void initState() {
    super.initState();
    final billingProvider =
        Provider.of<BillingProvider>(context, listen: false);

    billingProvider.fetchLatestMonthlyRentBilling(context).then((_) {
      // After fetching billing, update monthlyRent based on billing.totalAmount
      if (billingProvider.billing != null) {
        setState(() {
          monthlyRent = billingProvider.billing!.totalAmount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = selectedMonths * monthlyRent;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advance Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Display Monthly Rent
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    'Monthly Rent: ₱${monthlyRent.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Select months to pay:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Months selection
            Container(
              width: double.infinity, // force full width
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.center, // center the chips inside
                children: [1, 2, 3, 6, 12].map((month) {
                  return ChoiceChip(
                    label: Text('$month month${month > 1 ? 's' : ''}'),
                    selected: selectedMonths == month,
                    onSelected: (selected) {
                      setState(() {
                        selectedMonths = month;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              'Total Amount:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '₱${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(), // Push button to bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // TODO: trigger PayMongo payment here
                  print(
                      'Proceed to pay ₱$totalAmount for $selectedMonths months');

                  await Provider.of<PaymentProvider>(context, listen: false)
                      .processAdvanceRentPaymongoPayment(
                          context, totalAmount, selectedMonths);
                },
                child: const Text('Proceed to Pay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // button background color
                  foregroundColor: Colors.white, // text color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // NO border radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
