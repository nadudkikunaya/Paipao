import 'package:flutter/material.dart';

class FilterAlertDialog extends StatefulWidget {
  const FilterAlertDialog(
      {super.key,
      required this.defaultList,
      required this.updateFilter,
      required this.title});
  final List<String> defaultList;
  final Function updateFilter;
  final String title;

  @override
  State<FilterAlertDialog> createState() => _FilterAlertDialogState();
}

class _FilterAlertDialogState extends State<FilterAlertDialog> {
  final _filterController = TextEditingController();
  List<String> showItemFilter = [];
  @override
  void initState() {
    _filterController.addListener(_textFieldAction);
    setState(() {
      showItemFilter = widget.defaultList;
    });
    super.initState();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void _textFieldAction() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Text('กิจกรรมที่สนใจ'),
          scrollable: true,
          content: Container(
            child: Column(
              children: [
                TextField(
                  controller: _filterController,
                  onChanged: (value) {
                    if (value == null || value == '') {
                      showItemFilter = widget.defaultList;
                    } else {
                      showItemFilter = widget.defaultList
                          .where((element) => element.contains(value))
                          .toList();
                    }
                    setState(() {
                      showItemFilter = showItemFilter;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _filterController.clear();
                        setState(() {
                          showItemFilter = widget.defaultList;
                        });
                      },
                    ),
                    label: Text('ชื่อกิจกรรม'),
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                for (int i = 0; i < showItemFilter.length; i++)
                  TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.shade300),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black),
                      ),
                      onPressed: () {
                        widget.updateFilter(showItemFilter[i]);
                      },
                      child: Text(showItemFilter[i]))
              ],
            ),
          ),
        );
      },
    );
  }
}
