import 'package:get/get.dart';
import 'package:client/domain/entities/user.dart';
import 'package:client/app/extension/color.dart';
import 'package:flutter/material.dart';

class TeacherDashboardController extends GetxController {
  // États de l'interface
  final isLoading = true.obs;

  // Données de l'enseignant
  final teacher = Rx<User>(
      User(
        id: 0,
        firstName: '',
        lastName: '',
        email: '',
        avatar: '',
        role: 'teacher',
      )
  );

  // Statistiques de la classe
  final classStats = Rx<Map<String, dynamic>>({
    'totalStudents': 0,
    'averageScore': 0.0,
    'completedExercises': 0,
    'studentsToReview': 0,
  });

  // Performances par matière
  final subjectPerformances = <Map<String, dynamic>>[].obs;

  // Scores par matière (pour le graphique)
  final subjectScores = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les données de l'enseignant (simulées)
      teacher.value = User(
        id: 101,
        firstName: 'Marie',
        lastName: 'Durant',
        email: 'marie.durant@ecole.fr',
        avatar: 'assets/avatars/teacher1.png',
        role: 'teacher',
      );

      // Charger les statistiques de la classe (simulées)
      classStats.value = {
        'totalStudents': 28,
        'averageScore': 75.3,
        'completedExercises': 420,
        'studentsToReview': 5,
      };

      // Charger les performances par matière (simulées)
      subjectPerformances.value = [
        {
          'subject': 'Mathématiques',
          'averageScore': 72.5,
          'completedExercises': 120,
          'color': AppColors.mathColor,
        },
        {
          'subject': 'Français',
          'averageScore': 80.2,
          'completedExercises': 105,
          'color': AppColors.frenchColor,
        },
        {
          'subject': 'Histoire-Géographie',
          'averageScore': 68.7,
          'completedExercises': 85,
          'color': AppColors.historyColor,
        },
        {
          'subject': 'Sciences',
          'averageScore': 77.9,
          'completedExercises': 110,
          'color': AppColors.scienceColor,
        },
      ];

      // Charger les scores par matière (pour le graphique)
      subjectScores.value = {
        'Mathématiques': 72.5,
        'Français': 80.2,
        'Histoire-Géographie': 68.7,
        'Sciences': 77.9,
      };

    } catch (e) {
      print('Erreur lors du chargement des données du tableau de bord: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Obtenir la liste des élèves à revoir (scores faibles)
  List<Map<String, dynamic>> getStudentsToReview() {
    // Dans une application réelle, cette donnée viendrait de l'API
    // Pour la démo, nous retournons des données simulées
    return [
      {
        'id': 3,
        'name': 'Noah Petit',
        'avatar': 'assets/avatars/boy2.png',
        'score': 62.5,
        'lastActivity': '2 jours',
      },
      {
        'id': 5,
        'name': 'Louis Bernard',
        'avatar': 'assets/avatars/boy3.png',
        'score': 58.0,
        'lastActivity': '1 jour',
      },
      {
        'id': 8,
        'name': 'Emma Leclerc',
        'avatar': 'assets/avatars/girl3.png',
        'score': 55.8,
        'lastActivity': '3 jours',
      },
    ];
  }

  // Obtenir les meilleurs élèves
  List<Map<String, dynamic>> getTopStudents() {
    // Dans une application réelle, cette donnée viendrait de l'API
    // Pour la démo, nous retournons des données simulées
    return [
      {
        'id': 6,
        'name': 'Inès Thomas',
        'avatar': 'assets/avatars/girl3.png',
        'score': 90.5,
        'lastActivity': 'aujourd\'hui',
      },
      {
        'id': 2,
        'name': 'Emma Martin',
        'avatar': 'assets/avatars/girl1.png',
        'score': 85.0,
        'lastActivity': 'aujourd\'hui',
      },
      {
        'id': 1,
        'name': 'Lucas Dupont',
        'avatar': 'assets/avatars/boy1.png',
        'score': 78.5,
        'lastActivity': 'hier',
      },
    ];
  }

  // Obtenir les activités récentes
  List<Map<String, dynamic>> getRecentActivities() {
    // Dans une application réelle, cette donnée viendrait de l'API
    // Pour la démo, nous retournons des données simulées
    return [
      {
        'type': 'submission',
        'student': 'Lucas Dupont',
        'activity': 'a terminé l\'exercice "Addition de fractions"',
        'time': 'il y a 2h',
        'score': 85,
      },
      {
        'type': 'question',
        'student': 'Emma Martin',
        'activity': 'a posé une question sur "La conjugaison des verbes"',
        'time': 'il y a 3h',
        'score': null,
      },
      {
        'type': 'submission',
        'student': 'Noah Petit',
        'activity': 'a terminé l\'exercice "Les verbes du premier groupe"',
        'time': 'il y a 5h',
        'score': 65,
      },
      {
        'type': 'completion',
        'student': 'Inès Thomas',
        'activity': 'a terminé le cours "Les fractions"',
        'time': 'hier',
        'score': null,
      },
    ];
  }
}