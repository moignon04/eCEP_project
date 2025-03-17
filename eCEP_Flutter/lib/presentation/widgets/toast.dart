import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';

enum ToastType { success, error, info, warning }

class ToastService extends GetxService {
  void showToast({
    required String title,
    required String message,
    required ToastType type,
    Duration? duration,
  }) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error;
        break;
      case ToastType.info:
        backgroundColor = AppColors.info;
        icon = Icons.info;
        break;
      case ToastType.warning:
        backgroundColor = AppColors.warning;
        icon = Icons.warning;
        break;
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(icon, color: textColor),
      snackPosition: SnackPosition.TOP,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      duration: duration ?? Duration(seconds: 3),
    );
  }
}