import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../PROVIDERS/inquiry_provider.dart';
import '../../PROVIDERS/rentalAgreement_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String signatureSvgString;
  final int inquiryId;
  const CheckoutScreen({
    super.key,
    required this.inquiryId,
    required this.signatureSvgString, 
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
    
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inquiryProvider =
          Provider.of<InquiryProvider>(context, listen: false);
      inquiryProvider.fetchInquiryById(context, widget.inquiryId);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<InquiryProvider>(context, listen: false);
    final int? inquiryRoomId = inquiryProvider.inquiry?.data.inquiries.single.roomId;

    if (inquiryRoomId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loader if data is not available
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBoldText("inquiryId: ", "${widget.inquiryId}"),
              _buildBoldText("rent_start_date: ", "${inquiryProvider.inquiry?.data.inquiries.single.acceptedAt}"),
              _buildBoldText("rent_price: ", "${inquiryProvider.inquiry?.data.inquiries.single.rentPrice}"),
              _buildBoldText("deposit: ", ""),
              _buildBoldText("signatureSvgString: ", widget.signatureSvgString),
              _buildBoldText("inquiryRoomId: ", inquiryRoomId.toString()), // Fixed issue here
            ],
          ),
        ), 
      ),
    );
  }

  Widget _buildBoldText(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
