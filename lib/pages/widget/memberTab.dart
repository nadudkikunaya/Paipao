import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile/profile_old.dart';

class MemberTab extends StatefulWidget {
  const MemberTab(
      {super.key,
      required this.userData,
      required this.creator,
      required this.activity_id,
      required this.user_id,
      required this.refreshParent});
  final Map<String, dynamic> userData;
  final String creator;
  final String activity_id;
  final String user_id;
  final Function refreshParent;
  @override
  State<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {
  void acceptParticipant() async {
    print('update allow user to true');
    await FirebaseFirestore.instance
        .collection('announcement')
        .doc(widget.activity_id)
        .collection('participants')
        .doc(widget.userData['user_id'])
        .update({
      'isAllowed': true,
    });
    print('update numJoin');
    await FirebaseFirestore.instance
        .collection('announcement')
        .doc(widget.activity_id)
        .update({
      'numJoin': FieldValue.increment(1),
    }).then((value) {
      setState(() {
        widget.refreshParent(true);
      });
    });

    addChatRoom();
  }

  void addChatRoom() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userData['user_id'])
        .collection('chats')
        .doc(widget.activity_id)
        .get()
        .then((doc) async {
      if (!doc.exists) {
        DocumentReference<Map<String, dynamic>> chat_ref =
            FirebaseFirestore.instance.doc('chats/' + widget.activity_id);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userData['user_id'])
            .collection('chats')
            .doc(widget.activity_id)
            .set({
          'chat_ref': chat_ref,
          'latest_write': Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch)
        });

        await FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.activity_id)
            .update({
          'chatNumJoin': FieldValue.increment(1),
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      child: TextButton(
        onPressed: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Profile(userId: widget.userData['user_id'])));
        }),
        style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll<Color>(Colors.grey.shade300),
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
        ),
        child: Wrap(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 + 10,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Wrap(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userData['profile']),
                    radius: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    margin: EdgeInsets.only(top: 20, left: 15),
                    child: Text(
                      widget.userData['name'],
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            widget.creator == widget.user_id
                ? widget.userData['isAllowed']
                    ? widget.userData['user_id'] == widget.creator
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2 -
                                MediaQuery.of(context).size.width * 0.1 -
                                30,
                            margin: EdgeInsets.only(top: 30),
                            alignment: Alignment.centerRight,
                            child: Text('ผู้สร้างกิจกรรม'))
                        : Container(
                            width: MediaQuery.of(context).size.width / 2 -
                                MediaQuery.of(context).size.width * 0.1 -
                                30,
                            margin: EdgeInsets.only(top: 30),
                            alignment: Alignment.centerRight,
                            child: Text('รับเข้าร่วมกิจกรรมแล้ว'))
                    : Container(
                        width: MediaQuery.of(context).size.width / 2 -
                            MediaQuery.of(context).size.width * 0.1 -
                            30,
                        margin: EdgeInsets.only(top: 25),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: acceptParticipant,
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll<Color>(Colors.green),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.blueAccent),
                            foregroundColor:
                                MaterialStatePropertyAll<Color>(Colors.white),
                          ),
                          child: Text(
                            'รับเข้ากลุ่ม',
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                : widget.creator == widget.userData['user_id']
                    ? Container(
                        width: MediaQuery.of(context).size.width / 2 -
                            MediaQuery.of(context).size.width * 0.1 -
                            30,
                        margin: EdgeInsets.only(top: 25),
                        alignment: Alignment.centerRight,
                        child: Text('ผู้สร้างกิจกรรม'))
                    : widget.userData['isAllowed']
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2 -
                                MediaQuery.of(context).size.width * 0.1 -
                                30,
                            margin: EdgeInsets.only(top: 25),
                            alignment: Alignment.centerRight,
                            child: Text('ผู้ร่วมกิจกรรม'))
                        : Container(
                            width: MediaQuery.of(context).size.width / 2 -
                                MediaQuery.of(context).size.width * 0.1 -
                                30,
                            margin: EdgeInsets.only(top: 25),
                            alignment: Alignment.centerRight,
                            child: Text(''))
          ],
        ),
      ),
    );
  }
}
