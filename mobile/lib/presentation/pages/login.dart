import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/presentation/pages/index.dart';
import 'package:mobile/presentation/pages/table_screen.dart';
import 'package:mobile/presentation/widgets/header.dart';

class Login extends StatefulWidget {
  final int selectedButton;

  const Login({
    super.key,
    this.selectedButton = 0,
  });

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  late int _selectedButtonIndex = 0;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedButtonIndex = widget.selectedButton;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildTabButtons() {
    return Container(
      width: 260,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão Login
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedButtonIndex = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedButtonIndex == 0
                      ? const Color(0xFF6366F1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/Icons/login.svg',
                        colorFilter: ColorFilter.mode(
                          _selectedButtonIndex == 0
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                          BlendMode.srcIn,
                        ),
                        width: 17,
                        height: 17,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: _selectedButtonIndex == 0
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Botão Cadastrar
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedButtonIndex = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedButtonIndex == 1
                      ? const Color(0xFF6366F1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/Icons/register.svg',
                        colorFilter: ColorFilter.mode(
                          _selectedButtonIndex == 1
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                          BlendMode.srcIn,
                        ),
                        width: 17,
                        height: 17,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Register",
                        style: TextStyle(
                          color: _selectedButtonIndex == 1
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
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
    return GestureDetector(
      onTap: () {
        print("Login done");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TableScreen(),
          )
        );
      },
      child: Container(
        width: 260,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF06B6D4),
            width: 2,
          ),
        ),
        child: const Center(
          child: Text(
            "Create account",
            style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 20 , color: Color(0xFF06B6D4)),
          ),
        ),
      ),
    );
  }

  Widget _buildContentRegister() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Private key",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter your key",
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF06B6D4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF06B6D4), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            print("Key: ${_emailController.text}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TableScreen(),
              )
            );
          },
          child: Container(
            width: 260,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "Enter",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SizedBox(
      width: 260,
      child: _selectedButtonIndex == 0 
          ? _buildContentLogin() 
          : _buildContentRegister(),
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
            const Header(
              background: Colors.transparent,
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1B3D),
                border: Border.all(
                  color: const Color(0xFF06B6D4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTabButtons(),

                    const SizedBox(height: 30),
                    
                    _buildContent(),
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