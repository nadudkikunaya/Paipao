import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/widget/Post.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> posts = [
    // {
    //   'profile':
    //       'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
    //   'name': 'มั่นคง แสงอำไพ',
    //   'img': null,
    //   'caption': '         ศึกษาศาสตร์ โรแมนติกโพลล์เป่ายิ้งฉุบเซ็นทรัลศึกษาศาสตร์แพกเกจการันตี'
    //       'อ่อนด้อยคาราโอเกะ ซีเรียสปาสกาลภคันทลาพาธ'
    //       'ฟยอร์ดคอนเซปต์โลโก้ไรเฟิลตุ๊ดล็อบบี้อุปการคุณพันธุวิศวกรรมผ้าห่มบิล สารขัณฑ์ฟลุตโลชั่น'
    //       'ทอร์นาโดคอนเซ็ปต์แอ็คชั่นคอร์รัปชั่น หมวยซูเอี๋ยโหงว แรงดูดไฟลท์ว้อย พาวเวอร์เซฟตี้อพาร์ตเมนต์ผู้นำ'
    //       'ซีอีโอเป่ายิงฉุบมะกันโคโยตีรามเทพ dสงบสุขงั้นหล่อฮังก้วยบลูเบอร์รีโบกี้ โจ๋โหลยโท่ย ตัวเองลาเต้ฮิบรูมหาอุปราชาฮัลโลวีน',
    //   'like': 0,
    //   'isTapped': false,
    // },
    // {
    //   'profile':
    //       'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
    //   'name': 'มั่นคง แสงอำไพ',
    //   'img': 'https://img.salehere.co.th/p/1200x0/2022/01/20/swprgz8zwcl4.jpg',
    //   // 'img':
    //   //     'https://firebasestorage.googleapis.com/v0/b/paipao-app.appspot.com/o/pexels-roberto-nickson-2559941.jpg?alt=media&token=60881839-6e8f-4913-a867-7ae1cf1a03f4',
    //   'caption': 'มานั่งเล่นสวนร้อยปี ตึงๆ',
    //   'like': 1,
    //   'isTapped': false,
    // },
  ];
  void getFeed() async {
    FirebaseFirestore.instance
        .collection('feeds')
        .doc(user_id)
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .get()
        .then((collection) async {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in collection.docs) {
        Map<String, dynamic> feedData = doc.data();
        await feedData['post_ref']
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> postDoc) async {
          Map<String, dynamic>? postData = postDoc.data();
          await postData?['creator_ref']
              .get()
              .then((DocumentSnapshot<Map<String, dynamic>> userDoc) {
            Map<String, dynamic>? userData = userDoc.data();
            postData['user_name'] = userDoc['name'];
            postData['user_id'] = userDoc.id;
            postData['profile'] = userDoc['profile'];
            setState(() {
              posts.add(postData);
              print('--------------------------');
              print(posts);
            });
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getFeed();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: posts.isEmpty
          ? Center(child: Text('ไม่มีฟีดล่าสุด'))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    // height: MediaQuery.of(context).size.height *
                    //     (posts[index]['img'] == null ? 0.15 : 0.4),
                    child: Post(
                        photo: posts[index]['imageUrl'],
                        text: posts[index]['caption'],
                        user_name: posts[index]['user_name'],
                        profile: posts[index]['profile'],
                        user_id: posts[index]['user_id']));
              },
            ),
    );
  }
}
