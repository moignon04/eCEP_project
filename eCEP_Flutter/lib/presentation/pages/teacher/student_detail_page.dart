import 'package:flutter/material.dart';
import 'package:client/app/extension/color.dart';

class StudentDetailPage extends StatelessWidget {
  final int studentId;

  const StudentDetailPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final student = {
      'id': 1,
      'firstName': 'Lucas',
      'lastName': 'Dupont',
      'avatar': 'assets/avatars/boy1.png',
      'completedExercises': 28,
      'averageScore': 78.5,
      'subjects': {
        'Mathématiques': 72.5,
        'Français': 80.2,
        'Histoire-Géographie': 68.7,
        'Sciences': 77.9,
      },
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          '${student['firstName']} ${student['lastName']}',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Avatar et Informations de base
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(student['avatar'] as String),
                    radius: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${student['firstName']} ${student['lastName']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Score moyen: ${student['averageScore']}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exercices terminés: ${student['completedExercises']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Performances par matière
            Text(
              'Performances par matière',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            ...(student['subjects'] as Map<String, double>).entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          '${entry.value}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}