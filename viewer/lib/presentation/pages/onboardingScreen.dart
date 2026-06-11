import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _buildHomePage(),
          _buildPresentationPage(
            imagePath: 'assets/Presentation/presentation1.png',
            text: 'Understand, compare and track global coins in real time',
          ),
          _buildPresentationPage(
            imagePath: 'assets/Presentation/presentation2.png',
            text: 'Don\'t find out too late. Be notified at the first sign of a drop',
          ),
          _buildPresentationPage(
            imagePath: 'assets/Presentation/presentation3.png',
            text: 'Turn information into advantage before everyone else',
          ),
        ],
      ),
    );
  }

  // ── Home page ──────────────────────────────────────────────────────────────

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo with circular background
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF111827),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Image.asset('assets/Logo/CriptAlert.png'),
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            'While the world sleeps,\nCriptAlert watches',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 48),

          // Login and Sign up buttons side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOutlineButton(
                label: 'Login',
                onPressed: () { 
                  print('login clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(selectedButton: 1,),
                  ));
                },
              ),
              const SizedBox(width: 12),
              _buildOutlineButton(
                label: 'Sign up',
                onPressed: () { 
                  print('sign up clicked');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(selectedButton: 0,),
                  ));
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Discover more button (goes to the first demo page)
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Discover more',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF6366F1)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  // ── Presentation pages (1, 2, 3) ──────────────────────────────────────────

  Widget _buildPresentationPage({
    required String imagePath,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 140, height: 140),

          const SizedBox(height: 40),

          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 48),

          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              // pages 1, 2, 3 → indexes 1, 2, 3
              final active = _currentPage == i + 1;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              if (_currentPage == 3) {
                // Last page → go back to home
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                // Pages 1 and 2 → go to next
                _nextPage();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              minimumSize: const Size(160, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _currentPage == 3 ? 'Get started' : 'Next',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}