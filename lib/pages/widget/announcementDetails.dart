import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'announcementCard.dart';
import 'memberTab.dart';

class AnnouncementDetail extends StatefulWidget {
  const AnnouncementDetail(
      {super.key,
      required this.announceData,
      required this.isViewingDetail,
      required this.refreshParent});
  final Map<String, dynamic> announceData;
  final bool isViewingDetail;
  final Function refreshParent;

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  @override
  List<Map<String, dynamic>> participants = [];
  //final String temp_user_id = 'KbtEqJMBd1vOEu3cppZ6'; //A
  //final String temp_user_id = 'w7oYKajZtmNwOOrujJYm'; //B
  //final String temp_user_id = 'lze0oAskkL1Z7r24a0R7'; //C
  final String temp_user_id = 'pvtKqLVvqlb4LblhHdu3FvghAxz1'; //test01
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
          //print(participantData);
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

  void joinActivity() {
    //print('activity_id :' + widget.announceData['activity_id']);
    print(widget.announceData);
    String activity_id = widget.announceData['activity_id'];
    DocumentReference<Map<String, dynamic>> announce_ref =
        FirebaseFirestore.instance.doc('announcement/' + activity_id);

    print('add announcement ref in user');
    FirebaseFirestore.instance
        .collection('users')
        .doc(temp_user_id)
        .collection('announcement')
        .doc(activity_id)
        .set({
      'announce_ref': announce_ref,
      'status': 'participant',
    });

    bool isAllowed = true;
    bool isUpdateNumJoin = false;
    if (widget.announceData['isTypeSelect'] == false &&
        widget.announceData['capacity'] > widget.announceData['numJoin']) {
      print('update numJoin');
      FirebaseFirestore.instance
          .collection('announcement')
          .doc(activity_id)
          .update({
        'numJoin': FieldValue.increment(1),
      });
      isUpdateNumJoin = true;
    } else if (widget.announceData['isTypeSelect'] == true &&
        widget.announceData['capacity'] > widget.announceData['numJoin']) {
      isUpdateNumJoin = false;
      isAllowed = false;
    }

    print('add user to participants in activity');
    DocumentReference<Map<String, dynamic>> user_ref =
        FirebaseFirestore.instance.doc('users/' + temp_user_id);
    FirebaseFirestore.instance
        .collection('announcement')
        .doc(activity_id)
        .collection('participants')
        .doc(temp_user_id)
        .set({'isAllowed': isAllowed, 'user_ref': user_ref});
    refresh(isUpdateNumJoin);
  }

  void refresh(isUpdateNumJoin) {
    setState(() {
      getData();
      if (isUpdateNumJoin) {
        widget.announceData['numJoin'] += 1;
      }
      // no need *not important*
      widget.refreshParent();
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
                                                refreshParent: refresh,
                                              );
                                            }),
                                  ])))),
                  participants.isEmpty
                      ? Text('loading')
                      : participants.any(
                              (element) => element['user_id'] == temp_user_id)
                          ? Text('')
                          : Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: joinActivity,
                                      style: ButtonStyle(
                                        overlayColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.green),
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.blueAccent),
                                        foregroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Colors.white),
                                      ),
                                      child: Text(
                                        'เข้าร่วมกลุ่ม',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ],
              ),
            ),
          ); //whatever you're returning, does not have to be a Container
        });
  }
}
