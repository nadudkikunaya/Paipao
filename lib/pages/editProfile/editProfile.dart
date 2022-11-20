import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/editProfile/changeAct.dart';
import 'dart:ui';
import 'myCheckBox.dart';

import 'package:paipao/pages/editProfile/changeAct_old.dart';
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

  PickedFile? _profileFile;
  final ImagePicker _picker = ImagePicker();

  String user_id = FirebaseAuth.instance.currentUser!.uid;
  String name = '';
  String gender = "";
  String desc = "";
  bool? isDrinking;
  bool? isSmoking;
  bool? isVegetarian;
  int age = 0;
  String avatarURL = "";
  int detailMaxLines = 10;

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

        desc = user_data?["description"];
        avatarURL = user_data?["profile"];
        isVegetarian = user_data?["preference"]["isVegetarian"];
        isDrinking = user_data?["preference"]["isDrinking"];
        isSmoking = user_data?["preference"]["isSmoking"];
        Map<String, dynamic> preference = user_data?['preference'];
        preference.forEach((key, value) {
          condition.add({
            'name': key,
            'status': value,
          });
        });

        descriptionController.text = desc;
        nameController.text = name;
        // ignore: division_optimization
        print('in fucking setstate');
      });
    });
  }

  String preferenceToThai(String eng) {
    if (eng == 'isVegetarian') {
      return 'เป็นมังสวิรัติ';
    } else if (eng == 'isDrinking') {
      return 'ดื่มแอลกอฮอล์';
    } else if (eng == 'isSmoking') {
      return 'สูบบุหรี่';
    }
    return 'เกิดข้อผิดพลาด';
  }

  void updateCondition(String key, bool value) {
    setState(() {
      condition.forEach((element) {
        if (element['name'] == key) {
          element['status'] = value;
        }
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
              clipBehavior: Clip.antiAlias,
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
                    child: TextFormField(
                      maxLines: null,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          isCollapsed: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'รายละเอียด'),
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
                      MyCheckBox theBox = MyCheckBox(
                          preferenceToThai(condition[index]['name']),
                          condition[index]['status']);
                      return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            theBox.name.toString(),
                          ),
                          value: condition[index]['status'],
                          onChanged: (value) {
                            updateCondition(condition[index]['name'],
                                !condition[index]['status']);
                          });
                      // return CreateCheckBox(
                      //   MyCheckBox(condition[index]['name'],
                      //       condition[index]['status']),
                      // );
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
                        MaterialPageRoute(
                            builder: (context) => ChangeActivity()),
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            _updateProfile();
                          },
                          child: const Text("บันทึก")),
                    ),
                  )
                ]),
              ),
            ),
    );
  }

  void _updateProfile() async {
    //final String avatarURL = avatarURLController.text;

    Map<String, dynamic> _obj = {
      'name': nameController.text,
      'description': descriptionController.text,
      'preference': {},
    };

    for (Map<String, dynamic> element in condition) {
      _obj['preference'][element['name']] = element['status'];
    }

    print(_obj);
    uploadFile();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .update(_obj)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('อัปเดตโปรไฟล์เสร็จเรียบร้อย')),
      );
    });
  }

  void uploadFile() async {
    if (_profileFile == null) return;
    final fileProfile = File(_profileFile!.path);

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = user_id;
    //final fileName = '${DateTime.now().millisecondsSinceEpoch}_$user_id';

    final uploadTaskProfile =
        await storageRef.child('profile/$fileName.jpg').putFile(fileProfile);

    print('done');
    final profileURL = storageRef
        .child('profile/$fileName.jpg')
        .getDownloadURL()
        .then((link) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .update({'profile': link.toString()});
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
          print('test $value');
          setState(
            () => theBox.isSelected = value!,
          );
        });
  }
}
