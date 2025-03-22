// lib/presentation/app.dart
import 'package:client/presentation/controllers/auth/auth_binding.dart';
import 'package:client/presentation/controllers/courses/courses_binding.dart';
import 'package:client/presentation/controllers/courses/course_detail_binding.dart';
import 'package:client/presentation/controllers/exercises/exercise_detail_binding.dart';
import 'package:client/presentation/controllers/home/home_binding.dart';
import 'package:client/presentation/pages/administrator/admin_dashboard_page.dart';
// Import avec alias pour résoudre le conflit
import 'package:client/presentation/pages/auth/login_page.dart' ;
import 'package:client/presentation/pages/auth/sign_up_page.dart';
import 'package:client/presentation/pages/cours/course_detail_page.dart';
import 'package:client/presentation/pages/cours/courses_page.dart';
import 'package:client/presentation/pages/exercise/exercise_detail_page.dart';
// Import spécifique de NavigationMenu depuis home.dart
import 'package:client/presentation/pages/home.dart' show NavigationMenu;
import 'package:client/presentation/pages/lesson/lesson_detail_page.dart';
import 'package:client/presentation/pages/on_bording/onboarding.dart';
import 'package:client/presentation/pages/parent/parent_dashboard_page.dart';
import 'package:client/presentation/pages/teacher/class_progress_page.dart' show ClassProgressPage;
import 'package:client/presentation/pages/teacher/dashboard_page.dart';
import 'package:client/presentation/pages/teacher/student_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/services/local_storage.dart';

class App extends StatelessWidget {
  final store = Get.find<LocalStorageService>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'eCEP',
      home: NavigationMenu(), // Page d'accueil par défaut
      initialBinding: HomeBinding(),
      getPages: [
        // Routes générales - sans middleware
        GetPage(
          name: "/onboarding",
          page: () => OnboardingScreen(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: "/login",
          page: () => LoginPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: "/signUp",
          page: () => SignUpPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: "/home",
          page: () => NavigationMenu(),
          binding: HomeBinding(),
        ),

        // Routes pour les élèves - sans middleware
        GetPage(
          name: "/student/home",
          page: () => NavigationMenu(),
          binding: HomeBinding(),
        ),
        GetPage(
            name: '/courses',
            page: () => CoursesPage(),
            binding: CoursesBinding()
        ),
        GetPage(
          name: '/course-details',
          page: () => CourseDetailPage(),
          binding: CourseDetailBinding(),
        ),
        GetPage(
          name: '/exercise-detail',
          page: () => ExerciseDetailPage(),
          binding: ExerciseDetailBinding(),
        ),
        GetPage(
          name: '/lesson-detail',
          page: () => LessonDetailPage(),
        ),

        // Routes pour les enseignants - sans middleware
        GetPage(
          name: '/dashboard',
          page: () => TeacherDashboardPage(),
        ),
        GetPage(
          name: "/class-progress",
          page: () => ClassProgressPage(),
        ),

        // Routes pour les parents - sans middleware
        GetPage(
          name: "/parent/dashboard",
          page: () => ParentDashboardPage(),
        ),

        // Routes pour les administrateurs - sans middleware
        GetPage(
          name: "/admin/dashboard",
          page: () => AdminDashboardPage(),
        ),
      ],
    );
  }

  // Cette méthode n'est plus utilisée mais conservée
  Widget _getInitialRoute() {
    return NavigationMenu(); // Retourne simplement l'écran d'accueil
  }
}