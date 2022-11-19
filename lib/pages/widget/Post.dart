import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class Post extends StatefulWidget {
  const Post(
      {super.key,
      required this.photo,
      required this.text,
      required this.user_name,
      required this.profile,
      required this.user_id});
  final String? photo;
  final String? text;
  final String user_name;
  final String profile;
  final String user_id;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profile),
                  radius: 25,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child:
                      Title(color: Colors.blue, child: Text(widget.user_name)),
                )
              ],
            ),
          ),
          widget.photo == null
              ? Center()
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.network(
                      widget.photo!,
                      width: 400,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          widget.text == null
              ? Center()
              : Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                  child: Text(
                    widget.text!,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // Container(
              //     alignment: Alignment.centerLeft,
              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              //     child: Icon(Icons.favorite_border_outlined)),
              LikeButton(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                size: 20,
              ),
              Text("10,000 Likes")
            ],
          ),
        ]),
      ),
    );
  }
}

// class Post {
//   String? text;
//   String? photo;

//   Post(this.text, this.photo);
// }

// Widget CreatePost(String photo, String text) {
//   return Container(
//     child: Column(children: [
//       photo == null
//           ? Center()
//           : Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(26),
//                 child: Image.network(
//                   photo,
//                   width: 400,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//       Row(
//         children: [
//           // Container(
//           //     alignment: Alignment.centerLeft,
//           //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//           //     child: Icon(Icons.favorite_border_outlined)),
//           LikeButton(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//             size: 20,
//           ),
//           Text("10,000 Likes")
//         ],
//       ),
//       Container(
//         alignment: Alignment.centerLeft,
//         padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 14),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       )
//     ]),
//   );
// }
