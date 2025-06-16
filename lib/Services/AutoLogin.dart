import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treecals/Login/loginPage.dart';
import 'package:treecals/MainPage/NavigatorBar.dart';

Future<void> saveLogin(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', userId); // หรือเก็บ token ก็ได้
}

Future<void> checkLogin(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id');

  if (userId != null) {
    // ไปหน้า Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => NavigatorPage(state1: 2, ID: userId.toString()),
      ),
    );
  } else {
    // ไปหน้า Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
}
