import 'package:flutter/material.dart';
import 'dart:ui';
import 'myCheckBox.dart';

import 'package:paipao/pages/editProfile/changeAct.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<MyCheckBox> myBox = [
    MyCheckBox("สูบบุหรี่", false),
    MyCheckBox("ดื่มแอลกอฮอล์", false),
    MyCheckBox("เป็นมังสวิรัติ", false)
  ];

  String oldName = "มั่นไค แสงอำพงษ์";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 48,
            ),
            CircleAvatar(
              radius: 56,
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2020/07/20/06/42/english-bulldog-5422018_960_720.jpg"),
            ),
            SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'เปลี่ยนภาพโปรไฟล์',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("ชื่อ - นามสกุล",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: oldName),
                textInputAction: TextInputAction.done,
                controller: nameController,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text("คำอธิบาย",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: ''),
                textInputAction: TextInputAction.done,
                controller: descriptionController,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            CreateCheckBox(myBox[0]),
            CreateCheckBox(myBox[1]),
            CreateCheckBox(myBox[2]),
            SizedBox(
              height: 12,
            ),
            TextButton.icon(
              icon: Icon(IconData(0xe3f2, fontFamily: 'MaterialIcons')),
              label: Text(
                'แก้ไขกิจกรรมที่ชื่นชอบ  ',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeAct()),
                );
              },
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () {}, child: Text("บันทึก")),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget CreateCheckBox(MyCheckBox theBox) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          theBox.name.toString(),
        ),
        value: theBox.isSelected,
        onChanged: (value) {
          setState(
            () => theBox.isSelected = value!,
          );
        });
  }
}
