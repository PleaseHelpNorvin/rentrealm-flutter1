import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rentealm_flutter/screens/PAYMENT/checkout.dart';
import 'package:signature/signature.dart';

class RentalAgreementScreen extends StatefulWidget {
  final int notifNotifiableReservationId;
  const RentalAgreementScreen({
    super.key,
    required this.notifNotifiableReservationId,
    
    });


  @override
  State<RentalAgreementScreen> createState() => _RentalAgreementScreenState();
}

class _RentalAgreementScreenState extends State<RentalAgreementScreen> {
   final SignatureController _RentalSignatureController = SignatureController(
    penColor: Colors.blue,
    penStrokeWidth: 5,
    exportBackgroundColor: Colors.white,
  );



    @override
    void dispose() {
      _RentalSignatureController.dispose();
      super.dispose();
    }
    
  @override
  Widget build(BuildContext context) {
     // Check the constructor values
    // bool isPetAccessAvailable = widget.isPetAccess ? true : false;
    // bool isWifiAvailable = widget.isWifiEnabled ? true : false;
    // bool isLaundryAvailable = widget.isLaundryAccess ? true : false;
    // bool hasPrivateFridgeAvailable = widget.hasPrivateFridge ? true : false;
    // bool hasSmartTVAvailable = widget.hasSmartTV ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: Text("rental agreement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "By signing this agreement, the renter acknowledges and agrees to the following terms:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Scrollable Text with Expanded
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Reservation_id: ${widget.notifNotifiableReservationId}",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      // Bold text for "Payment Obligation"
                      TextSpan(
                        text: "Payment Obligation:  ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      TextSpan(
                        text:
                            "The renter agrees to pay the specified rent amount on time as outlined in the payment schedule. Late payments may incur additional charges as per the terms of the agreement.\n\n",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),

                      // Bold text for "Premises Maintenance"
                      TextSpan(
                        text: "Premises Maintenance: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      TextSpan(
                        text:
                            "The renter commits to maintaining the cleanliness and condition of the rented premises. It is the renter's responsibility to keep the premises clean, including regular cleaning and disposal of trash. Any damage caused by the renter or failure to maintain cleanliness will be subject to repair or cleaning fees.\n\n",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),

                      // Bold text for "Security Deposit"
                      TextSpan(
                        text: "Security Deposit: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      TextSpan(
                        text:
                            "A security deposit has been paid to cover any damages or unpaid balances. This deposit will be returned at the end of the tenancy, provided the premises are returned in the condition they were received, excluding reasonable wear and tear.\n\n",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),

                      // Bold text for "Agreement Compliance"
                      TextSpan(
                        text: "Agreement Compliance: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      TextSpan(
                        text:
                            "The renter agrees to comply with all the rules and regulations stated in this contract. Failure to comply may result in termination of the lease and forfeiture of the security deposit.\n\n",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Signature Pad UI
            const Text(
              "Signature:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color:
                    Colors.grey[200], // Background color of the signature box
                border: Border.all(
                  color: Colors.blue, // Border color set to blue
                  width: 1, // Border width set to 1px
                ),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Signature(
                controller: _RentalSignatureController,
                height: 200,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clear button (optional)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    foregroundColor: Colors.red, // Text color
                    side: BorderSide(
                      color: Colors.red, // Border color set to blue
                      width: 1, // Border width set to 1px
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    _RentalSignatureController.clear();
                  },
                  child: const Text('Clear Signature'),
                ),
                const SizedBox(width: 20),

                // Submit button (for future use)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    foregroundColor: Colors.blue, // Text color
                    side: BorderSide(
                      color: Colors.blue, // Border color set to blue
                      width: 1, // Border width set to 1px
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () async {
                    // Capture the signature as an Image object
                  var signatureImage = await _RentalSignatureController.toImage();

                  // Convert the Image to ByteData
                  var byteData = await signatureImage!.toByteData(format: ImageByteFormat.png);
                
                if (byteData != null) {
                  // Convert the ByteData into List<int>
                  final imageBytes = byteData.buffer.asUint8List();

                  // Get the app's document directory
                  final directory = await getApplicationDocumentsDirectory();
                  final file = File('${directory.path}/signature.png');

                  // Write the image bytes to a file
                  await file.writeAsBytes(imageBytes);

                  print("Signature saved to file: $file");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        reservationId: widget.notifNotifiableReservationId,
                        signaturePngString: file, // Pass the File instead of String
                      ),
                    ),
                  );
                }
              },

                  child: const Text('Submit Signature'),

                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}