import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/data/models/mock_data.dart';

class AchievementsController extends GetxController {
  // États de l'interface
  final isLoading = true.obs;
  final selectedTabIndex = 0.obs;

  // Statistiques
  final globalProgress = 0.0.obs;
  final unlockedCount = 0.obs;
  final totalCount = 0.obs;
  final stats = Rx<Map<String, dynamic>>({
    'level': 0,
    'points': 0,
    'streakDays': 0,
  });

  // Réalisations
  final allAchievements = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAchievements();
  }

  Future<void> loadAchievements() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les statistiques de l'utilisateur depuis les données simulées
      final userData = MockData.studentProfile;
      stats.value = {
        'level': userData['level'],
        'points': userData['points'],
        'streakDays': userData['streakDays'],
      };

      // Réalisations simulées
      final achievements = [
        {
          'id': 1,
          'title': 'Premier cours terminé',
          'description': 'Terminer votre premier cours',
          'category': 'Cours',
          'isUnlocked': true,
          'progress': 1,
          'target': 1,
          'date': '10/03/2024',
          'points': 50,
        },
        {
          'id': 2,
          'title': 'Mathématicien en herbe',
          'description': 'Terminer 5 cours de mathématiques',
          'category': 'Cours',
          'isUnlocked': true,
          'progress': 5,
          'target': 5,
          'date': '12/03/2024',
          'points': 100,
        },
        {
          'id': 3,
          'title': 'Linguiste débutant',
          'description': 'Terminer 3 cours de français',
          'category': 'Cours',
          'isUnlocked': false,
          'progress': 1,
          'target': 3,
          'points': 100,
        },
        {
          'id': 4,
          'title': 'Expert en fractions',
          'description': 'Obtenir 90% à tous les exercices sur les fractions',
          'category': 'Exercice',
          'isUnlocked': false,
          'progress': 3,
          'target': 5,
          'points': 150,
        },
        {
          'id': 5,
          'title': 'Série de feu',
          'description': 'Se connecter 7 jours consécutifs',
          'category': 'Assiduité',
          'isUnlocked': false,
          'progress': 5,
          'target': 7,
          'points': 100,
        },
        {
          'id': 6,
          'title': 'Explorateur scientifique',
          'description': 'Terminer le cours sur le corps humain',
          'category': 'Cours',
          'isUnlocked': true,
          'progress': 1,
          'target': 1,
          'date': '13/03/2024',
          'points': 75,
        },
        {
          'id': 7,
          'title': 'Maître des quiz',
          'description': 'Réussir 10 exercices avec un score de 100%',
          'category': 'Score',
          'isUnlocked': false,
          'progress': 6,
          'target': 10,
          'points': 200,
        },
        {
          'id': 8,
          'title': 'Lecteur assidu',
          'description': 'Lire 10 leçons différentes',
          'category': 'Cours',
          'isUnlocked': true,
          'progress': 10,
          'target': 10,
          'date': '14/03/2024',
          'points': 100,
        },
        {
          'id': 9,
          'title': 'Historien en devenir',
          'description': 'Terminer 3 cours d\'histoire-géographie',
          'category': 'Cours',
          'isUnlocked': false,
          'progress': 1,
          'target': 3,
          'points': 100,
        },
        {
          'id': 10,
          'title': 'Marathonien d\'études',
          'description': 'Étudier pendant 10 heures au total',
          'category': 'Progression',
          'isUnlocked': false,
          'progress': 7,
          'target': 10,
          'points': 150,
        },
      ];

      allAchievements.value = achievements;

      // Calculer les statistiques globales
      totalCount.value = allAchievements.length;
      unlockedCount.value = allAchievements.where((a) => a['isUnlocked']).length;
      globalProgress.value = unlockedCount.value / totalCount.value;

    } catch (e) {
      print('Erreur lors du chargement des réalisations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateAchievementProgress(int achievementId, int progress) {
    final index = allAchievements.indexWhere((a) => a['id'] == achievementId);
    if (index != -1) {
      final achievement = Map<String, dynamic>.from(allAchievements[index]);

      // Mettre à jour la progression
      achievement['progress'] = progress;

      // Vérifier si la réalisation est débloquée
      if (progress >= achievement['target'] && !achievement['isUnlocked']) {
        achievement['isUnlocked'] = true;
        achievement['date'] = _getCurrentDate();

        // Afficher une notification
        _showAchievementUnlockedNotification(achievement);
      }

      // Mettre à jour la réalisation dans la liste
      allAchievements[index] = achievement;

      // Recalculer les statistiques globales
      unlockedCount.value = allAchievements.where((a) => a['isUnlocked']).length;
      globalProgress.value = unlockedCount.value / totalCount.value;
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  void _showAchievementUnlockedNotification(Map<String, dynamic> achievement) {
    Get.snackbar(
      'Nouvelle réalisation !',
      'Vous avez débloqué "${achievement['title']}" et gagné ${achievement['points']} points !',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 5),
      backgroundColor: Get.theme.primaryColor.withOpacity(0.8),
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      icon: Icon(
        Icons.emoji_events,
        color: Colors.white,
      ),
      onTap: (_) {
        Get.back();
        // Rediriger vers la page de détail de la réalisation (si elle existe)
      },
    );
  }
}