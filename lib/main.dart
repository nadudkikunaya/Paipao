import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/login.dart';
import 'package:paipao/pages/auth/loginCheck.dart';
import 'package:paipao/pages/mainWrapper.dart';
import 'pages/developerMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ไปป่าว',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'K2D'),
      home: DeveloperMenu(),
    );
  }
}
