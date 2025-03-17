import 'package:flutter/material.dart';
import 'package:client/app/extension/color.dart';

class SubjectPerformanceCard extends StatelessWidget {
  final String subject;
  final double averageScore;
  final int completedExercises;
  final Color color;

  const SubjectPerformanceCard({
    Key? key,
    required this.subject,
    required this.averageScore,
    required this.completedExercises,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _getSubjectIcon(subject),
                color: color,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMedium,
                    ),
                    children: [
                      TextSpan(text: 'Score moyen: '),
                      TextSpan(
                        text: '${averageScore.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(averageScore),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$completedExercises exercices terminés',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: _getScoreColor(averageScore),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                '${averageScore.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _getScoreColor(averageScore),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathématiques':
        return Icons.calculate_outlined;
      case 'français':
        return Icons.menu_book_outlined;
      case 'histoire-géographie':
        return Icons.public_outlined;
      case 'sciences':
        return Icons.science_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

