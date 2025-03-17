import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:client/presentation/controllers/profile/profile_controller.dart';
import 'dart:io';

class SettingsController extends GetxController {
  // États de chargement
  final isLoading = false.obs;

  // Paramètres
  final darkMode = false.obs;
  final autoDownload = true.obs;
  final wifiOnly = true.obs;
  final pushNotifications = true.obs;
  final dailyReminders = true.obs;
  final courseUpdates = true.obs;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Dans une application réelle, charger les paramètres depuis le stockage local
      // Pour la démo, nous utilisons des valeurs par défaut

    } catch (e) {
      print('Erreur lors du chargement des paramètres: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setDarkMode(bool value) {
    darkMode.value = value;
    // Dans une application réelle, sauvegarder les paramètres

    // Changer le thème de l'application
    if (value) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }

    Get.snackbar(
      'Mode sombre',
      value ? 'Mode sombre activé' : 'Mode sombre désactivé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setAutoDownload(bool value) {
    autoDownload.value = value;
    // Dans une application réelle, sauvegarder les paramètres

    Get.snackbar(
      'Téléchargement automatique',
      value ? 'Téléchargement automatique activé' : 'Téléchargement automatique désactivé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setWifiOnly(bool value) {
    wifiOnly.value = value;
    // Dans une application réelle, sauvegarder les paramètres

    Get.snackbar(
      'Wi-Fi uniquement',
      value ? 'Téléchargement uniquement en Wi-Fi activé' : 'Téléchargement en données mobiles activé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setPushNotifications(bool value) {
    pushNotifications.value = value;
    // Dans une application réelle, sauvegarder les paramètres et configurer les notifications

    Get.snackbar(
      'Notifications push',
      value ? 'Notifications push activées' : 'Notifications push désactivées',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setDailyReminders(bool value) {
    dailyReminders.value = value;
    // Dans une application réelle, sauvegarder les paramètres et configurer les rappels

    Get.snackbar(
      'Rappels quotidiens',
      value ? 'Rappels quotidiens activés' : 'Rappels quotidiens désactivés',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setCourseUpdates(bool value) {
    courseUpdates.value = value;
    // Dans une application réelle, sauvegarder les paramètres

    Get.snackbar(
      'Mises à jour des cours',
      value ? 'Notifications de mises à jour des cours activées' : 'Notifications de mises à jour des cours désactivées',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        // Dans une application réelle, télécharger l'image et mettre à jour l'avatar

        Get.find<ProfileController>().updateUserData({
          'avatar': 'assets/avatars/boy1.png', // Utiliser une image par défaut pour la démo
        });

        Get.snackbar(
          'Avatar mis à jour',
          'Votre photo de profil a été mise à jour',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la sélection de l\'image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void changePassword(String currentPassword, String newPassword) {
    // Dans une application réelle, vérifier le mot de passe actuel et le mettre à jour

    // Simuler une mise à jour réussie
    Get.snackbar(
      'Mot de passe mis à jour',
      'Votre mot de passe a été mis à jour avec succès',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteAccount(String password) {
    // Dans une application réelle, vérifier le mot de passe et supprimer le compte

    // Simuler une confirmation
    Get.dialog(
      AlertDialog(
        title: Text('Compte supprimé'),
        content: Text('Votre compte a été supprimé avec succès. Vous allez être redirigé vers la page de connexion.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            child: Text('OK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

