import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paipao/pages/widget/announcementDetails.dart';
import '../profile/profile.dart';

class AnnouncementCard extends StatefulWidget {
  final Map<String, dynamic> announceData;
  final bool isViewingDetail;

  /*
  {
    isGenderCon: false
    isSmokingCon: false
    isDrinkingCon: false
  }

  */

  const AnnouncementCard(
      {super.key, required this.announceData, required this.isViewingDetail});

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.fromLTRB(8, 3, 0, 0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              widget.announceData['title'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                    child: Icon(Icons.groups,
                                        color: Colors.blue, size: 15),
                                  ),
                                  Text(
                                    '${widget.announceData['numJoin']}/${widget.announceData['capacity']}',
                                    style: TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 32,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(8, 3, 0, 8),
                      child: Wrap(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: widget.announceData['isTypeSelect']
                                    ? Colors.yellow
                                    : Colors.lightGreenAccent,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(3),
                            child: Text(
                              widget.announceData['isTypeSelect']
                                  ? 'คัดเลือกผู้เข้าร่วม'
                                  : 'เข้าร่วมได้เลย',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                            child: Wrap(children: [
                              Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.blue,
                              ),
                              Text(
                                widget.announceData['location'],
                                style: TextStyle(fontSize: 14),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              )
                            ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        widget.announceData['activity_date'],
                        style: TextStyle(color: Colors.grey.shade500),
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  padding: EdgeInsets.only(left: 8, bottom: 8),
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    children: [
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 15,
                            ),
                          ),
                          Text(
                            widget.announceData['conditions']['isGenderCon']
                                ? widget.announceData['conditions']
                                    ['genderConText']
                                : 'ไม่ระบุ',
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      widget.announceData['conditions']['isDrinkingCon'] ??
                              false
                          ? Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Icon(
                                    Icons.no_drinks,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                ),
                                Text(
                                  'ไม่ดื่มเหล้าเบียร์',
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            )
                          : Text(''),
                      widget.announceData['conditions']['isSmokingCon'] ?? false
                          ? Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Icon(
                                    Icons.smoke_free,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                ),
                                Text(
                                  'ไม่สูบบุหรี่',
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            )
                          : Text(''),
                    ],
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Wrap(
                        children: [
                          TextButton(
                            onPressed: (() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile(
                                          userId: widget.announceData['creator']
                                              ['user_id'])));
                            }),
                            style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll<Color>(
                                  Colors.grey.shade300),
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.white),
                              foregroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.black),
                            ),
                            child: Wrap(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 3, right: 3),
                                  child: Icon(
                                    Icons.campaign,
                                    size: 15,
                                  ),
                                ),
                                Text(
                                  widget.announceData['creator']['name'],
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    !widget.isViewingDetail
                        ? Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width / 2 - 32,
                            child: Wrap(
                              children: [
                                TextButton(
                                  onPressed: (() {
                                    // showModalBottomSheet(
                                    //     context: context,
                                    //     isScrollControlled: true,
                                    //     builder: (context) {
                                    //       return FractionallySizedBox(
                                    //         heightFactor: 0.9,
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //               borderRadius:
                                    //                   BorderRadius.only(
                                    //                       topLeft:
                                    //                           Radius.circular(
                                    //                               5),
                                    //                       topRight:
                                    //                           Radius.circular(
                                    //                               5))),
                                    //           child: Padding(
                                    //             padding:
                                    //                 EdgeInsets.only(top: 10),
                                    //             child: Column(children: [
                                    //               Center(
                                    //                 child: Container(
                                    //                     width:
                                    //                         MediaQuery.of(
                                    //                                     context)
                                    //                                 .size
                                    //                                 .width /
                                    //                             3,
                                    //                     decoration: BoxDecoration(
                                    //                         color: Colors
                                    //                             .grey.shade400,
                                    //                         borderRadius:
                                    //                             BorderRadius
                                    //                                 .circular(
                                    //                                     10)),
                                    //                     child: Text('')),
                                    //               ),
                                    //               Image.network(
                                    //                   'https://www.thesynergist.org/wp-content/uploads/2014/09/469564565.jpg'),
                                    //               Image.network(
                                    //                   'https://www.thesynergist.org/wp-content/uploads/2014/09/469564565.jpg'),
                                    //               Image.network(
                                    //                   'https://www.thesynergist.org/wp-content/uploads/2014/09/469564565.jpg'),
                                    //               Image.network(
                                    //                   'https://www.thesynergist.org/wp-content/uploads/2014/09/469564565.jpg'),
                                    //             ]),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     });

                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        builder: (BuildContext context) {
                                          return AnnouncementDetail(
                                              announceData: widget.announceData,
                                              isViewingDetail: true);
                                        });
                                  }),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.grey.shade300),
                                    backgroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.white),
                                    foregroundColor:
                                        MaterialStatePropertyAll<Color>(
                                            Colors.black),
                                  ),
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'ดูรายละเอียด',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        maxLines: 3,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text('')
                  ],
                ),
              ]))),
    );
  }
}
