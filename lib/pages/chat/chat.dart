import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int _counter = 0;
  List<String> names = [
    'Chopang',
    'Natthawat',
    'Peempeem',
    'Fefe',
    'Markmark',
    'Kritkrit'
  ];

  void _incrementCounter() {
    _counter++;
    setState(() {
      _counter = _counter % names.length;
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Chat',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'กดหาพ่อมึงหรอ',
        child: const Icon(Icons.add),
      ),
    );
  }
}
