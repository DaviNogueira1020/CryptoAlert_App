import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Rodape extends StatefulWidget {
  final Color backGround;
  final Color notificationsColor;
  final Color homeColor;
  final Color newsColor;
  final Color perfilColor;
  final Color bottonClicked;

  final double iconSize;
  final int initialBottonClicked;
  
  const Rodape({
    super.key,
    this.backGround = const Color(0xFF0F172A),
    this.notificationsColor = Colors.white, // cor do icone de notificações
    this.homeColor = Colors.white, // cor do icone home
    this.newsColor = Colors.white, // cor do icone de noticias
    this.perfilColor = Colors.white, // cor do icone de perfil
    this.bottonClicked = const Color(0xFF06B6D4), // cor do icone quando clicado
    this.iconSize = 30, // tamanho do icone
    this.initialBottonClicked = 0,
  });
  @override
  State<Rodape> createState() => _RodapeState();
}

class _RodapeState extends State<Rodape> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialBottonClicked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      color: widget.backGround,
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: GestureDetector(
                  onTap: () {
                    print("Notifications clicked");
                    setState(() => _selectedIndex = 0);
                  },

                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/notifications.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 0 ? widget.bottonClicked : widget.notificationsColor,
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              child: GestureDetector(
                onTap: (){
                  print("Home clicked");
                  setState(() => _selectedIndex = 1);
                },

                child: Center(
                  child: SvgPicture.asset(
                    'assets/Icons/home.svg',
                    colorFilter: ColorFilter.mode(
                      _selectedIndex == 1 ? widget.bottonClicked : widget.homeColor, 
                      BlendMode.srcIn,
                    ),
                    width: widget.iconSize,
                    height: widget.iconSize,
                  ),
                )
              ),
            ),
          ),

          Expanded(
            child: Container(
              child: GestureDetector(
                  onTap: () {
                    print("News clicked");
                    setState(() => _selectedIndex = 2);
                  },

                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/news.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 2 ? widget.bottonClicked : widget.newsColor, 
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                )
              ),
            ),

          Expanded(
            child: Container(
              child: GestureDetector(
                  onTap: () {
                    print("Perfil clicked");
                    setState(() => _selectedIndex = 3);
                  },

                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/perfil.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 3 ? widget.bottonClicked : widget.perfilColor, 
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                )
              ),
            ),
        ],
      ),
    );
  }
}