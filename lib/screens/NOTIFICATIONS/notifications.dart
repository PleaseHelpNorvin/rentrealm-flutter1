import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../PROVIDERS/notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> notifications = [
    // "Welcome to the app!",
    // "Your profile has been updated.",
    // "New message from support."
  ]; // ✅ Static notifications

 @override
  void initState() {
    super.initState();
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false).fetchNotification(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
        final notificationProvider1 = Provider.of<NotificationProvider>(context, listen: false);

      final fetchedNotifications = notificationProvider1.notificationsList;

      setState(() {
        notifications = fetchedNotifications;
      });
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate data fetching
    setState(() {
      notifications = [
        "New system update available!",
        "Reminder: Check your tasks"
      ]; // Simulated new data
    });
  }

  Widget _buildNoDataCard() {
    return Padding(
      padding: EdgeInsets.all(10),
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

  Widget _buildNotificationListCard(String notification) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue, width: 3), // ✅ 3-pixel border
        borderRadius: BorderRadius.circular(8), // ✅ Optional rounded corners
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ListTile(
        leading: Icon(Icons.notifications, color: Colors.blue),
        title: Text(notification, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
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
)


          ],
        ),
      ),
    );
  }
}
