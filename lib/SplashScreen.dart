import 'package:flutter/material.dart';
import 'package:treecals/Services/AutoLogin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
