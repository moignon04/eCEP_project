import 'package:client/app/extension/color.dart';
import 'package:client/app/services/local_storage.dart';
import 'package:client/data/repositories/course_repository.dart';
import 'package:client/data/repositories/exercise_repository.dart';
import 'package:client/domain/repositories/course_repository.dart';
import 'package:client/domain/repositories/exercise_repository.dart';
import 'package:client/domain/usecases/course/get_all_courses_usecase.dart';
import 'package:client/domain/usecases/course/search_courses_usecase.dart';
import 'package:client/domain/usecases/exercise/get_all_exercises_usecase.dart';
import 'package:client/presentation/controllers/auth/auth_controller.dart';
import 'package:client/presentation/controllers/courses/courses_controller.dart';
import 'package:client/presentation/controllers/exercises/exercises_controller.dart' show ExercisesController;
import 'package:client/presentation/pages/administrator/admin_dashboard_page.dart';
import 'package:client/presentation/pages/auth/login_page.dart';
import 'package:client/presentation/pages/cours/courses_page.dart';
import 'package:client/presentation/pages/exercise/exercises_page.dart';
import 'package:client/presentation/pages/home_page.dart';
import 'package:client/presentation/pages/parent/parent_dashboard_page.dart';
import 'package:client/presentation/pages/profile/profile_page.dart' show ProfilePage;
import 'package:client/presentation/pages/progress/progress_page.dart';
import 'package:client/presentation/pages/teacher/dashboard_page.dart';
import 'package:client/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;
  String _pageTitle = 'Accueil';

  // Référence au service de stockage local
  final store = Get.find<LocalStorageService>();
  @override
  void initState() {
    super.initState();

    // Initialiser les dépendances pour CoursesPage
    final courseRepo = CourseRepositoryImpl();
    Get.put<CourseRepository>(courseRepo);
    Get.put<GetAllCoursesUseCase>(GetAllCoursesUseCase(courseRepo));
    Get.put<SearchCoursesUseCase>(SearchCoursesUseCase(courseRepo));
    Get.put<CoursesController>(
      CoursesController(
        getAllCoursesUseCase: Get.find<GetAllCoursesUseCase>(),
        searchCoursesUseCase: Get.find<SearchCoursesUseCase>(),
      ),
    );



    // Initialiser les dépendances pour ExercisesPage
    final exerciseRepo = ExerciseRepositoryImpl();
    Get.put<ExerciseRepository>(exerciseRepo);
    Get.put<GetAllExercisesUseCase>(GetAllExercisesUseCase(exerciseRepo));
    Get.put<ExercisesController>(
      ExercisesController(
        getAllExercisesUseCase: Get.find<GetAllExercisesUseCase>(),
      ),
    );

    // Initialiser les pages après avoir configuré les dépendances
    _pages = [
      HomePage(),
      CoursesPage(), // Page des cours
      ExercisesPage(), // Page des exercices
      ProgressPage(), // Page des progrès
      ProfilePage(), // Page de profil
    ];
  }
  late List<Widget> _pages = [
    HomePage(),
    CoursesPage(), // Page des cours
    ExercisesPage(), // Page des exercices
    ProgressPage(), // Page des progrès
  ];

  void _onPageTapped(String newPage) {
    setState(() {
      _pageTitle = newPage;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          _pageTitle,
          style: TextStyle(color: AppColors.textDark),
        ),
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer() {
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
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(store.user?.avatar ?? 'assets/avatars/default.png'),
                ),
                SizedBox(height: 10),
                Text(
                  store.user?.fullName ?? 'Utilisateur',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Mode de navigation',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Section Mode de navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'CHANGER DE MODE',
              style: TextStyle(
                color: AppColors.textMedium,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Option Élève (Mode actuel)
          ListTile(
            leading: Icon(Icons.school, color: AppColors.secondary),
            title: Text('Mode Élève', style: TextStyle(fontWeight: FontWeight.bold)),
            selected: true,
            selectedTileColor: AppColors.secondary.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              // Déjà sur la page élève
            },
          ),

          // Option Enseignant
          ListTile(
            leading: Icon(Icons.person, color: AppColors.primary),
            title: Text('Mode Enseignant'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/login');
            },
          ),

          // Option Parent
          ListTile(
            leading: Icon(Icons.family_restroom, color: AppColors.info),
            title: Text('Mode Parent'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ParentDashboardPage());
            },
          ),

          // Option Administrateur
          ListTile(
            leading: Icon(Icons.admin_panel_settings, color: AppColors.error),
            title: Text('Mode Administrateur'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => AdminDashboardPage());
            },
          ),

          Divider(),

          // Section Compte et paramètres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'COMPTE & PARAMÈTRES',
              style: TextStyle(
                color: AppColors.textMedium,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Option Profil
          ListTile(
            leading: Icon(Icons.person_outline, color: AppColors.textDark),
            title: Text('Mon profil'),
            onTap: () {
              Navigator.pop(context);
              // Navigation vers la page de profil
            },
          ),

          // Option Paramètres
          ListTile(
            leading: Icon(Icons.settings_outlined, color: AppColors.textDark),
            title: Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
              // Navigation vers la page des paramètres
            },
          ),

          // Option Aide
          ListTile(
            leading: Icon(Icons.help_outline, color: AppColors.textDark),
            title: Text('Aide'),
            onTap: () {
              Navigator.pop(context);
              // Navigation vers la page d'aide
            },
          ),

          Divider(),

          // Option Déconnexion
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error),
            title: Text('Déconnexion', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pop(context);
              // Afficher une boîte de dialogue de confirmation
              _showLogoutConfirmationDialog();
            },
          ),
        ],
      ),
    );
  }

  // Boîte de dialogue de confirmation pour la déconnexion
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: Text('Déconnexion'),
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAllNamed('/login'); // Redirection vers la page de connexion
              },
            ),
          ],
        );
      },
    );
  }
}