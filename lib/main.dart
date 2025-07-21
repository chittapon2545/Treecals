import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treecals/MainPage/Tree/MyMap.dart';
import 'package:treecals/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final apps = Firebase.apps;
    if (apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyDPeleLrkQAfuw3FzasbDCpQW8_frWfdzw",
          appId: "1:276455666595:android:3ea9d13e82f669a687a016",
          messagingSenderId: "276455666595",
          projectId: "treecals",
          authDomain: "treecals.firebaseapp.com",
          storageBucket: "treecals.appspot.com",
          databaseURL:
              "https://treecals-default-rtdb.asia-southeast1.firebasedatabase.app",
        ),
      );
    }
  } catch (e) {
    // ignore duplicate app error
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: SplashScreen());
    // return MaterialApp(title: 'Flutter Demo', home: MyMapPage());
  }
}
