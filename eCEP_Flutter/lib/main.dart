import 'package:client/app/services/local_storage.dart';
import 'package:client/data/providers/network/api_provider.dart';
import 'package:client/presentation/app.dart';
import 'package:client/presentation/controllers/courses/courses_controller.dart';
import 'package:client/presentation/widgets/toast.dart' show ToastService;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // Initialiser GetStorage
  await GetStorage.init();
  await initializeDateFormatting('fr_FR', null);

  // Enregistrer les services
  Get.put(LocalStorageService());

  Get.put(ToastService());
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser l'application
  runApp(App());
}