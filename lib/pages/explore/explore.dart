import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paipao/pages/explore/createAnnouncement.dart';
import 'package:paipao/pages/explore/filterAlertDialog.dart';
import 'package:paipao/pages/explore/matchMakingFilter.dart';
import 'package:select_form_field/select_form_field.dart';
import 'announcementCard.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final _searchController = TextEditingController();
  final _filterController = TextEditingController();
  List<Map<String, dynamic>> announcedData = [];
  //final String user_id = FirebaseAuth.instance.currentUser!.uid;
  //final String user_id = 'pvtKqLVvqlb4LblhHdu3FvghAxz1'; //test01
  final String user_id = FirebaseAuth.instance.currentUser!.uid;

  List<String> provinceList = [];
  List<String> activitiesList = [];
  List<String> groupNumList = [
    'ไม่ระบุ',
    '3',
    '4',
    '5',
    '3 ถึง 5',
    '5 ถึง 10',
    '10 ขึ้นไป'
  ];
  List<String> genderList = [
    'ไม่ระบุ',
    'ชายเท่านั้น',
    'หญิงเท่านั้น',
    'LGBTQA+ เท่านั้น',
  ];

  String filterProvince = 'ไม่ระบุจังหวัด';
  String filterAcitivity = 'กิจกรรมทั้งหมด';
  String filterGroupNum = 'ไม่ระบุ';
  String filterGender = 'ไม่ระบุ';

  String formatDate(timestamp) {
    int millisec = (timestamp as Timestamp).toDate().millisecondsSinceEpoch;
    String dateformatted = DateFormat('วันที่ dd/MM/yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(millisec));
    return dateformatted;
  }

  getProvince() async {
    final String response = await rootBundle.loadString('assets/province.json');
    final data = await json.decode(response);
    provinceList = (data['province'] as List)
        .map((e) => (e as String).replaceAll('จังหวัด', ''))
        .toList();
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
        activitiesList.insert(0, 'กิจกรรมทั้งหมด');
      });
    });
  }

  getInitData() async {
    List<Map<String, dynamic>> listData = [];
    FirebaseFirestore.instance
        .collection('announcement')
        .where('activity_date', isGreaterThan: DateTime.now())
        .limit(20)
        .get()
        .then((announcement) {
      for (int i = 0; i < announcement.docs.length; i++) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc = announcement.docs[i];
        Map<String, dynamic> data = doc.data();
        data['activity_id'] = doc.id;
        data['activity_date'] = formatDate(data['activity_date']);
        data['creator_ref']
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic>? creator = doc.data();
          data['creator'] = {"user_id": doc.id, "name": creator!['name']};
          //print(data);
          listData.add(data);
          setState(() {
            /*
            announceData = {
              .
              .
              'activity_id': ,
              creator:{
                'user_id': ,
                'name': ,
              }
            }
            */
            announcedData = listData;
          });
        });
      }
    });
  }

  getFilterData() async {
    List<Map<String, dynamic>> listData = [];
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('announcement')
        .where('activity_date', isGreaterThan: DateTime.now());

    if (filterProvince != 'ไม่ระบุจังหวัด') {
      print('location');
      query = query.where('location', isEqualTo: filterProvince);
    }

    if (filterAcitivity != 'กิจกรรมทั้งหมด') {
      print('activity');
      query = query.where('activity_tag', isEqualTo: filterAcitivity);
    }

    if (filterGender != 'ไม่ระบุ') {
      print('gender');
      query = query.where('conditions.genderContext', isEqualTo: filterGender);
    }

    if (filterGroupNum != 'ไม่ระบุ') {
      print('test');
    }

    query.limit(20).get().then((announcement) {
      if (announcement.docs.isEmpty) {
        setState(() {
          announcedData = [];
        });
      }
      for (int i = 0; i < announcement.docs.length; i++) {
        QueryDocumentSnapshot<Map<String, dynamic>> doc = announcement.docs[i];
        Map<String, dynamic> data = doc.data();
        print('here');
        data['activity_id'] = doc.id;
        data['activity_date'] = formatDate(data['activity_date']);
        data['creator_ref']
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic>? creator = doc.data();
          data['creator'] = {"user_id": doc.id, "name": creator!['name']};
          //print(data);
          listData.add(data);
          print(listData);
          setState(() {
            /*
            announceData = {
              .
              .
              'activity_id': ,
              creator:{
                'user_id': ,
                'name': ,
              }
            }
            */
            announcedData = listData;
          });
        });
      }
    });
  }

  void updateFilterAcitivity(value) {
    setState(() {
      filterAcitivity = value;
    });
    getFilterData();
    Navigator.pop(context);
  }

  void updateFilterGroupNum(value) {
    setState(() {
      filterGroupNum = value;
    });
    getFilterData();
    Navigator.pop(context);
  }

  void updateFilterGender(value) {
    setState(() {
      filterGender = value;
    });
    getFilterData();
    Navigator.pop(context);
  }

  void updateFilterProvince(value) {
    setState(() {
      filterProvince = value;
    });
    getFilterData();
    Navigator.pop(context);
  }

  @override
  void initState() {
    getInitData();
    getActivity();
    getProvince();

    // Future.delayed(Duration.zero, () async {
    //   announcedData = await getData();
    //   setState(() {
    //     announcedData = announcedData;
    //     print(announcedData);
    //   });
    // });
    _searchController.addListener(_textFieldAction);
    _filterController.addListener(_textFieldAction);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  void _textFieldAction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateAnnouncement()));
              },
              icon: Icon(Icons.post_add))
        ],
      )
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     // Text('value:{${_searchController.text} }',
          //     //     textAlign: TextAlign.left,
          //     //     style: TextStyle(color: Colors.black)),
          //     Container(
          //       height: 40,
          //       decoration: BoxDecoration(
          //           color: Colors.white, borderRadius: BorderRadius.circular(5)),
          //       child: Center(
          //           child: TextField(
          //         controller: _searchController,
          //         decoration: InputDecoration(
          //             prefixIcon: Icon(Icons.search),
          //             suffixIcon: IconButton(
          //               icon: Icon(Icons.clear),
          //               onPressed: () {
          //                 _searchController.clear();
          //               },
          //             ),
          //             hintText: 'ค้นหา',
          //             border: InputBorder.none),
          //       )),
          //     ),
          //   ],
          // ),
          ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Card(
                        child: Wrap(
                      direction: Axis.vertical,
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 10,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll<Color>(
                                      Colors.grey.shade200),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontWeight: FontWeight.bold))),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return FilterAlertDialog(
                                        defaultList: provinceList,
                                        updateFilter: updateFilterProvince,
                                        title: 'เลือกพื้นที่',
                                      );
                                    });
                              },
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue),
                                  Text(filterProvince)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 4,
                              child: Wrap(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 3, 0, 8),
                                  child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.grey.shade300),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.grey.shade200),
                                        foregroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: (() {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FilterAlertDialog(
                                                defaultList: activitiesList,
                                                updateFilter:
                                                    updateFilterAcitivity,
                                                title: 'เลือกกิจกรรมที่สนใจ',
                                              );
                                            });
                                      }),
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.local_activity,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          Text(
                                            filterAcitivity,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 3, 0, 8),
                                  child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.grey.shade300),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.grey.shade200),
                                        foregroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: (() {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FilterAlertDialog(
                                                defaultList: groupNumList,
                                                updateFilter:
                                                    updateFilterGroupNum,
                                                title:
                                                    'เลือกจำนวนผู้เข้าร่วมกิจกรรม',
                                              );
                                            });
                                      }),
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.groups,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          Text(
                                            filterGroupNum,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 3, 0, 8),
                                  child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.grey.shade300),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.grey.shade200),
                                        foregroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.black),
                                      ),
                                      onPressed: (() {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return FilterAlertDialog(
                                                defaultList: genderList,
                                                updateFilter:
                                                    updateFilterGender,
                                                title:
                                                    'เลือกเพศของผู้เข้าร่วมกิจกรรม',
                                              );
                                            });
                                      }),
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          Text(
                                            filterGender,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )),
                                ),
                              ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 4 - 14,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 3, 5, 8),
                                child: TextButton(
                                  onPressed: (() {}),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.grey.shade200),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.white),
                                    foregroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.black),
                                  ),
                                  child: Wrap(
                                    children: [
                                      Icon(
                                        Icons.filter_alt,
                                        color: Colors.blue,
                                      ),
                                      Text('ตัวกรอง')
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ))),
                announcedData.isEmpty
                    ? Text('loading')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: announcedData.length,
                        itemBuilder: (context, index) {
                          return AnnouncementCard(
                              announceData: announcedData[index],
                              isViewingDetail: false);
                        },
                      ),
                // AnnouncementCard(
                //   title: 'ปั่นจักรยานรอบจุฬา',
                //   numPerson: '1',
                //   maxPerson: '5',
                //   isTypeSelect: false,
                //   location: 'กรุงเทพมหานคร',
                //   dateFormatted: 'วันอังคารที่ 15 พฤศจิกายน 2565',
                //   conditions: {
                //     'isGenderCon': false,
                //     'isSmokingCon': true,
                //     'isDrinkingCon': true
                //   },
                //   creator: 'มั่นคง แสงอำไพ',
                //   isViewingDetail: false,
                // ),
                // AnnouncementCard(
                //   title: 'ตกปลาที่ริมตลิ่ง',
                //   numPerson: '1',
                //   maxPerson: '5',
                //   isTypeSelect: true,
                //   location: 'กรุงเทพมหานคร',
                //   dateFormatted: 'วันพุธที่ 16 พฤศจิกายน 2565',
                //   conditions: {
                //     'isGenderCon': false,
                //     'isSmokingCon': false,
                //     'isDrinkingCon': true
                //   },
                //   creator: 'ณัฐวัตร หะยะมิน',
                //   isViewingDetail: false,
                // ),
                // AnnouncementCard(
                //   title: 'ขี่สเก็ตไปเย็ดสก๊อย',
                //   numPerson: '3',
                //   maxPerson: '10',
                //   isTypeSelect: false,
                //   location: 'กรุงเทพมหานคร',
                //   dateFormatted: 'วันพฤหัสบดีที่ 17 พฤศจิกายน 2565',
                //   conditions: {
                //     'isGenderCon': true,
                //     'isSmokingCon': false,
                //     'isDrinkingCon': false,
                //     'genderConText': 'ชายเท่านั้น'
                //   },
                //   creator: 'สมชาย คำมี',
                //   isViewingDetail: false,
                // ),
                // AnnouncementCard(
                //   title: 'ขี่สเก็ตไปเย็ดสก๊อย',
                //   numPerson: '3',
                //   maxPerson: '10',
                //   isTypeSelect: false,
                //   location: 'กรุงเทพมหานคร',
                //   dateFormatted: 'วันพฤหัสบดีที่ 17 พฤศจิกายน 2565',
                //   conditions: {
                //     'isGenderCon': true,
                //     'isSmokingCon': false,
                //     'isDrinkingCon': false,
                //     'genderConText': 'ชายเท่านั้น'
                //   },
                //   creator: 'สมชาย คำมี',
                //   isViewingDetail: false,
                // ),
                // AnnouncementCard(
                //   title: 'ขี่สเก็ตไปเย็ดสก๊อย',
                //   numPerson: '3',
                //   maxPerson: '10',
                //   isTypeSelect: false,
                //   location: 'กรุงเทพมหานคร',
                //   dateFormatted: 'วันพฤหัสบดีที่ 17 พฤศจิกายน 2565',
                //   conditions: {
                //     'isGenderCon': true,
                //     'isSmokingCon': false,
                //     'isDrinkingCon': false,
                //     'genderConText': 'ชายเท่านั้น'
                //   },
                //   creator: 'สมชาย คำมี',
                //   isViewingDetail: false,
                // )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          showDialog(
              context: context,
              builder: (context) {
                return MatchMakingFilter();
              });
        }),
        child: Icon(
          Icons.join_inner,
          color: Colors.black,
        ),
      ),
    );
  }
}
