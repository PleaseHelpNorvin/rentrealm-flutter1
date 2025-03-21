import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rentealm_flutter/PROVIDERS/payment_provider.dart';

class ReceiptDetailsScreen extends StatefulWidget {
  final String paymongoPaymentReference;
  final String receiptUrl;

  const ReceiptDetailsScreen({
    super.key,
    required this.paymongoPaymentReference,
    required this.receiptUrl,
  });

  @override
  State<ReceiptDetailsScreen> createState() => _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends State<ReceiptDetailsScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _downloadPdf(widget.receiptUrl);
  }

  Future<void> _downloadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/receipt.pdf');
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localFilePath = file.path;
        });
      }
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  Future<void> _savePdfToDownloads() async {
    try {
      final originalFile = File(localFilePath!);
      final downloadsDirectory = Directory('/storage/emulated/0/Download');
      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }

      final newFilePath = '${downloadsDirectory.path}/receipt_${widget.paymongoPaymentReference}.pdf';
      await originalFile.copy(newFilePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF saved to Downloads folder")),
      );
    } catch (e) {
      print("Error saving PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save PDF.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              if (localFilePath != null) {
                _savePdfToDownloads();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No PDF available to download.")),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: localFilePath == null
            ? const Center(child: CircularProgressIndicator())
            : PDFView(
                filePath: localFilePath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageSnap: true,
                fitPolicy: FitPolicy.BOTH,
              ),
      ),
    );
  }
}
