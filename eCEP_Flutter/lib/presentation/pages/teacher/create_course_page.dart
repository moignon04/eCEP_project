import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/teacher/create_course_controller.dart';
import 'package:client/presentation/widgets/app_bar_widget.dart';
import 'package:reorderables/reorderables.dart';

class CreateCoursePage extends StatelessWidget {
  final CreateCourseController controller = Get.put(CreateCourseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Créer un cours',
        showBackButton: true,
        actions: [
          Obx(() => controller.isSaving.value
              ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 2,
            ),
          )
              : IconButton(
            icon: Icon(Icons.save_outlined, color: AppColors.primary),
            onPressed: () => _showSaveOptions(context),
          )),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : _buildForm(context)),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCourseInfo(),
          SizedBox(height: 20),
          _buildSubjectSelector(),
          SizedBox(height: 20),
          _buildImagePicker(),
          SizedBox(height: 20),
          _buildChaptersSection(),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations sur le cours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                labelText: 'Titre du cours *',
                hintText: 'Ex: Les fractions',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description du cours *',
                hintText: 'Décrivez le contenu et les objectifs du cours...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Matière',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16),
            Obx(() => Wrap(
              spacing: 8,
              children: controller.subjects.map((subject) {
                final isSelected = controller.selectedSubject.value == subject;
                Color color;
                switch (subject.toLowerCase()) {
                  case 'mathématiques':
                    color = AppColors.mathColor;
                    break;
                  case 'français':
                    color = AppColors.frenchColor;
                    break;
                  case 'histoire-géographie':
                    color = AppColors.historyColor;
                    break;
                  case 'sciences':
                    color = AppColors.scienceColor;
                    break;
                  default:
                    color = AppColors.primary;
                }

                return ChoiceChip(
                  label: Text(subject),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      controller.selectedSubject.value = subject;
                    }
                  },
                  backgroundColor: Colors.white,
                  selectedColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? color : AppColors.textMedium,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Image du cours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Obx(() => controller.courseImage.value.isEmpty
                  ? Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
              )
                  : Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(controller.courseImage.value),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => controller.pickImage(),
                icon: Icon(Icons.add_photo_alternate),
                label: Text('Sélectionner une image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChaptersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chapitres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => controller.addChapter(),
              icon: Icon(Icons.add),
              label: Text('Ajouter un chapitre'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() => controller.chapters.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 50,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Aucun chapitre ajouté',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Cliquez sur "Ajouter un chapitre" pour commencer',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
            : ReorderableWrap(
          spacing: 0,
          runSpacing: 0,
          padding: EdgeInsets.zero,
          onReorder: (oldIndex, newIndex) {
            final chapter = controller.chapters.removeAt(oldIndex);
            controller.chapters.insert(newIndex, chapter);
          },
          children: List.generate(
            controller.chapters.length,
                (index) => _buildChapterCard(index),
          ),
        )),
      ],
    );
  }

  Widget _buildChapterCard(int index) {
    final chapter = controller.chapters[index];
    return Card(
      key: ValueKey(chapter['id']),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.drag_handle,
                  color: AppColors.textLight,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Titre du chapitre',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    onChanged: (value) => controller.updateChapterTitle(index, value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.removeChapter(index),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLessonsSection(index),
                SizedBox(height: 20),
                _buildExercisesSection(index),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsSection(int chapterIndex) {
    final lessons = controller.chapters[chapterIndex]['lessons'] as List<Map<String, dynamic>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Leçons',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => controller.addLesson(chapterIndex),
              icon: Icon(Icons.add, size: 16),
              label: Text('Ajouter'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        lessons.isEmpty
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Aucune leçon ajoutée',
            style: TextStyle(
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: lessons.length,
          itemBuilder: (context, lessonIndex) {
            final lesson = lessons[lessonIndex];
            return Card(
              elevation: 0,
              margin: EdgeInsets.only(bottom: 8),
              color: Colors.grey[100],
              child: ListTile(
                leading: Icon(
                  _getLessonTypeIcon(lesson['type']),
                  color: AppColors.primary,
                ),
                title: Text(
                  lesson['title'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${lesson['type']} • ${lesson['duration']} min',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () => _showLessonEditDialog(chapterIndex, lessonIndex),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => controller.removeLesson(chapterIndex, lessonIndex),
                    ),
                  ],
                ),
                onTap: () => _showLessonEditDialog(chapterIndex, lessonIndex),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExercisesSection(int chapterIndex) {
    final exercises = controller.chapters[chapterIndex]['exercises'] as List<Map<String, dynamic>>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercices',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => controller.addExercise(chapterIndex),
              icon: Icon(Icons.add, size: 16),
              label: Text('Ajouter'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        exercises.isEmpty
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Aucun exercice ajouté',
            style: TextStyle(
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          itemBuilder: (context, exerciseIndex) {
            final exercise = exercises[exerciseIndex];
            return Card(
              elevation: 0,
              margin: EdgeInsets.only(bottom: 8),
              color: Colors.grey[100],
              child: ListTile(
                leading: Icon(
                  _getExerciseTypeIcon(exercise['type']),
                  color: AppColors.secondary,
                ),
                title: Text(
                  exercise['title'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${exercise['type']} • ${exercise['difficulty']} étoile${exercise['difficulty'] > 1 ? 's' : ''} • ${exercise['points']} pts',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () => _showExerciseEditDialog(chapterIndex, exerciseIndex),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => controller.removeExercise(chapterIndex, exerciseIndex),
                    ),
                  ],
                ),
                onTap: () => _showExerciseEditDialog(chapterIndex, exerciseIndex),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showLessonEditDialog(int chapterIndex, int lessonIndex) {
    final lesson = (controller.chapters[chapterIndex]['lessons'] as List<Map<String, dynamic>>)[lessonIndex];

    final titleController = TextEditingController(text: lesson['title']);
    final contentController = TextEditingController(text: lesson['content']);
    final durationController = TextEditingController(text: lesson['duration'].toString());

    final selectedType = lesson['type'].toString().obs;

    Get.dialog(
      AlertDialog(
        title: Text('Modifier la leçon'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Type de contenu'),
              SizedBox(height: 8),
              Obx(() => Wrap(
                spacing: 8,
                children: controller.mediaTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: selectedType.value == type,
                    onSelected: (selected) {
                      if (selected) {
                        selectedType.value = type;
                      }
                    },
                  );
                }).toList(),
              )),
              SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: 'Durée (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'Contenu',
                  border: OutlineInputBorder(),
                  hintText: 'URL ou texte du contenu...',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newData = {
                'title': titleController.text,
                'type': selectedType.value,
                'duration': int.tryParse(durationController.text) ?? 15,
                'content': contentController.text,
              };

              controller.editLesson(chapterIndex, lessonIndex, newData);
              Get.back();
            },
            child: Text('Enregistrer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showExerciseEditDialog(int chapterIndex, int exerciseIndex) {
    final exercise = (controller.chapters[chapterIndex]['exercises'] as List<Map<String, dynamic>>)[exerciseIndex];

    final titleController = TextEditingController(text: exercise['title']);
    final pointsController = TextEditingController(text: exercise['points'].toString());

    final selectedType = exercise['type'].toString().obs;
    final difficulty = exercise['difficulty'].obs;

    final exerciseTypes = ['quiz', 'interactive', 'problem'].obs;

    Get.dialog(
      AlertDialog(
        title: Text('Modifier l\'exercice'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Type d\'exercice'),
              SizedBox(height: 8),
              Obx(() => Wrap(
                spacing: 8,
                children: exerciseTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: selectedType.value == type,
                    onSelected: (selected) {
                      if (selected) {
                        selectedType.value = type;
                      }
                    },
                  );
                }).toList(),
              )),
              SizedBox(height: 16),
              Text('Difficulté'),
              SizedBox(height: 8),
              Obx(() => Row(
                children: [1, 2, 3].map((level) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: difficulty.value >= level
                          ? Colors.amber
                          : Colors.grey[300],
                      size: 30,
                    ),
                    onPressed: () {
                      difficulty.value = level;
                    },
                  );
                }).toList(),
              )),
              SizedBox(height: 16),
              TextField(
                controller: pointsController,
                decoration: InputDecoration(
                  labelText: 'Points',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text('Questions (${(exercise['questions'] as List).length})'),
              SizedBox(height: 8),
              ..._buildQuestionsList(exercise['questions'] as List<Map<String, dynamic>>),
              SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () => controller.addQuestion(chapterIndex, exerciseIndex),
                  icon: Icon(Icons.add),
                  label: Text('Ajouter une question'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newData = {
                'title': titleController.text,
                'type': selectedType.value,
                'difficulty': difficulty.value,
                'points': int.tryParse(pointsController.text) ?? 10,
              };

              controller.editExercise(chapterIndex, exerciseIndex, newData);
              Get.back();
            },
            child: Text('Enregistrer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuestionsList(List<Map<String, dynamic>> questions) {
    if (questions.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Aucune question ajoutée',
            style: TextStyle(
              color: AppColors.textLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      ];
    }

    return questions.map((question) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          question['text'],
          style: TextStyle(fontSize: 14),
        ),
        subtitle: Text(
          '${question['type']} • ${(question['choices'] as List).length} options',
          style: TextStyle(fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          // Ouvrir l'éditeur de question (non implémenté dans cette version)
          Get.snackbar(
            'Information',
            'L\'éditeur de questions sera disponible dans une prochaine version',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    }).toList();
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Résumé',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${controller.chapters.length} chapitres • ${controller.totalLessons} leçons • ${controller.totalExercises} exercices',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Durée estimée: ${controller.estimatedDuration} minutes',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: controller.isSaving.value
                ? null
                : () => controller.previewCourse(),
            icon: Icon(Icons.visibility),
            label: Text('Prévisualiser'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _showSaveOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.save, color: AppColors.primary),
                title: Text('Enregistrer et publier'),
                subtitle: Text('Le cours sera disponible pour les élèves'),
                onTap: () {
                  Navigator.pop(context);
                  controller.saveCourse();
                },
              ),
              ListTile(
                leading: Icon(Icons.save_outlined, color: AppColors.secondary),
                title: Text('Enregistrer comme brouillon'),
                subtitle: Text('Le cours sera enregistré mais non publié'),
                onTap: () {
                  Navigator.pop(context);
                  controller.saveDraft();
                },
              ),
              Obx(() => SwitchListTile(
                value: controller.isDownloadable.value,
                onChanged: (value) {
                  controller.isDownloadable.value = value;
                },
                title: Text('Disponible hors ligne'),
                subtitle: Text('Les élèves pourront télécharger ce cours'),
                secondary: Icon(
                  Icons.download_outlined,
                  color: AppColors.info,
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  IconData _getLessonTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.headphones;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'text':
        return Icons.article;
      default:
        return Icons.description;
    }
  }

  IconData _getExerciseTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Icons.quiz;
      case 'interactive':
        return Icons.touch_app;
      case 'problem':
        return Icons.calculate;
      default:
        return Icons.assignment;
    }
  }
}