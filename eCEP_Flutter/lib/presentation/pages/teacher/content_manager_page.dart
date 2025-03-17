import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/app/extension/color.dart';
import 'package:client/presentation/controllers/teacher/content_manager_controller.dart';
import 'package:client/presentation/widgets/teacher/teacher_drawer.dart';
import 'package:client/presentation/widgets/teacher/teacher_bottom_nav.dart';
import 'package:client/data/models/course.dart';

import '../../../domain/entities/user.dart' show User;

class ContentManagerPage extends StatefulWidget {
  const ContentManagerPage({Key? key}) : super(key: key);

  @override
  _ContentManagerPageState createState() => _ContentManagerPageState();
}

class _ContentManagerPageState extends State<ContentManagerPage> with SingleTickerProviderStateMixin {
  final ContentManagerController controller = Get.put(ContentManagerController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  int _currentIndex = 2; // Index for bottom nav (Courses)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      controller.selectedTabIndex.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textDark),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Gestion du contenu',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textDark),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () => _showAddContentOptions(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMedium,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Cours'),
            Tab(text: 'Exercices'),
            Tab(text: 'Ressources'),
          ],
        ),
      ),
      drawer: Obx(() => TeacherDrawer(
        teacher: controller.courses.isNotEmpty
            ? User(
          id: 101,
          firstName: 'Marie',
          lastName: 'Durant',
          email: 'marie.durant@ecole.fr',
          avatar: 'assets/avatars/teacher1.png',
          role: 'teacher',
        )
            : User(
          id: 0,
          firstName: '',
          lastName: '',
          email: '',
          avatar: '',
          role: 'teacher',
        ),
        currentPage: 'courses',
      )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildCoursesTab(),
            _buildExercisesTab(),
            _buildResourcesTab(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (controller.selectedTabIndex.value) {
            case 0:
              controller.createNewCourse();
              break;
            case 1:
              controller.createNewExercise();
              break;
            case 2:
              controller.addNewResource();
              break;
          }
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: TeacherBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigation logic (simplified for demo)
          switch (index) {
            case 0:
              Get.offAllNamed('/teacher-dashboard');
              break;
            case 1:
              Get.offAllNamed('/class-progress');
              break;
            case 3:
              Get.offAllNamed('/teacher-exercises');
              break;
            case 4:
              Get.offAllNamed('/teacher-profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildCoursesTab() {
    final courses = controller.filteredCourses;

    if (courses.isEmpty) {
      return _buildEmptyState(
        'Aucun cours trouvé',
        'Ajoutez un nouveau cours en cliquant sur le bouton +',
        Icons.menu_book_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadContent(),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseItem(course);
        },
      ),
    );
  }

  Widget _buildCourseItem(Course course) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Course header with image
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  course.subjectColor,
                  course.subjectColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: Image.asset(
                      course.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              course.subject,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Get.toNamed('/edit-course', arguments: course);
                              } else if (value == 'delete') {
                                _showDeleteConfirmation('course', course.id);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: AppColors.primary),
                                    SizedBox(width: 8),
                                    Text('Modifier'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Supprimer'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        course.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Course details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.play_lesson, size: 16, color: AppColors.textMedium),
                    SizedBox(width: 4),
                    Text(
                      '${course.totalLessons} leçons',
                      style: TextStyle(color: AppColors.textMedium),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.assignment, size: 16, color: AppColors.textMedium),
                    SizedBox(width: 4),
                    Text(
                      '${course.totalExercises} exercices',
                      style: TextStyle(color: AppColors.textMedium),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: course.progress > 0 ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        course.progress > 0 ? 'Publié' : 'Brouillon',
                        style: TextStyle(
                          color: course.progress > 0 ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  course.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Get.toNamed('/edit-course', arguments: course);
                      },
                      child: Text('Modifier'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/course-details', arguments: course);
                      },
                      child: Text('Voir détails'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesTab() {
    final exercises = controller.filteredExercises;

    if (exercises.isEmpty) {
      return _buildEmptyState(
        'Aucun exercice trouvé',
        'Ajoutez un nouvel exercice en cliquant sur le bouton +',
        Icons.assignment_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadContent(),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return _buildExerciseItem(exercise);
        },
      ),
    );
  }

  Widget _buildExerciseItem(Map<String, dynamic> exercise) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
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
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(exercise['difficulty']).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getExerciseTypeIcon(exercise['type']),
                    color: _getDifficultyColor(exercise['difficulty']),
                    size: 22,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        exercise['courseName'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: exercise['isPublished'] ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exercise['isPublished'] ? 'Publié' : 'Brouillon',
                    style: TextStyle(
                      color: exercise['isPublished'] ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildDifficultyIndicator(exercise['difficulty']),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: AppColors.secondary,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${exercise['points']} pts',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  'Créé le ${exercise['dateCreated']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.toggleExercisePublishStatus(exercise['id']);
                  },
                  icon: Icon(
                    exercise['isPublished'] ? Icons.unpublished : Icons.publish,
                    size: 18,
                  ),
                  label: Text(
                    exercise['isPublished'] ? 'Dépublier' : 'Publier',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: exercise['isPublished'] ? Colors.grey : Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed('/edit-exercise', arguments: exercise);
                  },
                  icon: Icon(Icons.edit, size: 18),
                  label: Text('Modifier'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation('exercise', exercise['id']);
                  },
                  icon: Icon(Icons.delete, size: 18),
                  label: Text('Supprimer'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(int difficulty) {
    return Row(
      children: [
        ...List.generate(
          difficulty,
              (index) => Icon(
            Icons.star,
            color: _getDifficultyColor(difficulty),
            size: 14,
          ),
        ),
        ...List.generate(
          3 - difficulty,
              (index) => Icon(
            Icons.star_border,
            color: AppColors.textLight,
            size: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildResourcesTab() {
    final resources = controller.filteredResources;

    if (resources.isEmpty) {
      return _buildEmptyState(
        'Aucune ressource trouvée',
        'Ajoutez une nouvelle ressource en cliquant sur le bouton +',
        Icons.insert_drive_file_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadContent(),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return _buildResourceItem(resource);
        },
      ),
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> resource) {
    final Color typeColor = controller.getResourceTypeColor(resource['type']);
    final IconData typeIcon = controller.getResourceTypeIcon(resource['type']);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
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
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    typeIcon,
                    color: typeColor,
                    size: 22,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${resource['courseName']} • ${resource['fileSize']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: resource['isPublished'] ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    resource['isPublished'] ? 'Publié' : 'Brouillon',
                    style: TextStyle(
                      color: resource['isPublished'] ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    resource['type'].toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: typeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Icon(
                  Icons.download,
                  size: 14,
                  color: AppColors.textLight,
                ),
                SizedBox(width: 4),
                Text(
                  '${resource['downloads']} téléchargements',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                Spacer(),
                Text(
                  'Mis à jour le ${resource['lastUpdated']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.toggleResourcePublishStatus(resource['id']);
                  },
                  icon: Icon(
                    resource['isPublished'] ? Icons.unpublished : Icons.publish,
                    size: 18,
                  ),
                  label: Text(
                    resource['isPublished'] ? 'Dépublier' : 'Publier',
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: resource['isPublished'] ? Colors.grey : Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    // Preview resource
                    Get.toNamed('/preview-resource', arguments: resource);
                  },
                  icon: Icon(Icons.visibility, size: 18),
                  label: Text('Aperçu'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation('resource', resource['id']);
                  },
                  icon: Icon(Icons.delete, size: 18),
                  label: Text('Supprimer'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rechercher du contenu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Mot-clé',
                hintText: 'Titre, description...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              decoration: InputDecoration(
                labelText: 'Matière',
                border: OutlineInputBorder(),
              ),
              value: controller.selectedSubject.value,
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Toutes les matières'),
                ),
                DropdownMenuItem<String?>(
                  value: 'Mathématiques',
                  child: Text('Mathématiques'),
                ),
                DropdownMenuItem<String?>(
                  value: 'Français',
                  child: Text('Français'),
                ),
                DropdownMenuItem<String?>(
                  value: 'Histoire-Géographie',
                  child: Text('Histoire-Géographie'),
                ),
                DropdownMenuItem<String?>(
                  value: 'Sciences',
                  child: Text('Sciences'),
                ),
              ],
              onChanged: (value) {
                controller.selectedSubject.value = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.searchQuery.value = '';
              controller.selectedSubject.value = null;
              Get.back();
            },
            child: Text('Réinitialiser'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Rechercher'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter du contenu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.menu_book, color: AppColors.primary),
              ),
              title: Text('Nouveau cours'),
              subtitle: Text('Créer un cours complet avec chapitres et leçons'),
              onTap: () {
                Get.back();
                controller.createNewCourse();
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assignment, color: AppColors.secondary),
              ),
              title: Text('Nouvel exercice'),
              subtitle: Text('Créer des exercices pour vos cours'),
              onTap: () {
                Get.back();
                controller.createNewExercise();
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.insert_drive_file, color: Colors.purple),
              ),
              title: Text('Nouvelle ressource'),
              subtitle: Text('Ajouter des documents, vidéos ou fichiers audio'),
              onTap: () {
                Get.back();
                controller.addNewResource();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String contentType, int id) {
    String title = '';
    String message = '';

    switch (contentType) {
      case 'course':
        title = 'Supprimer le cours';
        message = 'Êtes-vous sûr de vouloir supprimer ce cours ? Cette action est irréversible.';
        break;
      case 'exercise':
        title = 'Supprimer l\'exercice';
        message = 'Êtes-vous sûr de vouloir supprimer cet exercice ? Cette action est irréversible.';
        break;
      case 'resource':
        title = 'Supprimer la ressource';
        message = 'Êtes-vous sûr de vouloir supprimer cette ressource ? Cette action est irréversible.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              switch (contentType) {
                case 'course':
                // Delete course logic (not implemented in this demo)
                  Get.snackbar(
                    'Cours supprimé',
                    'Le cours a été supprimé avec succès.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  break;
                case 'exercise':
                  controller.deleteExercise(id);
                  break;
                case 'resource':
                  controller.deleteResource(id);
                  break;
              }
            },
            child: Text('Supprimer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
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

  IconData _getExerciseTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return Icons.quiz;
      case 'interactive':
        return Icons.touch_app;
      case 'text':
        return Icons.text_fields;
      default:
        return Icons.assignment;
    }
  }
  }