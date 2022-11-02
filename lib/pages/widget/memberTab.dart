import 'package:flutter/material.dart';

import '../profile/profile_old.dart';

class MemberTab extends StatefulWidget {
  const MemberTab({
    super.key,
    required this.picURL,
    required this.userId,
  });
  final String picURL;
  final String userId;

  @override
  State<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      child: TextButton(
        onPressed: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(userId: widget.userId)));
        }),
        style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll<Color>(Colors.grey.shade300),
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
        ),
        child: Wrap(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 + 10,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Wrap(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.picURL),
                    radius: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    margin: EdgeInsets.only(top: 20, left: 15),
                    child: Text(
                      widget.userId,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2 -
                  MediaQuery.of(context).size.width * 0.1 -
                  30,
              margin: EdgeInsets.only(top: 25),
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll<Color>(Colors.green),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.blueAccent),
                  foregroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white),
                ),
                child: Text(
                  'รับเข้ากลุ่ม',
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
