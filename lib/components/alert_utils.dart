import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AlertUtils {
  // Success Alert
  static void showSuccessAlert(BuildContext context,
      {String? title, String? message, VoidCallback? onConfirmBtnTap}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title ?? 'Success',
      text: message ?? 'Operation completed successfully!',
      onConfirmBtnTap: onConfirmBtnTap,
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
      onConfirmBtnTap: onConfirmBtnTap,
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
      onConfirmBtnTap: onConfirmBtnTap,
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
      onConfirmBtnTap: onConfirmBtnTap,
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
