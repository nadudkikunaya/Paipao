import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/explore/waitingRoom.dart';

class MatchMakingFilter extends StatefulWidget {
  const MatchMakingFilter({
    super.key,
  });

  @override
  State<MatchMakingFilter> createState() => _MatchMakingFilterState();
}

class _MatchMakingFilterState extends State<MatchMakingFilter> {
  final _filterController = TextEditingController();
  int numJoin = 2;
  List showItemFilter = [];
  List<String> cityActivity = [];
  bool loading = true;

  void getCityActivity() async {
    await FirebaseFirestore.instance
        .collection('data')
        .doc('cityActivity')
        .get()
        .then((doc) {
      Map<String, dynamic>? data = doc.data();

      setState(() {
        cityActivity = (data?['activities'] as List)
            .map((item) => item as String)
            .toList();
        showItemFilter = cityActivity;
        loading = false;
      });
    });
  }

  void increaseNumJoin() {
    if (numJoin == null || numJoin < 2) {
      numJoin = 2;
    }
    if (numJoin >= 2 && numJoin < 10) {
      numJoin = numJoin + 1;
    }
    setState(() {
      numJoin = numJoin;
    });
  }

  void decreaseNumJoin() {
    if (numJoin == null || numJoin < 2) {
      numJoin = 2;
    }
    if (numJoin > 2) {
      numJoin = numJoin - 1;
    }
    setState(() {
      numJoin = numJoin;
    });
  }

  @override
  void initState() {
    getCityActivity();
    _filterController.addListener(_textFieldAction);
    super.initState();
  }

  @override
  void dispose() {
    _filterController.dispose();
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
          title: Text('ค้นหากิจกรรมแบบฉับพลัน'),
          scrollable: true,
          content: loading
              ? Center(child: Text('loading'))
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ผู้เข้าร่วมไม่เกิน'),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                decreaseNumJoin();
                              },
                              icon: Icon(Icons.remove)),
                          Text('$numJoin คน'),
                          IconButton(
                              onPressed: () {
                                increaseNumJoin();
                              },
                              icon: Icon(Icons.add))
                        ],
                      ),
                      TextField(
                        controller: _filterController,
                        onChanged: (value) {
                          if (value == null || value == '') {
                            showItemFilter = cityActivity;
                          } else {
                            showItemFilter = cityActivity
                                .where((element) => element.contains(value))
                                .toList();
                          }
                          setState(() {
                            showItemFilter = showItemFilter;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _filterController.clear();
                              setState(() {
                                showItemFilter = cityActivity;
                              });
                            },
                          ),
                          label: Text('ชื่อกิจกรรม'),
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      for (int i = 0; i < showItemFilter.length; i++)
                        TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll<Color>(
                                  Colors.grey.shade300),
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                              foregroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.black),
                            ),
                            onPressed: () {
                              _filterController.text = showItemFilter[i];
                              showItemFilter = [];
                            },
                            child: Text(showItemFilter[i])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return WaitingRoom(
                                        minNumJoin: numJoin,
                                        activity: _filterController.text,
                                      );
                                    });
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
