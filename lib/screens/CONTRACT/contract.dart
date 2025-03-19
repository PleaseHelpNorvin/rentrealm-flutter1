import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/screens/CONTRACT/contract_details.dart';

// import '../../Models/rentalAgreement_model.dart';
import '../../PROVIDERS/rentalAgreement_provider.dart';
import '../../models/rentalAgreement_model.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  List<String> contract = [
    "Welcome to the app!",
    "Your profile has been updated.",
    "New message from support."
  ]; // ✅ Static contract

  @override
  void initState() {
    super.initState();
    print("contract screen Initialized!");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rentalAgreementProvider =
          Provider.of<RentalagreementProvider>(context, listen: false);
      rentalAgreementProvider.fetchIndexRentalAgreement(context);
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate data fetching
    setState(() {
      contract = [
        "New system update available!",
        "Reminder: Check your tasks"
      ]; // Simulated new data
    });
  }

  Widget _buildNoDataCard() {
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
                "No contract found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildcontractListCard(RentalAgreement contract) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              ContractDetailsScreen(contractCode: contract.agreementCode),
            )
        
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
              style: TextStyle(fontSize: 16)), // Assuming `title` exists
          // subtitle: Text(contract.description ??
          //     "No Description"), // Assuming `description` exists
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
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: Consumer<RentalagreementProvider>(
                  // ✅ Correct: Using the Provider
                  builder: (context, rentalAgreementProvider, child) {
                    final contracts = rentalAgreementProvider
                        .rentalAgreements; // Get the list from provider

                    if (contracts.isEmpty) {
                      return _buildNoDataCard();
                    }

                    return ListView.builder(
                      itemCount: contracts.length,
                      itemBuilder: (context, index) {
                        return _buildcontractListCard(
                            contracts[index]); // ✅ Using card widget
                      },
                    );
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
