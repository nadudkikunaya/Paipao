import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerDetail3.dart';
import 'package:paipao/pages/widget/tag.dart';

class ChangeActivity extends StatefulWidget {
  const ChangeActivity({super.key});

  @override
  State<ChangeActivity> createState() => _ChangeActivityState();
}

class _ChangeActivityState extends State<ChangeActivity> {
  List<dynamic> activities = [];
  List<String> favourite = [];
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  void getData() async {
    await FirebaseFirestore.instance
        .collection('data')
        .doc('activities')
        .get()
        .then((doc) async {
      Map<String, dynamic>? dataActivity = doc.data();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .get()
          .then((value) {
        Map<String, dynamic>? dataFav = value.data();
        favourite = (dataFav?['activities'] as List)
            .map((item) => item as String)
            .toList();

        setState(() {
          favourite = favourite;
          activities = dataActivity?['activities'];
        });
      });
    });
  }

  bool getIsFavActivity(String act) {
    return favourite.contains(act);
  }

  void updateUserActivity() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .update({'activities': favourite});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกการเปลี่ยนแปลงสำเร็จ')),
    );
  }

  void updateFavouriteList(String activity) {
    if (favourite.contains(activity)) {
      favourite.remove(activity);
    } else {
      favourite.add(activity);
    }

    print(favourite);
    setState(() {
      favourite = favourite;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เลือกกิจกรรมที่คุณชื่นชอบ'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.height - 40,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'เลือกกิจกรรมที่คุณชื่นชอบ',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Wrap(
                          direction: Axis.horizontal,
                          clipBehavior: Clip.antiAlias,
                          children: activities.isEmpty
                              ? [Text('loading')]
                              : activities
                                  .map((activity) => Tag(
                                        label: activity.toString(),
                                        updateParent: updateFavouriteList,
                                        isFavourite: getIsFavActivity(activity),
                                      ))
                                  .toList()
                          //[

                          //   Tag(label: 'ปั่นจักรยาน'),
                          //   Tag(label: 'ตกปลา'),
                          //   Tag(label: 'ตั้งแคมป์'),
                          //   Tag(label: 'จิตอาสา'),
                          //   Tag(label: 'ปั่นจักรยาน'),
                          //   Tag(label: 'ตกปลา'),
                          //   Tag(label: 'ตั้งแคมป์'),
                          //   Tag(label: 'จิตอาสา'),
                          //   Tag(label: 'ปั่นจักรยาน'),
                          //   Tag(label: 'ตกปลา'),
                          //   Tag(label: 'ตั้งแคมป์'),
                          //   Tag(label: 'จิตอาสา'),
                          //   Tag(label: 'ปั่นจักรยาน'),
                          //   Tag(label: 'ตกปลา'),
                          //   Tag(label: 'ตั้งแคมป์'),
                          //   Tag(label: 'จิตอาสา'),
                          // ],
                          )),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            updateUserActivity();
                          },
                          child: Text('บันทึก')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
