import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/domain/entities/user.dart';

class TeacherDrawer extends StatelessWidget {
  final User teacher;
  final String currentPage;

  const TeacherDrawer({
    Key? key,
    required this.teacher,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  title: 'Tableau de bord',
                  icon: Icons.dashboard_outlined,
                  onTap: () => _navigateTo('/teacher-dashboard'),
                  isSelected: currentPage == 'dashboard',
                ),
                _buildNavItem(
                  title: 'Mes classes',
                  icon: Icons.people_outlined,
                  onTap: () => _navigateTo('/class-progress'),
                  isSelected: currentPage == 'classes',
                ),
                _buildNavItem(
                  title: 'Gestion des cours',
                  icon: Icons.menu_book_outlined,
                  onTap: () => _navigateTo('/teacher-courses'),
                  isSelected: currentPage == 'courses',
                ),
                _buildNavItem(
                  title: 'Gestion des exercices',
                  icon: Icons.assignment_outlined,
                  onTap: () => _navigateTo('/teacher-exercises'),
                  isSelected: currentPage == 'exercises',
                ),
                _buildNavItem(
                  title: 'Évaluations et examens',
                  icon: Icons.grading_outlined,
                  onTap: () => _navigateTo('/teacher-exams'),
                  isSelected: currentPage == 'exams',
                ),
                Divider(),
                _buildNavItem(
                  title: 'Messages',
                  icon: Icons.message_outlined,
                  onTap: () => _navigateTo('/teacher-messages'),
                  isSelected: currentPage == 'messages',
                  badge: '3',
                ),
                _buildNavItem(
                  title: 'Calendrier',
                  icon: Icons.calendar_today_outlined,
                  onTap: () => _navigateTo('/teacher-calendar'),
                  isSelected: currentPage == 'calendar',
                ),
                Divider(),
                _buildNavItem(
                  title: 'Mon profil',
                  icon: Icons.person_outline,
                  onTap: () => _navigateTo('/teacher-profile'),
                  isSelected: currentPage == 'profile',
                ),
                _buildNavItem(
                  title: 'Paramètres',
                  icon: Icons.settings_outlined,
                  onTap: () => _navigateTo('/teacher-settings'),
                  isSelected: currentPage == 'settings',
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(teacher.avatar),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${teacher.firstName} ${teacher.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Professeur',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'CM2',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
    String? badge,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textMedium,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: badge != null
          ? Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
        child: Text(
          badge,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : null,
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.help_outline,
            color: AppColors.textMedium,
          ),
          SizedBox(width: 16),
          Text(
            'Centre d\'aide',
            style: TextStyle(
              color: AppColors.textDark,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              // Show confirmation dialog
              Get.dialog(
                AlertDialog(
                  title: Text('Se déconnecter'),
                  content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed('/login');
                      },
                      child: Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateTo(String route) {
    Get.back(); // Close drawer
    if (Get.currentRoute != route) {
      Get.offAllNamed(route);
    }
  }
}