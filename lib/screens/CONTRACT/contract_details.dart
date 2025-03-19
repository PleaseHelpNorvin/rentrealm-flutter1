import 'package:flutter/material.dart';

class ContractDetailsScreen extends StatefulWidget {
  final String contractCode;
  const ContractDetailsScreen({super.key, required this.contractCode});

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Contract Details Screen"),
      // ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("test ${widget.contractCode}"),
            ],
          ),
        ),
      ),
    );
  }
}