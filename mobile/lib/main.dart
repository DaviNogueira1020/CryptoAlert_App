import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/presentation/pages/index.dart';
import 'firebase_options.dart';
import 'services/banco_de_dados.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase só em Android/iOS
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await BancoDeDados.inicializar();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CriptAlert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Scaffold(
        body: Center(
          child: Index(),
        ),
      ),
    );
  }
}
