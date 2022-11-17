import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/chat/chatRoom.dart';
import 'package:paipao/pages/widget/tag.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final String user_id = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> chats = [];

  getInitData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('chats')
        .orderBy('latest_write', descending: true)
        .get()
        .then((collection) async {
      for (var userChatDoc in collection.docs) {
        Map<String, dynamic> userChatData = userChatDoc.data();
        print(userChatData);
        await userChatData['chat_ref']
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic>? data = doc.data();
          data?['chat_id'] = doc.id;
          setState(() {
            chats.add(data!);
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แชท'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Tag(label: 'ทั้งหมด'),
                Tag(label: 'ส่วนตัว'),
                Tag(label: 'กลุ่ม')
              ],
            ),
            chats.isEmpty
                ? Center(
                    child: Text('ไม่มีแชท'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      dynamic data = chats[index];
                      return Card(
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                            chat_id: chats[index]['chat_id'],
                                            isMatchmaking: chats[index]
                                                ['isMatchmaking'],
                                          )));
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll<Color>(
                                  Colors.grey.shade300),
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                              foregroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(data['chatImage'])),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data['chatName']),
                                          data['isGroup']
                                              ? Text(
                                                  '${data['chatNumJoin'].toString()} คน')
                                              : Center()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
