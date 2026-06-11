// Estrutura principal do app: Header, barra de cotações e Footer ficam fixos.
// Só o conteúdo do meio muda quando o usuário troca de aba.

import 'package:flutter/material.dart';
import 'package:mobile/presentation/pages/newsPagesContent.dart';
import 'package:mobile/presentation/pages/table_screen.dart';
import 'package:mobile/presentation/widgets/header.dart';
import 'package:mobile/presentation/widgets/ticker_bar.dart';
import 'package:mobile/presentation/widgets/footer.dart';
import 'package:mobile/presentation/widgets/animated_background.dart';
import 'package:mobile/presentation/pages/alerts/alertas_page.dart';
import 'package:mobile/presentation/pages/profile/perfil.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 1});

  @override
  State<MainShell> createState() => _MainShellState();
}

// Mantem o estado da aba mesmo quando o usuário troca de tela.
class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // Conteúdo principal sem AnimatedBackground (pois vai dentro)
    final mainContent = Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Column(
        children: [
          const Header(),
          const TickerBar(),

          // IndexedStack mantém todas as telas carregadas ao mesmo tempo.
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const AlertasPageContent(),   // Aba 0
                const TableScreen(),          // new Aba 1
                const NewsPageContent(),     // Aba 2
                
                Center(
                  child: PerfilPageContent(onTabSelected: (i) => setState(() => _currentIndex = i)),
                ),
              ],
            ),
          ),
          // Footer recebe o índice atual para destacar a aba selecionada
          Footer(
            initialBottonClicked: _currentIndex,
            onTabSelected: (i) => setState(() => _currentIndex = i),
          ),
        ],
      ),
    );

    // Envolve o conteúdo com AnimatedBackground para adicionar partículas
    return AnimatedBackground(
      child: mainContent,
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
