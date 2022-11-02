import 'package:flutter/material.dart';

class Post {
  String text = "";
  String photo = "";

  Post(this.text, this.photo);
}

Widget CreatePost(String photo, String text) {
  return Container(
    child: Column(children: [
     
      Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Image.network(
            photo,
            width: 400,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
      ),
      
      Row(
        children: [
          
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 2),
            
            child: Icon(Icons.favorite_border_outlined)),
            Text("10,000 Likes")
        ],
      ),
        
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 2),
        child: Text(
          text ,
          style: TextStyle(fontSize: 14),
        ),
      ),
      SizedBox(
        height: 10,
      )
    ]),
  );
}
