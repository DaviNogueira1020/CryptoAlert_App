import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/onboardingScreen.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingScreen(), // direto, sem Column
    );
  }
}