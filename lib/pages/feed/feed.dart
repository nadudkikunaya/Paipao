import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Map<String, dynamic>> posts = [
    {
      'profile':
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      'name': 'มั่นคง แสงอำไพ',
      'img': null,
      'caption': '         ศึกษาศาสตร์ โรแมนติกโพลล์เป่ายิ้งฉุบเซ็นทรัลศึกษาศาสตร์แพกเกจการันตี'
          'อ่อนด้อยคาราโอเกะ ซีเรียสปาสกาลภคันทลาพาธ'
          'ฟยอร์ดคอนเซปต์โลโก้ไรเฟิลตุ๊ดล็อบบี้อุปการคุณพันธุวิศวกรรมผ้าห่มบิล สารขัณฑ์ฟลุตโลชั่น'
          'ทอร์นาโดคอนเซ็ปต์แอ็คชั่นคอร์รัปชั่น หมวยซูเอี๋ยโหงว แรงดูดไฟลท์ว้อย พาวเวอร์เซฟตี้อพาร์ตเมนต์ผู้นำ'
          'ซีอีโอเป่ายิงฉุบมะกันโคโยตีรามเทพ dสงบสุขงั้นหล่อฮังก้วยบลูเบอร์รีโบกี้ โจ๋โหลยโท่ย ตัวเองลาเต้ฮิบรูมหาอุปราชาฮัลโลวีน',
      'like': 0,
      'isTapped': false,
    },
    {
      'profile':
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?w=2000',
      'name': 'มั่นคง แสงอำไพ',
      'img': 'https://img.salehere.co.th/p/1200x0/2022/01/20/swprgz8zwcl4.jpg',
      // 'img':
      //     'https://firebasestorage.googleapis.com/v0/b/paipao-app.appspot.com/o/pexels-roberto-nickson-2559941.jpg?alt=media&token=60881839-6e8f-4913-a867-7ae1cf1a03f4',
      'caption': 'มานั่งเล่นสวนร้อยปี ตึงๆ',
      'like': 1,
      'isTapped': false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            // height: MediaQuery.of(context).size.height *
            //     (posts[index]['img'] == null ? 0.15 : 0.4),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(posts[index]['profile']),
                          radius: 25,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Title(
                              color: Colors.blue,
                              child: Text(posts[index]['name'])),
                        )
                      ],
                    ),
                  ),
                  posts[index]['img'] == null
                      ? Text('')
                      : Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: MediaQuery.of(context).size.height * 0.3,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Image.network(
                            posts[index]['img'],
                            width: MediaQuery.of(context).size.width - 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Flexible(
                      child: posts[index]['caption'] == null
                          ? Text('')
                          : Text(
                              posts[index]['caption'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            bool? isTapped = posts[index]['isTapped'];
                            if (isTapped!) {
                              posts[index]['like'] -= 1;
                            } else {
                              posts[index]['like'] += 1;
                            }
                            setState(() {
                              posts[index]['isTapped'] =
                                  !posts[index]['isTapped'];
                              posts[index]['like'] = posts[index]['like'];
                            });
                          },
                          icon: posts[index]['isTapped'] ?? false
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                          label: Text(''),
                          style: ButtonStyle(
                            overlayColor: MaterialStatePropertyAll<Color>(
                                Colors.transparent),
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.white),
                            foregroundColor: posts[index]['isTapped'] ?? false
                                ? MaterialStatePropertyAll<Color>(Colors.red)
                                : MaterialStatePropertyAll<Color>(Colors.black),
                          ),
                        ),
                        Text(posts[index]['like'].toString() +
                            (posts[index]['like'] <= 1 ? ' like' : ' likes'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}
