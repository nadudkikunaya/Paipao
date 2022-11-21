import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key, required this.follower, required this.following});
  final List<String> follower;
  final List<String> following;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController titleController = TextEditingController();

  PickedFile? _imageFile;
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "สร้างโพสต์ใหม่",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
            child: Column(
          children: [
            // SizedBox(
            //   height: 48,
            // ),
            // CircleAvatar(
            //   radius: 56,
            //   backgroundImage: NetworkImage(
            //       "https://cdn.pixabay.com/photo/2020/07/20/06/42/english-bulldog-5422018_960_720.jpg"),
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.all(12),
            //   child: Text(
            //     name,
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(12),
              child: Text(
                "แชร์กิจกรรมที่น่าตื่นเต้นของคุณสิ!",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                maxLines: 10,
                //expands: true,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    isCollapsed: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'พิมพ์อะไรสักอย่าง ...'),
                textInputAction: TextInputAction.done,
                controller: titleController,
              ),
            ),
            SizedBox(height: 12),
            _imageFile == null
                ? ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return bottomSheet();
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 95,
                      child: Row(
                        children: [
                          Text('เพิ่มรูปภาพ  '),
                          Icon(IconData(0xf131, fontFamily: 'MaterialIcons'))
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return bottomSheet();
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          // ClipOval(
                          //         child: Material(
                          //           color: Colors.grey.shade400,
                          //           child: Padding(
                          //             padding: EdgeInsets.all(20),
                          //             child: Icon(
                          //               Icons.image,
                          //               size: 160,
                          //               color: Colors.black.withOpacity(0.3),
                          //             ),
                          //           ),
                          //         ),
                          //       )

                          Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.fill,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.3,
                            isAntiAlias: true,
                          )
                        ],
                      ),
                    ),
                  ),

            // _imageFile == null
            //     ? Stack(
            //         children: [
            //           Center(
            //             child: Container(
            //               height: MediaQuery.of(context).size.height * 0.3,
            //               width: MediaQuery.of(context).size.width * 0.8,
            //               color: Colors.grey.shade300,
            //             ),
            //           ),
            //           Center(
            //               child: Icon(Icons.image,
            //                   color: Colors.grey.shade600, size: 40))
            //         ],
            //       )
            //     : Container(
            //         height: MediaQuery.of(context).size.height * 0.3,
            //         width: MediaQuery.of(context).size.width * 0.8,
            //         child: Image.file(File(_imageFile!.path)))
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        onPressed: (() {
          post();
        }),
      ),
    );
  }

  void post() async {
    await uploadFile();
    Timestamp createdAt = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    //create post
    await FirebaseFirestore.instance.collection('posts').add({
      'creator_ref':
          FirebaseFirestore.instance.collection('users').doc(user_id),
      'createdAt': createdAt,
      'caption': titleController.text,
      'imageUrl': imageUrl,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection('posts')
          .doc(value.id)
          .set({
        'post_ref':
            FirebaseFirestore.instance.collection('posts').doc(value.id),
        'createdAt': createdAt,
      });

      List<String> temp_list = widget.follower + [user_id];
      for (String userid in temp_list) {
        await FirebaseFirestore.instance
            .collection('feeds')
            .doc(userid)
            .collection('posts')
            .doc(value.id)
            .set({
          'post_ref':
              FirebaseFirestore.instance.collection('posts').doc(value.id),
          'createdAt': createdAt,
        });
      }
    });
    Navigator.pop(context);
  }

  Future uploadFile() async {
    if (_imageFile == null) return;
    final fileProfile = File(_imageFile!.path);

    final storageRef = FirebaseStorage.instance.ref();
    //final fileName = user_id;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$user_id';

    final uploadTaskProfile =
        await storageRef.child('post/$fileName.jpg').putFile(fileProfile);

    // print('done');
    imageUrl = await storageRef.child('post/$fileName.jpg').getDownloadURL();

    return true;
    //     .then((link) async {
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(user_id)
    //       .collection('post')
    //       .add({'profile': link.toString()});
    // });
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
        _imageFile = pickedFile;
      });
    }
  }
}
