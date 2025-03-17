// lib/app/middleware/role_middleware.dart
import 'package:client/app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleMiddleware extends GetMiddleware {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  @override
  RouteSettings? redirect(String? route) {
    if (!_storageService.isAuthenticated) {
      return const RouteSettings(name: '/login');
    }

    final user = _storageService.user;
    if (user != null) {
      switch (user.role) {
        case 'student':
        // Si l'utilisateur est déjà sur une route d'élève, ne pas rediriger
          if (route?.startsWith('/student') == true) {
            return null;
          }
          return const RouteSettings(name: '/student/home');
        case 'teacher':
          if (route?.startsWith('/teacher') == true) {
            return null;
          }
          return const RouteSettings(name: '/teacher/dashboard');
        case 'parent':
          if (route?.startsWith('/parent') == true) {
            return null;
          }
          return const RouteSettings(name: '/parent/dashboard');
        case 'admin':
          if (route?.startsWith('/admin') == true) {
            return null;
          }
          return const RouteSettings(name: '/admin/dashboard');
        default:
          return const RouteSettings(name: '/login');
      }
    }

    return null;
  }
}