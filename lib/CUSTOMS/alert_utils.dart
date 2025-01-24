import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../SCREENS/homelogged.dart';

class AlertUtils {
  // Success Alert
   static void showSuccessAlert(BuildContext context,
      {String? title, String? message, VoidCallback? onConfirmBtnTap}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title ?? 'Success',
      text: message ?? 'Operation completed successfully!',
      onConfirmBtnTap: () {
        // Ensure that Navigator pops from the correct context
        Navigator.of(context, rootNavigator: true).pop(); // Ensure using rootNavigator to pop dialogs
      if (onConfirmBtnTap != null) {
          onConfirmBtnTap(); // Execute the provided callback
      }

      },
    );
  }

  // Error Alert
  static void showErrorAlert(BuildContext context,
      {String? title, String? message, VoidCallback? onConfirmBtnTap}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title ?? 'Error',
      text: message ?? 'Something went wrong!',
       onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the dialog
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap(); // Execute additional logic if provided
        }
      },
    );
  }

  // Info Alert
  static void showInfoAlert(BuildContext context,
      {String? title, String? message, VoidCallback? onConfirmBtnTap}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: title ?? 'Information',
      text: message ?? 'Here is some information!',
       onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the dialog
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap(); // Execute additional logic if provided
        }
      },
    );
  }

  // Warning Alert
  static void showWarningAlert(BuildContext context,
      {String? title, String? message, VoidCallback? onConfirmBtnTap}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title ?? 'Warning',
      text: message ?? 'Please be cautious!',
       onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Close the dialog
        if (onConfirmBtnTap != null) {
          onConfirmBtnTap(); // Execute additional logic if provided
        }
      },
    );
  }

  static void showLogoutDialog(BuildContext context,
      {String? title,
      String? message,
      VoidCallback? onConfirmTap,
      VoidCallback? onCancelTap}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: title ?? 'Babye :<',
      text: message ?? 'Are you sure to logout? :<',
      onConfirmBtnTap: () {
        if (onConfirmTap != null) {
          onConfirmTap(); // Execute logic when 'Yes' is tapped
        }
      },
      onCancelBtnTap: () {
        if (onCancelTap != null) {
          onCancelTap(); // Execute logic when 'No' is tapped
        }
      },
    );
  }
}
