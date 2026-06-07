import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialBottonClicked;
  }

  @override
  void didUpdateWidget(Footer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialBottonClicked != oldWidget.initialBottonClicked) {
      _selectedIndex = widget.initialBottonClicked;
    }
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    widget.onTabSelected?.call(index);
  }

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