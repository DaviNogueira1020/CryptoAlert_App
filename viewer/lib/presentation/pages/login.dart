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

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late int _selectedButtonIndex = 0;
  final TextEditingController _keyController = TextEditingController();
  bool _loading = false;
  String? _erro;
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _selectedButtonIndex = widget.selectedButton;
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _arrowAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _irParaIndex() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Index()),
    );
  }

  Future<void> _criarConta() async {
    setState(() { _loading = true; _erro = null; });
    try {
      final banco = BancoDeDados();
      final key = await banco.gerarKey();
      setState(() { _loading = false; });
      if (!mounted) return;
      await _mostrarModalChave(key);
    } catch (e) {
      setState(() { _loading = false; _erro = e.toString(); });
    }
  }

  Future<void> _mostrarModalChave(String key) async {
    bool copiado = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: const Color(0xFF0F1B3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF06B6D4), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Header(background: Colors.transparent),
                const SizedBox(height: 8),
                const Text(
                  '"O direito à privacidade e o acesso irrestrito à informação é um direito universal de todos"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const Divider(color: Color(0xFF1E3A5F), height: 24),
                const Text(
                  'Sua chave privada foi gerada. Ela é sua única forma de acesso.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SUA CHAVE DE ACESSO',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0F1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: copiado ? const Color(0xFF10B981) : const Color(0xFF06B6D4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    key,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                ),
                if (copiado)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                        SizedBox(width: 6),
                        Text('Chave copiada com sucesso', style: TextStyle(color: Color(0xFF10B981), fontSize: 12)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: key));
                    setModalState(() { copiado = true; });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF06B6D4), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.copy, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text('COPIAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: copiado ? () {
                    Navigator.of(context).pop();
                    _irParaIndex();
                  } : null,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: copiado ? const Color(0xFF6366F1) : const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ENTRAR',
                          style: TextStyle(
                            color: copiado ? Colors.white : const Color(0xFF4B5563),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: copiado ? Colors.white : const Color(0xFF4B5563), size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0A0A),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF7F1D1D), width: 1),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
                      SizedBox(height: 6),
                      Text(
                        'Guarde sua chave em um lugar seguro.\nSe perdê-la, não será possível recuperar sua conta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.lock_outline, color: Color(0xFF4B5563), size: 12),
                    SizedBox(width: 4),
                    Text('E2E', style: TextStyle(color: Color(0xFF4B5563), fontSize: 11)),
                    SizedBox(width: 12),
                    Text('|', style: TextStyle(color: Color(0xFF4B5563))),
                    SizedBox(width: 12),
                    Icon(Icons.security, color: Color(0xFF4B5563), size: 12),
                    SizedBox(width: 4),
                    Text('ULID', style: TextStyle(color: Color(0xFF4B5563), fontSize: 11)),
                    SizedBox(width: 12),
                    Text('|', style: TextStyle(color: Color(0xFF4B5563))),
                    SizedBox(width: 12),
                    Icon(Icons.shield_outlined, color: Color(0xFF4B5563), size: 12),
                    SizedBox(width: 4),
                    Text('FIRESTORE', style: TextStyle(color: Color(0xFF4B5563), fontSize: 11)),
                  ],
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
        const Text(
          'Uma chave única será gerada como seu acesso.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 16),
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Create account",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xFF06B6D4))),
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: _arrowAnimation,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(_arrowAnimation.value, 0),
                            child: const Icon(Icons.arrow_forward, color: Color(0xFF06B6D4), size: 20),
                          ),
                        ),
                      ],
                    ),
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
                borderRadius: BorderRadius.circular(16),
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
