import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/editProfile/myCheckBox.dart';
import 'package:paipao/pages/explore/waitingRoom.dart';

class ReportDialoig extends StatefulWidget {
  const ReportDialoig({
    super.key,
    required this.report_user_id,
  });

  final String report_user_id;

  @override
  State<ReportDialoig> createState() => _ReportDialoigState();
}

class _ReportDialoigState extends State<ReportDialoig> {
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  final _otherReason = TextEditingController();
  List reportReason = [
    {
      'reason': 'ไม่มาตามเวลาที่นัดไว้',
      'status': false,
    },
    {
      'reason': 'ทำความประพฤติอย่างไม่เหมาะสมต่อคนอื่นๆ',
      'status': false,
    },
    {
      'reason': 'ฉ้อโกง',
      'status': false,
    },
    {
      'reason': 'ทำความเสียหายแก่ผู้อื่น',
      'status': false,
    },
    {
      'reason': 'ทำร้ายร่างกาย',
      'status': false,
    },
    {
      'reason': 'ข้อมูลในบัญชีไม่ตรงกับความจริง',
      'status': false,
    },
    {
      'reason': 'อื่นๆ',
      'status': false,
    },
  ];
  bool loading = false;

  void sendReport() async {
    List<String> reason = [];
    reportReason.forEach((element) {
      if (element['status'] && element['reason'] != 'อื่นๆ') {
        reason.add(element['reason']);
      } else if (element['status'] && element['reason'] == 'อื่นๆ') {
        reason.add(_otherReason.text);
      }
    });
    Timestamp createdAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.report_user_id)
        .collection('reports')
        .add({'user_id': user_id, 'reason': reason, 'createdAt': createdAt});
  }

  void updateReportReason(String reason, bool value) {
    setState(() {
      reportReason.forEach((element) {
        if (element['reason'] == reason) {
          element['status'] = value;
        }
      });
    });
  }

  @override
  void initState() {
    _otherReason.addListener(_textFieldAction);
    super.initState();
  }

  @override
  void dispose() {
    _otherReason.dispose();
    super.dispose();
  }

  void _textFieldAction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Text('เลือกเหตุผลในการรายงาน'),
          scrollable: true,
          content: loading
              ? Center(child: Text('loading'))
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (reportReason.map((reason) {
                          MyCheckBox theBox =
                              MyCheckBox(reason['reason'], reason['status']);
                          return (CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                theBox.name.toString(),
                              ),
                              value: reason['status'],
                              onChanged: (value) {
                                updateReportReason(
                                    reason['reason'], !reason['status']);
                              })) as Widget;
                        }).toList()) +
                        [
                          // ListView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: reportReason.length,
                          //   itemBuilder: (context, index) {
                          //     MyCheckBox theBox = MyCheckBox(
                          //         reportReason[index]['reason'],
                          //         reportReason[index]['status']);
                          //     return CheckboxListTile(
                          //         controlAffinity: ListTileControlAffinity.leading,
                          //         title: Text(
                          //           theBox.name.toString(),
                          //         ),
                          //         value: reportReason[index]['status'],
                          //         onChanged: (value) {
                          //           updateReportReason(
                          //               reportReason[index]['reason'],
                          //               !reportReason[index]['status']);
                          //         });
                          //   },
                          // ),
                          reportReason[reportReason.length - 1]['status'] ==
                                  false
                              ? Center()
                              : TextField(
                                  controller: _otherReason,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _otherReason.clear();
                                          // _otherReason.text = '';
                                        });
                                      },
                                    ),
                                    label: Text('เหตุผลอื่นๆ'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    sendReport();
                                    Navigator.pop(context);
                                  },
                                  child: Text('ตกลง')),
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
}
