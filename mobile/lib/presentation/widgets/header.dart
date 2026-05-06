import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Color background;
  final double logoSize;
  final double textSize;
  final Color textColor;

  const Header({
    super.key,
    this.background = const Color(0xFF0F172A),
    this.logoSize = 51,
    this.textSize = 32,
    this.textColor = const Color(0xFF22D3EE),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      color: background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Logo/CriptAlert.png', width: logoSize, height: logoSize),
          const SizedBox(width: 10),
          Text(
            'CriptAlert',
            style: TextStyle(fontWeight: FontWeight.w600 ,fontSize: textSize, color: textColor),
          ),
        ],
      ),
    );
  }
}