import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';

class ContractDetailsScreen extends StatefulWidget {
  final String contractCode;
  const ContractDetailsScreen({super.key, required this.contractCode});

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    _fetchAndDownloadPdf();
  }

  Future<void> _fetchAndDownloadPdf() async {
    final provider =
        Provider.of<RentalagreementProvider>(context, listen: false);
    await provider.fetchRentalAgreementUrl(context, widget.contractCode);

    final pdfUrl = provider.pdfUrl;
    if (pdfUrl != null && pdfUrl.isNotEmpty) {
      await _downloadPdf(pdfUrl);
    }
  }

  Future<void> _downloadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/contract.pdf');
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
    final rentalAgreementProvider = Provider.of<RentalagreementProvider>(context, listen: false);
    final rentalagreementCode = rentalAgreementProvider.rentalAgreements.first.agreementCode;
    final originalFile = File(localFilePath!);
    final downloadsDirectory = Directory('/storage/emulated/0/Download'); // Common path for Android downloads
    if (!downloadsDirectory.existsSync()) {
      downloadsDirectory.createSync(recursive: true);
    }

    final newFilePath = '${downloadsDirectory.path}/$rentalagreementCode.pdf';
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
        title: const Text("Contract Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              if (localFilePath != null) {
                _savePdfToDownloads(); // Function to save the PDF
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
