import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/billing_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';
import 'package:rentealm_flutter/screens/PAYMENT/monthlyRentPayment.dart';
import 'package:rentealm_flutter/screens/PAYMENT/payment.dart';

import '../../PROVIDERS/notification_provider.dart';

class NotificationsDetailsScreen extends StatefulWidget {
  final int notificationId;
  final String notificationTitle;
  final String notificationMessage;
  final int notifNotifiableReservationId;

  const NotificationsDetailsScreen({
    super.key,
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.notifNotifiableReservationId,
  });

  @override
  State<NotificationsDetailsScreen> createState() =>
      _NotificationsDetailsScreenState();
}

class _NotificationsDetailsScreenState
    extends State<NotificationsDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false)
        .updateStatusToRead(context, widget.notificationId);
    Provider.of<BillingProvider>(context, listen: false)
        .fetchLatestMonthlyRentBilling(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.notificationTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.notificationMessage,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text("${widget.notifNotifiableReservationId}"),
              // Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla facilisi. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit.", style: TextStyle(fontSize: 20),),
              const SizedBox(height: 20), // Adds spacing before the button
              if (widget.notificationTitle == "Reservation Accepted!")
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/rentalAgreement',
                          arguments: {
                            'notifNotifiableReservationId':
                                widget.notifNotifiableReservationId,
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text("Proceed to agreement"),
                  ),
                )
              else if (widget.notificationTitle == "Payment Failed")
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      int? billingId =
                          Provider.of<PaymentProvider>(context, listen: false)
                              .checkFailPaymentBilling
                              ?.id;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentScreen(billingId: billingId ?? 0),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text("Retry Payment"),
                  ),
                )
              else if (widget.notificationTitle
                  .startsWith("Monthly Rent billing for"))
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Provider.of<PaymentProvider>(context, listen: false)
                              .processRentPaymongoPayment(context);

                          final billingId = Provider.of<BillingProvider>(
                                  context,
                                  listen: false)
                              .billing
                              ?.id;

                          if (billingId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Monthlyrentpayment(billingId: billingId),
                              ),
                            );
                          } else {
                            // Handle null billingId if needed (optional)
                            print("Billing ID is null");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text("Proceed to Rent Payment"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/advancepayment");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text("Pay Advance"),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
