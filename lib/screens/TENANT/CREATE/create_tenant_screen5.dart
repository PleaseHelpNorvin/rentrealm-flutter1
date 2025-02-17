import 'package:flutter/material.dart';
import 'package:signature/signature.dart'; // Import the signature package

class CreateTenantScreen5 extends StatefulWidget {
  const CreateTenantScreen5({super.key});

  @override
  State<CreateTenantScreen5> createState() => _CreateTenantScreen5State();
}

class _CreateTenantScreen5State extends State<CreateTenantScreen5> {
  // Signature controller
  final SignatureController _controller = SignatureController(
    penColor: Colors.blue,
    penStrokeWidth: 5,
    exportBackgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign your Commitment"),
        // backgroundColor: const Color(0x00f8f9ff),
        // foregroundColor: Colors.blue,

        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                      // Bold text for "Payment Obligation"
                      TextSpan(
                        text: "Payment Obligation: ",
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
                controller: _controller,
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
                    _controller.clear();
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
                  onPressed: () {
                    // You can later extract signature and send it to backend
                    print("Signature submitted!");
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
