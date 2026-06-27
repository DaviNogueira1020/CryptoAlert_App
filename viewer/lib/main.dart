import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/presentation/pages/onboardingScreen.dart';
import 'package:mobile/presentation/shell/main_shell.dart';
import 'package:mobile/services/alertasServices.dart';
import 'package:mobile/services/sessao_usuario.dart';
import 'firebase_options.dart';
import 'services/banco_de_dados.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase em todas as plataformas (mobile e web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa SharedPreferences e conexão com Firestore
  await BancoDeDados.inicializar();

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
      // Se não tiver chave salva na sessão, vai pro onboarding
      home: SessaoUsuario.chave.isEmpty
          ? const OnboardingScreen()
          : const MainShell(initialIndex: 1),
    );
  }
}
