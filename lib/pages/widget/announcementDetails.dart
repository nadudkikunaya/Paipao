import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'announcementCard.dart';
import 'memberTab.dart';

class AnnouncementDetail extends StatefulWidget {
  const AnnouncementDetail(
      {super.key, required this.announceData, required this.isViewingDetail});
  final Map<String, dynamic> announceData;
  final bool isViewingDetail;

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  @override
  List<Map<String, dynamic>> participants = [];
  //final String temp_user_id = 'KbtEqJMBd1vOEu3cppZ6';
  final String temp_user_id = 'w7oYKajZtmNwOOrujJYm';
  getData() async {
    List<Map<String, dynamic>> listData = [];
    await FirebaseFirestore.instance
        .collection('announcement')
        .doc(widget.announceData['activity_id'])
        .collection('participants')
        .get()
        .then((participantsCollection) async {
      for (var participantDoc in participantsCollection.docs) {
        Map<String, dynamic> data = participantDoc.data();
        await data['user_ref']
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> doc) {
          Map<String, dynamic>? participantData = doc.data();
          participantData!['isAllowed'] = data['isAllowed'];
          participantData['user_id'] = doc.id;
          print(participantData);
          listData.add(participantData);
          // setState(() {
          //   participants = listData;
          //   print(participants.length.toString());
          // });
        });
      }
    });
    setState(() {
      participants = listData;
    });
  }

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.75, //set this as you want
        maxChildSize: 0.75, //set this as you want
        minChildSize: 0, //set this as you want
        expand: true,
        builder: (context, scrollController) {
          return Container(
            color: Colors.grey.shade200,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  AnnouncementCard(
                      announceData: widget.announceData, isViewingDetail: true),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Wrap(direction: Axis.vertical, children: [
                                Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.spaceBetween,
                                    runAlignment: WrapAlignment.spaceBetween,

                                    // alignment: WrapAlignment.spaceBetween,
                                    // runAlignment: WrapAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          padding:
                                              EdgeInsets.fromLTRB(8, 3, 0, 0),
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                'รายละเอียด',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )),
                                    ]),
                                Container(
                                  width: MediaQuery.of(context).size.width - 30,
                                  padding: EdgeInsets.all(10),
                                  //color: Colors.amber,
                                  child: Flexible(
                                      child: Text(
                                    widget.announceData['detail'] ?? 'ไม่ระบุ',
                                    overflow: TextOverflow.clip,
                                  )),
                                )
                              ])))),
                  Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceBetween,
                                        runAlignment:
                                            WrapAlignment.spaceBetween,

                                        // alignment: WrapAlignment.spaceBetween,
                                        // runAlignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 3, 0, 0),
                                              child: Wrap(
                                                direction: Axis.horizontal,
                                                children: [
                                                  Text(
                                                    'ผู้เข้าร่วม',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 3, 0, 0),
                                                    child: Wrap(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 3, 0, 0),
                                                          child: Icon(
                                                              Icons.groups,
                                                              color:
                                                                  Colors.blue,
                                                              size: 15),
                                                        ),
                                                        Text(
                                                          '${widget.announceData['numJoin']}/${widget.announceData['capacity']}',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ]),
                                    participants.isEmpty
                                        ? Text('loading')
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: participants.length,
                                            itemBuilder: (context, index) {
                                              return MemberTab(
                                                userData: participants[index],
                                                creator: widget
                                                        .announceData['creator']
                                                    ['user_id'],
                                                activity_id:
                                                    widget.announceData[
                                                        'activity_id'],
                                                user_id: temp_user_id,
                                              );
                                            }),
                                    // MemberTab(
                                    //     picURL:
                                    //         'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
                                    //     userId: 'ทดสอบ พลานุพัฒน์'),
                                    // MemberTab(
                                    //     picURL:
                                    //         'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
                                    //     userId: 'ทดสอบ พลานุพัฒน์'),
                                    // MemberTab(
                                    //     picURL:
                                    //         'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
                                    //     userId: 'ทดสอบ พลานุพัฒน์')
                                  ]))))
                ],
              ),
            ),
          ); //whatever you're returning, does not have to be a Container
        });
  }
}
