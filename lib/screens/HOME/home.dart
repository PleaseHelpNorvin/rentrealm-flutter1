import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
import 'package:rentealm_flutter/PROVIDERS/reservation_provider.dart';
import 'package:rentealm_flutter/models/reservation_model.dart';
// import 'package:rentealm_flutter/PROVIDERS/reservation_provider.dart';
// import 'package:rentealm_flutter/PROVIDERS/rentalAgreement_provider.dart';
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

import 'package:rentealm_flutter/models/rentalAgreement_model.dart'
    as rentalModel;
import 'package:rentealm_flutter/models/tenant_model.dart' as tenantModel;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> _profileCheckFuture;

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
    Provider.of<RentalagreementProvider>(context, listen: false)
        .fetchActiveRentalAgreementByProfileId(context);

    // Step 1: Fetch user profile
    final hasProfile = await profileProvider.loadUserProfile(context);
    setState(() {
      _profileCheckFuture =
          Future.value(hasProfile); // ✅ Ensure it updates correctly
    });

    // Step 2: Fetch picked rooms only if profile exists
    if (hasProfile &&
        pickedRoomProvider.userId != null &&
        pickedRoomProvider.token != null) {
      pickedRoomProvider.fetchPickedRooms(
        userProfileUserId: pickedRoomProvider.userId,
        token: pickedRoomProvider.token,
      );
    }

    // Step 3: Check if tenant already exists before fetching
    if (tenantProvider.tenant == null) {
      await tenantProvider.fetchTenant(context);
    } else {
      print("Tenant data already exists, skipping fetch.");
    }
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
        child: Consumer4<ProfileProvider, PickedRoomProvider, TenantProvider,
            RentalagreementProvider>(
          builder: (context, profileProvider, pickedRoomProvider,
              tenantProvider, rentalAgreementProvider, child) {
            final singlePickedRoom = pickedRoomProvider.singlePickedRoom;
            final tenant = tenantProvider.tenant;
            final activeAgreements = rentalAgreementProvider.rentalAgreements;

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
                    _buildShowMaintenanceRequestsList(tenant),
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
          "Select Rental Agreement",
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
                            onTap: () {
                              print("Selected contract: ${contract.id}");
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

  Widget _buildShowMaintenanceRequestsList(TenantResponse? tenantResponse) {
    if (tenantResponse == null) return SizedBox();

    final maintenanceRequests = tenantResponse.data.tenantMaintenanceRequest;

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
              // Title and Button in a Column (button below the title)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Maintenance Requests",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddMaintenanceRequestDialog(context);
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Request"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Show maintenance requests
              if (maintenanceRequests.isEmpty)
                Center(
                  child: Text(
                    "No maintenance requests found.",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                )
              else
                SizedBox(
                  height: 300, // Prevents overflow
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: maintenanceRequests.length,
                    itemBuilder: (context, index) {
                      final request = maintenanceRequests[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            "Issue: ${request.description}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status: ${request.status}",
                                  style: TextStyle(color: Colors.black87)),
                              Text("Requested On: ${request.requestedAt}",
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                          leading: Icon(Icons.build, color: Colors.blue),
                          trailing: Icon(
                            request.status == "Completed"
                                ? Icons.check_circle
                                : Icons.pending,
                            color: request.status == "Completed"
                                ? Colors.green
                                : Colors.red,
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

  // Function to show Add Maintenance Request dialog

  void _showAddMaintenanceRequestDialog(BuildContext context) {
    TextEditingController _descriptionController = TextEditingController();
    File? _selectedImage; // Store selected image

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
              child: Wrap(
                children: [
                  // Title
                  Center(
                    child: Text(
                      "Add Maintenance Request",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Input Field
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Describe the issue",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  // Image Picker Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    icon: Icon(Icons.photo),
                    label: Text("Add Photo"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  const SizedBox(height: 10),

                  // Display Selected Image
                  if (_selectedImage != null)
                    Column(
                      children: [
                        Image.file(_selectedImage!,
                            height: 150, fit: BoxFit.cover),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage =
                                  null; // Remove the selected image
                            });
                          },
                          child: Text("Remove Photo",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Buttons (Cancel & Submit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child:
                            Text("Cancel", style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Submit logic here
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: Text("Submit",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
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
