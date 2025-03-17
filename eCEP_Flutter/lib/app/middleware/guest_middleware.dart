import 'package:client/app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestMiddleware extends GetMiddleware {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  @override
  RouteSettings? redirect(String? route) {
    // Si l'utilisateur est déjà authentifié, rediriger vers la page d'accueil
    if (_storageService.isAuthenticated) {
      return const RouteSettings(name: '/home');
    }
    return null;
  }
}