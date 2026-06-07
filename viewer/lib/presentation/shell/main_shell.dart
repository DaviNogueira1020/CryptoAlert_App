// Estrutura principal do app: Header, barra de cotações e Footer ficam fixos.
// Só o conteúdo do meio muda quando o usuário troca de aba.

import 'package:flutter/material.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/ticker_bar.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/pages/alerts/alertas_page.dart';
import 'package:mobile/presentation/pages/table.dart';
import 'package:mobile/presentation/pages/profile/perfil.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 1});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Column(
        children: [
          const Header(),
          const TickerBar(),

          // IndexedStack mantém todas as telas carregadas ao mesmo tempo.
          // Só exibe a tela do índice atual, mas as outras não são destruídas ao trocar de aba.
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const AlertasPageContent(),   // Aba 0
                const TableContent(),          // Aba 1
                const _NewsPlaceholder(),      // Aba 2
                PerfilPageContent(onTabSelected: (i) => setState(() => _currentIndex = i)),
              ],
            ),
          ),

          Footer(
            initialBottonClicked: _currentIndex,
            onTabSelected: (i) => setState(() => _currentIndex = i),
          ),
        ],
      ),
    );
  }
}

class _NewsPlaceholder extends StatelessWidget {
  const _NewsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Em breve', style: TextStyle(color: Colors.white54, fontSize: 16)),
    );
  }
}
