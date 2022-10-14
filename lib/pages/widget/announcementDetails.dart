import 'package:flutter/material.dart';

import 'announcementCard.dart';
import 'memberTab.dart';

class AnnouncementDetail extends StatefulWidget {
  const AnnouncementDetail(
      {super.key,
      required this.title,
      required this.numPerson,
      required this.maxPerson,
      required this.isTypeSelect,
      required this.location,
      required this.dateFormatted,
      required this.conditions,
      required this.creator,
      required this.isViewingDetail});
  final String title;
  final String numPerson;
  final String maxPerson;
  final bool isTypeSelect;
  final String location;
  final String dateFormatted;
  final Map<String, dynamic> conditions;
  final String creator;
  final bool isViewingDetail;

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DraggableScrollableSheet(
          initialChildSize: 0.75, //set this as you want
          maxChildSize: 0.75, //set this as you want
          minChildSize: 0.75, //set this as you want
          expand: true,
          builder: (context, scrollController) {
            return Container(
              color: Colors.grey.shade200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AnnouncementCard(
                        title: widget.title,
                        numPerson: widget.numPerson,
                        maxPerson: widget.maxPerson,
                        isTypeSelect: widget.isTypeSelect,
                        location: widget.location,
                        dateFormatted: widget.dateFormatted,
                        conditions: widget.conditions,
                        creator: widget.creator,
                        isViewingDetail: true),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                child:
                                    Wrap(direction: Axis.vertical, children: [
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )),
                                      ]),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    padding: EdgeInsets.all(10),
                                    //color: Colors.amber,
                                    child: Flexible(
                                        child: Text(
                                      '         ศึกษาศาสตร์ โรแมนติกโพลล์เป่ายิ้งฉุบเซ็นทรัลศึกษาศาสตร์แพกเกจการันตี'
                                      'อ่อนด้อยคาราโอเกะ ซีเรียสปาสกาลภคันทลาพาธ'
                                      'ฟยอร์ดคอนเซปต์โลโก้ไรเฟิลตุ๊ดล็อบบี้อุปการคุณพันธุวิศวกรรมผ้าห่มบิล สารขัณฑ์ฟลุตโลชั่น'
                                      'ทอร์นาโดคอนเซ็ปต์แอ็คชั่นคอร์รัปชั่น หมวยซูเอี๋ยโหงว แรงดูดไฟลท์ว้อย พาวเวอร์เซฟตี้อพาร์ตเมนต์ผู้นำ'
                                      'ซีอีโอเป่ายิงฉุบมะกันโคโยตีรามเทพ dสงบสุขงั้นหล่อฮังก้วยบลูเบอร์รีโบกี้ โจ๋โหลยโท่ย ตัวเองลาเต้ฮิบรูมหาอุปราชาฮัลโลวีน',
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
                                child:
                                    Wrap(direction: Axis.vertical, children: [
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
                                                  padding: EdgeInsets.fromLTRB(
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
                                                            color: Colors.blue,
                                                            size: 15),
                                                      ),
                                                      Text(
                                                        '1/5',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ]),
                                  MemberTab(
                                      picURL:
                                          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
                                      userId: 'ทดสอบ พลานุพัฒน์'),
                                  MemberTab(
                                      picURL:
                                          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
                                      userId: 'ทดสอบ พลานุพัฒน์'),
                                  MemberTab(
                                      picURL:
                                          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
                                      userId: 'ทดสอบ พลานุพัฒน์')
                                ]))))
                  ],
                ),
              ),
            ); //whatever you're returning, does not have to be a Container
          }),
    );
  }
}
