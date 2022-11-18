import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/chat/chatRoom.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom(
      {super.key, required this.minNumJoin, required this.activity});
  final int minNumJoin;
  final String activity;

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  //final String user_id = 'pvtKqLVvqlb4LblhHdu3FvghAxz1';
  bool isProgressing = true;
  bool isLoading = true;
  int durationValue = 10;
  String progressState = 'กำลังจับกลุ่ม';
  Timestamp threeMinutesAgo = Timestamp.fromMillisecondsSinceEpoch(
      DateTime.now().subtract(Duration(minutes: 3)).millisecondsSinceEpoch);
  List<QueryDocumentSnapshot<Map<String, dynamic>>> waiting_room = [];
  int roomNumber = 0;
  late Map<String, dynamic>? roomData;
  String selectedRoom = '';
  late StreamSubscription subscription;

  void getData() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = FirebaseFirestore
        .instance
        .collection('matchmaking')
        .where('activity', isEqualTo: widget.activity)
        .where('createdAt', isGreaterThan: threeMinutesAgo)
        .orderBy('createdAt')
        .snapshots();
    subscription = snapshots.listen((event) {
      if (event.docs.isEmpty) {
        print('empty');
        createMatchMaking(false);
        //durationValue
      }

      if (event.docs.isEmpty) {
        setState(() {
          isLoading = true;
        });
      }
      //someone has join
      if (event.docChanges.isNotEmpty &&
          selectedRoom == event.docChanges.last.doc.id &&
          isProgressing) {
        if (!event.docChanges.last.doc.get('isLocked')) changeProgressState(30);
      }

      //before loading stream
      if (event.docs.isNotEmpty && selectedRoom == '') {
        changeProgressState(durationValue);
        setState(() {
          //durationValue
          durationValue = 10;
          waiting_room = event.docs;
          roomData = waiting_room[roomNumber].data();
          isLoading = false;
        });
      } else {
        //after loading stream
        changeProgressState(durationValue);
        setState(() {
          waiting_room = event.docs;
          roomData = waiting_room[roomNumber].data();
        });
      }
    });
  }

  void createMatchMaking(bool isNextActivity) {
    print('outside');
    FirebaseFirestore.instance.collection('matchmaking').add({
      'activity': widget.activity,
      'createdAt': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      'participants': [user_id],
      'minNumJoin': widget.minNumJoin,
      'numJoin': 1,
      'isLocked': false,
    }).then((value) {
      print('inside');
      setState(() {
        selectedRoom = value.id;
        //set duration
        durationValue = 180;
      });
      print(value.id);
      if (isNextActivity) {
        roomNumber = waiting_room.indexWhere((element) {
          return element.id == value.id;
        });

        roomData = waiting_room[roomNumber].data();
      }
      changeProgressState(durationValue);
    });
  }

  void changeProgressState(int value) {
    print('change state $value');

    setState(() {
      durationValue = value;
      controller.value = 0;
      controller.duration = Duration(seconds: value);
      if (value == 30) {
        progressState = 'รอสมาชิกเพิ่มเติม';
      } else if (value == 180) {
        progressState = 'กำลังจับกลุ่ม';
      } else if (value == 10) {
        progressState = 'เจอกลุ่มแล้ว โปรดกดเข้าร่วมกิจกรรม';
      }
    });

    controller.reset();
    controller.animateTo(1);
  }

  void joinActivity() {
    if (roomData?['numJoin'] < roomData?['minNumJoin']) {
      selectedRoom = waiting_room[roomNumber].id;
      FirebaseFirestore.instance
          .collection('matchmaking')
          .doc(selectedRoom)
          .update({
        'participants': FieldValue.arrayUnion([user_id]),
        'numJoin': FieldValue.increment(1),
        'minNumJoin': widget.minNumJoin < roomData?['minNumJoin']
            ? widget.minNumJoin
            : roomData?['minNumJoin'],
      }).then(
        (value) {
          changeProgressState(30);
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('คนเต็มแล้ว')),
      );
    }
  }

  void leaveActivity() {
    if (roomData?['numJoin'] == 1) {
      deleteEmptyWaitingRoom();
    } else {
      FirebaseFirestore.instance
          .collection('matchmaking')
          .doc(selectedRoom)
          .update({
        'participants': FieldValue.arrayRemove([user_id]),
        'numJoin': FieldValue.increment(-1)
      }).then((value) {});
    }
  }

  void createChat() async {
    if (roomData?['isLocked'] == false) {
      print('create chat');
      await FirebaseFirestore.instance
          .collection('matchmaking')
          .doc(waiting_room[roomNumber].id)
          .update({
        'isLocked': true,
      });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(waiting_room[roomNumber].id)
          .set({
        'chatImage':
            'https://cdn2.vectorstock.com/i/1000x1000/61/61/cute-blue-tree-cartoon-vector-15226161.jpg',
        'chatName': 'กิจกรรม-${waiting_room[roomNumber].id}',
        'chatNumJoin': roomData?['numJoin'],
        'isGroup': true,
        'isMatchmaking': true,
        'participants': roomData?['participants']
      });
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('chats')
        .doc(waiting_room[roomNumber].id)
        .set({
      'chat_ref': FirebaseFirestore.instance
          .collection('chats')
          .doc(waiting_room[roomNumber].id),
      'latest_write': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch)
    });
  }

  void nextActivity() {
    if (roomNumber + 1 > waiting_room.length - 1) {
      print('create new room');
      setState(() {
        createMatchMaking(true);
      });
    } else {
      print('not create new room');
      print(roomNumber + 1);
      waiting_room.forEach((el) {
        print(el.id);
      });
      setState(() {
        roomNumber += 1;
        roomData = waiting_room[roomNumber].data();
      });
    }
  }

  void deleteEmptyWaitingRoom() {
    FirebaseFirestore.instance
        .collection('matchmaking')
        .doc(selectedRoom)
        .delete();
  }

  String showTime() {
    int intSeconds = controller.lastElapsedDuration!.inSeconds;
    int diff = durationValue - intSeconds;
    String minutes = (diff / 60).toInt().toString();
    String seconds = (diff % 60).toInt().toString();

    if (minutes.length == 1) {
      minutes = '0$minutes';
    }
    if (seconds.length == 1) {
      seconds = '0$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    getData();

    controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(seconds: durationValue),
    )..addListener(() {
        if (controller.isCompleted && durationValue == 30) {
          createChat();
          isProgressing = false;
          setState(() {
            isProgressing = isProgressing;
          });
        } else if (controller.isCompleted && durationValue == 10) {
          print('next act');
          changeProgressState(10);
          nextActivity();
        } else if (controller.isCompleted && durationValue == 180) {
          print('delete');
          subscription.cancel();
          deleteEmptyWaitingRoom();
          Navigator.pop(context);
        }
        setState(() {});
      });
    controller.animateTo(1);
    //controller.repeat(reverse: false);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    subscription.cancel();
    if (selectedRoom != '' && durationValue == 30) {
      leaveActivity();
    } else if (selectedRoom != '' && durationValue == 180) {
      deleteEmptyWaitingRoom();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext widget) {
    // return StreamBuilder(
    //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
    //     builder: (context, snapshot) {
    //       return StatefulBuilder(
    //         builder: (context, setState) {

    //           return AlertDialog(
    //             title: Text('test'),
    //             content: Column(
    //               children: test(snapshot.data),
    //             ),
    //           );
    //         },
    //       );
    //     });
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Text('อยู่ระหว่างการจับกลุ่ม'),
          scrollable: true,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isProgressing
                    ? Column(
                        children: [
                          Text(progressState),
                          Text(showTime()),

                          //Text(controller.toStringDetails()),
                          LinearProgressIndicator(
                            value: controller.value,
                          ),
                        ],
                      )
                    : Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                          chat_id: waiting_room[roomNumber].id,
                                          isMatchmaking: true,
                                        )),
                              );
                            },
                            icon: Icon(
                              Icons.chat_bubble_outline,
                              size: 30,
                            )),
                      ),
                waiting_room.isEmpty
                    ? Center()
                    : controller.isCompleted
                        ? Center()
                        : Center(
                            child: Column(
                              children: [
                                Text('รหัสห้อง ${waiting_room[roomNumber].id}'),
                                Text('ผูเข้าร่วม ${roomData?['numJoin']}'),
                                //empty = ยังไม่เลือกห้องให้ขึ้นให้เลือกก่อน
                                selectedRoom.isNotEmpty
                                    ? Center()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                joinActivity();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green),
                                              child: Text('เข้าร่วมกิจกรรมนี้'),
                                            ),
                                          )),
                                          Expanded(
                                              child: Container(
                                            margin: EdgeInsets.all(5),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                nextActivity();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              child: Text('ดูกิจกรรมต่อไป'),
                                            ),
                                          ))
                                        ],
                                      )
                              ],
                            ),
                          ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //     onPressed: () {
                    //       controller.reset();
                    //       controller.duration = Duration(seconds: 30);
                    //       progressState = 'รอสมาชิกเพิ่มเติม';
                    //       controller.animateTo(1);
                    //     },
                    //     child: Text('setState')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('ยกเลิก'))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> test(QuerySnapshot<Map<String, dynamic>>? data) {
    if (data == null) {
      return [Center()];
    }
    return data!.docs.map((doc) {
      // return ListTile(title: Text(doc.id.toString()));
      return Text(doc.id);
    }).toList();
  }
}
