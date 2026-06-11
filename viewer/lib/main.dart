import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/presentation/pages/login.dart';
import 'package:mobile/presentation/pages/onboardingScreen.dart';
import 'package:mobile/presentation/shell/main_shell.dart';
import 'package:mobile/services/alertasServices.dart';
import 'package:mobile/services/sessao_usuario.dart';
import 'firebase_options.dart';
import 'services/banco_de_dados.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await BancoDeDados.inicializar();
  }

  // Carrega os alertas salvos antes de abrir o app
  await AlertasService.carregar();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CriptAlert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SessaoUsuario.chave.isEmpty
        ? const OnboardingScreen()
        : const MainShell(initialIndex: 1),
    );
  }
}
