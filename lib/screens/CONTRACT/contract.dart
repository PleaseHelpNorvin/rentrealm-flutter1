import 'package:flutter/material.dart';

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

  Widget _buildcontractListCard(String notification) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue, width: 3), // ✅ 3-pixel border
        borderRadius: BorderRadius.circular(8), // ✅ Optional rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ListTile(
        leading: Icon(Icons.list, color: Colors.blue),
        title: Text(notification, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: contract.isEmpty
                    ? _buildNoDataCard()
                    : ListView.builder(
                        itemCount: contract.length,
                        itemBuilder: (context, index) {
                          return _buildcontractListCard(contract[index]); // ✅ Using card widget
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
