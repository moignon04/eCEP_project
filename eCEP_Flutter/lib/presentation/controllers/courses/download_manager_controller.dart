import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';

class DownloadManagerController extends GetxController {
  // États d'interface
  final isLoading = true.obs;

  // Stockage
  final usedStorage = '1.2 GB'.obs;
  final availableStorage = '5.8 GB'.obs;
  final usedStoragePercentage = 0.2.obs; // 20% utilisé

  // Paramètres
  final wifiOnly = true.obs;
  final autoDownloadNewContent = false.obs;
  final videoQuality = 'Moyenne'.obs;

  // Téléchargements en cours
  final activeDownloads = <Map<String, dynamic>>[].obs;
  // Téléchargements terminés
  final downloadedCourses = <Map<String, dynamic>>[].obs;

  // Pour la recherche et le filtrage
  final allDownloadedCourses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDownloads();
  }

  void loadDownloads() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les téléchargements actifs (simulés)
      activeDownloads.value = [
        {
          'id': 1,
          'title': 'Les fractions - Chapitre 2',
          'subject': 'Mathématiques',
          'progress': 45,
          'downloadedSize': '24 MB',
          'totalSize': '52 MB',
          'remainingTime': '2 min restantes',
          'isPaused': false,
          'color': AppColors.mathColor,
          'icon': Icons.calculate_outlined,
        },
        {
          'id': 2,
          'title': 'La conjugaison des verbes - Tous les chapitres',
          'subject': 'Français',
          'progress': 78,
          'downloadedSize': '85 MB',
          'totalSize': '110 MB',
          'remainingTime': '1 min restantes',
          'isPaused': false,
          'color': AppColors.frenchColor,
          'icon': Icons.menu_book_outlined,
        },
      ];

      // Charger les téléchargements terminés (simulés)
      final mockDownloadedCourses = [
        {
          'id': 3,
          'title': 'Le corps humain',
          'subject': 'Sciences',
          'videos': '8',
          'audios': '2',
          'documents': '5',
          'size': '420 MB',
          'color': AppColors.scienceColor,
          'icon': Icons.science_outlined,
          'date': '12/03/2024',
        },
        {
          'id': 4,
          'title': 'Les grandes découvertes',
          'subject': 'Histoire-Géographie',
          'videos': '5',
          'audios': '3',
          'documents': '7',
          'size': '380 MB',
          'color': AppColors.historyColor,
          'icon': Icons.public_outlined,
          'date': '10/03/2024',
        },
        {
          'id': 5,
          'title': 'Les équations',
          'subject': 'Mathématiques',
          'videos': '6',
          'audios': '0',
          'documents': '3',
          'size': '250 MB',
          'color': AppColors.mathColor,
          'icon': Icons.calculate_outlined,
          'date': '05/03/2024',
        },
      ];

      downloadedCourses.value = mockDownloadedCourses;
      allDownloadedCourses.value = mockDownloadedCourses;

    } catch (e) {
      print('Erreur lors du chargement des téléchargements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDownloads() async {
    loadDownloads();
    return Future.value();
  }

  void filterDownloads(String query) {
    if (query.isEmpty) {
      downloadedCourses.value = allDownloadedCourses;
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    downloadedCourses.value = allDownloadedCourses.where((course) {
      return course['title'].toLowerCase().contains(lowercaseQuery) ||
          course['subject'].toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  void togglePauseDownload(int downloadId) {
    final index = activeDownloads.indexWhere((download) => download['id'] == downloadId);
    if (index != -1) {
      final updatedDownload = Map<String, dynamic>.from(activeDownloads[index]);
      updatedDownload['isPaused'] = !updatedDownload['isPaused'];

      activeDownloads[index] = updatedDownload;

      // Afficher un message de confirmation
      Get.snackbar(
        updatedDownload['isPaused'] ? 'Téléchargement en pause' : 'Téléchargement repris',
        updatedDownload['isPaused']
            ? 'Le téléchargement de "${updatedDownload['title']}" est en pause'
            : 'Le téléchargement de "${updatedDownload['title']}" a repris',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void cancelDownload(int downloadId) {
    activeDownloads.removeWhere((download) => download['id'] == downloadId);

    // Afficher un message de confirmation
    Get.snackbar(
      'Téléchargement annulé',
      'Le téléchargement a été annulé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteDownload(int courseId) {
    downloadedCourses.removeWhere((course) => course['id'] == courseId);
    allDownloadedCourses.removeWhere((course) => course['id'] == courseId);

    // Dans une application réelle, supprimer les fichiers du stockage local

    // Mettre à jour les infos de stockage (simulé)
    usedStoragePercentage.value = usedStoragePercentage.value - 0.05;
    if (usedStoragePercentage.value < 0) usedStoragePercentage.value = 0;

    usedStorage.value = '${(double.parse(usedStorage.value.split(' ')[0]) - 0.3).toStringAsFixed(1)} GB';

    // Afficher un message de confirmation
    Get.snackbar(
      'Téléchargement supprimé',
      'Le cours a été supprimé de vos téléchargements',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearAllDownloads() {
    activeDownloads.clear();
    downloadedCourses.clear();
    allDownloadedCourses.clear();

    // Réinitialiser les statistiques de stockage
    usedStoragePercentage.value = 0.0;
    usedStorage.value = '0.0 GB';

    // Afficher un message de confirmation
    Get.snackbar(
      'Téléchargements supprimés',
      'Tous les téléchargements ont été supprimés',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openDownloadedCourse(int courseId) {
    final course = downloadedCourses.firstWhere((c) => c['id'] == courseId, orElse: () => {});
    if (course.isNotEmpty) {
      // Naviguer vers le détail du cours
      Get.toNamed('/course-details', arguments: {
        'id': courseId,
        'title': course['title'],
        'subject': course['subject'],
        // Autres données nécessaires pour l'affichage du cours
      });
    }
  }

  void setWifiOnly(bool value) {
    wifiOnly.value = value;
  }

  void setAutoDownloadNewContent(bool value) {
    autoDownloadNewContent.value = value;
  }

  void setVideoQuality(String quality) {
    videoQuality.value = quality;
  }
}