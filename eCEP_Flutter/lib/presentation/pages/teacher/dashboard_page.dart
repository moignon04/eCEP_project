import 'package:client/app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/teacher/teacher_dashboard_controller.dart';
import 'package:client/presentation/widgets/teacher/teacher_bottom_nav.dart';
import 'package:client/presentation/widgets/teacher/class_stats_card.dart';
import 'package:client/presentation/widgets/teacher/subject_performance_card.dart';
import 'package:client/presentation/widgets/teacher/progress_chart.dart';
import 'package:client/presentation/widgets/teacher/student_progress_card.dart';
import 'package:client/presentation/widgets/teacher/teacher_drawer.dart'; // Importez le drawer

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({Key? key}) : super(key: key);

  @override
  _TeacherDashboardPageState createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  final TeacherDashboardController controller = Get.put(TeacherDashboardController());
  final LocalStorageService _storageService = Get.find<LocalStorageService>();

  @override


  void _checkRole() {
    final user = _storageService.user;
    if (user == null || user.role != 'teacher') {
      // Rediriger vers la page de connexion si le rôle n'est pas enseignant
      Get.offAllNamed('/login');
    }
  }
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, ${controller.teacher.value.firstName}',
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
        )),
        actions: [
          Obx(() => CircleAvatar(
            backgroundImage: AssetImage(controller.teacher.value.avatar),
            radius: 18,
          )),
          const SizedBox(width: 16),
        ],
      ),
      drawer: TeacherDrawer( // Ajoutez le drawer ici
        teacher: controller.teacher.value,
        currentPage: 'dashboard', // Indiquez la page actuelle
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildClassStatsGrid(),
              const SizedBox(height: 24),
              _buildPerformanceSection(),
              const SizedBox(height: 24),
              _buildStudentsToReviewSection(),
              const SizedBox(height: 24),
              _buildRecentActivitiesSection(),
              const SizedBox(height: 24),
              _buildSubjectDetailsSection(),
            ],
          ),
        );
      }),
      bottomNavigationBar: TeacherBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigation logic would go here
          if (index == 1) {
            // Navigate to class progress page
            Get.toNamed('/class-progress');
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Tableau de bord',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildClassStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ClassStatsCard(
          title: 'Élèves',
          value: controller.classStats.value['totalStudents'].toString(),
          icon: Icons.people,
          color: AppColors.primary,
        ),
        ClassStatsCard(
          title: 'Note moyenne',
          value: '${controller.classStats.value['averageScore'].toStringAsFixed(1)}%',
          icon: Icons.assessment,
          color: AppColors.success,
        ),
        ClassStatsCard(
          title: 'Exercices terminés',
          value: controller.classStats.value['completedExercises'].toString(),
          icon: Icons.assignment_turned_in,
          color: AppColors.secondary,
        ),
        ClassStatsCard(
          title: 'À revoir',
          value: controller.classStats.value['studentsToReview'].toString(),
          icon: Icons.warning,
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance par matière',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to detailed analytics page
                Get.toNamed('/class-analytics');
              },
              child: Text(
                'Voir plus',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SubjectProgressChart(
          subjectScores: controller.subjectScores,
        ),
      ],
    );
  }

  Widget _buildStudentsToReviewSection() {
    final studentsToReview = controller.getStudentsToReview();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Élèves à revoir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to students list filtered by "needs review"
                Get.toNamed('/class-progress', arguments: {'filter': 'review'});
              },
              child: Text(
                'Voir tous',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...studentsToReview.map((student) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: StudentProgressCard(
            name: student['name'],
            avatar: student['avatar'],
            completedExercises: 0, // Not displayed in this context
            averageScore: student['score'],
            onTap: () {
              // Navigate to student detail page
              Get.toNamed('/student-detail', arguments: {'studentId': student['id']});
            },
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildRecentActivitiesSection() {
    final recentActivities = controller.getRecentActivities();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activités récentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentActivities.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = recentActivities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getActivityColor(activity['type']).withOpacity(0.1),
                  child: Icon(
                    _getActivityIcon(activity['type']),
                    color: _getActivityColor(activity['type']),
                    size: 18,
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppColors.textDark),
                    children: [
                      TextSpan(
                        text: activity['student'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ${activity['activity']}',
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
                trailing: activity['score'] != null
                    ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(activity['score']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${activity['score']}%',
                    style: TextStyle(
                      color: _getScoreColor(activity['score']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Détails par matière',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.subjectPerformances.length,
          itemBuilder: (context, index) {
            final subject = controller.subjectPerformances[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SubjectPerformanceCard(
                subject: subject['subject'],
                averageScore: subject['averageScore'],
                completedExercises: subject['completedExercises'],
                color: subject['color'],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'submission':
        return AppColors.primary;
      case 'question':
        return AppColors.secondary;
      case 'completion':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'submission':
        return Icons.assignment_turned_in;
      case 'question':
        return Icons.help_outline;
      case 'completion':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}