import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentealm_flutter/MODELS/room_model.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';
import 'package:rentealm_flutter/SCREENS/TENANT/CREATE/create_tenant_screen3.dart';
import 'package:rentealm_flutter/SCREENS/TENANT/CREATE/create_tenant_screen4.dart';
import 'package:rentealm_flutter/SCREENS/TENANT/CREATE/create_tenant_screen5.dart';

import '../../../PROVIDERS/property_provider.dart';
import '../../../models/property_model.dart';

class CreateTenantScreen6 extends StatefulWidget {
  //Billing UI
  final int roomId;

  final bool isPetAccess;

  final bool isWifiEnabled;
  final double wifiCharge;

  final bool isLaundryAccess;
  final double laundryCharge;

  final bool hasPrivateFridge;
  final double privateFridgeCharge;

  final bool hasSmartTV;
  final double smartTVCharge;

  final String? signatureSvg;

  const CreateTenantScreen6({
    super.key, 
    required this.roomId,

    required this.isPetAccess,
    
    required this.isWifiEnabled,
    required this.wifiCharge,

    required this.isLaundryAccess,
    required this.laundryCharge,

    required this.hasPrivateFridge,
    required this.privateFridgeCharge,

    required this.hasSmartTV,
    required this.smartTVCharge,

    required this.signatureSvg,

  });

  @override
  State<CreateTenantScreen6> createState() => _CreateTenantScreen6State();
}

class _CreateTenantScreen6State extends State<CreateTenantScreen6> {
  String? selectedStartDate;
  int? selectedDuration;
  final List<int> durationOptions = [1, 2, 3, 6, 12];
  Property? fetchedProperty;


  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<RoomProvider>(context, listen: false)
        .fetchRoomById(context, widget.roomId));

    // Fetch Property Data
    Future.microtask(() async {
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      Property? property = await propertyProvider.fetchPropertyById(context, 2);

      if (property != null) {
        setState(() {
          fetchedProperty = property; // Update the class-level variable
        });
        print("Fetched Property: ${fetchedProperty?.name}");
        print("Property ID: ${fetchedProperty?.id}");
      } else {
        print("Failed to fetch property.");
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Consumer<RoomProvider>(
          builder: (context, roomProvider, child) {
            final Room? room = roomProvider.singleRoom;

            if (room == null) {
              return const Center(child: CircularProgressIndicator());
            } 

            // return Consumer<PropertyProvider>(
            //   builder: (context, propertyProvider, child) {
            //  final Property? property = propertyProvider.property;



            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Align to the left
                          children: [
                            Text(
                              "Selected Room:",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Card(
                        color: const Color(0xff2196F3),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: room.roomPictureUrls.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: room.roomPictureUrls.first,
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Text(
                                                    'Image Not Available')),
                                      )
                                    : Image.asset(
                                        "assets/images/rentrealm_logo.png",
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Align text to the start
                                  children: [
                                    Text(
                                      room.roomCode,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDAEFFF),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      room.roomDetails,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFDAEFFF),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "₱ ${room.rentPrice} / Month",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDAEFFF),
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            10), // Add spacing between text and button
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateTenantScreen3(
                                                          roomId:
                                                              widget.roomId)));
                                        },
                                        child: const Text("View Details"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.white, // Button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                3), // Set border radius to 3
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Align to the left
                          children: [
                            Text(
                              "Select Rental Duration:",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: selectedDuration,
                          hint: const Text(
                            "Choose Duration",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                          items: durationOptions.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("${value.toString()} Month"),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedDuration = newValue;
                              print("Selected Duration: $selectedDuration");
                            });
                          },
                          underline: Container(),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Align to the left
                          children: [
                            Text(
                              "Select Rental Start Date:",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller:
                              TextEditingController(text: selectedStartDate),
                          decoration: const InputDecoration(
                            hintText: "Pick a date",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.blueAccent),
                          ),
                          style: const TextStyle(color: Colors.blueAccent),
                          readOnly: true, // To prevent manual input
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedStartDate = "${pickedDate.toLocal()}"
                                    .split(' ')[0]; // Format the date
                              });
                              print("Selected Start Date: $selectedStartDate");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Set the background color here
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Rent Summary",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // Text color white for contrast
                                ),
                              ),
                            ),
                            //divider underline
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                            //property
                            // if (property != null) 
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Text(
                                      "Property: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, 
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      fetchedProperty?.name ?? 'No Property Name',  
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white, 
                                      ),
                                    )
                                  ],
                                ),
                              ),


                            //address
                            const SizedBox(height: 5),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Text(
                                      "Address: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${fetchedProperty?.address.line1 ?? 'No Property Name'} ${fetchedProperty?.address.line2 ?? 'No Property Name'} ${fetchedProperty?.address.province?? 'no province'}  ${fetchedProperty?.address.postalCode}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),
                            //Room
                            const SizedBox(height: 5),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Text(
                                      "Room: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      room.roomCode,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),

                            //divider underline
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                            //Move in date
                            const SizedBox(height: 5),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Move in Date: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "data",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),
                            //rent price
                            const SizedBox(height: 5),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Text(
                                      "Rent Price: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      room.rentPrice.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),
                            //Lease Duration
                            const SizedBox(height: 5),
                             Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Room Minimum Lease Duration: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                     room.minLease.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),

                                 const SizedBox(height: 5),
                             Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "My Rent Lease Duration: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      this.selectedDuration.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),

                            //divider underline
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),

                            const SizedBox(height: 5),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Prorated Rent (January): ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "data",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),
                            //ADVANCE PAYMENT(February)
                            const SizedBox(height: 5),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      "Advance Payment (February): ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "data",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors
                                            .white, // Text color white for contrast
                                      ),
                                    )
                                  ],
                                )),

                            //divider underline
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                            //Total
                            const SizedBox(height: 5),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "Total Payment: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white, // Text color white for contrast
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "data",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors
                                          .white, // Text color white for contrast
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width:
                      double.infinity, // Ensure the container takes full width
                  height: MediaQuery.of(context).size.height *
                      0.08, // Adjust height as necessary
                  color: Colors.blue, // Parent container color
                  child: Container(
                    margin: const EdgeInsets.all(
                        10), // Add margin instead of padding
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CreateTenantScreen5(roomId: widget.roomId)
                        //   ),
                        // );
                        print("FROM BIILING UI SCREEN");
                        print("=======================");
                        print("roomId: ${widget.roomId}");
                        print("isPetAccess: ${widget.isPetAccess}");
                        print("isWifiEnabled: ${widget.isWifiEnabled}");
                        print("wifiCharge: ${widget.wifiCharge}");
                        print("isLaundryAccess: ${widget.isLaundryAccess}");
                        print("laundryCharge: ${widget.laundryCharge}");
                        print("hasPrivateFridge: ${widget.hasPrivateFridge}");
                        print("privateFridgeCharge: ${widget.privateFridgeCharge}");
                        print("hasSmartTV: ${widget.hasSmartTV}");
                        print("smartTVCharge: ${widget.hasSmartTV}");
                        print("signatureSvg: ${widget.signatureSvg}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set button background to white
                        foregroundColor: Colors.blue, // Button text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: Colors.blue,
                              width: 2), // Blue border with width 2
                        ),
                        minimumSize: Size(double.infinity,
                            50), // Forces the button to fill the width
                      ),
                      child: const Text("Pay Now"),
                    ),
                  ),
                )
              ],
            );
          },
        )),
      );
  }
}
