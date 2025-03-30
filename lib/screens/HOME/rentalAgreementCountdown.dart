import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/rentalAgreement_model.dart';

class RentalAgreementDetailsModal extends StatelessWidget {
  final RentalAgreementData data;

  const RentalAgreementDetailsModal({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rental Billing Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[700]),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(),

          // Agreement Information
          _buildDetailRow("Agreement Code:", data.rentalAgreementCode),
          _buildDetailRow(
              "Last Billing Update:", _formatDate(data.lastBillingUpdate)),
          _buildDetailRow("Your Next Billing Date:", data.nextBillingDate),
          _buildDetailRow("Remaining Days:", "${data.remainingDays} days"),
          _buildDetailRow("Billing Status:", data.billingStatus),
          _buildDetailRow("Total Amount:", "₱${data.totalAmount}"),
          _buildDetailRow("Amount Paid:", "₱${data.amountPaid}"),
          _buildDetailRow("Remaining Balance:", "₱${data.remainingBalance}"),
          Text(
            "Please be prepared for the next billing cycle and make your payment on time.\nThank you!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('MMMM dd, yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
