import 'package:flutter/material.dart';

class Monthlyrentpayment extends StatefulWidget {
  final int billingId;

  const Monthlyrentpayment({super.key, required this.billingId});

  @override
  State<Monthlyrentpayment> createState() => _MonthlyrentpaymentState();
}

class _MonthlyrentpaymentState extends State<Monthlyrentpayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
