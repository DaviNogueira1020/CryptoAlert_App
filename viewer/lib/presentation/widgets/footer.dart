import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Barra de navegação inferior com ícones para cada aba. Destaca a aba selecionada.
class Footer extends StatefulWidget {
  final Color backGround;
  final Color notificationsColor;
  final Color homeColor;
  final Color newsColor;
  final Color perfilColor;
  final Color bottonClicked; 
  final double iconSize;
  final int initialBottonClicked;
  final ValueChanged<int>? onTabSelected; 

// Footer é um StatefulWidget para manter o estado da aba selecionada. Recebe o índice inicial e uma função de callback para notificar a mudança de aba.
  const Footer({
    super.key,
    this.backGround = const Color(0xFF0F172A),
    this.notificationsColor = Colors.white,
    this.homeColor = Colors.white,
    this.newsColor = Colors.white,
    this.perfilColor = Colors.white,
    this.bottonClicked = const Color(0xFF06B6D4),
    this.iconSize = 30,
    this.initialBottonClicked = 0,
    this.onTabSelected,
  });


  @override
  State<Footer> createState() => _FooterState();
}


class _FooterState extends State<Footer> {
  late int _selectedIndex;

// Inicializa o índice selecionado com o valor recebido do widget pai. 
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialBottonClicked;
  }

// Atualiza o índice selecionado se o widget pai enviar um novo índice inicial.
  @override
  void didUpdateWidget(Footer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialBottonClicked != oldWidget.initialBottonClicked) {
      _selectedIndex = widget.initialBottonClicked;
    }
  }

// Função chamada ao clicar em um ícone. 
  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    widget.onTabSelected?.call(index);
  }

// Constrói a barra de navegação com os ícones. 
  @override
  Widget build(BuildContext context) {
    final icons = [
      'assets/Icons/notifications.svg',
      'assets/Icons/home.svg',
      'assets/Icons/news.svg',
      'assets/Icons/perfil.svg',
    ];

    return Container(
      color: widget.backGround,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          width: double.infinity,
          child: Row(
            children: List.generate(4, (i) {
              final active = _selectedIndex == i;
              final colors = [
                widget.notificationsColor,
                widget.homeColor,
                widget.newsColor,
                widget.perfilColor,
              ];
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTap(i),
                  child: Center(
                    child: SvgPicture.asset(
                      icons[i],
                      colorFilter: ColorFilter.mode(
                        active ? widget.bottonClicked : colors[i],
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}