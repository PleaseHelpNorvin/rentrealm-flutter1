import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';

import '../payment_response_screen/payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int billingId;
  const PaymentScreen({super.key, required this.billingId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final WebViewController _controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    final checkoutUrl = Provider.of<PaymentProvider>(context).checkoutUrl;

    if (checkoutUrl == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // Prevent the user from going back to the previous screen
        return false;
      },
      child: Scaffold(
        body: WebViewWidget(
          controller: _controller
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (url) {
                  if (url.contains("expired-session")) {
                    // Handle expired session
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Session Expired"),
                        content:
                            Text("The session has expired. Please try again."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                        billingId: widget.billingId)),
                              );
                            },
                            child: Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.contains("payment-success")) {
                    Navigator.pop(context, true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentSuccessScreen(
                              billingId: widget.billingId)),
                    );
                    return NavigationDecision.prevent;
                  } else if (request.url.contains("payment-failed")) {
                    Navigator.pop(context, false);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse(checkoutUrl)),
        ),
      ),
    );
  }
}
