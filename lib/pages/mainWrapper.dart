import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/login.dart';
import 'package:paipao/pages/chat/chat.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:paipao/pages/profile/profile.dart';
import './feed/feed.dart';
import './explore/explore.dart';
import './profile/profile.dart';
import './chat/chat.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedBottomNav = 0;
  static const List<Widget> _pages = <Widget>[
    Feed(),
    Explore(),
    Chat(),
    Profile(),
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedBottomNav],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black54,
          selectedItemColor: Colors.white,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'โฮม',
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.travel_explore),
                label: 'ค้นหา',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.sms),
                label: 'แชท',
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'โปรไฟล์',
                backgroundColor: Colors.blue),
          ],
          currentIndex: _selectedBottomNav,
          onTap: (index) {
            setState(() {
              _selectedBottomNav = index;
            });
          },
        ));
  }
}
