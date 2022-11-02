import 'package:flutter/material.dart';

Widget Status(String status, String rank, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12),
    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
    //padding: const EdgeInsets.all(20.0),
    width: 120,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            status,
            style: TextStyle(fontSize: 14),
          ),
          Text(rank, style: TextStyle(fontSize: 14))
        ],
      ),
    ),
  );
}
