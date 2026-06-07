import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulid/ulid.dart';

class BancoDeDados {
  static late SharedPreferences _prefs;
  final _db = FirebaseFirestore.instance;
  static const _keyLocal = 'user_key';

  final Map<String, Map<String, dynamic>> _cache = {};

  static Future<void> inicializar() async {
  _prefs = await SharedPreferences.getInstance();
  
  // Conecta ao emulador local
//  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}

  Future<String> gerarKey() async {
    final key = Ulid().toString().toLowerCase();

    await _db.collection('usuarios').doc(key).set({
      'created_at': FieldValue.serverTimestamp(),
      'dados': {},
    });

    await _prefs.setString(_keyLocal, key);
    return key;
  }

  Future<bool> entrarComKey(String key) async {
    final doc = await _db.collection('usuarios').doc(key).get();

    if (doc.exists) {
      await _prefs.setString(_keyLocal, key);
      return true;
    }
    return false;
  }

  String? keySalva() {
    return _prefs.getString(_keyLocal);
  }

  Map<String, dynamic>? buscarDados(String key) {
    return _cache[key];
  }

  Future<Map<String, dynamic>?> buscarDadosAsync(String key) async {
    final doc = await _db.collection('usuarios').doc(key).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    _cache[key] = data;
    return data;
  }

  Future<void> salvarDados(String key, Map<String, dynamic> dados) async {
    await _db.collection('usuarios').doc(key).update({
      'dados': dados,
    });

    if (_cache.containsKey(key)) {
      _cache[key]!['dados'] = dados;
    }
  }

  Future<void> sair() async {
    await _prefs.remove(_keyLocal);
    _cache.clear();
  }

  Future<void> apagarConta(String key) async {
    await _db.collection('usuarios').doc(key).delete();
    await _prefs.remove(_keyLocal);
    _cache.clear();
  }
}