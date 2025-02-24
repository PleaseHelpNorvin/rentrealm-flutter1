import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/models/property_model.dart';
import '../PROVIDERS/property_provider.dart';
import '../screens/property_map_screen.dart';
import 'package:rentealm_flutter/screens/outer_create_tenant_screen2.dart';

class OuterCreateTenantScreen1 extends StatefulWidget {
  const OuterCreateTenantScreen1({super.key});

  @override
  State<OuterCreateTenantScreen1> createState() =>
      _OuterCreateTenantScreen1State();
}

class _OuterCreateTenantScreen1State extends State<OuterCreateTenantScreen1> {
  final double staticLat = 10.315397; //remove for dynamic use
  final double staticLong = 123.997458;

  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  String selectedGender = ''; // Class-level variable to store gender selection
  String selectedType = "";
  bool? isPet;

  // Map<int, bool> cardStates = {}; // Track state for each card

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<PropertyProvider>(context, listen: false)
        .fetchProperties(context));
  }

  Widget _buildSearchBar() {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    // final properties = propertyProvider.searchProperties;
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
              controller: _searchController,
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
                propertyProvider.searchForProperties(value);
                // setState(() {
                //   searchQuery = value.toLowerCase();
                // });
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
      isScrollControlled: true,
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Gender",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Icon(Icons.male),
                            value: "boys-only",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setModalState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Icon(Icons.female),
                            value: "girls-only",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setModalState(() {
                                selectedGender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Select Property Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSelectableBox(setModalState, "apartment"),
                        SizedBox(width: 10),
                        _buildSelectableBox(setModalState, "house"),
                        SizedBox(width: 10),
                        _buildSelectableBox(setModalState, "boarding-house"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Pet preference",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text("Yes, I'm fine with pets around",
                                style: TextStyle(fontSize: 11)),
                            value: true,
                            groupValue: isPet,
                            onChanged: (value) {
                              setModalState(() {
                                isPet = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text("No, I'd prefer a pet-free place",
                                style: TextStyle(fontSize: 11)),
                            value: false,
                            groupValue: isPet,
                            onChanged: (value) {
                              setModalState(() {
                                isPet = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          print("Selected Gender: $selectedGender");
                          print("Selected Type: $selectedType");
                          print("IsPet?: $isPet");

                          // 🔥 APPLY FILTERS AFTER CLOSING MODAL
                          Provider.of<PropertyProvider>(context, listen: false)
                              .filterProperties(
                                  selectedGender, selectedType, isPet);
                        },
                        child: Text("Apply Filters"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPropertyList() {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final properties = propertyProvider.searchProperties;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: properties.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No properties found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  return _buildPropertyCard(properties[index], context);
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final properties = propertyProvider.searchProperties;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Realm'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
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
            _buildSearchBar(), // Search bar at the top
            // SizedBox(height: 5),

            // Title Section
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Property",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildPropertyList()
          ],
        ),
      ),
    );
  }

  // void _toggleCardState(int index) {
  //   setState(() {
  //     cardStates[index] = !(cardStates[index] ?? false); // Toggle state
  //   });
  // }

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

  Widget _buildSelectableBox(Function setModalState, String type) {
    return GestureDetector(
      onTap: () {
        setModalState(() {
          selectedType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: selectedType == type ? Colors.blue : Colors.white,
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: selectedType == type ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget _buildSearchBar(PropertyProvider propertyProvider) {
  //   return Container(
  //     padding: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       color: Color(0xFF2196F3),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: _searchController,
  //             style: TextStyle(color: Colors.white),
  //             decoration: InputDecoration(
  //               hintText: "Search Location.",
  //               hintStyle: TextStyle(color: Colors.white),
  //               border: InputBorder.none,
  //               prefixIcon: Icon(Icons.search, color: Colors.white),
  //               contentPadding:
  //                   EdgeInsets.symmetric(vertical: 12), // Adjust padding here
  //             ),
  //             onChanged: (value) {
  //               setState(() {
  //                 searchQuery = value.toLowerCase();
  //               });
  //             },
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.filter_list, color: Colors.white),
  //           onPressed: _showFilterDialog,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPropertyCard(Property property, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Card tapped");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OuterCreateTenantScreen2(),
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
                    height: 195, // Adjust height as needed
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 9), // Space between image and text
                // Text Section on the Right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Gender allowed: ${property.genderAllowed}",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Type: ${property.type}",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Status: ${property.status}",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Location: ${property.address.line1} ${property.address.line2} ${property.address.province} ${property.address.postalCode}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Button Section
                      InkWell(
                        onTap: () {
                          print("Button location");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyMapScreen(
                                  lat: 10.315397,
                                  long: 123.997458,
                                  propertyName: "test"),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_on, // Flutter location icon
                              color: Colors.blue, // Set color
                              size: 24, // Set size
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildBooleanCard(int index) {
  //   bool isActive = cardStates[index] ?? false; // Get current state

  //   return GestureDetector(
  //     onTap: () => _toggleCardState(index), // Toggle when tapped
  //     child: Card(
  //       color:
  //           isActive ? Colors.blue : Colors.white, // Blue = true, White = false
  //       elevation: 5,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //         side: BorderSide(
  //           color: Colors.blue, // Add border to make it visible when inactive
  //           width: 2,
  //         ),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.all(5),
  //         child: Center(
  //           child: Text(
  //             isActive ? "PETS ALLOWED" : "NO PETS ALLOWED", // Display state
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: isActive
  //                   ? Colors.white
  //                   : Colors.blue, // White when active, Blue when inactive
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final propertyProvider = Provider.of<PropertyProvider>(context);
  //   final properties = propertyProvider.properties;

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Rent Realm'),
  //       backgroundColor: Colors.blue,
  //       foregroundColor: Colors.white,
  //       automaticallyImplyLeading: false,
  //       actions: [
  //         IconButton(
  //           icon: Icon(Icons.menu),
  //           onPressed: () => _showMenu(context),
  //         ),
  //       ],
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(5),
  //       child: Column(
  //         children: [
  //           _buildSearchBar(), // Search bar at the top
  //           // SizedBox(height: 5),

  //           // Title Section
  //           Padding(
  //             padding: EdgeInsets.only(left: 10, right: 10, top: 10),
  //             child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 "Property",
  //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //           // SizedBox(height: 5),

  //           // Property Cards List (Expanded to take all available space)
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(10),
  //               child: ListView.builder(
  //                 itemCount: properties.length,
  //                 itemBuilder: (context, index) {
  //                   return _buildPropertyCard(properties[index], context);
  //                 },
  //                 scrollDirection:
  //                     Axis.vertical, // Enables horizontal scrolling
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
