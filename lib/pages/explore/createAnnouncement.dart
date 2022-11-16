import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paipao/pages/explore/filterAlertDialog.dart';

enum Gender { all, male, female, lgbt }

enum IsSmoking { no, yes }

enum IsDrinking { no, yes }

enum IsVegetarian { no, yes }

enum IsTypeSelect { no, yes }

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  String user_id = 'pvtKqLVvqlb4LblhHdu3FvghAxz1';
  bool isDateSelected = false;
  late DateTime startDate; // instance of DateTime
  String startDateInString = 'วันที่เริ่มกิจกรรม';
  Gender? gender = Gender.all;
  IsSmoking? isSmoking = IsSmoking.no;
  IsDrinking? isDrinking = IsDrinking.no;
  IsVegetarian? isVegetarian = IsVegetarian.no;
  IsTypeSelect? isTypeSelect = IsTypeSelect.no;

  late final _formPostAnnouncementKey = GlobalKey<FormState>();
  final activityNameController = TextEditingController();
  final activityDetailController = TextEditingController();
  final numJoinController = TextEditingController();
  final provinceController = TextEditingController();
  final startDateController = TextEditingController();
  final activityController = TextEditingController();
  List<String> provinceList = [];
  List<String> activitiesList = [];
  int detailMaxLines = 10;

  getProvince() async {
    final String response = await rootBundle.loadString('assets/province.json');
    final data = await json.decode(response);
    provinceList = (data['province'] as List)
        .map((e) => (e as String).replaceAll('จังหวัด', ''))
        .toList();
  }

  void updateProvince(value) {
    setState(() {
      provinceController.text = value;
    });
    Navigator.pop(context);
  }

  void updateActivity(value) {
    setState(() {
      activityController.text = value;
    });
    Navigator.pop(context);
  }

  void increaseNumJoin() {
    int? value_int = int.tryParse(numJoinController.text);
    if (value_int == null || value_int! < 2) {
      numJoinController.text = 2.toString();
    }
    if (value_int! >= 2) {
      numJoinController.text = (value_int + 1).toString();
    }
  }

  void decreaseNumJoin() {
    int? value_int = int.tryParse(numJoinController.text);
    if (value_int! == null || value_int! < 2) {
      numJoinController.text = 2.toString();
    }
    if (value_int > 2) {
      numJoinController.text = (value_int - 1).toString();
    }
  }

  getActivity() async {
    FirebaseFirestore.instance
        .collection('data')
        .doc('activities')
        .get()
        .then((doc) {
      Map<String, dynamic>? data = doc.data();

      setState(() {
        activitiesList = (data?['activities'] as List)
            .map((item) => item as String)
            .toList();
      });
    });
  }

  bool enumToBool(dynamic choice) {
    choice = choice.toString();
    if (choice.contains('.yes')) {
      return true;
    }
    return false;
  }

  bool genderEnumToBool(String choice) {
    if (choice == 'all') {
      return false;
    } else {
      return true;
    }
  }

  String? genderContextToThai(String choice) {
    if (choice == 'male') {
      return 'ชายเท่านั้น';
    } else if (choice == 'female') {
      return 'หญิงเท่านั้น';
    } else if (choice == 'lgbt') {
      return 'LGBTQA+เท่านั้น';
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    getProvince();
    getActivity();
    numJoinController.text = '2';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    activityNameController.dispose();
    activityDetailController.dispose();
    numJoinController.dispose();
    provinceController.dispose();
    startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประกาศกิจกรรม'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'ประกาศกิจกรรม',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Expanded(
                      child: Form(
                          key: _formPostAnnouncementKey,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text('ชื่อกิจกรรม'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกข้อมูล';
                                    }
                                    return null;
                                  },
                                  controller: activityNameController,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                height: detailMaxLines * 20,
                                child: TextFormField(
                                  maxLines: detailMaxLines,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    isCollapsed: true,
                                    label: Text('รายละเอียด'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกข้อมูล';
                                    }

                                    return null;
                                  },
                                  controller: activityDetailController,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FilterAlertDialog(
                                            defaultList: activitiesList,
                                            updateFilter: updateActivity,
                                            title: 'เลือกชนิดของกิจกรรม',
                                          );
                                        });
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      label: Text('ชนิดของกิจกรรม'),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกข้อมูล';
                                      }
                                      return null;
                                    },
                                    controller: activityController,
                                  ),
                                ),
                              ),

                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FilterAlertDialog(
                                            defaultList: provinceList,
                                            updateFilter: updateProvince,
                                            title: 'เลือกพื้นที่จังหวัด',
                                          );
                                        });
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      label: Text('พื้นที่จังหวัด'),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกข้อมูล';
                                      }
                                      return null;
                                    },
                                    controller: provinceController,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (datePick != null) {
                                      setState(() {
                                        startDate = datePick;
                                        isDateSelected = true;

                                        // put it here
                                        startDateInString =
                                            '${startDate.day}/${startDate.month}/${startDate.year}'; // 08/14/2019

                                        startDateController.text =
                                            startDateInString;
                                      });
                                    }
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      label: Text('วันที่เริ่มกิจกรรม'),
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'กรุณากรอกข้อมูล';
                                      }
                                      return null;
                                    },
                                    controller: startDateController,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(5),
                                child: Wrap(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: IconButton(
                                          style: IconButton.styleFrom(
                                              shape: CircleBorder()),
                                          onPressed: () {
                                            increaseNumJoin();
                                          },
                                          icon: Icon(Icons.add)),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          label: Text('จำนวนคน'),
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'กรุณากรอกจำนวนคน';
                                          }
                                          int? value_int = int.tryParse(value);
                                          //int.parse(value);
                                          if (value_int == null) {
                                            return 'กรอกตัวเลข';
                                          }
                                          if (value_int! <= 1) {
                                            return '2 คนขึ้นไป';
                                          }
                                          return null;
                                        },
                                        controller: numJoinController,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 2),
                                      child: IconButton(
                                          onPressed: () {
                                            decreaseNumJoin();
                                          },
                                          icon: Icon(Icons.minimize)),
                                    ),
                                  ],
                                ),
                              ),

                              // GestureDetector(
                              //     child: Icon(Icons.calendar_today),
                              //     onTap: () async {
                              //       final datePick = await showDatePicker(
                              //           context: context,
                              //           initialDate: DateTime.now(),
                              //           firstDate: DateTime(1900),
                              //           lastDate: DateTime(2100));
                              //       if (datePick != null &&
                              //           datePick != startDate) {
                              //         setState(() {
                              //           startDate = datePick;
                              //           isDateSelected = true;

                              //           // put it here
                              //           startDateInString =
                              //               "${startDate.month}/${startDate.day}/${startDate.year}"; // 08/14/2019
                              //         });
                              //       }
                              //     })
                            ],
                          )),
                    ),
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'การเลือกรับผู้เข้าร่วมกิจกรรม',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('เข้าร่วมได้เลย'),
                              leading: Radio<IsTypeSelect>(
                                value: IsTypeSelect.no,
                                groupValue: isTypeSelect,
                                onChanged: (IsTypeSelect? value) {
                                  setState(() {
                                    isTypeSelect = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('คัดเลือกผู้เข้าร่วม'),
                              leading: Radio<IsTypeSelect>(
                                value: IsTypeSelect.yes,
                                groupValue: isTypeSelect,
                                onChanged: (IsTypeSelect? value) {
                                  setState(() {
                                    isTypeSelect = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'เพศผู้เข้าร่วมกิจกรรม',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('เพศใดก็ได้'),
                              leading: Radio<Gender>(
                                value: Gender.all,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ชายเท่านั้น'),
                              leading: Radio<Gender>(
                                value: Gender.male,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('หญิงเท่านั้น'),
                              leading: Radio<Gender>(
                                value: Gender.female,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('LGBTQA+เท่านั้น'),
                              leading: Radio<Gender>(
                                value: Gender.lgbt,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'เงื่อนไขการสูบบุหรี่ระหว่างกิจกรรม',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ไม่สูบบุหรี่'),
                              leading: Radio<IsSmoking>(
                                value: IsSmoking.no,
                                groupValue: isSmoking,
                                onChanged: (IsSmoking? value) {
                                  setState(() {
                                    isSmoking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('สามารถสูบบุหรี่'),
                              leading: Radio<IsSmoking>(
                                value: IsSmoking.yes,
                                groupValue: isSmoking,
                                onChanged: (IsSmoking? value) {
                                  setState(() {
                                    isSmoking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'เงื่อนไขการดื่มเครื่องดื่มแอลกอฮอล์ระหว่างกิจกรรม',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ไม่ดื่ม'),
                              leading: Radio<IsDrinking>(
                                value: IsDrinking.no,
                                groupValue: isDrinking,
                                onChanged: (IsDrinking? value) {
                                  setState(() {
                                    isDrinking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('สามารถดื่ม'),
                              leading: Radio<IsDrinking>(
                                value: IsDrinking.yes,
                                groupValue: isDrinking,
                                onChanged: (IsDrinking? value) {
                                  setState(() {
                                    isDrinking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'เงื่อนไขการรับประทานอาหาร',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ไม่เป็นมังสวิรัติ'),
                              leading: Radio<IsVegetarian>(
                                value: IsVegetarian.no,
                                groupValue: isVegetarian,
                                onChanged: (IsVegetarian? value) {
                                  setState(() {
                                    isVegetarian = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('เป็นมังสวิรัติ'),
                              leading: Radio<IsVegetarian>(
                                value: IsVegetarian.yes,
                                groupValue: isVegetarian,
                                onChanged: (IsVegetarian? value) {
                                  setState(() {
                                    isVegetarian = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formPostAnnouncementKey.currentState!
                                .validate()) {
                              print('create annoucement');
                              DocumentReference creator_ref =
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user_id);
                              FirebaseFirestore.instance
                                  .collection('announcement')
                                  .add({
                                'title': activityNameController.text,
                                'capacity': int.parse(numJoinController.text),
                                'location': provinceController.text,
                                'isTypeSelect': enumToBool(isTypeSelect),
                                'numJoin': 1,
                                'detail': activityDetailController.text,
                                'creator_ref': creator_ref,
                                'created_timestamp':
                                    Timestamp.fromDate(DateTime.now()),
                                'activity_tag': activityController.text,
                                'activity_date': Timestamp.fromDate(startDate),
                                'conditions': {
                                  'isDrinkingCon': enumToBool(isDrinking),
                                  'isGenderCon': genderEnumToBool(gender
                                      .toString()
                                      .replaceAll('Gender.', '')),
                                  'isSmokingCon': enumToBool(isSmoking),
                                  'genderContext': genderContextToThai(gender
                                      .toString()
                                      .replaceAll('Gender.', ''))
                                }
                              }).then((value) async {
                                print('create announcement participants');
                                await FirebaseFirestore.instance
                                    .collection('announcement')
                                    .doc(value.id)
                                    .collection('participants')
                                    .doc(user_id)
                                    .set({
                                  'isAllowed': true,
                                  'user_ref': creator_ref
                                });

                                print('create announcement in user');
                                DocumentReference announce_ref =
                                    await FirebaseFirestore.instance
                                        .collection('announcement')
                                        .doc(value.id);
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user_id)
                                    .collection('announcement')
                                    .doc(value.id)
                                    .set({
                                  'announce_ref': announce_ref,
                                  'status': 'creator',
                                }).then((value) {});
                                print('create chat group');

                                await FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(value.id)
                                    .set({
                                  'chatImage':
                                      'https://cdn2.vectorstock.com/i/1000x1000/61/61/cute-blue-tree-cartoon-vector-15226161.jpg',
                                  'chatName': activityNameController.text,
                                  'chatNumJoin': 1,
                                  'isGroup': true,
                                }).then((chat) async {
                                  print('create chat group in user');
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user_id)
                                      .collection('chats')
                                      .doc(value.id)
                                      .set({
                                    'chat_ref': FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(value.id),
                                    'latest_write':
                                        Timestamp.fromDate(DateTime.now())
                                  }).then(
                                    (value) {
                                      print('finish everything');
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                              });
                            }
                          },
                          child: Text('สร้างประกาศ')),
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
