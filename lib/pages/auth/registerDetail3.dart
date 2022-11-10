import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerWaitApprove.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

// https://stackoverflow.com/questions/51415236/show-circular-progress-dialog-in-login-screen-in-flutter-how-to-implement-progr
showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text('เรากำลังทำการสมัครสมาชิกให้คุณ')),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return WillPopScope(onWillPop: () async => false, child: alert);
    },
  );
}

class RegisterDetail3 extends StatefulWidget {
  final Map<String, dynamic> regData;
  const RegisterDetail3({super.key, required this.regData});

  @override
  State<RegisterDetail3> createState() => _RegisterDetail3State();
}

class _RegisterDetail3State extends State<RegisterDetail3> {
  PickedFile? _profileFile;
  PickedFile? _pidFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.height - 40,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'อัพโหลดรูปภาพของคุณ',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  TextButton(
                    onPressed: (() {
                      setState(() {
                        _profileFile = null;
                      });
                    }),
                    child: Text(
                      'ภาพโปรไฟล์',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height * 0.4,
                    //color: Colors.red,
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        Container(
                            //color: Colors.orange,
                            alignment: Alignment.center,
                            // ignore: unnecessary_null_comparison
                            child: _profileFile == null
                                ? Stack(
                                    children: [
                                      ClipOval(
                                        child: Material(
                                          color: Colors.grey.shade400,
                                          child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Icon(
                                              Icons.image,
                                              size: 160,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        right: 30,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return bottomSheet(1);
                                                });
                                          },
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            FileImage(File(_profileFile!.path)),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        right: 30,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {
                                                  return bottomSheet(1);
                                                });
                                          },
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: (() {
                      setState(() {
                        _pidFile = null;
                      });
                    }),
                    child: Text(
                      'สำเนาบัตรประชาชน',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return bottomSheet(2);
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height * 0.4,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          _pidFile == null
                              ? ClipOval(
                                  child: Material(
                                    color: Colors.grey.shade400,
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Icon(
                                        Icons.image,
                                        size: 160,
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                )
                              : Image.file(
                                  File(_pidFile!.path),
                                  fit: BoxFit.cover,
                                )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () async {
                            showLoaderDialog(context);
                            try {
                              // Create the user in Firebase
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: widget.regData['regEmail'],
                                password: widget.regData['regPassword'],
                              )
                              // Use callback functions instead of just leaving the code outside to tie what will be done if success together with the await (https://www.youtube.com/watch?v=zNjxDUmkseA 2:27:07)
                              .then((credential) {
                                // TODO: Upload the additional user data to Cloud Firesotre
                                final db = FirebaseFirestore.instance;
                                db.collection('users')
                                  .doc(credential.user!.uid)
                                  .set({
                                    "name": widget.regData['regName'],
                                    "likes": "to test",
                                  })
                                  .onError((e, _) => print('Error writing document: $e'));

                                // The server-side process is completed
                                if (!mounted) return; // Need to add this after every await calls that will be followed with any BuildContext (https://stackoverflow.com/questions/68871880/do-not-use-buildcontexts-across-async-gaps)
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterWaitApprove()));
                              });

                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ความซับซ้อนของรหัสผ่านน้อยเกิน')),
                                );
                              } else if (e.code == 'email-already-in-use') {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('อีเมลล์ที่ให้มานั้นได้ถูกใช้ไปแล้ว')),
                                );
                              } else {  // Any other FirebaseAuthExceptions
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          child: Text('อ่ะ ต่อไป')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(int fileNo) {
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
                takePhoto(ImageSource.camera, fileNo);
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, fileNo);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source, int fileNo) async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (pickedFile != null && fileNo == 1) {
      setState(() {
        _profileFile = pickedFile!;
      });
    }
    if (pickedFile != null && fileNo == 2) {
      setState(() {
        _pidFile = pickedFile!;
      });
    }
  }
}
