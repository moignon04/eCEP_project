import 'package:client/app/extension/color.dart';
import 'package:client/app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final store = Get.find<LocalStorageService>();
  int _currentPage = 0;
  final int _numPages = 3;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Réussis ton examen du CEP',
      'description': 'Une application complète conçue pour aider les élèves du CM2 à préparer efficacement leur examen de CEP.',
      'image': 'assets/images/onboarding1.png',
      'color': AppColors.primary,
    },
    {
      'title': 'Cours interactifs',
      'description': 'Accède à des cours interactifs en mathématiques, français, histoire-géographie et sciences, où que tu sois, même sans internet.',
      'image': 'assets/images/onboarding2.png',
      'color': AppColors.secondary,
    },
    {
      'title': 'Suivi et motivation',
      'description': 'Gagne des points, débloque des badges et suis ta progression pour rester motivé tout au long de ton apprentissage.',
      'image': 'assets/images/onboarding3.png',
      'color': AppColors.success,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              _buildSkipButton(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _numPages,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildPageContent(_pages[index]);
                  },
                ),
              ),
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentPage < _numPages - 1
            ? TextButton(
          onPressed: () {
            _pageController.animateToPage(
              _numPages - 1,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          child: Text(
            'Passer',
            style: TextStyle(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
            : SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> pageData) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(pageData['image']),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            pageData['title'],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: pageData['color'],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            pageData['description'],
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textMedium,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _numPages,
                  (index) => _buildDotIndicator(index),
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _numPages - 1) {
                  // Dernière page
                  store.onboardingCompleted = true;
                  Get.offAllNamed('/login');
                } else {
                  // Passer à la page suivante
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _pages[_currentPage]['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentPage == _numPages - 1 ? 'Commencer' : 'Suivant',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (_currentPage == _numPages - 1) ...[
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                store.onboardingCompleted = true;
                Get.offAllNamed('/login');
              },
              child: Text(
                'J\'ai déjà un compte',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[_currentPage]['color']
            : AppColors.textLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}