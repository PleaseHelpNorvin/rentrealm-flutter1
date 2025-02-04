import 'package:flutter/material.dart';

class CreateTenantScreen1 extends StatefulWidget {
  const CreateTenantScreen1({super.key});

  @override
  State<CreateTenantScreen1> createState() => _CreateTenantScreen1State();
}

class _CreateTenantScreen1State extends State<CreateTenantScreen1> {
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
        padding: EdgeInsets.all(10), // Padding around the whole body
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
                style: TextStyle(
                  color: Colors.white, // Set text color to white
                ),
                decoration: InputDecoration(
                  hintText: "Search Apartment...",
                  hintStyle: TextStyle(
                    color: Colors.white, // Set the color of the hint text
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white,),
                ),
              ),
            ),

            SizedBox(height: 10), // Space between search bar and list

            // Apartment List
            Expanded(
              child: Container(
                color: Color(0xFFDAEFFF), // Background color (optional)
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10), // Adds padding on left and right
                  shrinkWrap: true, // Prevent ListView from taking up extra space
                  itemCount: 21, // Replace with actual apartment count
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      color: Color(0xff2196F3),
                      child: Padding(
                        padding: EdgeInsets.all(10), // Padding inside the Card
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text with the top
                          children: [
                            // Left Side: Apartment Image
                            Container(
                              width: 150, // Fixed width for image
                              height: 180, // Fixed height for image
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // border: Border.all(),
                                image: DecorationImage(
                                  image: AssetImage("assets/images/rentrealm_logo.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10), // Space between image and text

                            // Right Side: Apartment Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Part: Apartment ID
                                  Text(
                                    "Apartment-12312312",  // Apartment ID
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFDAEFFF), // Heading style
                                    ),
                                  ),
                                  SizedBox(height: 5),

                                  // Middle Part: Apartment details (Girls Only, Available, Location)
                                   Text(
                                    "Appartment",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFDAEFFF), // To highlight specific details
                                    ),
                                  ),

                                  Text(
                                    "Girls Only",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFF005D), // To highlight specific details
                                    ),
                                  ),
                                  Text(
                                    "Available",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF00FF26), // Mark as available
                                    ),
                                  ),
                                  Text(
                                    "Saac 1 Buaya Lapu Lapu City\nCebu 6015",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFDAEFFF), // Light grey color for location
                                    ),
                                    maxLines: 3
                                  ),
                                  SizedBox(height: 10), // Space between details and buttons

                                  // Bottom Part: Two clickable boxes (acting as buttons)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Action for the button
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            backgroundColor: Color(0xFFDAEFFF), // Button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5), // Set the border radius
                                            ),
                                          ),

                                          child: Icon(
                                            Icons.pin_drop, // Google Map pin icon
                                            color: Color(0xff2196F3), // Icon color
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10), // Space between the two buttons
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Action for second button
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            backgroundColor: Color(0xff2196F3), // Button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5), // Set the border radius
                                            ),
                                          ).copyWith(
                                            side: MaterialStateProperty.all(BorderSide(
                                              color: Color(0xFFDAEFFF), // Border color
                                              width: 2, // Border width
                                            )),
                                          ),

                                          child: Text(
                                            "Contact",
                                            style: TextStyle(color: Colors.white),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
