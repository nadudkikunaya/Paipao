import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/chat/chatMemberTab.dart';

import '../profile/profile.dart';

class ChatMember extends StatefulWidget {
  const ChatMember({super.key, required this.participants});
  final Map<String, Map<String, dynamic>> participants;

  @override
  State<ChatMember> createState() => _ChatMemberState();
}

class _ChatMemberState extends State<ChatMember> {
  List<Map<String, dynamic>> chatParticipants = [];

  void mapToList() {
    setState(() {
      widget.participants.keys.forEach((key) {
        chatParticipants.add(widget.participants[key]!);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    mapToList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อสมาชิก'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: chatParticipants.length,
            itemBuilder: (context, index) {
              return ChatMemberTab(
                  userData: chatParticipants[index],
                  user_id: chatParticipants[index]['id']);
            },
          ),
        ],
      )),
    );
  }
}
