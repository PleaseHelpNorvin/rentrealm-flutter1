import 'package:flutter/material.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  bool isShowingApartments = true; // ✅ Tracks which list is displayed

  List<String> apartments = [
    "Apartment 1 - Available",
    "Apartment 2 - Rented",
    "Apartment 3 - Available",
  ];

  List<String> reservations = [
    "Reservation 101 - Pending",
    "Reservation 102 - Confirmed",
  ];

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate data fetching
    setState(() {
      apartments = [
        "Apartment 4 - Available",
        "Apartment 5 - Rented"
      ];
      reservations = [
        "Reservation 103 - Canceled",
        "Reservation 104 - Pending"
      ];
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
                "No Data Found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(String text) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ListTile(
        leading: Icon(Icons.home, color: Colors.blue),
        title: Text(text, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildRentListAndPaylist() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildApartmentButton("Apartments"),
          _buildReservationButton("Reservations"),
        ],
      ),
    );
  }

  Widget _buildApartmentButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isShowingApartments = true; // ✅ Show Apartments List
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isShowingApartments ? Colors.blue : Colors.white,
        foregroundColor: isShowingApartments ? Colors.white : Colors.blue,
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

  Widget _buildReservationButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isShowingApartments = false; // ✅ Show Reservations List
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: !isShowingApartments ? Colors.blue : Colors.white,
        foregroundColor: !isShowingApartments ? Colors.white : Colors.blue,
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
            _buildRentListAndPaylist(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: (isShowingApartments ? apartments : reservations).isEmpty
                    ? _buildNoDataCard()
                    : ListView.builder(
                        itemCount: isShowingApartments ? apartments.length : reservations.length,
                        itemBuilder: (context, index) {
                          return _buildListCard(
                            isShowingApartments ? apartments[index] : reservations[index],
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
