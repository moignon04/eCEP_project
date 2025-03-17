import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' ;
import 'package:get/get.dart';
import 'package:client/domain/entities/user.dart';
import 'package:client/data/models/badge.dart';
import 'package:client/data/models/mock_data.dart';

class ProfileController extends GetxController {
  // États d'interface
  final isLoading = true.obs;

  // Utilisateur
  final user = User(
    id: 0,
    firstName: '',
    lastName: '',
    email: '',
    avatar: '',
    role: '',
  ).obs;

  // Statistiques
  final stats = Rx<Map<String, dynamic>>({
    'level': 0,
    'points': 0,
    'streakDays': 0,
    'completedCourses': 0,
    'completedExercises': 0,
    'averageScore': 0,
  });

  // Données d'activité
  final recentBadges = <ABadge>[].obs;
  final recentActivities = <Map<String, dynamic>>[].obs;
  final subjectProgress = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les données de l'utilisateur depuis les données simulées
      final userData = MockData.studentProfile;
      user.value = User(
        id: userData['id'],
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        email: userData['email'],
        avatar: userData['avatar'],
        role: userData['role'],
      );

      // Charger les statistiques
      stats.value = {
        'level': userData['level'],
        'points': userData['points'],
        'streakDays': userData['streakDays'],
        'completedCourses': userData['completedCourses'],
        'completedExercises': userData['completedExercises'],
        'averageScore': userData['averageScore'],
      };

      // Charger les badges récents
      recentBadges.value = MockData.badges
          .where((badge) => badge['isUnlocked'] == true)
          .take(5)
          .map((data) => ABadge.fromJson(data))
          .toList();

      // Charger les activités récentes (simulées)
      recentActivities.value = [
        {
          'type': 'cours',
          'title': 'Les fractions',
          'description': 'Leçon terminée',
          'timeAgo': 'il y a 2h',
        },
        {
          'type': 'exercice',
          'title': 'Addition de fractions',
          'description': 'Exercice réussi (85%)',
          'timeAgo': 'il y a 3h',
        },
        {
          'type': 'badge',
          'title': 'Mathématiques Débutant',
          'description': 'Badge débloqué',
          'timeAgo': 'il y a 3h',
        },
        {
          'type': 'cours',
          'title': 'La conjugaison des verbes',
          'description': 'Progression (30%)',
          'timeAgo': 'hier',
        },
        {
          'type': 'exercice',
          'title': 'Les verbes du premier groupe',
          'description': 'Exercice réussi (95%)',
          'timeAgo': 'hier',
        },
      ];

      // Charger les progrès par matière (simulés)
      subjectProgress.value = [
        {
          'name': 'Maths',
          'progress': 75,
        },
        {
          'name': 'Français',
          'progress': 60,
        },
        {
          'name': 'Histoire',
          'progress': 40,
        },
        {
          'name': 'Sciences',
          'progress': 85,
        },
      ];

    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Mettre à jour les données de l'utilisateur
      if (data.containsKey('firstName')) {
        user.update((val) {
          val!.firstName = data['firstName'];
        });
      }

      if (data.containsKey('lastName')) {
        user.update((val) {
          val!.lastName = data['lastName'];
        });
      }

      if (data.containsKey('email')) {
        user.update((val) {
          val!.email = data['email'];
        });
      }

      if (data.containsKey('avatar')) {
        user.update((val) {
          val!.avatar = data['avatar'];
        });
      }

      // Dans une application réelle, envoyer ces données à l'API

      Get.snackbar(
        'Profil mis à jour',
        'Vos informations ont été mises à jour avec succès.',
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      print('Erreur lors de la mise à jour des données utilisateur: $e');
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la mise à jour de votre profil.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    // Dans une application réelle, déconnecter l'utilisateur de l'API

    // Afficher un dialogue de confirmation
    bool confirm = await Get.dialog(
      AlertDialog(
        title: Text('Se déconnecter'),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('Déconnexion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Rediriger vers la page de connexion
      Get.offAllNamed('/login');
    }
  }
}