import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';
import 'package:rentealm_flutter/models/payment_model.dart';
import 'package:rentealm_flutter/screens/CONTRACT/contract_details.dart';
import 'package:rentealm_flutter/screens/CONTRACT/receipt_details.dart';
import '../../PROVIDERS/rentalAgreement_provider.dart';
import '../../models/rentalAgreement_model.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  bool isShowingContracts = true; // Toggle between contracts & receipts

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RentalagreementProvider>(context, listen: false)
          .fetchIndexRentalAgreement(context);

      Provider.of<PaymentProvider>(context, listen: false)
          .fetchReceiptsByProfileId(context);
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate data fetching
    setState(() {}); // Refresh UI
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton("Contracts", true),
          SizedBox(width: 10),
          _buildButton("Receipts", false),
        ],
      ),
    );
  }

  Widget _buildButton(String text, bool showContracts) {
    bool isSelected = (isShowingContracts == showContracts);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isShowingContracts = showContracts;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: Colors.blue),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildNoDataCard(String message) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 50, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractListCard(RentalAgreement contract) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContractDetailsScreen(contractCode: contract.agreementCode),
          ),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          leading: Icon(Icons.list, color: Colors.blue),
          title: Text(contract.agreementCode ?? "No Title",
              style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildReceiptListCard(Receipt receipt) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReceiptDetailsScreen(
                    paymongoPaymentReference: receipt.paymongoPaymentReference,
                    receiptUrl: receipt.receiptUrl,
                  )),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          leading: Icon(Icons.receipt_long, color: Colors.green),
          title: Text(receipt.paymongoPaymentReference,
              style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            _buildToggleButtons(), // ✅ Buttons for switching
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: Consumer<PaymentProvider>(
                  builder: (context, paymentProvider, child) {
                    final receipts = paymentProvider
                        .receipts; // ✅ Get receipts from provider

                    if (isShowingContracts) {
                      return Consumer<RentalagreementProvider>(
                        builder: (context, rentalAgreementProvider, child) {
                          final contracts =
                              rentalAgreementProvider.rentalAgreements;

                          return contracts.isEmpty
                              ? _buildNoDataCard("No contracts found")
                              : ListView.builder(
                                  itemCount: contracts.length,
                                  itemBuilder: (context, index) {
                                    return _buildContractListCard(
                                        contracts[index]);
                                  },
                                );
                        },
                      );
                    } else {
                      return receipts.isEmpty
                          ? _buildNoDataCard("No receipts found")
                          : ListView.builder(
                              itemCount: receipts.length,
                              itemBuilder: (context, index) {
                                return _buildReceiptListCard(receipts[index]);
                              },
                            );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
