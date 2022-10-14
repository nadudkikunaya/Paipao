import 'package:flutter/material.dart';
import './pages/developer_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ไปป่าว',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeveloperMenu(),
    );
  }
}
