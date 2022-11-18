import 'package:flutter/material.dart';
import 'filterChipData.dart';

class FilterChips {
  static final all = <FilterChipData>[
    FilterChipData(
      label: 'ปั่นจักรยาน',
      isSelected: false,
      color: Colors.green,
    ),
    FilterChipData(
      label: 'ตกปลา',
      isSelected: false,
      color: Colors.red,
    ),
    FilterChipData(
      label: 'ตั้งแคมป์',
      isSelected: false,
      color: Colors.blue,
    ),
    FilterChipData(
      label: 'จิตอาสา',
      isSelected: false,
      color: Colors.orange,
    ),
    FilterChipData(
      label: 'กินซอยจุ๊',
      isSelected: false,
      color: Colors.purple,
    ),
    FilterChipData(
      label: 'เที่ยวตลาดนัด',
      isSelected: false,
      color: Colors.pink,
    ),
  ];
}
