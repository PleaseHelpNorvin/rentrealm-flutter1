import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentealm_flutter/screens/NOTIFICATIONS/notifications_details.dart';
import '../../PROVIDERS/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchNotification(context);
    });
  }

  Future<void> _refreshData() async {
    await Provider.of<NotificationProvider>(context, listen: false).fetchNotification(context);
  }

  Widget _buildNoDataCard() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 50, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No notifications found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationListCard(Map<String, dynamic> notification) {
    String notificationTitle = notification["title"] ?? "No Title";
    String notificationMessage = notification["message"] ?? "No Message";

    return GestureDetector(
      onTap: () async {
        await Provider.of<NotificationProvider>(context, listen: false)
            .updateStatusToRead(context, notification["id"]);
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationsDetailsScreen(
              notificationId: notification["id"],
              notificationTitle: notificationTitle,
              notificationMessage: notificationMessage,
            ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          leading: Icon(Icons.notifications, color: Colors.blue),
          title: Text(notificationTitle, style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildListFilterRow() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Expanded(child: _buildFilterButton("All", "all")),
          Expanded(child: _buildFilterButton("Unread", "unread")),
          Expanded(child: _buildFilterButton("Read", "read")),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, String filterType) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        bool isSelected = provider.filterType == filterType;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5), // Add spacing between buttons
          child: ElevatedButton(
            onPressed: () {
              provider.setFilterType(filterType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.grey,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10), // Adjust padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center, // Ensure text is centered
              style: TextStyle(fontSize: 14), // Adjust font size if needed
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notificationDetails;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            _buildListFilterRow(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
                child: notifications.isEmpty
                    ? _buildNoDataCard()
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return _buildNotificationListCard(notifications[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
