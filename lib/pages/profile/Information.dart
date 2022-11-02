import 'package:flutter/material.dart';

Widget Information(String gender, int age) {
  return Row(children: [
    Icon(IconData(0xe491, fontFamily: 'MaterialIcons')),
    Text(
      gender,
      style: TextStyle(fontSize: 16),
    ),
    buildVertiaclDivider(),
    Text(
      age.toString() + " ปี",
      style: TextStyle(fontSize: 16),
    ),
  ]);
}

Widget AddMoreInfo(String moreInfo) {
  return Row(
    children: [
      buildVertiaclDivider(),
      Text(moreInfo, style: TextStyle(fontSize: 16)),
    ],
  );
}

Widget AddBioInfo(String moreInfo) {
  return Wrap(children: [
    Row(
      children: [
        Text(
          moreInfo,
          style: TextStyle(fontSize: 12),
        ),
      ],
    ),
  ]);
}

Widget buildVertiaclDivider() {
  return Container(
    height: 18,
    child: VerticalDivider(
      color: Colors.black,
      thickness: 1,
    ),
  );
}
