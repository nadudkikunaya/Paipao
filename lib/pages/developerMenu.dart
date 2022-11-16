import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/login.dart';
import 'package:paipao/pages/auth/registerDetail2.dart';
import 'package:paipao/pages/auth/registerDetail3.dart';
import 'package:paipao/pages/chat/chatRoom.dart';
import 'package:paipao/pages/explore/createAnnouncement.dart';
import 'package:paipao/pages/factory.dart';
import 'mainWrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeveloperMenu extends StatefulWidget {
  const DeveloperMenu({super.key});
  // const DeveloperMenu({super.key, required this.title});
  // final String title;

  @override
  State<DeveloperMenu> createState() => _DeveloperMenuState();
}

class _DeveloperMenuState extends State<DeveloperMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer Menu'),
      ),
      body: Center(
          // ignore: avoid_unnecessary_containers
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Developer Menu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: Text('Login'),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatRoom()),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('SkipPage'),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainWrapper()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  child: Text('MainMenu'),
                )),
              ],
            ),
            // StreamBuilder(
            //   stream:
            //       FirebaseFirestore.instance.collection('users').snapshots(),
            //   builder: (context, snapshot) {
            //     return Expanded(
            //         // height: MediaQuery.of(context).size.height * 0.5,
            //         child: ListView(children: makeListWidget(snapshot.data)));
            //   },
            // )
          ],
        ),
      )),
    );
  }

  List<Widget> makeListWidget(QuerySnapshot<Map<String, dynamic>>? data) {
    return data!.docs.map((doc) {
      return ListTile(title: Text(doc['name'].toString()));
    }).toList();
  }
}
