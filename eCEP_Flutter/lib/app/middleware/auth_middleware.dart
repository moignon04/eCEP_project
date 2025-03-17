import 'package:client/app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  final LocalStorageService store = Get.find<LocalStorageService>();

  @override
  RouteSettings? redirect(String? route) {
    // Vérifie si l'utilisateur est connecté
    if (store.token == null || store.token!.isEmpty) {
      return const RouteSettings(name: '/login');
    }

    // Si c'est une route enseignant, vérifie le rôle
    if (route?.startsWith('/teacher') == true) {
      final user = store.user;
      if (user == null || user.role != 'teacher') {
        // L'utilisateur n'est pas un enseignant, rediriger vers la page d'accueil
        return const RouteSettings(name: '/home');
      }
    }

    return null;
  }
}