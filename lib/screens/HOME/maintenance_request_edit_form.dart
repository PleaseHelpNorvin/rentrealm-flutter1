import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../PROVIDERS/maintenanceRequest_provider.dart';

class MaintenanceRequestEditPage extends StatelessWidget {
  final int maintenanceId;

  MaintenanceRequestEditPage({required this.maintenanceId});

  @override
  Widget build(BuildContext context) {
    final maintenanceRequestProvider = Provider.of<MaintenancerequestProvider>(context);
    maintenanceRequestProvider.setSelectedMaintenanceRequest(maintenanceId);

    final selectedRequest = maintenanceRequestProvider.selectedMaintenanceRequest;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Maintenance Request"),
      ),
      body: selectedRequest != null
          ? DraggableScrollableSheet(
              initialChildSize: 0.4, // Initial height (40% of screen height)
              minChildSize: 0.2, // Minimum height (20% of screen height)
              maxChildSize: 0.6, // Maximum height (60% of screen height)
              builder: (BuildContext context, ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section (Fixed Header)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Edit Maintenance Request",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey[700]),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        Divider(),

                        // Scrollable Content (Inside the SingleChildScrollView)
                        selectedRequest.images != null
                            ? CachedNetworkImage(
                                imageUrl: selectedRequest.images.toString(),
                                width: double.infinity, // Adjust the width as needed
                                height: 200, // Adjust the height as needed
                                fit: BoxFit.cover,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              )
                            : Container(),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ticket Code: ${selectedRequest.ticketCode}'),
                              TextField(
                                controller: TextEditingController(text: selectedRequest.title),
                                decoration: InputDecoration(labelText: 'Title'),
                              ),
                              TextField(
                                controller: TextEditingController(text: selectedRequest.description),
                                decoration: InputDecoration(labelText: 'Description'),
                              ),
                              Text('Status: ${selectedRequest.status}'),
                              Text('Requested At: ${selectedRequest.requestedAt}'),
                              SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      print("Saving the maintenance request...");
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                  SizedBox(width: 10),
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
            )
          : Center(child: Text("No request found")),
    );
  }
}
