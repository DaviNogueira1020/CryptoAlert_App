import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/presentation/pages/table.dart';

class Footer extends StatefulWidget {
  final Color backGround;
  final Color notificationsColor;
  final Color homeColor;
  final Color newsColor;
  final Color perfilColor;
  final Color bottonClicked;

  final double iconSize;
  final int initialBottonClicked;

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
  Widget build(BuildContext context) {
    return Container(
      color: widget.backGround,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    print('Notifications clicked');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(selectedButton: 1,),
                        ));
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/notifications.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 0
                            ? widget.bottonClicked
                            : widget.notificationsColor,
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TableScreen(),
                        ));
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/home.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 1
                            ? widget.bottonClicked
                            : widget.homeColor,
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/news.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 2
                            ? widget.bottonClicked
                            : widget.newsColor,
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PerfilPage(
                          totalAlertas: AlertasService.totalAlertas,
                          alertasAtivos: AlertasService.alertasAtivos,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/Icons/perfil.svg',
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 3
                            ? widget.bottonClicked
                            : widget.perfilColor,
                        BlendMode.srcIn,
                      ),
                      width: widget.iconSize,
                      height: widget.iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}