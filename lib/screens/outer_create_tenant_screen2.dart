import 'package:flutter/material.dart';
import 'package:rentealm_flutter/screens/outer_create_tenant_screen3.dart';

class OuterCreateTenantScreen2 extends StatefulWidget {
  const OuterCreateTenantScreen2({super.key});

  @override
  State<OuterCreateTenantScreen2> createState() =>
      _OuterCreateTenantScreen2State();
}

class _OuterCreateTenantScreen2State extends State<OuterCreateTenantScreen2> {
  String searchQuery = '';

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Location.",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.white),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12), // Adjust padding here
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Adjusts modal height dynamically
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Prevents unnecessary stretching
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Gender",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("test"),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome to Rent Realm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Divider(),
              ListTile(
                leading: Icon(Icons.login, color: Colors.blue),
                title: Text("Login"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.app_registration, color: Colors.green),
                title: Text("Register"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/register');
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPropertyCard() {
    return GestureDetector(
      onTap: () {
        print("Card tapped");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OuterCreateTenantScreen3(),
          ),
        );
      },
      child: SizedBox(
        width: 350,
        child: Card(
          color: Colors.blue,
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section on the Left
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/getstartbg2.jpg',
                    width: 150, // Adjust width as needed
                    height: 130, // Adjust height as needed
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 9), // Space between image and text
                // Text Section on the Right
                Expanded(
                    child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Room Code",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Category: zdasdasdas",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Room Status: test test apartment",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Rent Price: ₱123/month",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rooms"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _showMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            // _buildSearchBar(),
            // Padding(
            //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       "Room",
            //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    _buildPropertyCard(),
                    SizedBox(width: 10),
                    _buildPropertyCard(),
                    SizedBox(width: 10),
                    _buildPropertyCard(),
                    // SizedBox(width: 10),
                    // _buildPropertyCard(),
                    // SizedBox(width: 10),
                    // _buildPropertyCard(),
                    // SizedBox(width: 10),
                    // _buildPropertyCard(),
                    // SizedBox(width: 10),
                    // _buildPropertyCard(),
                    // SizedBox(width: 10),
                    // _buildPropertyCard(),
                    // SizedBox(width: 10),
                    // _buildPropertyCard(),
                    // SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
