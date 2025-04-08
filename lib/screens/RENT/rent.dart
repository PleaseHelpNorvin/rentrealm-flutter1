import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/reservation_provider.dart';
import 'package:rentealm_flutter/screens/RENT/inner_create_tenant_screen1.dart';
import 'package:rentealm_flutter/screens/RENT/reservation_details.dart';

import '../../PROVIDERS/property_provider.dart';
import '../../models/property_model.dart';
import '../../models/reservation_model.dart';
import '../property_map_screen.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  bool isShowingApartments = true; // ✅ Tracks which list is displayed
  //filter init stuffs
  String searchQuery = '';
  TextEditingController _searchController = TextEditingController();
  String selectedType = "";
  String selectedGender = '';
  bool? isPet;

  @override
  void initState() {
    super.initState();
      Future.microtask(() {
        Provider.of<PropertyProvider>(context, listen: false).fetchProperties(context);
        Provider.of<ReservationProvider>(context, listen: false).fetchReservations(context);
      });
  }
  
  // List<String> reservations = [
  //   "Reservation 1",
  //   "Reservation 2",
  //   "Reservation 3",
  //   "Reservation 4",
  // ];

  Future<void> _refreshData() async {
    await Provider.of<PropertyProvider>(context, listen: false).fetchProperties(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            _buildAprtmantsListandReservationsList(),
            if (isShowingApartments) _buildSearchBar(), // Only show in apartments

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: isShowingApartments
                    ? _buildApartmentList()
                    : _buildReservationList(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildApartmentList() {
  return Consumer<PropertyProvider>(
    builder: (context, propertyProvider, child) {
      if (propertyProvider.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (propertyProvider.properties.isEmpty) {
        return _buildNoDataCard();
      }

      return ListView.builder(
        itemCount: propertyProvider.properties.length,
        itemBuilder: (context, index) {
          return _buildApartmentCard(propertyProvider.properties[index]);
        },
      );
    },
  );
}


  Widget _buildApartmentCard(Property property) {
    return GestureDetector(
      onTap: () {
        print("_buildApartmentCard Tapped!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  
            InnerCreateTenantScreen1(propertyId: property.id)
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: property.propertyPictureUrl.isNotEmpty 
                  ? CachedNetworkImage(
                      imageUrl: property.propertyPictureUrl.first,
                      fit: BoxFit.cover,
                      width: 150, // Adjust width as needed
                      height: 195, // Adjust height as needed
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                        Center(
                          child: Text(
                            'Failed to load image ${property.propertyPictureUrl.first}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red),
                          ),
                        ),
                    )
                   : Image.asset(
                        'assets/images/rentrealm_logo.png',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 180,
                      ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(property.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Gender allowed: ",
                              style: TextStyle(color: Colors.white), // Default color for "Gender allowed: "
                            ),
                            TextSpan(
                              text: property.genderAllowed,
                              style: TextStyle(
                                color: property.genderAllowed == 'boys-only'
                                    ? Colors.cyanAccent // Color for 'boy'
                                    : property.genderAllowed == 'girls-only'
                                        ? Colors.pink // Color for 'girl'
                                        : Colors.white, // Default color if gender is something else
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Type: ${property.type}", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Status: ",
                              style: TextStyle(color: Colors.white), // Default color for "Status:"
                            ),
                            TextSpan(
                              text: property.status,
                              style: TextStyle(
                                color: property.status == 'vacant'
                                    ? Colors.lightGreenAccent // Color for 'vacant'
                                    : property.status == 'full'
                                        ? Colors.red // Color for 'full'
                                        : Colors.white, // Default color if status is something else
                              ),
                            ),
                          ],
                        ),
                      ),                      
                      SizedBox(height: 5),
                      Text("Location: ${property.address.line1} ${property.address.line2} ${property.address.province} ${property.address.postalCode}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyMapScreen(lat: 10.315397, long: 123.997458, propertyName: "test"),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Icon(Icons.location_on, color: Colors.blue, size: 24),
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

    Widget _buildSearchBar() {
    return Padding(padding: EdgeInsets.only(top:  10, bottom: 0, left: 10,right: 10),
      child: Container(
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
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                final propertyProvider =
                    Provider.of<PropertyProvider>(context, listen: false);

                if (value.isEmpty) {
                  propertyProvider.clearSearch(); // Restore full list
                } else {
                  propertyProvider.searchForProperties(value);
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
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


Widget _buildReservationList() {
  return Consumer<ReservationProvider>(
    builder: (context, reservationProvider, child) {
      final reservations = reservationProvider.reservationList; // Get reservations

      if (reservations!.isEmpty) {
        return _buildNoDataCard();
      }

      return ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return _buildReservationCard(reservations[index]); // Adjust based on your data structure
        },
      );
    },
  );
}


  Widget _buildReservationCard(Reservation reservation) {
    return GestureDetector(
      onTap: () {
        print('Reservation tapped: ${reservation.reservationCode}');
        // Example: Navigate to reservation details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationDetails(reservationId: reservation.id),
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
          leading: Icon(Icons.home, color: Colors.blue),
          title: Text(
            'Reservation Code: ${reservation.reservationCode}',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text('Status: ${reservation.status}'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
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
  

  Widget _buildAprtmantsListandReservationsList() {
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

  


}
