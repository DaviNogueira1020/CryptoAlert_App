import 'dart:typed_data'; // Necessário para o Uint8List na função de download
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/presentation/pages/index.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/services/banco_de_dados.dart';

class Login extends StatefulWidget {
  final int selectedButton;
  const Login({super.key, this.selectedButton = 0});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  late int _selectedButtonIndex = 0;
  final TextEditingController _keyController = TextEditingController();
  bool _loading = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _selectedButtonIndex = widget.selectedButton;
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _irParaIndex() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Index()),
    );
  }

  // 1. FLUXO ATUALIZADO PARA CRIAR CONTA E CHAMAR O NOVO MODAL
  Future<void> _criarConta() async {
    setState(() {
      _loading = true;
      _erro = null;
    });

    try {
      final banco = BancoDeDados();
      final key = await banco.gerarKey();

      setState(() => _loading = false);

      if (!mounted) return;

      await _mostrarModalChave(key);
    } catch (e) {
      setState(() {
        _loading = false;
        _erro = "Erro ao gerar chave.";
      });
    }
  }

  // 2. HELPER DE DOWNLOAD (SIMULADO VIA CLIPBOARD ATÉ EVOLUIR PAR PATH_PROVIDER)
  Future<void> _baixarKey(String key) async {
    final bytes = key.codeUnits;
    final blob = Uint8List.fromList(bytes);

    // Flutter mobile simples:
    await Clipboard.setData(ClipboardData(text: key));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Chave copiada (download simulado via clipboard)"),
      ),
    );
  }

  // 3. NOVO MODAL DE CHAVE ESTILO "ZERO-TRUST / SKYNET"
  Future<void> _mostrarModalChave(String key) async {
    bool copiado = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: const Color(0xFF0B0F1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF06B6D4), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.security, color: Color(0xFFEF4444), size: 42),
                const SizedBox(height: 12),
                const Text(
                  "CHAVE GERADA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Essa chave é a única forma de acesso à sua conta. "
                  "A responsabilidade de armazenamento é exclusivamente do usuário.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF6366F1)),
                  ),
                  child: Text(
                    key,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF06B6D4),
                      fontSize: 14,
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                
                // BOTÃO COPIAR
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: key));
                    setModalState(() => copiado = true);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: copiado ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        copiado ? "COPIADO ✓" : "COPIAR CHAVE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // BOTÃO DOWNLOAD
                GestureDetector(
                  onTap: () => _baixarKey(key),
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF06B6D4)),
                    ),
                    child: const Center(
                      child: Text(
                        "BAIXAR .TXT",
                        style: TextStyle(
                          color: Color(0xFF06B6D4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // CONTINUAR (Bloqueado até copiar)
                GestureDetector(
                  onTap: copiado
                      ? () {
                          Navigator.pop(context);
                          _irParaIndex();
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: copiado
                          ? const Color(0xFF06B6D4)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        copiado ? "ENTRAR →" : "Copie a chave para continuar",
                        style: TextStyle(
                          color: copiado ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _entrarComKey() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      setState(() { _erro = 'Digite sua chave.'; });
      return;
    }
    setState(() { _loading = true; _erro = null; });
    try {
      final banco = BancoDeDados();
      final ok = await banco.entrarComKey(key);
      if (ok) {
        _irParaIndex();
      } else {
        setState(() { _erro = 'Chave não encontrada.'; });
      }
    } catch (e) {
      setState(() { _erro = 'Erro ao conectar. Tente novamente.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Widget _buildTabButtons() {
    return Container(
      width: 260,
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() { _selectedButtonIndex = 0; _erro = null; }),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedButtonIndex == 0 ? const Color(0xFF6366F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/Icons/login.svg',
                        colorFilter: ColorFilter.mode(
                          _selectedButtonIndex == 0 ? Colors.white : const Color(0xFF9CA3AF),
                          BlendMode.srcIn,
                        ),
                        width: 17, height: 17,
                      ),
                      const SizedBox(width: 6),
                      Text("Login",
                        style: TextStyle(
                          color: _selectedButtonIndex == 0 ? Colors.white : const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() { _selectedButtonIndex = 1; _erro = null; }),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedButtonIndex == 1 ? const Color(0xFF6366F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/Icons/register.svg',
                        colorFilter: ColorFilter.mode(
                          _selectedButtonIndex == 1 ? Colors.white : const Color(0xFF9CA3AF),
                          BlendMode.srcIn,
                        ),
                        width: 17, height: 17,
                      ),
                      const SizedBox(width: 6),
                      Text("Register",
                        style: TextStyle(
                          color: _selectedButtonIndex == 1 ? Colors.white : const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentLogin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_erro != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(_erro!, style: const TextStyle(color: Colors.redAccent)),
          ),
        GestureDetector(
          onTap: _loading ? null : _criarConta,
          child: Container(
            width: 260,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF06B6D4), width: 2),
            ),
            child: Center(
              child: _loading
                  ? const CircularProgressIndicator(color: Color(0xFF06B6D4))
                  : const Text("Create account",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xFF06B6D4))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentRegister() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Private key",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _keyController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter your key",
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF06B6D4))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2)),
          ),
        ),
        if (_erro != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_erro!, style: const TextStyle(color: Colors.redAccent)),
          ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _loading ? null : _entrarComKey,
          child: Container(
            width: 260,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Enter",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Header(background: Colors.transparent),
            const SizedBox(height: 10),
            Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1B3D),
                border: Border.all(color: const Color(0xFF06B6D4), width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButtons(),
                    const SizedBox(height: 30),
                    _selectedButtonIndex == 0 ? _buildContentLogin() : _buildContentRegister(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}