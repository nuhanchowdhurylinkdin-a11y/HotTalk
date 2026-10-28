import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHelpers {
  const AppHelpers._();

  static void showSnackbar({
    required String title,
    required String message,
    ContentType type = ContentType.failure,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = Get.context;

    if (context == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.transparent,
          duration: duration,
          content: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: type,
          ),
        ),
      );
  }

  static void showSuccessSnackbar({
    required String title,
    required String message,
  }) {
    showSnackbar(title: title, message: message, type: ContentType.success);
  }

  static void showErrorSnackbar({
    required String title,
    required String message,
  }) {
    showSnackbar(title: title, message: message, type: ContentType.failure);
  }

  static void showWarningSnackbar({
    required String title,
    required String message,
  }) {
    showSnackbar(title: title, message: message, type: ContentType.warning);
  }

  static void showHelpSnackbar({
    required String title,
    required String message,
  }) {
    showSnackbar(title: title, message: message, type: ContentType.help);
  }
}
