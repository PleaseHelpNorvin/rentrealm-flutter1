import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AlertUtils {
  // Success Alert
  static void showSuccessAlert(BuildContext context, {String? title, String? message}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: title ?? 'Success',
      text: message ?? 'Operation completed successfully!',
    );
  }

  // Error Alert
  static void showErrorAlert(BuildContext context, {String? title, String? message}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: title ?? 'Error',
      text: message ?? 'Something went wrong!',
    );
  }

  // Info Alert
  static void showInfoAlert(BuildContext context, {String? title, String? message}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: title ?? 'Information',
      text: message ?? 'Here is some information!',
    );
  }

  // Warning Alert
  static void showWarningAlert(BuildContext context, {String? title, String? message}) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: title ?? 'Warning',
      text: message ?? 'Please be cautious!',
    );
  }
}
