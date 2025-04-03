import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/room_provider.dart';
// import 'package:rentealm_flutter/PROVIDERS/reservation_provider.dart';
import 'package:rentealm_flutter/models/maintenanceRequest_model.dart';
// import 'package:rentealm_flutter/models/reservation_model.dart';
// import 'package:rentealm_flutter/PROVIDERS/reservation_provider.dart';
// import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
import '../../PROVIDERS/maintenanceRequest_provider.dart';
import '../../PROVIDERS/tenant_provider.dart';
import 'package:rentealm_flutter/SCREENS/PROFILE/CREATE/create_profile_screen1.dart';
import '../../models/rentalAgreement_model.dart';
// as rentalProviderRentalAgreements;
// import 'package:rentealm_flutter/models/profile_model.dart';
import '../../PROVIDERS/pickedRoom_provider.dart';
import '../../PROVIDERS/profile_provider.dart';
// import '../../PROVIDERS/rentalAgreement_provider.dart';
import '../../models/tenant_model.dart';
// import '../../models/rentalAgreement_model.dart';
import '../outer_create_tenant_screen4.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// import 'package:rentealm_flutter/models/rentalAgreement_model.dart'
    // as rentalModel;
// import 'package:rentealm_flutter/models/tenant_model.dart' as tenantModel;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> _profileCheckFuture;
   File? _image;
    String? selectedStatus;  // To store the selected status for filtering
  int? selectedRoomId;

  @override
  void initState() {
    super.initState();

    _profileCheckFuture =
        Future.value(false); // Prevent LateInitializationError

    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async {
    if (!mounted) return;

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final pickedRoomProvider =
        Provider.of<PickedRoomProvider>(context, listen: false);
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);
    final rentalProvider =
        Provider.of<RentalagreementProvider>(context, listen: false);
    final maintenancerequestProvider = Provider.of<MaintenancerequestProvider>(context, listen:false);

    rentalProvider.fetchActiveRentalAgreementByProfileId(context);


    final hasProfile = await profileProvider.loadUserProfile(context);

    setState(() {
      _profileCheckFuture = Future.value(hasProfile);
    });

    if (hasProfile &&
        pickedRoomProvider.userId != null &&
        pickedRoomProvider.token != null) {
      await pickedRoomProvider.fetchPickedRooms(
        userProfileUserId: pickedRoomProvider.userId,
        token: pickedRoomProvider.token,
      );

      setState(() {}); // 🔥 UI refresh after rooms are fetched
    }

    if (tenantProvider.tenant == null) {
      await tenantProvider.fetchTenant(context);
      setState(() {}); // 🔥 UI refresh after tenant is updated
    }

    maintenancerequestProvider.fetchRoomByProfileId(context); 
      setState(() {});

    await maintenancerequestProvider.fetchMaintenanceRequestListByTenantId(context);
    // if (!mounted) return; // ✅ Final check before UI update
    setState(() {}); // ✅ Just an empty setState to trigger UI rebuild

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(
                child:
                    CircularProgressIndicator()); // ✅ Show loader while fetching
          }

          return FutureBuilder<bool>(
            future: _profileCheckFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == false) {
                return _buildNoDataCard();
              }

              return _buildWithDataCard();
            },
          );
        },
      ),
    );
  }

  Widget _buildWithDataCard() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _profileCheckFuture =
              Provider.of<ProfileProvider>(context, listen: false)
                  .loadUserProfile(context);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Consumer5<ProfileProvider, PickedRoomProvider, TenantProvider,
            RentalagreementProvider, MaintenancerequestProvider >(
          builder: (context, profileProvider, pickedRoomProvider,
              tenantProvider, rentalAgreementProvider, maintenanceRequestProvider, child) {
            final singlePickedRoom = pickedRoomProvider.singlePickedRoom;
            final tenant = tenantProvider.tenant;
            final activeAgreements = rentalAgreementProvider.rentalAgreements;
            final roomByProfileIdList = maintenanceRequestProvider.roomByProfileIdList;
            final maintenanceRequestsList = maintenanceRequestProvider.maintenanceRequests;
            final maintenanceRequestObj = maintenanceRequestProvider.selectedMaintenanceRequest;

            // ✅ Show a loading spinner if any provider is still fetching data
            if (profileProvider.isLoading ||
                pickedRoomProvider.isLoading ||
                tenantProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (activeAgreements.isEmpty) {
              print("no active agreemebts");
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (tenant != null) ...[
                    _buildChangeActiveRentalAgreement(context, tenant),
                    _buildShowMonthlyCountdownDashboard(tenant),
                    _buildShowMaintenanceRequestsList(tenant,roomByProfileIdList, maintenanceRequestsList, maintenanceRequestObj),
                  ] else ...[
                    if (singlePickedRoom != null)
                      _buildContinueReservationPayment(
                          context, profileProvider, singlePickedRoom),
                    if (singlePickedRoom == null) _buildShowReservationSent(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChangeActiveRentalAgreement(
      BuildContext context, TenantResponse? tenantResponse) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width
      child: ElevatedButton(
        onPressed: () async {
          // ✅ Ensure latest data is fetched before displaying dialog
          // await Provider.of<RentalagreementProvider>(context, listen: false)
          //     .fetchActiveRentalAgreementByProfileId(context);

          // ✅ Show the dialog (it will read the latest data from Provider)
          _showActiveAgreementsListDialog(context);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text(
          "Inspect Your Other Active Rental Agreement",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showActiveAgreementsListDialog(BuildContext context) async {
    await Provider.of<RentalagreementProvider>(context, listen: false)
        .fetchActiveRentalAgreementByProfileId(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Consumer<RentalagreementProvider>(
          builder: (context, rentalAgreementProvider, child) {
            final rentalAgreements = rentalAgreementProvider.rentalAgreements;

            print("Rental Agreements inside modal: ${rentalAgreements.length}");

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Active Rental Agreement",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[700]),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(),

                  // No agreements available
                  if (rentalAgreements.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No active agreements available.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: rentalAgreements.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1),
                        itemBuilder: (context, index) {
                          final contract = rentalAgreements[index];

                          String formattedDate = contract.rentStartDate != null
                              ? DateFormat('MMMM dd, yyyy').format(
                                  DateTime.parse(contract.rentStartDate))
                              : "N/A";

                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            leading:
                                Icon(Icons.description, color: Colors.blue),
                            title: Text(
                              "Contract #${contract.agreementCode}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Start Date: $formattedDate",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey[600], size: 18),
                            onTap: () async {
                              print("Selected contract: ${contract.id}");
                              // await Provider.of<TenantProvider>(context,
                              //         listen: false)
                              //     .viewActiveAgreementsCountDown(
                              //         context, contract.id);
                              await Provider.of<RentalagreementProvider>(
                                      context,
                                      listen: false)
                                  .viewRentalAgreementCountdown(
                                      context, contract.id);

                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContinueReservationPayment(
      BuildContext context, ProfileProvider profileProvider, singlePickedRoom) {
    return GestureDetector(
      onTap: () {
        if (singlePickedRoom?.room.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OuterCreateTenantScreen4(
                roomId: singlePickedRoom!.room.id,
                profileId: profileProvider.userProfile?.data.id ?? 0,
                pickedRoomId: singlePickedRoom.id,
              ),
            ),
          );
          print("Room ID: ${singlePickedRoom?.room.id}");
        } else {
          print("No room selected.");
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Continue to Reservation Payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Room ID: ${singlePickedRoom?.room.id ?? 'N/A'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Room Details: ${singlePickedRoom?.room.roomDetails ?? 'No details available'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowReservationSent() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Reservation Sent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please wait for a possible call from management.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Also, check your notifications for updates.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowMonthlyCountdownDashboard(TenantResponse? tenantResponse) {
    if (tenantResponse == null)
      return SizedBox(); // Handle null tenant gracefully

    final tenant = tenantResponse.data.tenant;
    final latestBilling = tenantResponse.data.latestBilling;
    final nextBillingMonth = tenantResponse.data.nextBillingMonth;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Dashboard",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Rental Agreement Code: ${tenant.rentalAgreement.agreementCode}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Billing Status: ${latestBilling?.status ?? 'Not available'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Next Billing Month: ${nextBillingMonth ?? 'No due date'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildShowMaintenanceRequestsList(TenantResponse? tenantResponse, List<RoomByProfileId> roomByProfileIdList, List<MaintenanceRequest> maintenanceRequestsList, MaintenanceRequest? maintenanceRequestObj) {
  //   if (tenantResponse == null) return SizedBox();

  //   if (roomByProfileIdList == null) return SizedBox();
    

  //   // final maintenanceRequests = tenantResponse.data.tenantMaintenanceRequest;
      
  //   return SizedBox(
  //     width: double.infinity,
  //     child: Card(
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Title and Button in a Column (button below the title)
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Maintenance Requests",
  //                   style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.blue),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 ElevatedButton.icon(
  //                   onPressed: () {
  //                     _showAddMaintenanceRequestDialog(context, roomByProfileIdList);
  //                   },
  //                   icon: Icon(Icons.add),
  //                   label: Text("Add Request"),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.blue,
  //                     foregroundColor: Colors.white,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(3)),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 10),

  //             // Show maintenance requests
  //             if (maintenanceRequestsList.isEmpty)
  //               Center(
  //                 child: Text(
  //                   "No maintenance requests found.",
  //                   style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black54),
  //                 ),
  //               )
  //             else
  //               SizedBox(
  //                 height: 350, // Prevents overflow
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: BouncingScrollPhysics(),
  //                   itemCount: maintenanceRequestsList.length,
  //                   itemBuilder: (context, index) {
  //                     final request = maintenanceRequestsList[index];
  //                     DateTime requestedAt = DateTime.parse(request.requestedAt.toString());
  //                     String formattedDate = DateFormat('MMMM dd, yyyy hh:mm a').format(requestedAt);

  //                     return GestureDetector(
  //                       onTap: () {
  //                         print("tapped ${request.id}");
  //                         _showMaintenanceRequestDetails(context, maintenanceRequestObj, request.id);
  //                       },
  //                       child: Card(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(3)),
  //                       margin: EdgeInsets.symmetric(vertical: 5),
  //                       child: ListTile(
  //                         title: Text(
  //                           "Issue: ${request.ticketCode}",
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.blue),
  //                         ),
  //                         subtitle: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text("Status: ${request.status}",
  //                                 style: TextStyle(color: Colors.black87)),
  //                             Text("Requested On: $formattedDate",
  //                                 style: TextStyle(color: Colors.black54)),
  //                           ],
  //                         ),
  //                        leading: Icon(Icons.build, color: Colors.blue),
  //                         trailing: Row(
  //                           mainAxisSize: MainAxisSize.min, // Makes the row take minimum space
  //                           children: [
  //                             Icon(
  //                               request.status == "Completed"
  //                                   ? Icons.check_circle
  //                                   : Icons.pending,
  //                               color: request.status == "Completed"
  //                                   ? Colors.green
  //                                   : Colors.red,
  //                             ),
  //                             SizedBox(width: 0), // Reduces the space between icons
  //                             IconButton(
  //                               icon: Icon(Icons.edit, color: Colors.blue),
  //                               padding: EdgeInsets.zero,
  //                               onPressed: () {
  //                                 // Handle the button tap here
  //                                 print('Edit button tapped for ticket: ${request.ticketCode}');
  //                                 _maintenanceRequestEditForm(context, request.id,  roomByProfileIdList);
  //                               },
  //                             ),
  //                             SizedBox(width: 0), // Reduces the space between icons
  //                             IconButton(
  //                               icon: Icon(Icons.delete, color: Colors.blue),
  //                               padding: EdgeInsets.zero,
  //                               onPressed: () {
  //                                 // Handle the button tap here
  //                                 print('Delete button tapped for ticket: ${request.ticketCode}');
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildShowMaintenanceRequestsList(
      TenantResponse? tenantResponse,
      List<RoomByProfileId> roomByProfileIdList,
      List<MaintenanceRequest> maintenanceRequestsList,
      MaintenanceRequest? maintenanceRequestObj) {

    if (tenantResponse == null) return SizedBox();
    if (roomByProfileIdList == null) return SizedBox();

    // Apply filters
    List<MaintenanceRequest> filteredRequests = maintenanceRequestsList.where((request) {
      bool matchesStatus = selectedStatus == null || request.status == selectedStatus;
      bool matchesRoomId = selectedRoomId == null || request.roomId == selectedRoomId;

      return matchesStatus && matchesRoomId;
    }).toList();

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Maintenance Requests",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  
                  // Row containing the ElevatedButton and DropdownButton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Aligns items to take up available space
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddMaintenanceRequestDialog(context, roomByProfileIdList);
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add Request"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        ),
                      ),
                      SizedBox(width: 10), // Adds some space between the button and dropdown
                      DropdownButton<String>(
                        hint: Text("Filter by Status"),
                        value: selectedStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                        },
                        items: <String>['pending','assigned', 'completed', 'in_progress', 'cancelled']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Show maintenance requests
              if (filteredRequests.isEmpty)
                Center(
                  child: Text(
                    "No maintenance requests found.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                )
              else
                SizedBox(
                  height: 350, // Prevents overflow
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      DateTime requestedAt = DateTime.parse(request.requestedAt.toString());
                      String formattedDate = DateFormat('MMMM dd, yyyy hh:mm a').format(requestedAt);

                      return GestureDetector(
                        onTap: () {
                          print("tapped ${request.id}");
                          _showMaintenanceRequestDetails(context, maintenanceRequestObj, request.id);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              "Issue: ${request.ticketCode}",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status: ${request.status}", style: TextStyle(color: Colors.black87)),
                                Text("Requested On: $formattedDate", style: TextStyle(color: Colors.black54)),
                              ],
                            ),
                            leading: Icon(Icons.build, color: Colors.blue),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min, // Makes the row take minimum space
                              children: [
                                Icon(
                                  request.status == "Completed" ? Icons.check_circle : Icons.pending,
                                  color: request.status == "Completed" ? Colors.green : Colors.red,
                                ),
                                SizedBox(width: 0), // Reduces the space between icons
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    print('Edit button tapped for ticket: ${request.ticketCode}');
                                    _maintenanceRequestEditForm(context, request.id, roomByProfileIdList);
                                  },
                                ),
                                SizedBox(width: 0), // Reduces the space between icons
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.blue),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    print('Delete button tapped for ticket: ${request.ticketCode}');
                                    _maintenanceCancelConfirmDialog(context, request.id);
                                    // Handle delete action
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> _maintenanceRequestEditForm(BuildContext context, int maintenanceId, List<RoomByProfileId> roomCodeLists) async {
    print("from _maintenanceRequestEditForm() maintenanceId: $maintenanceId");

    final maintenanceRequestProvider = Provider.of<MaintenancerequestProvider>(context, listen: false);
    await maintenanceRequestProvider.fetchMaintenanceRequestSingleObject(context, maintenanceId);

    final selectedRequest =  maintenanceRequestProvider.selectedMaintenanceRequest;

    if (selectedRequest != null) {
      TextEditingController titleController = TextEditingController(text: selectedRequest.title);
      TextEditingController descriptionController = TextEditingController(text: selectedRequest.description);
      
      int? _selectedRoomId = selectedRequest.roomId;  // ✅ Get the existing room ID

      await Provider.of<RoomProvider>(context, listen: false).fetchRoomById(context, _selectedRoomId!);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              maintenanceRequestProvider.clearNewImage();
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 1.0,
              minChildSize: 0.8,
              maxChildSize: 1.0,
              builder: (BuildContext context, ScrollController scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Edit Maintenance Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.close, color: Colors.grey[700]),
                              onPressed: () {
                                maintenanceRequestProvider.clearNewImage();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Divider(),

                        // Image Picker Section
                        GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

                            if (pickedFile != null) {
                              print("pickedFile path: ${pickedFile.path}");
                              maintenanceRequestProvider.updateNewImage(File(pickedFile.path));
                            } else {
                              print("No image selected.");
                            }
                          },
                          child: Consumer<MaintenancerequestProvider>(
                            builder: (context, maintenanceRequestProvider, child) {
                              return maintenanceRequestProvider.newImage != null
                                  ? Image.file(
                                      maintenanceRequestProvider.newImage!,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : selectedRequest.images.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: selectedRequest.images.single,
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        )
                                      : Container(
                                          height: 200,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: Center(child: Text("No image selected")),
                                        );
                            },
                          ),
                        ),

                        // Form Fields
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Room Code Dropdown
                              Consumer<RoomProvider>(
                                builder: (context, roomProvider, child) {
                                  return DropdownButtonFormField<int>(
                                    value: _selectedRoomId,
                                    onChanged: (newValue) {
                                      _selectedRoomId = newValue;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Select Room Code",
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    items: roomCodeLists.map((room) {
                                      return DropdownMenuItem<int>(
                                        value: room.roomId,
                                        child: Text(room.roomCode),
                                      );
                                    }).toList(),
                                    validator: (value) => value == null ? "Please select a room code" : null,
                                  );
                                },
                              ),

                              Text('Ticket Code: ${selectedRequest.ticketCode}'),
                              TextField(
                                controller: titleController,
                                decoration: InputDecoration(labelText: 'Title'),
                              ),
                              TextField(
                                controller: descriptionController,
                                decoration: InputDecoration(labelText: 'Description'),
                              ),
                              Text('Status: ${selectedRequest.status}'),
                              Text('Requested At: ${selectedRequest.requestedAt}'),
                              SizedBox(height: 20),

                              // Save Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      String updatedTitle = titleController.text;
                                      String updatedDescription = descriptionController.text;
                                      File? selectedImage = maintenanceRequestProvider.newImage;
                                      final maintenanceProvider = Provider.of<MaintenancerequestProvider>(context, listen: false);

                                          maintenanceProvider.updateMaintenanceRequest(context, updatedTitle, updatedDescription, _selectedRoomId!, selectedImage, maintenanceId);
                                         
                                      print("Updated Maintenance Request: $updatedTitle, $updatedDescription");

                                      maintenanceRequestProvider.clearNewImage();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text('Save', style: TextStyle(color: Colors.white)),
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
            ),
          );
        },
      );
    } else {
      print("Selected maintenance request is null");
    }
  }

    void _maintenanceCancelConfirmDialog(BuildContext context, int maintenanceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Maintenance Request'),
          content: Text('Are you sure you want to cancel this maintenance request?'),
          actions: <Widget>[
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Cancel'),
            ),
            // Confirm button
            TextButton(
              onPressed: () async {
                // Call the function to cancel the maintenance request
                // Replace with your actual API call or logic
                await Provider.of<MaintenancerequestProvider>(context, listen:  false).patchStatusToCancel(context, maintenanceId);
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }



  void _showMaintenanceRequestDetails(BuildContext context, MaintenanceRequest? maintenanceRequestObj, int maintenanceId) async {
    print("from _showMaintenanceRequestDetails() maintenanceId: ${maintenanceRequestObj?.id}");

    final maintenanceRequestProvider = Provider.of<MaintenancerequestProvider>(context, listen: false);
    await maintenanceRequestProvider.fetchMaintenanceRequestSingleObject(context, maintenanceId);

    // Fetch the selected maintenance request from the provider
    final selectedRequest = maintenanceRequestProvider.selectedMaintenanceRequest;

    // Show the dialog with the selected maintenance request details
    if (selectedRequest != null) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true, // Allows the dialog to be dismissed by tapping outside of it
        barrierLabel: 'Maintenance Request Details',
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return AlertDialog(
            title: Text('Maintenance Request Details'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3), // Set the border radius here
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ticket Code: ${selectedRequest.ticketCode}'),
                  Text('Title: ${selectedRequest.title}'),
                  Text('Description: ${selectedRequest.description}'),
                  Text('Status: ${selectedRequest.status}'),
                  Text('Requested At: ${selectedRequest.requestedAt}'),
                  // Add more fields as needed, such as images or other details
                  // Example to display images (if any) using CachedNetworkImage
                  selectedRequest.images.isNotEmpty
                      ? Column(
                          children: selectedRequest.images.map((image) {
                            return CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            );
                          }).toList(),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  print("Image from selectedRequest.images.map((image) or backend : ${selectedRequest.images.toString()} ");
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      print("Selected maintenance request is null");
    }
  }


  // Function to show Add Maintenance Request dialog

    void _showAddMaintenanceRequestDialog(BuildContext context, List<RoomByProfileId> roomCodeLists) {
    final _formKey = GlobalKey<FormState>(); // Form key for validation
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    File? _selectedImage;
    int? _selectedRoomId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Form(
                key: _formKey, // Attach form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        "Add Maintenance Request",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown for Room Code Selection
                    DropdownButtonFormField<int>(
                      value: _selectedRoomId,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRoomId = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Room Code",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: roomCodeLists.map((room) {
                        return DropdownMenuItem<int>(
                          value: room.roomId,
                          child: Text(room.roomCode),
                        );
                      }).toList(),
                      validator: (value) => value == null ? "Please select a room code" : null, // Validation
                    ),
                    const SizedBox(height: 20),

                    // Title Input Field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Title of the issue",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty ? "Title cannot be empty" : null, // Validation
                    ),
                    const SizedBox(height: 20),

                    // Description Input Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: "Describe the issue",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      maxLines: 3,
                      validator: (value) => value == null || value.trim().isEmpty ? "Description cannot be empty" : null, // Validation
                    ),
                    const SizedBox(height: 20),

                    // Image Picker Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            _selectedImage = File(pickedFile.path);
                          });
                        }
                      },
                      icon: Icon(Icons.photo),
                      label: Text("Add Photo"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    const SizedBox(height: 5),

                    // Display Selected Image
                    if (_selectedImage != null)
                      Column(
                        children: [
                          Image.file(_selectedImage!, height: 150, fit: BoxFit.cover),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: Text("Remove Photo", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),

                    // Buttons (Cancel & Submit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancel", style: TextStyle(color: Colors.red)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) { // Validate before submitting
                              String title = _titleController.text.trim();
                              String description = _descriptionController.text.trim();
                              int? roomId = _selectedRoomId;
                              File? imageFile = _selectedImage; // Get image file path
                              
                              if (roomId == null) {
                                print("Room ID is required.");
                                return;
                              }

                              Provider.of<MaintenancerequestProvider>(context, listen: false)
                                .createMaintenanceRequest(context, title, description, roomId, imageFile);
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: Text("Submit", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  /// Widget shown when the user doesn't have a profile
  Widget _buildNoDataCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.orange.shade50,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("No profile Detected!"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateProfileScreen1(),
                      ),
                    );
                  },
                  child: const Text('Continue Creating Profile'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
