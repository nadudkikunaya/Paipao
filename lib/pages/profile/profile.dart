import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/editProfile/editProfile.dart';
import 'package:paipao/pages/newPost/newPost.dart';
import 'Information.dart';
import 'Post.dart';
import 'StatWidget.dart';
import 'Status.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  String name = '';
  String gender = "";
  String desc = "";
  bool? isDrinking;
  bool? isSmoking;
  bool? isVegetarian;
  int age = 0;
  String avatarURL = "";
  Map<String, int>? exp = {};
  List<String> imgPost = [
    "https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg",
    "https://cdn.pixabay.com/photo/2018/10/19/12/14/train-3758523_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/29/09/16/architecture-1868667_960_720.jpg"
  ];

  List<Map<String, dynamic>> postInfo = [
    {
      "img":
          "https://cdn.pixabay.com/photo/2017/01/20/00/30/maldives-1993704_960_720.jpg",
      "caption": "ฮูลาฮูลา ลัลลั้ลลาในทะเล"
    },
    {
      "img":
          "https://cdn.pixabay.com/photo/2018/10/19/12/14/train-3758523_960_720.jpg",
      "caption": "รถไฟจะไปโคราช"
    },
    {
      "img":
          "https://cdn.pixabay.com/photo/2016/11/29/09/16/architecture-1868667_960_720.jpg",
      "caption": "เย้ๆๆๆ ถึงโคราชแล้ว"
    }
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
    if (gender == "male")
      return "ชาย";
    else if (gender == "female")
      return "หญิง";
    else
      return gender;
  }

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
        gender = genderENtoTH(user_data?["gender"]);
        desc = user_data?["description"];
        avatarURL = user_data?["profile"];
        isVegetarian = user_data?["preference"]["isVegetarian"];
        isDrinking = user_data?["preference"]["isDrinking"];
        isSmoking = user_data?["preference"]["isSmoking"];
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

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            padding: EdgeInsets.symmetric(),
            child: IconButton(
              icon: Icon(Icons.post_add),
              iconSize: 32,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPost()),
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
                  MaterialPageRoute(builder: (context) => EditProfile()),
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
                                StatWidget("Followers", "100M"),
                                StatWidget("Following", "0")
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            alignment: Alignment.topLeft,
                            child: Text("Post",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    // ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: postInfo.length,
                      itemBuilder: (context, index) {
                        return CreatePost(
                            postInfo[index]["img"], postInfo[index]["caption"]);
                      },
                    ),
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
