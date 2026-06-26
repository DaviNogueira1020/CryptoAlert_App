import 'package:shared_preferences/shared_preferences.dart';

class SessaoUsuario {
  static String chave = '';
  static const String _chaveKey = 'usuario_chave';

  // Salva a chave no storage e na variável
  static Future<void> salvarChave(String novaChave) async {
    chave = novaChave;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveKey, novaChave);
  }

  // Lê do storage ao abrir o app — retorna true se encontrou
  static Future<bool> carregarChave() async {
    final prefs = await SharedPreferences.getInstance();
    final chaveSalva = prefs.getString(_chaveKey);
    if (chaveSalva != null && chaveSalva.isNotEmpty) {
      chave = chaveSalva;
      return true;
    }
    return false;
  }

  // Limpa tudo (logout)
  static Future<void> limparChave() async {
    chave = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveKey);
  }
}