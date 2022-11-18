import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile/profile.dart';

class ChatMemberTab extends StatefulWidget {
  const ChatMemberTab({
    super.key,
    required this.userData,
    required this.user_id,
  });
  final Map<String, dynamic> userData;
  final String user_id;

  @override
  State<ChatMemberTab> createState() => _ChatMemberTabState();
}

class _ChatMemberTabState extends State<ChatMemberTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //alignment: Alignment.centerLeft,
      child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: TextButton(
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Profile(user_id: widget.user_id)));
              }),
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                overlayColor:
                    MaterialStatePropertyAll<Color>(Colors.grey.shade300),
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
              ),
              child: Wrap(
                // alignment: WrapAlignment.start,
                children: [
                  Container(
                    //alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(top: 10, bottom: 10),

                    child: Wrap(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.userData['imageUrl']),
                          radius: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: EdgeInsets.only(top: 20, left: 15),
                          child: Text(
                            widget.userData['firstName'],
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ]),
    );
    // Container(
    //   alignment: Alignment.centerLeft,
    //   //width: MediaQuery.of(context).size.width - 10,
    //   child: TextButton(
    //     onPressed: (() {
    //       Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => Profile(user_id: widget.user_id)));
    //     }),
    //     style: ButtonStyle(
    //       overlayColor: MaterialStatePropertyAll<Color>(Colors.grey.shade300),
    //       backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
    //       foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
    //     ),
    //     child: Wrap(
    //       children: [
    //         Container(
    //           width: MediaQuery.of(context).size.width / 2 + 10,
    //           margin: EdgeInsets.only(top: 10, bottom: 10),
    //           child: Wrap(
    //             children: [
    //               CircleAvatar(
    //                 backgroundImage: NetworkImage(widget.userData['imageUrl']),
    //                 radius: 30,
    //               ),
    //               Container(
    //                 width: MediaQuery.of(context).size.width * 0.2,
    //                 margin: EdgeInsets.only(top: 20, left: 15),
    //                 child: Text(
    //                   widget.userData['firstName'],
    //                   maxLines: 2,
    //                   softWrap: true,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
