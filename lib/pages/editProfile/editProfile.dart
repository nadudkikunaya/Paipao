import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'myCheckBox.dart';

import 'package:paipao/pages/editProfile/changeAct.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController avatarURLController = TextEditingController();
  TextEditingController isSmokingController = TextEditingController();
  TextEditingController isDrinkingController = TextEditingController();
  TextEditingController isVegetarianController = TextEditingController();
  PickedFile? _profileFile;
  final ImagePicker _picker = ImagePicker();

  String user_id = "pvtKqLVvqlb4LblhHdu3FvghAxz1";
  String name = '';
  String gender = "";
  String desc = "";
  bool? isDrinking;
  bool? isSmoking;
  bool? isVegetarian;
  int age = 0;
  String avatarURL = "";
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  List<MyCheckBox> myBox = [
    MyCheckBox("สูบบุหรี่", false),
    MyCheckBox("ดื่มแอลกอฮอล์", false),
    MyCheckBox("เป็นมังสวิรัติ", false)
  ];

  List<Map<String, dynamic>> condition = [];

  void getData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user_id)
        .get()
        .then((doc) {
      Map<String, dynamic>? user_data = doc.data();
      print(user_data);
      setState(() {
        name = user_data?["name"];
        nameController.text = name;
        desc = user_data?["description"];
        avatarURL = user_data?["profile"];
        isVegetarian = user_data?["preference"]["isVegetarian"];
        isDrinking = user_data?["preference"]["isDrinking"];
        isSmoking = user_data?["preference"]["isSmoking"];
        condition = [
          {'name': 'สูบบุหรี่', 'status': isSmoking},
          {'name': 'ดื่มแอลกอฮอล์', 'status': isDrinking},
          {'name': 'เป็นมังสวิรัติ', 'status': isVegetarian},
        ];
        // ignore: division_optimization
      });
    });
  }

  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

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
      body: name == ''
          ? Center(
              child: Text('loading'),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(children: [
                  SizedBox(
                    height: 48,
                  ),
                  _profileFile == null
                      ? CircleAvatar(
                          radius: 56,
                          backgroundImage: NetworkImage(avatarURL),
                        )
                      : CircleAvatar(
                          radius: 56,
                          backgroundImage: FileImage(File(_profileFile!.path)),
                        ),
                  SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return bottomSheet();
                          });
                    },
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: condition.length,
                    itemBuilder: (context, index) {
                      return CreateCheckBox(
                        MyCheckBox(condition[index]['name'],
                            condition[index]['status']),
                      );
                    },
                  ),
                  // CreateCheckBox(myBox[0]),
                  // CreateCheckBox(myBox[1]),
                  // CreateCheckBox(myBox[2]),
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
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("บันทึก")),
                    ),
                  )
                ]),
              ),
            ),
    );
  }

  Future<void> _update([DocumentSnapshot? user_data]) async {
    if (user_data != null) {
      avatarURLController.text = user_data['profile'];
      nameController.text = user_data['name'];
      descriptionController.text = user_data['description'];
      isSmokingController.text = user_data['preference']['isSmoking'];
      isDrinkingController.text = user_data['preference']['isDrinking'];
      isVegetarianController.text = user_data['preference']['isVegetarian'];
    }

    final String avatarURL = avatarURLController.text;
    final String name = nameController.text;
    final String desc = descriptionController.text;
    final bool isSmoking = isSmokingController.text as bool;
    final bool isDrinking = isDrinkingController.text as bool;
    final bool isVegetarian = isVegetarianController.text as bool;

    await _users.doc(user_data!.id).update({
      'profile': avatarURL,
      'name': name,
      'description': desc,
      'isSmoking': isSmoking,
      'isDrinking': isDrinking,
      'isVegetarian': isVegetarian
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        _profileFile = pickedFile!;
      });
    }
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
