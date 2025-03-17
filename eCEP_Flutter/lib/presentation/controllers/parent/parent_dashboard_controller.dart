import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentDashboardController extends GetxController {
  // États de chargement
  final isLoading = true.obs;

  // Informations du parent
  final parent = Rx<Map<String, dynamic>>({});

  // Liste des enfants associés à ce parent
  final children = <Map<String, dynamic>>[].obs;

  // Enfant actuellement sélectionné
  final selectedChildIndex = 0.obs;

  // Activités récentes
  final recentActivities = <Map<String, dynamic>>[].obs;

  // Résumé par matière
  final subjectSummary = <Map<String, dynamic>>[].obs;

  // Notifications
  final notifications = <Map<String, dynamic>>[].obs;
  final unreadNotifications = 0.obs;

  // Dates des prochains examens
  final upcomingExams = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    try {
      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      // Charger les informations du parent (simulées)
      parent.value = {
        'id': 1,
        'firstName': 'Pierre',
        'lastName': 'Dupont',
        'email': 'pierre.dupont@email.com',
        'avatar': 'assets/avatars/parent1.png',
      };

      // Charger la liste des enfants (simulées)
      children.value = [
        {
          'id': 101,
          'firstName': 'Lucas',
          'lastName': 'Dupont',
          'grade': 'CM2',
          'avatar': 'assets/avatars/boy1.png',
          'averageScore': 78.5,
          'level': 5,
          'points': 850,
          'streakDays': 5,
          'lastActivity': 'Aujourd\'hui',
          'recentProgress': [60, 65, 70, 75, 78],
        },
        {
          'id': 102,
          'firstName': 'Sophie',
          'lastName': 'Dupont',
          'grade': 'CE2',
          'avatar': 'assets/avatars/girl1.png',
          'averageScore': 82.3,
          'level': 4,
          'points': 720,
          'streakDays': 3,
          'lastActivity': 'Hier',
          'recentProgress': [72, 74, 78, 80, 82],
        }
      ];

      // Sélectionner le premier enfant par défaut
      if (children.isNotEmpty) {
        await loadChildData(selectedChildIndex.value);
      }

      // Charger les notifications (simulées)
      notifications.value = [
        {
          'id': 1,
          'title': 'Évaluation à venir',
          'message': 'Lucas a une évaluation en Mathématiques prévue pour le 18 mars.',
          'date': '15/03/2025',
          'time': '14:30',
          'read': false,
          'type': 'exam'
        },
        {
          'id': 2,
          'title': 'Badge débloqué',
          'message': 'Lucas a débloqué le badge "Expert en Fractions"!',
          'date': '14/03/2025',
          'time': '16:45',
          'read': true,
          'type': 'badge'
        },
        {
          'id': 3,
          'title': 'Message de l\'enseignant',
          'message': 'Mme Durant souhaite fixer un rendez-vous pour discuter des progrès de Lucas.',
          'date': '13/03/2025',
          'time': '10:15',
          'read': false,
          'type': 'message'
        },
        {
          'id': 4,
          'title': 'Devoir non complété',
          'message': 'Lucas n\'a pas encore terminé l\'exercice "Multiplication de fractions".',
          'date': '12/03/2025',
          'time': '18:00',
          'read': true,
          'type': 'homework'
        },
      ];

      // Compter les notifications non lues
      unreadNotifications.value = notifications.where((n) => n['read'] == false).length;

      // Charger les examens à venir (simulés)
      upcomingExams.value = [
        {
          'id': 1,
          'title': 'Évaluation Mathématiques',
          'subject': 'Mathématiques',
          'date': '18/03/2025',
          'time': '10:00',
          'type': 'quiz',
          'childId': 101
        },
        {
          'id': 2,
          'title': 'Contrôle de Français',
          'subject': 'Français',
          'date': '20/03/2025',
          'time': '14:00',
          'type': 'exam',
          'childId': 101
        },
        {
          'id': 3,
          'title': 'Interrogation Sciences',
          'subject': 'Sciences',
          'date': '19/03/2025',
          'time': '11:00',
          'type': 'quiz',
          'childId': 102
        },
      ];

    } catch (e) {
      print('Erreur lors du chargement des données: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadChildData(int index) async {
    if (index >= 0 && index < children.length) {
      selectedChildIndex.value = index;
      final childId = children[index]['id'];

      // Simuler un délai réseau
      await Future.delayed(Duration(milliseconds: 500));

      // Charger les activités récentes (simulées)
      recentActivities.value = [
        {
          'id': 1,
          'childId': childId,
          'type': 'course',
          'title': 'A terminé le cours "Les fractions"',
          'date': '15/03/2025',
          'time': '14:25',
        },
        {
          'id': 2,
          'childId': childId,
          'type': 'exercise',
          'title': 'A réussi l\'exercice "Addition de fractions"',
          'score': 85,
          'date': '15/03/2025',
          'time': '13:40',
        },
        {
          'id': 3,
          'childId': childId,
          'type': 'badge',
          'title': 'A débloqué le badge "Mathématiques Débutant"',
          'date': '15/03/2025',
          'time': '13:45',
        },
        {
          'id': 4,
          'childId': childId,
          'type': 'course',
          'title': 'A commencé le cours "La conjugaison des verbes"',
          'date': '14/03/2025',
          'time': '16:10',
        },
        {
          'id': 5,
          'childId': childId,
          'type': 'exercise',
          'title': 'A réussi l\'exercice "Les verbes du premier groupe"',
          'score': 95,
          'date': '14/03/2025',
          'time': '15:30',
        },
      ];

      // Charger le résumé par matière (simulé)
      subjectSummary.value = [
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
    }
  }

  // Marquer une notification comme lue
  void markNotificationAsRead(int notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['read'] = true;
      notifications.refresh();

      // Mettre à jour le compteur de notifications non lues
      unreadNotifications.value = notifications.where((n) => n['read'] == false).length;
    }
  }

  // Marquer toutes les notifications comme lues
  void markAllNotificationsAsRead() {
    for (var notification in notifications) {
      notification['read'] = true;
    }
    notifications.refresh();
    unreadNotifications.value = 0;
  }

  // Contacter l'enseignant
  void contactTeacher() {
    Get.dialog(
      AlertDialog(
        title: Text('Contacter l\'enseignant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Envoyer un e-mail'),
              subtitle: Text('marie.durant@ecole.fr'),
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
            Text('À: Mme Durant (Professeur de ${children[selectedChildIndex.value]['firstName']})'),
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
                  'Votre message a été envoyé au professeur.',
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

  // Naviguer vers le détail de l'enfant
  void navigateToChildDetail() {
    if (children.isNotEmpty) {
      Get.toNamed('/child-progress', arguments: {
        'childId': children[selectedChildIndex.value]['id']
      });
    }
  }

  // Naviguer vers les notifications
  void navigateToNotifications() {
    Get.toNamed('/parent-notifications');
  }

  // Naviguer vers la messagerie
  void navigateToMessaging() {
    Get.toNamed('/parent-messaging');
  }
}