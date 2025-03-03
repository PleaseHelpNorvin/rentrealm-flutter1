import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/inquiry_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/tenant_provider.dart';
import 'package:rentealm_flutter/screens/homelogged.dart';

import 'PAYMENT/rental_agreement.dart';

class OuterCreateTenantScreen4 extends StatefulWidget {
  final int roomId;
  final int profileId;

  const OuterCreateTenantScreen4({super.key, 
    required this.roomId,
    required this.profileId,
  });

  @override
  State<OuterCreateTenantScreen4> createState() => _OuterCreateTenantScreen4State();
}

class _OuterCreateTenantScreen4State extends State<OuterCreateTenantScreen4> {
  bool _isPetAccess = false;
  bool _isWifiEnabled = false;
  bool _isLaundryAccess = false;
  bool _hasPrivateFridge = false;
  bool _hasSmartTV = false;

  double wifiCharge = 50.0;
  double laundryCharge = 30.0;
  double privateFridgeCharge = 40.0;
  double smartTVCharge = 1160.0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Preferences"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet Access
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pets,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "PET ACCESS?",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Switch(
                    value: _isPetAccess,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isPetAccess = newValue;
                      });
                    },
                  ),
                ),

                // Wifi Enabled
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "WIFI ENABLED? (Charged: ₱$wifiCharge)",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Switch(
                    value: _isWifiEnabled,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isWifiEnabled = newValue;
                      });
                    },
                  ),
                ),

                // Laundry Access
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_laundry_service,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "LAUNDRY ACCESS? (Charged: ₱$laundryCharge)",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Switch(
                    value: _isLaundryAccess,
                    onChanged: (bool newValue) {
                      setState(() {
                        _isLaundryAccess = newValue;
                      });
                    },
                  ),
                ),

                // Private Fridge
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.kitchen,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        // Use Expanded or Flexible
                        child: Text(
                          "HAS PRIVATE FRIDGE? (Charged: ₱$privateFridgeCharge)",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          softWrap: true, // Allow wrapping of text
                        ),
                      ),
                    ],
                  ),
                ),

                Center(
                  child: Switch(
                    value: _hasPrivateFridge,
                    onChanged: (bool newValue) {
                      setState(() {
                        _hasPrivateFridge = newValue;
                      });
                    },
                  ),
                ),

                // Smart TV
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tv,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "HAS SMART TV? (Charged: ₱$smartTVCharge)",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Switch(
                    value: _hasSmartTV,
                    onChanged: (bool newValue) {
                      setState(() {
                        _hasSmartTV = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RentalAgreementScreen(
                //       roomId: widget.roomId,
                //       // Pass the charge values only if the corresponding switch is true
                //       isPetAccess: _isPetAccess,
                //       isWifiEnabled: _isWifiEnabled,
                //       wifiCharge: _isWifiEnabled ? wifiCharge : 0.0,
                //       isLaundryAccess: _isLaundryAccess,
                //       laundryCharge: _isLaundryAccess ? laundryCharge : 0.0,
                //       hasPrivateFridge: _hasPrivateFridge,
                //       privateFridgeCharge: _hasPrivateFridge ? privateFridgeCharge : 0.0,
                //       hasSmartTV: _hasSmartTV,
                //       smartTVCharge: _hasSmartTV ? smartTVCharge : 0.0,
                //     ),
                //   ),
                // );

                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (_) => HomeLoggedScreen()),
                //   );
                // });

                final inquiryProvider = Provider.of<InquiryProvider> (context, listen:false); 
                inquiryProvider.storeInquiry(
                  context, 
                  widget.roomId, 
                  widget.profileId, 
                  _isPetAccess, 
                  _isWifiEnabled, 
                  _isLaundryAccess, 
                  _hasPrivateFridge, 
                  _hasSmartTV
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Text("Submit Inquiry"),
            ),
          ),
        ],
      ),
    );
  }
}