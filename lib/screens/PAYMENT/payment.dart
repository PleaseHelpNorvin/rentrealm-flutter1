import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';

import '../payment_response_screen/payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

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
        // appBar: AppBar(title: Text('Complete Payment')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // appBar: AppBar(title: Text('Complete Payment')),
      body: WebViewWidget(
        controller: _controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains("payment-success")) {
                  Navigator.pop(context, true); // Payment success
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
                  );

                  return NavigationDecision.prevent;
                } else if (request.url.contains("payment-failed")) {
                  Navigator.pop(context, false); // Payment failed
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(checkoutUrl)),
      ),
    );
  }
}
