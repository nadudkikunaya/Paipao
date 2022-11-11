import 'package:flutter/material.dart';
import 'package:paipao/pages/editProfile/editProfile.dart';
import 'package:paipao/pages/newPost/newPost.dart';
import 'dart:ui';
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
  String name = "มั่นไค แสงอำพงษ์";
  String gender = "ชาย";
  int age = 27;
  String avatarURL =
      "https://cdn.pixabay.com/photo/2020/07/20/06/42/english-bulldog-5422018_960_720.jpg";
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
      body: SingleChildScrollView(
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
              Wrap(
                spacing: 5,
                children: [
                  Status(
                      "นักแคมป์", "มือใหม่", Color.fromARGB(255, 38, 212, 255)),
                  Status(
                      "นักสู้", "มือฉมัง", Color.fromARGB(255, 157, 255, 45)),
                  Status("นักต้มตุ๋น", "มือฉมัง",
                      Color.fromARGB(255, 255, 57, 146)),
                  Status("นักรบไฟนอล", "มือฉมัง",
                      Color.fromARGB(255, 231, 255, 53)),
                  Status(
                      "นักกินจุ", "มือฉมัง", Color.fromARGB(255, 175, 84, 255)),
                ],
              ),

              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Information("ชาย", 27),
                            AddMoreInfo("เปงมังจ้า"),
                          ],
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text(
                                  "สวัสดีครับท่านผู้ชมขอต้อนรับสู่ island อยากมีแฟน theirs a chance ในดินแดนมหัศจรรย์ ดวงตะวันไม่เคยดับทำยังไงก็นอนไม่หลับ อยากมีแฟน there is a chance in love island In this little love island ในดินแดนที่เรียกว่า love island")),
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
