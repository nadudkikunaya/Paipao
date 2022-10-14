import 'package:flutter/material.dart';
import '../widget/announcementCard.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchTermAction);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchTermAction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('value:{${_searchController.text} }',
            //     textAlign: TextAlign.left,
            //     style: TextStyle(color: Colors.black)),
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    hintText: 'ค้นหา',
                    border: InputBorder.none),
              )),
            ),
          ],
        ),
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
                              onPressed: () {},
                              child: Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Icon(Icons.location_on, color: Colors.blue),
                                  Text('กรุงเทพมหานคร')
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
                                      onPressed: (() {}),
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.local_activity,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          Text(
                                            'กิจกรรมที่สนใจ',
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
                                      onPressed: (() {}),
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.groups,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          Text(
                                            'ไม่ระบุ',
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
                                      onPressed: (() {}),
                                      child: Wrap(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          Text(
                                            'ไม่ระบุ',
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
                AnnouncementCard(
                  title: 'ปั่นจักรยานรอบจุฬา',
                  numPerson: '1',
                  maxPerson: '5',
                  isTypeSelect: false,
                  location: 'กรุงเทพมหานคร',
                  dateFormatted: 'วันอังคารที่ 15 พฤศจิกายน 2565',
                  conditions: {
                    'isGenderCon': false,
                    'isSmokingCon': true,
                    'isDrinkingCon': true
                  },
                  creator: 'มั่นคง แสงอำไพ',
                  isViewingDetail: false,
                ),
                AnnouncementCard(
                  title: 'ตกปลาที่ริมตลิ่ง',
                  numPerson: '1',
                  maxPerson: '5',
                  isTypeSelect: true,
                  location: 'กรุงเทพมหานคร',
                  dateFormatted: 'วันพุธที่ 16 พฤศจิกายน 2565',
                  conditions: {
                    'isGenderCon': false,
                    'isSmokingCon': false,
                    'isDrinkingCon': true
                  },
                  creator: 'ณัฐวัตร หะยะมิน',
                  isViewingDetail: false,
                ),
                AnnouncementCard(
                  title: 'ขี่สเก็ตไปเย็ดสก๊อย',
                  numPerson: '3',
                  maxPerson: '10',
                  isTypeSelect: false,
                  location: 'กรุงเทพมหานคร',
                  dateFormatted: 'วันพฤหัสบดีที่ 17 พฤศจิกายน 2565',
                  conditions: {
                    'isGenderCon': true,
                    'isSmokingCon': false,
                    'isDrinkingCon': false,
                    'genderConText': 'ชายเท่านั้น'
                  },
                  creator: 'สมชาย คำมี',
                  isViewingDetail: false,
                ),
                AnnouncementCard(
                  title: 'ขี่สเก็ตไปเย็ดสก๊อย',
                  numPerson: '3',
                  maxPerson: '10',
                  isTypeSelect: false,
                  location: 'กรุงเทพมหานคร',
                  dateFormatted: 'วันพฤหัสบดีที่ 17 พฤศจิกายน 2565',
                  conditions: {
                    'isGenderCon': true,
                    'isSmokingCon': false,
                    'isDrinkingCon': false,
                    'genderConText': 'ชายเท่านั้น'
                  },
                  creator: 'สมชาย คำมี',
                  isViewingDetail: false,
                ),
                AnnouncementCard(
                  title: 'ขี่สเก็ตไปเย็ดสก๊อย',
                  numPerson: '3',
                  maxPerson: '10',
                  isTypeSelect: false,
                  location: 'กรุงเทพมหานคร',
                  dateFormatted: 'วันพฤหัสบดีที่ 17 พฤศจิกายน 2565',
                  conditions: {
                    'isGenderCon': true,
                    'isSmokingCon': false,
                    'isDrinkingCon': false,
                    'genderConText': 'ชายเท่านั้น'
                  },
                  creator: 'สมชาย คำมี',
                  isViewingDetail: false,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {}),
        child: Icon(
          Icons.join_inner,
          color: Colors.black,
        ),
      ),
    );
  }
}
