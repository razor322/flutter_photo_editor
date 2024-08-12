import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    Color backgroundColor = Colors.greenAccent,
    Color colorText = Colors.white,
    required Icon? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      duration: duration,
      colorText: colorText,
      shouldIconPulse: false,
      icon: icon ?? const Icon(Icons.notifications, color: Colors.white),
    );
  }
}
