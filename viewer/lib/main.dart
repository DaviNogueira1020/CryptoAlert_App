import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/presentation/pages/login.dart';
import 'package:mobile/presentation/pages/onboardingScreen.dart';
import 'package:mobile/presentation/shell/main_shell.dart';
import 'package:mobile/services/alertasServices.dart';
import 'package:mobile/services/sessao_usuario.dart';
import 'firebase_options.dart';
import 'services/banco_de_dados.dart';

// importa tua tela Loading
import 'package:mobile/presentation/pages/loading.dart'; // ajusta o caminho

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // segura a splash nativa

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await BancoDeDados.inicializar();
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }

  await AlertasService.carregar();
  await SessaoUsuario.carregarChave();

  FlutterNativeSplash.remove(); // remove a splash nativa, entra o Flutter
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
      home: const Loading(), // começa na Loading, ela redireciona depois
    );
  }
}