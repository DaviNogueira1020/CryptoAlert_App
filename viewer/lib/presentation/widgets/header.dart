import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Color background;
  final double logoSize;
  final double textSize;
  final Color textColor;

  const Header({
    super.key,
    this.background = Colors.transparent,
    this.logoSize = 52,
    this.textSize = 34,
    this.textColor = const Color(0xFF67E8F9),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo/CriptAlert.png',
            width: logoSize,
            height: logoSize,
          ),
          const SizedBox(width: 12),
          Text(
            'CriptAlert',
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: textColor,
              shadows: const [
                Shadow(
                  color: Color(0xFF22D3EE),
                  blurRadius: 5,
                ),
                Shadow(
                  color: Color(0xFF22D3EE),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}