import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/chat/chatRoom.dart';
import 'package:paipao/pages/editProfile/editProfile.dart';
import 'package:paipao/pages/editProfile/profileSetting.dart';
import 'package:paipao/pages/newPost/newPost.dart';
import 'package:paipao/pages/profile/reportDialog.dart';
import 'package:paipao/pages/profile/Status.dart';
import 'Information.dart';
import '../widget/Post.dart';
import 'StatWidget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user_id});
  final String user_id;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user_id = FirebaseAuth.instance.currentUser!.uid;
  bool isMyProfile = false;
  String name = '';
  String gender = '';
  String desc = '';
  bool? isDrinking;
  bool? isSmoking;
  bool? isVegetarian;
  int age = 0;
  String avatarURL = '';
  Map<String, int>? exp = {};
  // List<String> followingCheck = [];
  List<String> follower = [];
  List<String> following = [];
  List<String> imgPost = [
    'https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg',
    'https://cdn.pixabay.com/photo/2018/10/19/12/14/train-3758523_960_720.jpg',
    'https://cdn.pixabay.com/photo/2016/11/29/09/16/architecture-1868667_960_720.jpg'
  ];

  List<Map<String, dynamic>> postInfo = [
    // {
    //   "imageUrl":
    //       "https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg",
    //   "caption": "ฮูลาฮูลา ลัลลั้ลลาในทะเล"
    // },
    // {
    //   "imageUrl":
    //       "https://cdn.pixabay.com/photo/2018/10/19/12/14/train-3758523_960_720.jpg",
    //   "caption": "รถไฟจะไปโคราช"
    // },
    // {
    //   "imageUrl":
    //       "https://cdn.pixabay.com/photo/2016/11/29/09/16/architecture-1868667_960_720.jpg",
    //   "caption": "เย้ๆๆๆ ถึงโคราชแล้ว"
    // }
  ];

  String getRank(int value) {
    if (value <= 5) {
      return 'มือใหม่';
    } else if (value <= 20) {
      return 'สมัครเล่น';
    } else if (value <= 50) {
      return 'มือฉมัง';
    } else if (value <= 99) {
      return 'โคตรเซียน';
    } else if (value >= 100) {
      return 'ตำนาน';
    }

    return 'ไม่ระบุ';
  }

  getRandomColor(int value) {
    if (value <= 5) {
      return Colors.lightBlueAccent;
    } else if (value <= 20) {
      return Colors.lightGreenAccent;
    } else if (value <= 50) {
      return Colors.limeAccent;
    } else if (value <= 99) {
      return Color.fromARGB(255, 255, 102, 153);
    } else if (value >= 100) {
      return Colors.redAccent;
    }

    return Colors.grey.shade300;
  }

  String genderENtoTH(gender) {
    if (gender == 'male')
      return 'ชาย';
    else if (gender == 'female')
      return 'หญิง';
    else
      return gender;
  }

  // void getFollowingCheck() async {
  //   String realId = FirebaseAuth.instance.currentUser!.uid;
  //   QuerySnapshot<Map<String, dynamic>> collection = await FirebaseFirestore
  //       .instance
  //       .collection('users')
  //       .doc(realId)
  //       .collection('following')
  //       .get();

  //   for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
  //     String docid = doc.id;
  //     followingCheck.add(docid);
  //   }
  //   print(followingCheck);
  // }

  void getFollowing() async {
    QuerySnapshot<Map<String, dynamic>> collection = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user_id)
        .collection('following')
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
      String docid = doc.id;
      following.add(docid);
    }
    print('following');
    print(following);
  }

  void getFollower() async {
    QuerySnapshot<Map<String, dynamic>> collection = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user_id)
        .collection('follower')
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
      String docid = doc.id;
      follower.add(docid);
    }

    print('follower');
    print(follower);
  }

  void unfollowUpdate() async {
    String realId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      //followingCheck.remove(realId);
      follower.remove(realId);
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('follower')
        .doc(realId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(realId)
        .collection('following')
        .doc(user_id)
        .delete();

    print('here2');
  }

  void followUpdate() async {
    String realId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      //followingCheck.add(realId);
      follower.add(realId);
    });

    //update follower at this profile user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('follower')
        .doc(realId)
        .set({
      'user_ref': FirebaseFirestore.instance.collection('users').doc(realId)
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(realId)
        .collection('following')
        .doc(user_id)
        .set({
      'user_ref': FirebaseFirestore.instance.collection('users').doc(user_id)
    });

    print('here1');
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .get()
        .then((doc) {
      Map<String, dynamic>? user_data = doc.data();
      setState(() {
        name = user_data?['name'];
        gender = genderENtoTH(user_data?['gender']);
        desc = user_data?['description'];
        avatarURL = user_data?['profile'];
        isVegetarian = user_data?['preference']['isVegetarian'];
        isDrinking = user_data?['preference']['isDrinking'];
        isSmoking = user_data?['preference']['isSmoking'];
        Map<String, dynamic> temp = user_data?['exp'];
        temp.forEach((key, value) {
          print('$key $value');
          exp?[key] = (value as int);
        });

        print(exp);

        // ignore: division_optimization
        age = (DateTime.now()
                    .difference((user_data?['birthdate'] as Timestamp).toDate())
                    .inDays
                    .toInt() /
                365)
            .toInt();
      });
    });
  }

  void getPost() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get()
        .then((collection) async {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
        DocumentReference postRef =
            (doc.data()['post_ref'] as DocumentReference);
        postRef.get().then((postDoc) {
          setState(() {
            postInfo.add((postDoc.data() as Map<String, dynamic>));
            print(postInfo);
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    user_id = widget.user_id ?? user_id;
    if (user_id == FirebaseAuth.instance.currentUser!.uid) {
      isMyProfile = true;
    }
    getFollowing();
    getFollower();
    // if (!isMyProfile) {
    //   getFollowingCheck();
    // }
    getData();
    getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isMyProfile
            ? Text('โปรไฟล์')
            : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: EdgeInsets.symmetric(),
                  child: IconButton(
                    icon: Icon(Icons.post_add),
                    iconSize: 32,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPost(
                                  follower: follower,
                                  following: following,
                                )),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    iconSize: 32,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileSetting()),
                      );
                    },
                  ),
                ),
              ]),
      ),
      body: name == ''
          ? Center(child: Text('loading'))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          name, // มั่นไค แสงอำพงษ์ มั่นไค แสงอำพงษ์ มั่นไค แสงอำพงษ์
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 56,
                                  backgroundImage: NetworkImage(avatarURL),
                                ),
                                StatWidget(
                                    'ผู้ติดตาม', follower.length.toString()),
                                StatWidget(
                                    'กำลังติดตาม', following.length.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    exp!.keys.isEmpty
                        ? Center()
                        : Wrap(
                            spacing: exp!.length.toDouble(),
                            children: exp!.keys
                                .map((key) => Status(
                                    key,
                                    getRank((exp![key] as int)),
                                    getRandomColor((exp![key] as int))))
                                .toList()
                            // [
                            //   Status("นักแคมป์", "มือใหม่",
                            //       Color.fromARGB(255, 38, 212, 255)),
                            //   Status("นักสู้", "มือฉมัง",
                            //       Color.fromARGB(255, 157, 255, 45)),
                            //   Status("นักต้มตุ๋น", "มือฉมัง",
                            //       Color.fromARGB(255, 255, 57, 146)),
                            //   Status("นักรบไฟนอล", "มือฉมัง",
                            //       Color.fromARGB(255, 231, 255, 53)),
                            //   Status("นักกินจุ", "มือฉมัง",
                            //       Color.fromARGB(255, 175, 84, 255)),
                            // ],
                            ),

                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Divider(
                          height: 6,
                          thickness: 0.8,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    Container(
                      // child: Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Information(gender, age),
                                  isVegetarian == null
                                      ? Center()
                                      : isVegetarian!
                                          ? AddMoreInfo('มังสวิรัติ')
                                          : Center(),
                                  Expanded(
                                      child: Container(
                                    child: Row(
                                      children: [
                                        isDrinking == null
                                            ? Center()
                                            : isDrinking!
                                                ? Center()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Icon(
                                                      Icons.no_drinks,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                        isSmoking == null
                                            ? Center()
                                            : isSmoking!
                                                ? Center()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Icon(
                                                        Icons.smoke_free,
                                                        color: Colors.red)),
                                      ],
                                    ),
                                  ))
                                ],
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                width: MediaQuery.of(context).size.width,
                                child: Center(child: Text(desc)),
                              )
                            ],
                          ),
                          isMyProfile
                              ? Center()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    follower.any((element) =>
                                            element ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.grey),
                                                  onPressed: () {
                                                    unfollowUpdate();
                                                  },
                                                  child: Text('เลิกติดตาม'),
                                                ))
                                              ],
                                            ),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue),
                                                  onPressed: () {
                                                    followUpdate();
                                                  },
                                                  child: Text('ติดตาม'),
                                                ))
                                              ],
                                            ),
                                          ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            onPressed: () async {
                                              // String realId = FirebaseAuth
                                              //     .instance.currentUser!.uid;
                                              // await FirebaseFirestore.instance
                                              //     .collection('chats')
                                              //     .where('participants',
                                              //         arrayContainsAny: [
                                              //           user_id,
                                              //           realId
                                              //         ])
                                              //     .where('isGroup',
                                              //         isEqualTo: false)
                                              //     .get()
                                              //     .then((doc) async {
                                              //       if (doc.docs.isEmpty) {
                                              //         //add room
                                              //         await FirebaseFirestore
                                              //             .instance
                                              //             .collection('chats')
                                              //             .add({
                                              //           'isGroup': false,
                                              //           'isMathcMaking': false,
                                              //         });
                                              //       } else {
                                              //         Navigator.push(
                                              //           context,
                                              //           MaterialPageRoute(
                                              //               builder:
                                              //                   (context) =>
                                              //                       ChatRoom(
                                              //                         isMatchmaking:
                                              //                             false,
                                              //                         chat_id: doc
                                              //                             .docs[
                                              //                                 0]
                                              //                             .id,
                                              //                       )),
                                              //         );
                                              //       }
                                              //     });
                                            },
                                            child: Text('แขท'),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                              child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.indigo),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return ReportDialoig(
                                                        report_user_id:
                                                            user_id);
                                                  });
                                            },
                                            child: Text('รายงาน'),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          postInfo.isEmpty
                              ? Center()
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 12),
                                  alignment: Alignment.topLeft,
                                  child: Text('Post',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                          postInfo.isEmpty
                              ? Center()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: postInfo.length,
                                  itemBuilder: (context, index) {
                                    return Post(
                                        user_name: name,
                                        profile: avatarURL,
                                        user_id: user_id,
                                        photo: postInfo[index]['imageUrl'],
                                        text: postInfo[index]['caption']);
                                  },
                                ),
                        ],
                      ),
                    ),
                    // ),

                    // CreatePost(
                    //     "https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg",
                    //     "ฮูลาฮูลา ลัลลั้ลลาในทะเล"),
                    // CreatePost(
                    //     "https://cdn.pixabay.com/photo/2018/10/19/12/14/train-3758523_960_720.jpg",
                    //     "รถไฟจะไปโคราช"),
                    // CreatePost(
                    //     "https://cdn.pixabay.com/photo/2016/11/29/09/16/architecture-1868667_960_720.jpg",
                    //     "เย้ๆๆๆ ถึงโคราชแล้ว")
                  ],
                ),
              ),
            ),
    );
  }
}
