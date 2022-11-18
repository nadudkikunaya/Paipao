import 'package:flutter/material.dart';
import 'dart:ui';
import 'myCheckBox.dart';
import 'filterChip.dart';
import 'filterChipData.dart';

class ChangeAct extends StatefulWidget {
  const ChangeAct({super.key});

  @override
  State<ChangeAct> createState() => _ChangeActState();
}

class _ChangeActState extends State<ChangeAct> {
  List<FilterChipData> filterChips = FilterChips.all;
  int index = 3;
  final double spacing = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              "เลือกกิจกรรมที่คุณชื่นชอบ",
              style: TextStyle(fontSize: 26),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          buildFilterChips(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: (() {}),
      ),
    );
  }

  Widget buildFilterChips() => Wrap(
        runSpacing: spacing,
        spacing: spacing,
        children: filterChips
            .map((filterChip) => FilterChip(
                  label: Text(filterChip.label.toString()),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: filterChip.color,
                  ),
                  backgroundColor: filterChip.color?.withOpacity(0.1),
                  onSelected: (isSelected) => setState(() {
                    filterChips = filterChips.map((otherChip) {
                      return filterChip == otherChip
                          ? otherChip.copy(isSelected: isSelected)
                          : otherChip;
                    }).toList();
                  }),
                  selected: filterChip.isSelected,
                  checkmarkColor: filterChip.color,
                  selectedColor: filterChip.color?.withOpacity(0.25),
                ))
            .toList(),
      );
}
