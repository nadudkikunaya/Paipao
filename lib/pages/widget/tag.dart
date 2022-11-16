import 'package:flutter/material.dart';

class Tag extends StatefulWidget {
  const Tag({super.key, required this.label, this.updateParent});
  final String label;
  final Function? updateParent;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isTapped = !isTapped;
        widget.updateParent!(widget.label);
        setState(() {
          isTapped = isTapped;
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isTapped ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Text(widget.label),
      ),
    );
  }
}