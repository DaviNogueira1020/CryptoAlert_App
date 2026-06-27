import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/onboardingScreen.dart';
import 'package:mobile/presentation/shell/main_shell.dart';
import 'package:mobile/services/sessao_usuario.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => LoadingState();
}

class LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _redirecionar();
  }

  Future<void> _redirecionar() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessaoUsuario.chave.isEmpty
            ? const OnboardingScreen()
            : const MainShell(initialIndex: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A), // fundo escuro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0F172A),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Image.asset('assets/Logo/CriptAlert.png'),
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Color(0xFF6366F1),
            ),
          ],
        ),
      ),
    );
  }
}