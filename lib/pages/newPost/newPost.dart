import 'package:flutter/material.dart';
import 'dart:ui';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController activityController = TextEditingController();

  String name = "มั่นไค แสงอำพงษ์";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "New Post",
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
            SizedBox(
              height: 48,
            ),
            CircleAvatar(
              radius: 56,
              backgroundImage: NetworkImage(
                  "https://cdn.pixabay.com/photo/2020/07/20/06/42/english-bulldog-5422018_960_720.jpg"),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'พิมพ์อะไรสักอย่าง ...'),
                textInputAction: TextInputAction.done,
                controller: activityController,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
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
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.post_add),
        onPressed: (() {}),
      ),
    );
  }
}
