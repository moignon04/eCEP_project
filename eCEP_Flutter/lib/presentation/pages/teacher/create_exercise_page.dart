import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/teacher/create_exercise_controller.dart';
import 'package:client/presentation/widgets/teacher/teacher_drawer.dart';

class CreateExercisePage extends StatelessWidget {
  final CreateExerciseController controller = Get.put(CreateExerciseController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.isEdit.value ? 'Modifier l\'exercice' : 'Nouvel exercice',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        )),
        actions: [
          Obx(() => controller.isSaving.value
              ? Container(
            margin: EdgeInsets.all(8),
            width: 40,
            child: Center(child: CircularProgressIndicator()),
          )
              : TextButton.icon(
            onPressed: () => controller.saveExercise(),
            icon: Icon(Icons.save),
            label: Text('Enregistrer'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExerciseInfoSection(),
              SizedBox(height: 24),
              _buildQuestionsSection(),
              SizedBox(height: 24),
              _buildPublishSection(),
              SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExerciseInfoSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations générales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16),
            // Titre de l'exercice
            TextField(
              decoration: InputDecoration(
                labelText: 'Titre de l\'exercice',
                hintText: 'Ex: Addition de fractions',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              controller: TextEditingController(text: controller.title.value),
              onChanged: (value) => controller.title.value = value,
            ),
            SizedBox(height: 16),
            // Type d'exercice
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type d\'exercice',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              value: controller.type.value,
              items: [
                DropdownMenuItem(value: 'quiz', child: Text('Quiz à choix multiples')),
                DropdownMenuItem(value: 'text', child: Text('Réponse textuelle')),
                DropdownMenuItem(value: 'interactive', child: Text('Exercice interactif')),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.type.value = value;
                }
              },
            ),
            SizedBox(height: 16),
            // Cours associé
            Obx(() => DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Cours associé',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              value: controller.selectedCourseId.value == 0 && controller.availableCourses.isNotEmpty
                  ? controller.availableCourses.first.id
                  : controller.selectedCourseId.value,
              items: controller.availableCourses.map((course) => DropdownMenuItem(
                value: course.id,
                child: Text(course.title),
              )).toList(),
              onChanged: controller.onCourseChanged,
            )),
            SizedBox(height: 16),
            // Chapitre associé
            Obx(() => DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Cours associé',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book),
              ),
              value: controller.selectedCourseId.value == 0 && controller.availableCourses.isNotEmpty
                  ? controller.availableCourses.first.id
                  : controller.selectedCourseId.value,
              items: controller.availableCourses.map((course) => DropdownMenuItem(
                value: course.id,
                child: Text(course.title),
              )).toList(),
              onChanged: controller.onCourseChanged,
            )),
            SizedBox(height: 16),
            // Difficulté
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Difficulté',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() => Slider(
                  value: controller.difficulty.value.toDouble(),
                  min: 1,
                  max: 3,
                  divisions: 2,
                  label: _getDifficultyLabel(controller.difficulty.value),
                  activeColor: _getDifficultyColor(controller.difficulty.value),
                  onChanged: (value) => controller.difficulty.value = value.toInt(),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Facile', style: TextStyle(color: Colors.green)),
                    Text('Moyen', style: TextStyle(color: Colors.orange)),
                    Text('Difficile', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Points à gagner
            TextField(
              decoration: InputDecoration(
                labelText: 'Points à gagner',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.emoji_events),
              ),
              controller: TextEditingController(text: controller.points.value.toString()),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final points = int.tryParse(value);
                if (points != null && points > 0) {
                  controller.points.value = points;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.addQuestion(),
                  icon: Icon(Icons.add),
                  label: Text('Ajouter une question'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.questions.length,
              separatorBuilder: (context, index) => Divider(height: 32, thickness: 1),
              itemBuilder: (context, index) => _buildQuestionItem(index),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionItem(int index) {
    final question = controller.questions[index];
    final isChoiceQuestion = question['type'] == 'choice';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question header and controls
        Row(
          children: [
            Text(
              'Question ${index + 1}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8),
            DropdownButton<String>(
              value: question['type'],
              underline: Container(),
              items: [
                DropdownMenuItem(value: 'choice', child: Text('Choix multiples')),
                DropdownMenuItem(value: 'text', child: Text('Réponse textuelle')),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.updateQuestionType(index, value);
                }
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.removeQuestion(index),
              tooltip: 'Supprimer la question',
            ),
          ],
        ),
        SizedBox(height: 8),
        // Question text
        TextField(
          decoration: InputDecoration(
            labelText: 'Texte de la question',
            hintText: 'Ex: Combien font 1/2 + 1/4 ?',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: question['text']),
          onChanged: (value) => controller.updateQuestionText(index, value),
          maxLines: 2,
        ),
        SizedBox(height: 16),
        // Choices or text answer depending on question type
        if (isChoiceQuestion) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Options de réponse',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              TextButton.icon(
                onPressed: () => controller.addChoice(index),
                icon: Icon(Icons.add, size: 16),
                label: Text('Ajouter une option'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: question['choices'].length,
            itemBuilder: (context, choiceIndex) {
              final choice = question['choices'][choiceIndex];
              final isCorrect = question['correctAnswer'] == choice['id'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Radio<String>(
                      value: choice['id'],
                      groupValue: question['correctAnswer'],
                      onChanged: (value) {
                        if (value != null) {
                          controller.setCorrectAnswer(index, value);
                        }
                      },
                      activeColor: AppColors.success,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Option ${choiceIndex + 1}',
                          hintText: 'Texte de l\'option',
                          border: OutlineInputBorder(),
                          suffixIcon: isCorrect ? Icon(Icons.check_circle, color: AppColors.success) : null,
                        ),
                        controller: TextEditingController(text: choice['text']),
                        onChanged: (value) => controller.updateChoiceText(index, choiceIndex, value),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeChoice(index, choiceIndex),
                      tooltip: 'Supprimer cette option',
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            'Sélectionnez la réponse correcte en utilisant les boutons radio.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
              fontStyle: FontStyle.italic,
            ),
          ),
        ] else ...[
          // Text answer
          Text(
            'Réponse correcte (texte)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Réponse attendue',
              hintText: 'Ex: 3/4',
              border: OutlineInputBorder(),
              helperText: 'La réponse de l\'élève doit correspondre exactement à ce texte.',
            ),
            controller: TextEditingController(text: question['correctAnswer']),
            onChanged: (value) => controller.updateTextAnswer(index, value),
          ),
          SizedBox(height: 8),
          Text(
            'Note: la réponse de l\'élève doit correspondre exactement à ce texte (insensible à la casse).',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPublishSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publication',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16),
            Obx(() => SwitchListTile(
              title: Text('Publier cet exercice'),
              subtitle: Text(
                controller.isPublished.value
                    ? 'L\'exercice sera immédiatement disponible pour les élèves'
                    : 'L\'exercice sera enregistré comme brouillon',
              ),
              value: controller.isPublished.value,
              onChanged: (value) => controller.isPublished.value = value,
              activeColor: AppColors.success,
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Facile';
      case 2:
        return 'Moyen';
      case 3:
        return 'Difficile';
      default:
        return 'Facile';
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}