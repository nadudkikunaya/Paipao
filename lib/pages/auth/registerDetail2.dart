import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerDetail3.dart';
import 'package:paipao/pages/widget/tag.dart';

class RegisterDetail2 extends StatefulWidget {
  final Map<String, dynamic> regData;
  const RegisterDetail2({super.key, required this.regData});

  @override
  State<RegisterDetail2> createState() => _RegisterDetail2State();
}

class _RegisterDetail2State extends State<RegisterDetail2> {
  List<dynamic> activities = [];
  List<String> favourite = [];
  void getData() {
    FirebaseFirestore.instance
        .collection('data')
        .doc('activities')
        .get()
        .then((doc) {
      Map<String, dynamic>? data = doc.data();

      setState(() {
        activities = data?['activities'];
        print(activities);
      });
    });
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
                                      updateParent: updateFavouriteList))
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
                            widget.regData['favouriteList'] = favourite;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterDetail3(
                                          regData: widget.regData,
                                        )));
                          },
                          child: Text('อ่ะ ต่อไป')),
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
