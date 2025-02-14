

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentealm_flutter/SCREENS/TENANT/CREATE/property_map_screen.dart';

import '../../../MODELS/property_model.dart';
import '../../../PROVIDERS/property_provider.dart';
import '../../../PROVIDERS/room_provider.dart';
import 'create_tenant_screen2.dart';

class CreateTenantScreen1 extends StatefulWidget {
  const CreateTenantScreen1({super.key});

  @override
  State<CreateTenantScreen1> createState() => _CreateTenantScreen1State();
}

class _CreateTenantScreen1State extends State<CreateTenantScreen1> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch properties when the screen initializes
    Future.microtask(() => Provider.of<PropertyProvider>(context, listen: false)
        .fetchProperties(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Apartment"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // Search Bar
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search Apartment...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            SizedBox(height: 10),

            // Apartment List
            Expanded(
              child: Container(
                color: Color(0xFFDAEFFF), // Background color
                child: Consumer<PropertyProvider>(
                  builder: (context, propertyProvider, child) {
                    final properties = propertyProvider.properties
                        .where((property) =>
                            property.name.toLowerCase().contains(searchQuery) ||
                            property.status.toLowerCase().contains(searchQuery) ||
                            property.genderAllowed.toLowerCase().contains(searchQuery) ||
                            property.address.line1.toLowerCase().contains(searchQuery) ||
                            property.address.line2.toLowerCase().contains(searchQuery) ||
                            property.address.province.toLowerCase().contains(searchQuery) ||
                            property.address.postalCode.toLowerCase().contains(searchQuery)
                        ).toList();

                    if (properties.isEmpty) {
                      return Center(
                        child: Text(
                          "No apartments available.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shrinkWrap: true,
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          color: Color(0xff2196F3),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Apartment Image
                                Container(
                                  width: 150,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: property.propertyPictureUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: property.propertyPictureUrl,
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 180,
                                          placeholder: (context, url) => Center(
                                            child:
                                                CircularProgressIndicator(), // Shows while loading
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Text(
                                              'Failed to load image',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          fadeInDuration:
                                              Duration(milliseconds: 500),
                                        )
                                      : Image.asset(
                                          'assets/images/rentrealm_logo.png',
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 180,
                                        ),
                                ),

                                SizedBox(width: 10),

                                // Apartment Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Apartment-${property.name}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDAEFFF),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        property.type ,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFDAEFFF),
                                        ),
                                      ),
                                      Text(
                                        genderLabels[property.genderAllowed] ??
                                            "unknown",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: genderColors[
                                                  property.genderAllowed] ??
                                              Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        statusLabels[property.status] ??
                                            "Unknown",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              statusColors[property.status] ??
                                                  Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "${property.address.line1} ${property.address.line2} ${property.address.province} ${property.address.postalCode}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFDAEFFF),
                                        ),
                                        maxLines: 3,
                                      ),
                                      SizedBox(height: 10),

                                      // Buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                              
                                                Navigator.push(
                                                  context, 
                                                  MaterialPageRoute(
                                                    builder: (context) => 
                                                    PropertyMapScreen(
                                                      lat: property.address.lat, 
                                                      long: property.address.long,
                                                      propertyName: property.name,
                                                    )
                                                  )
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                backgroundColor:
                                                    Color(0xFFDAEFFF),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.pin_drop,
                                                color: Color(0xff2196F3),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                final roomProvider =
                                                    Provider.of<RoomProvider>(
                                                        context,
                                                        listen: false);
                                                await roomProvider.fetchRoom(
                                                    context, property.id);
                                                if (roomProvider
                                                    .room.isNotEmpty) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CreateTenantScreen2(
                                                              propertyId:
                                                                  property.id),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            "No rooms available for this property")),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                backgroundColor:
                                                    Color(0xff2196F3),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                side: BorderSide(
                                                  color: Color(0xFFDAEFFF),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                "Rooms",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
