import 'package:flutter/material.dart';
import 'package:paipao/pages/chat/chatRoom.dart';
import 'package:paipao/pages/widget/tag.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> chats = [
    {
      'isGroup': true,
      'chatName': 'ห้องแขทตั้งแคมป์',
      'chatImage':
          'https://static.vecteezy.com/system/resources/previews/003/413/353/original/camp-element-icon-design-illustration-free-vector.jpg',
      'chatNumJoin': 3,
      'activityDate': '9/10/2022'
    },
    {
      'isGroup': false,
      'chatName': 'นายเอ แอปเปิ้ล',
      'chatImage': 'https://randomuser.me/api/portraits/men/60.jpg',
    },
    {
      'isGroup': false,
      'chatName': 'นางซี แคทแมว',
      'chatImage': 'https://randomuser.me/api/portraits/women/81.jpg',
    },
    {
      'isGroup': true,
      'chatName': 'ห้องแขทตกปลา',
      'chatImage':
          'https://cdn2.vectorstock.com/i/1000x1000/61/31/fishing-logo-design-hook-up-logo-vector-27336131.jpg',
      'chatNumJoin': 5,
      'activityDate': '9/10/2022'
    },
    {
      'isGroup': false,
      'chatName': 'นายบี เบิร์ดนก',
      'chatImage': 'https://randomuser.me/api/portraits/men/23.jpg',
    }
  ];
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
            ListView.builder(
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
                                builder: (context) => ChatRoom()));
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['chatName']),
                                    data['isGroup']
                                        ? Text('${data['chatNumJoin']} คน')
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
