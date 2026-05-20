import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/index.dart';


void main() {
  runApp(const MyApp());
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/banco_de_dados.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await BancoDeDados.inicializar();
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CriptAlert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('App funcionando!'),
        ),
      ),
    );
  }
}