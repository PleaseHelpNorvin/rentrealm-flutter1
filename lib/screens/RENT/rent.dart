import 'package:flutter/material.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {

  List<String> rent = [
    "Welcome to the app!",
    "Your profile has been updated.",
    "New message from support."
  ]; // ✅ Static rent

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate data fetching
    setState(() {
      rent = [
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
                "No Rent found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRentListCard(String notification) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue, width: 3), // ✅ 3-pixel border
        borderRadius: BorderRadius.circular(8), // ✅ Optional rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.blue),
        title: Text(notification, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
  Widget _buildRentListandPaylist() {
  return SizedBox(
    width: double.infinity, // ✅ Ensures full width
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ✅ Spaces buttons evenly
      children: [
        _buildRentButton("My Rent"),
        _buildRentButton("My Payment"),
      ],
    ),
  );
}

Widget _buildRentButton(String text) {
  return ElevatedButton(
    onPressed: () {
      print("$text tapped");
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.12,
        vertical: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(5),
      child: Text(text),
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
            _buildRentListandPaylist(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: rent.isEmpty
                    ? _buildNoDataCard()
                    : ListView.builder(
                        itemCount: rent.length,
                        itemBuilder: (context, index) {
                          return _buildRentListCard(rent[index]); // ✅ Using card widget
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
