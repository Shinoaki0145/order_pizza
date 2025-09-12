import 'package:flutter/material.dart';
import 'package:order_pizza/pages/login_page.dart';
import 'package:order_pizza/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTag: togglePage,
      );
    } else {
      return RegisterPage(
        onTag: togglePage,
      );
    }
  }
}