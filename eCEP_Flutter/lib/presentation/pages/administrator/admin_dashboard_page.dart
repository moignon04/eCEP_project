import 'package:client/app/extension/color.dart';
import 'package:client/app/services/local_storage.dart';
import 'package:client/presentation/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  final LocalStorageService _storageService = Get.find<LocalStorageService>();
  final AuthController _authController = Get.find<AuthController>();

  late TabController _tabController;
  bool _isLoading = false;

  // Statistiques du tableau de bord
  final Map<String, int> _stats = {
    'totalUsers': 458,
    'students': 375,
    'teachers': 42,
    'parents': 29,
    'administrators': 12,
    'activeCourses': 52,
    'pendingContent': 8,
  };

  // Liste des utilisateurs récents
  final List<Map<String, dynamic>> _recentUsers = [
    {
      'id': 1,
      'firstName': 'Marie',
      'lastName': 'Koné',
      'email': 'marie.kone@ecole.bf',
      'role': 'teacher',
      'createdAt': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': 2,
      'firstName': 'Jules',
      'lastName': 'Ouedraogo',
      'email': 'jules.o@ecole.bf',
      'role': 'student',
      'createdAt': DateTime.now().subtract(Duration(days: 3)),
    },
    {
      'id': 3,
      'firstName': 'Aminata',
      'lastName': 'Sawadogo',
      'email': 'aminata.s@ecole.bf',
      'role': 'parent',
      'createdAt': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 4,
      'firstName': 'Pascal',
      'lastName': 'Dembélé',
      'email': 'pascal.d@ecole.bf',
      'role': 'teacher',
      'createdAt': DateTime.now().subtract(Duration(days: 7)),
    },
    {
      'id': 5,
      'firstName': 'Raissa',
      'lastName': 'Bamba',
      'email': 'raissa.b@ecole.bf',
      'role': 'student',
      'createdAt': DateTime.now().subtract(Duration(days: 8)),
    },
  ];

  // Liste des contenus en attente de validation
  final List<Map<String, dynamic>> _pendingContent = [
    {
      'id': 1,
      'title': 'Fractions et décimaux',
      'type': 'course',
      'subject': 'Mathématiques',
      'submittedBy': 'Marie Koné',
      'submittedAt': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': 2,
      'title': 'Conjugaison du passé composé',
      'type': 'course',
      'subject': 'Français',
      'submittedBy': 'Pascal Dembélé',
      'submittedAt': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': 3,
      'title': 'Quiz sur les régions du Burkina Faso',
      'type': 'exercise',
      'subject': 'Histoire-Géographie',
      'submittedBy': 'Marie Koné',
      'submittedAt': DateTime.now().subtract(Duration(days: 3)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkRole();
  }

  void _checkRole() {
    final user = _storageService.user;
    if (user == null || user.role != 'admin') {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now());
    final user = _storageService.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, Admin ${user?.firstName ?? ""}',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              today,
              style: TextStyle(
                color: AppColors.textMedium,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.textDark),
            onPressed: () {
              // Naviguer vers les notifications
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                user?.firstName?.substring(0, 1).toUpperCase() ?? "A",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMedium,
          tabs: const [
            Tab(text: 'Tableau de bord'),
            Tab(text: 'Utilisateurs'),
            Tab(text: 'Contenu'),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildUsersTab(),
          _buildContentTab(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final user = _storageService.user;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.firstName?.substring(0, 1).toUpperCase() ?? "A",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${user?.firstName ?? ""} ${user?.lastName ?? ""}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Administrateur',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: AppColors.primary),
            title: Text('Tableau de bord'),
            onTap: () {
              _tabController.animateTo(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: AppColors.primary),
            title: Text('Gestion des utilisateurs'),
            onTap: () {
              _tabController.animateTo(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: AppColors.primary),
            title: Text('Gestion du contenu'),
            onTap: () {
              _tabController.animateTo(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: AppColors.primary),
            title: Text('Gestion des classes'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManagementPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppColors.primary),
            title: Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: AppColors.error),
            title: Text('Déconnexion', style: TextStyle(color: AppColors.error)),
            onTap: () async {
              Navigator.pop(context);
              await _authController.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatisticsSection(),
          SizedBox(height: 24),
          _buildRecentActivitySection(),
          SizedBox(height: 24),
          _buildQuickActionsSection(),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard('Utilisateurs', _stats['totalUsers']!.toString(), Icons.people, AppColors.primary),
            _buildStatCard('Élèves', _stats['students']!.toString(), Icons.school, AppColors.secondary),
            _buildStatCard('Enseignants', _stats['teachers']!.toString(), Icons.person, AppColors.success),
            _buildStatCard('Parents', _stats['parents']!.toString(), Icons.family_restroom, AppColors.info),
            _buildStatCard('Cours actifs', _stats['activeCourses']!.toString(), Icons.book, AppColors.warning),
            _buildStatCard('Contenu en attente', _stats['pendingContent']!.toString(), Icons.pending, AppColors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _recentUsers.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final user = _recentUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getRoleColor(user['role']).withOpacity(0.2),
                  child: Text(
                    user['firstName'].substring(0, 1),
                    style: TextStyle(
                      color: _getRoleColor(user['role']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text('${user['firstName']} ${user['lastName']}'),
                subtitle: Text(_getRoleName(user['role'])),
                trailing: Text(
                  _formatDate(user['createdAt']),
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  // Naviguer vers les détails de l'utilisateur
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Ajouter un utilisateur',
                Icons.person_add,
                AppColors.primary,
                    () {
                  // Naviguer vers la page d'ajout d'utilisateur
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Valider du contenu',
                Icons.check_circle,
                AppColors.success,
                    () {
                  _tabController.animateTo(2);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Gérer les classes',
                Icons.school,
                AppColors.secondary,
                    () {
                  // Naviguer vers la page de gestion des classes
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Paramètres',
                Icons.settings,
                AppColors.info,
                    () {
                  // Naviguer vers la page des paramètres
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    // Cette version est simplifiée - dans une véritable application, cette partie
    // serait plus élaborée avec recherche, filtrage et pagination
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un utilisateur',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Naviguer vers la page d'ajout d'utilisateur
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                itemCount: _recentUsers.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = _recentUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRoleColor(user['role']).withOpacity(0.2),
                      child: Text(
                        user['firstName'].substring(0, 1),
                        style: TextStyle(
                          color: _getRoleColor(user['role']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text('${user['firstName']} ${user['lastName']}'),
                    subtitle: Text(user['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(_getRoleName(user['role'])),
                          backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getRoleColor(user['role']),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.edit, color: AppColors.primary),
                          onPressed: () {
                            // Modifier l'utilisateur
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: AppColors.error),
                          onPressed: () {
                            // Supprimer l'utilisateur
                            _showDeleteDialog(user);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Naviguer vers les détails de l'utilisateur
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher du contenu',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.filter_list),
                label: Text('Filtrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Afficher les options de filtrage
                },
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Contenu en attente de validation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _pendingContent.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppColors.success,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tout le contenu a été validé !',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _pendingContent.length,
              itemBuilder: (context, index) {
                final content = _pendingContent[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildContentTypeIcon(content['type']),
                            SizedBox(width: 8),
                            Text(
                              content['subject'],
                              style: TextStyle(
                                color: _getSubjectColor(content['subject']),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              _formatDate(content['submittedAt']),
                              style: TextStyle(
                                color: AppColors.textMedium,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          content['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Soumis par: ${content['submittedBy']}',
                          style: TextStyle(
                            color: AppColors.textMedium,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              child: Text('Refuser'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Refuser le contenu
                              },
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              child: Text('Approuver'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Approuver le contenu
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'course':
        icon = Icons.book;
        color = AppColors.primary;
        break;
      case 'exercise':
        icon = Icons.assignment;
        color = AppColors.secondary;
        break;
      case 'exam':
        icon = Icons.quiz;
        color = AppColors.warning;
        break;
      default:
        icon = Icons.description;
        color = AppColors.textMedium;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer l\'utilisateur'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ${user['firstName']} ${user['lastName']} ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Logique de suppression
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return AppColors.error;
      case 'teacher':
        return AppColors.primary;
      case 'parent':
        return AppColors.info;
      case 'student':
        return AppColors.secondary;
      default:
        return AppColors.textMedium;
    }
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'admin':
        return 'Administrateur';
      case 'teacher':
        return 'Enseignant';
      case 'parent':
        return 'Parent';
      case 'student':
        return 'Élève';
      default:
        return 'Utilisateur';
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathématiques':
        return AppColors.mathColor;
      case 'français':
        return AppColors.frenchColor;
      case 'histoire-géographie':
        return AppColors.historyColor;
      case 'sciences':
        return AppColors.scienceColor;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}