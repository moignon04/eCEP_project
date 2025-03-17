import 'package:get/get.dart';
import 'package:flutter/material.dart';

class StudentDetailController extends GetxController {
  // États de l'interface
  final isLoading = true.obs;

  // Données de l'élève
  final studentId = 0.obs;
  final student = Rx<Map<String, dynamic>>({});

  // Performances par matière
  final subjectPerformances = <Map<String, dynamic>>[].obs;

  // Activités récentes
  final recentActivities = <Map<String, dynamic>>[].obs;

  // Exercices complétés
  final completedExercises = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Récupérer l'ID de l'élève des arguments
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      if (Get.arguments.containsKey('studentId')) {
        studentId.value = Get.arguments['studentId'];
      }
    }

    loadStudentData();
  }

  Future<void> loadStudentData() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les données de l'élève (simulées)
      student.value = {
        'id': studentId.value,
        'firstName': 'Lucas',
        'lastName': 'Dupont',
        'avatar': 'assets/avatars/boy1.png',
        'email': 'lucas.d@ecole.fr',
        'grade': 'CM2',
        'completedExercises': 28,
        'averageScore': 78.5,
        'level': 5,
        'points': 850,
        'streakDays': 5,
        'lastActivity': 'Aujourd\'hui',
      };

      // Charger les performances par matière (simulées)
      subjectPerformances.value = [
        {
          'subject': 'Mathématiques',
          'progress': 75,
          'score': 72,
          'exercises': 10,
          'color': Colors.blue,
        },
        {
          'subject': 'Français',
          'progress': 60,
          'score': 80,
          'exercises': 8,
          'color': Colors.red,
        },
        {
          'subject': 'Histoire-Géographie',
          'progress': 40,
          'score': 68,
          'exercises': 5,
          'color': Colors.amber,
        },
        {
          'subject': 'Sciences',
          'progress': 85,
          'score': 85,
          'exercises': 5,
          'color': Colors.green,
        },
      ];

      // Charger les activités récentes (simulées)
      recentActivities.value = [
        {
          'type': 'course',
          'title': 'A terminé le cours "Les fractions"',
          'date': '15/03/2024',
          'time': '14:25',
        },
        {
          'type': 'exercise',
          'title': 'A réussi l\'exercice "Addition de fractions"',
          'score': 85,
          'date': '15/03/2024',
          'time': '13:40',
        },
        {
          'type': 'badge',
          'title': 'A débloqué le badge "Mathématiques Débutant"',
          'date': '15/03/2024',
          'time': '13:45',
        },
        {
          'type': 'course',
          'title': 'A commencé le cours "La conjugaison des verbes"',
          'date': '14/03/2024',
          'time': '16:10',
        },
        {
          'type': 'exercise',
          'title': 'A réussi l\'exercice "Les verbes du premier groupe"',
          'score': 95,
          'date': '14/03/2024',
          'time': '15:30',
        },
      ];

      // Charger les exercices complétés (simulés)
      completedExercises.value = [
        {
          'id': 1,
          'title': 'Addition de fractions',
          'course': 'Les fractions',
          'subject': 'Mathématiques',
          'score': 85,
          'completedAt': '15/03/2024',
          'difficulty': 2,
        },
        {
          'id': 2,
          'title': 'Les verbes du premier groupe',
          'course': 'La conjugaison des verbes',
          'subject': 'Français',
          'score': 95,
          'completedAt': '14/03/2024',
          'difficulty': 1,
        },
        {
          'id': 3,
          'title': 'Multiplication de fractions',
          'course': 'Les fractions',
          'subject': 'Mathématiques',
          'score': 75,
          'completedAt': '13/03/2024',
          'difficulty': 2,
        },
        {
          'id': 4,
          'title': 'Les grandes découvertes',
          'course': 'Les grandes découvertes',
          'subject': 'Histoire-Géographie',
          'score': 68,
          'completedAt': '12/03/2024',
          'difficulty': 2,
        },
        {
          'id': 5,
          'title': 'Le système digestif',
          'course': 'Le corps humain',
          'subject': 'Sciences',
          'score': 85,
          'completedAt': '11/03/2024',
          'difficulty': 3,
        },
      ];

    } catch (e) {
      print('Erreur lors du chargement des données de l\'élève: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Contacter l'élève ou ses parents (simulé)
  void contactStudent() {
    Get.dialog(
      AlertDialog(
        title: Text('Contacter l\'élève ou ses parents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Envoyer un e-mail'),
              subtitle: Text('lucas.d@ecole.fr'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'E-mail',
                  'Ouverture de votre application e-mail...',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contacter les parents'),
              subtitle: Text('parents.dupont@email.com'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'E-mail',
                  'Ouverture de votre application e-mail...',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Envoyer un message dans l\'application'),
              onTap: () {
                Get.back();
                _showMessageDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }

  // Dialogue pour envoyer un message (simulé)
  void _showMessageDialog() {
    final TextEditingController messageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Envoyer un message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('À: Lucas Dupont'),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Saisissez votre message...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                Get.back();
                Get.snackbar(
                  'Message envoyé',
                  'Votre message a été envoyé à Lucas Dupont.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Envoyer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Créer une note pour cet élève (simulé)
  void createNote() {
    final TextEditingController noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Ajouter une note sur cet élève'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                hintText: 'Ex: A besoin d\'aide en calcul de fractions...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                Get.back();
                Get.snackbar(
                  'Note ajoutée',
                  'Votre note a été ajoutée au dossier de cet élève.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Sauvegarder'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Exporter les données de l'élève (simulé)
  void exportStudentData() {
    Get.dialog(
      AlertDialog(
        title: Text('Exporter les données'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choisissez le format d\'exportation :'),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('PDF'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Export PDF',
                  'Les données de l\'élève ont été exportées au format PDF.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Excel'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Export Excel',
                  'Les données de l\'élève ont été exportées au format Excel.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
        ],
      ),
    );
  }
}