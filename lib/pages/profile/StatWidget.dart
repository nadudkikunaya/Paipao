import 'package:flutter/material.dart';

Widget StatWidget(String title, String stat) {
  return Expanded(
    child: Column(children: [
      Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Text(
        stat,
        style: TextStyle(fontSize: 16),
      )
    ]),
  );
}
