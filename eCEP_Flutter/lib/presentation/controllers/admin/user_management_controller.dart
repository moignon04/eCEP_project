import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class UserManagementController extends GetxController {

  void setUserClass(int userId, String className) async {
    try {
      final index = users.indexWhere((u) => u['id'] == userId);
      if (index != -1) {
        isLoading.value = true;

        // Simuler un délai réseau
        await Future.delayed(Duration(milliseconds: 500));

        users[index] = {
          ...users[index],
          'class': className
        };

        applyFilters();

        Get.snackbar(
          'Classe modifiée',
          'L\'utilisateur est maintenant dans la classe ${className}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetPassword(int userId) {
    Get.dialog(
      AlertDialog(
        title: Text('Réinitialiser le mot de passe'),
        content: Text('Voulez-vous vraiment réinitialiser le mot de passe de cet utilisateur ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Get.back(); // Fermer le dialogue de confirmation
                isLoading.value = true;

                // Simuler un délai réseau
                await Future.delayed(Duration(seconds: 1));

                Get.snackbar(
                  'Succès',
                  'Le mot de passe a été réinitialisé. Un email a été envoyé à l\'utilisateur.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Erreur',
                  'Une erreur est survenue: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } finally {
                isLoading.value = false;
              }
            },
            child: Text('Réinitialiser'),
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
          ),
        ],
      ),
    );
  }

  void generateUserReport() async {
    try {
      isLoading.value = true;

      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Rapport généré',
        'Le rapport des utilisateurs a été généré et téléchargé.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void importUsers() {
    Get.dialog(
      AlertDialog(
        title: Text('Importer des utilisateurs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sélectionnez un fichier CSV à importer'),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  Get.back(); // Fermer le dialogue
                  isLoading.value = true;

                  // Simuler un délai réseau
                  await Future.delayed(Duration(seconds: 2));

                  Get.snackbar(
                    'Importation réussie',
                    '10 utilisateurs ont été importés avec succès.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );

                  await loadUsers(); // Recharger la liste des utilisateurs
                } catch (e) {
                  Get.snackbar(
                    'Erreur',
                    'Une erreur est survenue: $e',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } finally {
                  isLoading.value = false;
                }
              },
              icon: Icon(Icons.upload_file),
              label: Text('Sélectionner un fichier'),
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

  void bulkAction(String action) async {
    try {
      isLoading.value = true;

      // Simuler un délai réseau
      await Future.delayed(Duration(seconds: 1));

      switch (action) {
        case 'activate':
          Get.snackbar(
            'Action en masse',
            'Tous les utilisateurs filtrés ont été activés.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case 'deactivate':
          Get.snackbar(
            'Action en masse',
            'Tous les utilisateurs filtrés ont été désactivés.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case 'delete':
          Get.dialog(
            AlertDialog(
              title: Text('Confirmer la suppression en masse'),
              content: Text('Êtes-vous sûr de vouloir supprimer tous les utilisateurs filtrés ? Cette action est irréversible.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Annuler'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Action en masse',
                      'Tous les utilisateurs filtrés ont été supprimés.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text('Supprimer'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          );
          break;
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}// État de chargement
final isLoading = true.obs;
final searchQuery = ''.obs;
final selectedRole = 'Tous'.obs;
final selectedClass = 'Toutes'.obs;

// Liste des utilisateurs
final users = <Map<String, dynamic>>[].obs;

// Liste des utilisateurs filtrés
final filteredUsers = <Map<String, dynamic>>[].obs;

// Liste des rôles disponibles
final roles = ['Tous', 'Étudiant', 'Professeur', 'Parent', 'Administrateur'].obs;

// Liste des classes disponibles
final classes = ['Toutes', 'CM2-A', 'CM2-B', 'CM1-A', 'CM1-B', 'CE2-A', 'CE2-B'].obs;

// Utilisateur en cours d'édition
final editingUser = Rx<Map<String, dynamic>>({});

// Contrôleurs de texte pour l'ajout/modification d'utilisateur
late TextEditingController firstNameController;
late TextEditingController lastNameController;
late TextEditingController emailController;
late TextEditingController usernameController;
late TextEditingController passwordController;

@override
void onInit() {

  initTextControllers();
  loadUsers();
}

@override
void onClose() {
  disposeTextControllers();

}

void initTextControllers() {
  firstNameController = TextEditingController();
  lastNameController = TextEditingController();
  emailController = TextEditingController();
  usernameController = TextEditingController();
  passwordController = TextEditingController();
}

void disposeTextControllers() {
  firstNameController.dispose();
  lastNameController.dispose();
  emailController.dispose();
  usernameController.dispose();
  passwordController.dispose();
}

void clearTextControllers() {
  firstNameController.clear();
  lastNameController.clear();
  emailController.clear();
  usernameController.clear();
  passwordController.clear();
}

Future<void> loadUsers() async {
  isLoading.value = true;

  try {
    // Simuler un délai réseau
    await Future.delayed(Duration(seconds: 1));

    // Générer des données utilisateur de test
    final random = math.Random();
    final testUsers = <Map<String, dynamic>>[];

    // Étudiants
    for (int i = 1; i <= 20; i++) {
      final classIndex = random.nextInt(6);
      final className = classes[classIndex + 1]; // Skip "Toutes"
      testUsers.add({
        'id': 100 + i,
        'firstName': 'Étudiant',
        'lastName': 'Test $i',
        'email': 'etudiant$i@ecole.fr',
        'username': 'etudiant$i',
        'role': 'Étudiant',
        'class': className,
        'avatar': 'assets/avatars/${i % 2 == 0 ? 'boy' : 'girl'}${1 + (i % 3)}.png',
        'status': random.nextBool() ? 'Actif' : 'Inactif',
        'createdAt': '01/03/2025',
      });
    }

    // Professeurs
    for (int i = 1; i <= 6; i++) {
      final classIndex = i % 6;
      final className = classes[classIndex + 1]; // Skip "Toutes"
      testUsers.add({
        'id': 200 + i,
        'firstName': 'Professeur',
        'lastName': 'Test $i',
        'email': 'prof$i@ecole.fr',
        'username': 'prof$i',
        'role': 'Professeur',
        'class': className,
        'avatar': 'assets/avatars/teacher${1 + (i % 2)}.png',
        'status': 'Actif',
        'createdAt': '01/03/2025',
      });
    }

    // Parents
    for (int i = 1; i <= 15; i++) {
      testUsers.add({
        'id': 300 + i,
        'firstName': 'Parent',
        'lastName': 'Test $i',
        'email': 'parent$i@email.com',
        'username': 'parent$i',
        'role': 'Parent',
        'class': 'N/A',
        'avatar': 'assets/avatars/parent${1 + (i % 2)}.png',
        'status': random.nextBool() ? 'Actif' : 'Inactif',
        'createdAt': '01/03/2025',
      });
    }

    // Administrateurs
    for (int i = 1; i <= 2; i++) {
      testUsers.add({
        'id': 400 + i,
        'firstName': 'Admin',
        'lastName': 'Test $i',
        'email': 'admin$i@ecole.fr',
        'username': 'admin$i',
        'role': 'Administrateur',
        'class': 'N/A',
        'avatar': 'assets/avatars/admin$i.png',
        'status': 'Actif',
        'createdAt': '01/03/2025',
      });
    }

    users.value = testUsers;
    applyFilters();
  } catch (e) {
    print('Erreur lors du chargement des utilisateurs: $e');
  } finally {
    isLoading.value = false;
  }
}

void applyFilters() {
  final query = searchQuery.value.toLowerCase();
  final role = selectedRole.value;
  final className = selectedClass.value;

  filteredUsers.value = users.where((user) {
    // Filtre de recherche
    final matchesSearch =
        user['firstName'].toString().toLowerCase().contains(query) ||
            user['lastName'].toString().toLowerCase().contains(query) ||
            user['email'].toString().toLowerCase().contains(query) ||
            user['username'].toString().toLowerCase().contains(query);

    // Filtre de rôle
    final matchesRole = role == 'Tous' || user['role'] == role;

    // Filtre de classe
    final matchesClass = className == 'Toutes' ||
        user['class'] == className ||
        (user['role'] != 'Étudiant' && user['role'] != 'Professeur');

    return matchesSearch && matchesRole && matchesClass;
  }).toList();
}

void prepareForAddUser() {
  editingUser.value = {};
  clearTextControllers();
}

void prepareForEditUser(Map<String, dynamic> user) {
  editingUser.value = Map<String, dynamic>.from(user);

  firstNameController.text = user['firstName'] ?? '';
  lastNameController.text = user['lastName'] ?? '';
  emailController.text = user['email'] ?? '';
  usernameController.text = user['username'] ?? '';
  passwordController.clear(); // Ne pas remplir le mot de passe
}

Future<void> saveUser() async {
  // Validation
  if (firstNameController.text.isEmpty ||
      lastNameController.text.isEmpty ||
      emailController.text.isEmpty ||
      usernameController.text.isEmpty) {
    Get.snackbar(
      'Erreur',
      'Veuillez remplir tous les champs obligatoires',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (!GetUtils.isEmail(emailController.text)) {
    Get.snackbar(
      'Erreur',
      'L\'adresse e-mail n\'est pas valide',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  // Si c'est un nouvel utilisateur, vérifier le mot de passe
  if (editingUser.value.isEmpty && passwordController.text.isEmpty) {
    Get.snackbar(
      'Erreur',
      'Le mot de passe est obligatoire pour un nouvel utilisateur',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  try {
    isLoading.value = true;

    // Simuler un délai réseau
    await Future.delayed(Duration(seconds: 1));

    if (editingUser.value.isEmpty) {
      // Ajouter un nouvel utilisateur
      final newUser = {
        'id': 1000 + users.length,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'role': 'Étudiant', // Par défaut
        'class': 'CM2-A', // Par défaut
        'avatar': 'assets/avatars/boy1.png', // Par défaut
        'status': 'Actif',
        'createdAt': '15/03/2025',
      };

      users.add(newUser);
      Get.snackbar(
        'Succès',
        'Utilisateur ajouté avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      // Mettre à jour un utilisateur existant
      final index = users.indexWhere((u) => u['id'] == editingUser.value['id']);
      if (index != -1) {
        users[index] = {
          ...users[index],
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'username': usernameController.text,
        };

        Get.snackbar(
          'Succès',
          'Utilisateur mis à jour avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }

    applyFilters();
    Get.back(); // Fermer le dialogue
  } catch (e) {
    Get.snackbar(
      'Erreur',
      'Une erreur est survenue: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

void deleteUser(int userId) {
  Get.dialog(
    AlertDialog(
      title: Text('Confirmer la suppression'),
      content: Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ? Cette action est irréversible.'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Annuler'),
        ),
        TextButton(
          onPressed: () async {
            try {
              Get.back(); // Fermer le dialogue de confirmation
              isLoading.value = true;

              // Simuler un délai réseau
              await Future.delayed(Duration(seconds: 1));

              final index = users.indexWhere((u) => u['id'] == userId);
              if (index != -1) {
                users.removeAt(index);
                applyFilters();

                Get.snackbar(
                  'Succès',
                  'Utilisateur supprimé avec succès',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            } catch (e) {
              Get.snackbar(
                'Erreur',
                'Une erreur est survenue: $e',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } finally {
              isLoading.value = false;
            }
          },
          child: Text('Supprimer'),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
        ),
      ],
    ),
  );
}

void toggleUserStatus(int userId) async {
  try {
    final index = users.indexWhere((u) => u['id'] == userId);
    if (index != -1) {
      isLoading.value = true;

      // Simuler un délai réseau
      await Future.delayed(Duration(milliseconds: 500));

      // Inverser le statut
      final newStatus = users[index]['status'] == 'Actif' ? 'Inactif' : 'Actif';
      users[index] = {
        ...users[index],
        'status': newStatus
      };

      applyFilters();

      Get.snackbar(
        'Statut modifié',
        'L\'utilisateur est maintenant ${users[index]['status']}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Erreur',
      'Une erreur est survenue: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}

void setUserRole(int userId, String role) async {
  try {
    final index = users.indexWhere((u) => u['id'] == userId);
    if (index != -1) {
      isLoading.value = true;

      // Simuler un délai réseau
      await Future.delayed(Duration(milliseconds: 500));

      users[index] = {
        ...users[index],
        'role': role
      };

      applyFilters();

      Get.snackbar(
        'Rôle modifié',
        'L\'utilisateur est maintenant ${role}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Erreur',
      'Une erreur est survenue: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false;
  }
}