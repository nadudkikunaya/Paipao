import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:paipao/pages/chat/chatMember.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:open_filex/open_filex.dart';

enum Status { delivered, error, seen, sending, sent }

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {super.key, required this.chat_id, required this.isMatchmaking});
  final String chat_id;
  final bool isMatchmaking;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<types.Message> _messages = [];
  Map<String, Map<String, dynamic>> chatParticipants = {};
  String? chat_id;
  final String user_id = FirebaseAuth.instance.currentUser!.uid;
  //final String user_id = 'KbtEqJMBd1vOEu3cppZ6';
  // ignore: unnecessary_string_interpolations
  //final _user = types.User(id: 'f0J6UlbRBagsL42chvzWGxob6ss2');
  types.User _user = types.User(id: '');
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: user_id);
    chat_id = widget.chat_id;
    _loadChatUser();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ห้องแชท'),
            Row(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.sentiment_satisfied_outlined),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatMember(
                                  participants: chatParticipants,
                                )),
                      );
                    },
                    icon: Icon(Icons.groups),
                  ),
                ),
              ],
            )
          ],
        )),
        body: loading
            ? Center(
                child: Text('loading'),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chat_id)
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('กำลังโหลดข้อมูล'),
                    );
                  } else if (snapshot.hasData) {
                    return Chat(
                      messages: formatMessage(snapshot.data) ?? [],
                      onAttachmentPressed: _handleAttachmentPressed,
                      onMessageTap: _handleMessageTap,
                      onPreviewDataFetched: _handlePreviewDataFetched,
                      onSendPressed: _handleSendPressed,
                      showUserAvatars: true,
                      showUserNames: true,
                      user: _user,
                    );
                  } else {
                    return Chat(
                      messages: [],
                      onAttachmentPressed: _handleAttachmentPressed,
                      onMessageTap: _handleMessageTap,
                      onPreviewDataFetched: _handlePreviewDataFetched,
                      onSendPressed: _handleSendPressed,
                      showUserAvatars: true,
                      showUserNames: true,
                      user: _user,
                    );
                  }
                },
              ),
      );

  void _addMessage(types.Message message) {
    Map<String, dynamic> temp_msg = message.toJson();
    temp_msg['status'] = 'sent';
    temp_msg['createdAt'] =
        Timestamp.fromMillisecondsSinceEpoch(temp_msg['createdAt']);
    print('add message');
    print(temp_msg);
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chat_id)
        .collection('messages')
        .add(temp_msg);
    //     .add({
    //   'author': {
    //     'id': message.author.id,
    //   },
    //   'createdAt': Timestamp.fromMillisecondsSinceEpoch(message.createdAt!),
    //   'id': message.id,
    //   'status': 'sent',
    //   'type': message.type.toString(),
    //   'message': message.repliedMessage!.toJson()
    // });
    // .add({
    //   'author': message.author,
    //   'createdAt': message.createdAt,
    //   'id': message.id,
    //   'status': 'sent',
    //   'text': message.
    // });
    // setState(() {
    //   _messages.insert(0, message);
    // });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    print('before add message');
    _addMessage(textMessage);
  }

  void _loadAnnouncementUser() async {
    final res = await FirebaseFirestore.instance
        .collection('announcement')
        .doc(chat_id)
        .collection('participants')
        .get();

    print('get each user');
    for (var docId in res.docs) {
      Map<String, dynamic> data = docId.data();
      if (data['isAllowed']) {
        await data['user_ref']
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> userDoc) async {
          Map<String, dynamic>? userData = userDoc.data();
          chatParticipants[userDoc.id] = {
            'firstName': userData?['name'],
            'imageUrl': userData?['profile'],
            'id': userDoc.id
          };
          setState(() {
            chatParticipants = chatParticipants;
          });
        });
      }
    }
    chatParticipants.forEach((x, y) {
      print(y.toString());
    });
    print('get each user finish');
    setState(() {
      loading = false;
    });
  }

  void _loadMatchMakingUser() async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat_id)
        .get()
        .then((doc) async {
      Map<String, dynamic>? data = doc.data();
      List<String> participants = (data?['participants'] as List)
          .map((item) => item as String)
          .toList();

      for (var userId in participants) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> userDoc) {
          Map<String, dynamic>? userData = userDoc.data();
          chatParticipants[userDoc.id] = {
            'firstName': userData?['name'],
            'imageUrl': userData?['profile'],
            'id': userDoc.id
          };
          setState(() {
            chatParticipants = chatParticipants;
          });
        });
      }
    });
    setState(() {
      loading = false;
    });
  }

  void _loadChatUser() async {
    if (!widget.isMatchmaking)
      _loadAnnouncementUser();
    else
      _loadMatchMakingUser();

    print('get each user finish');
  }

  List<types.Message>? formatMessage(
      QuerySnapshot<Map<String, dynamic>>? data) {
    print('it was here');
    final msg = data?.docs.map((e) {
      print('data');
      Map<String, dynamic> data = e.data();
      print(data);
      data['author'] = chatParticipants[data['author']['id']];
      data['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().millisecondsSinceEpoch;
      return types.Message.fromJson(data);
    }).toList();
    return msg;
  }

  void _loadMessages(QuerySnapshot<Map<String, dynamic>> data) async {
    print('get message');
    QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat_id)
        .collection('messages')
        .get();
    // var temp;
    // res.forEach(
    //   (element) {
    //     final test = element.docs.map((e) {
    //       print(e.data());
    //       Map<String, dynamic> data = e.data();
    //       data['author'] = chatParticipants[data['author']['id']];
    //       data['createdAt'] =
    //           (data['createdAt'] as Timestamp).toDate().millisecondsSinceEpoch;
    //       return types.Message.fromJson(data);
    //     }).toList();
    //     print(test);
    //     temp = test;
    //   },
    // );
    final test = res.docs.map((e) {
      print(e.data());
      Map<String, dynamic> data = e.data();
      data['author'] = chatParticipants[data['author']['id']];
      data['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().millisecondsSinceEpoch;
      return types.Message.fromJson(data);
    }).toList();

    print(test);
    // final response = await rootBundle.loadString('assets/test.json');
    // final messages = (jsonDecode(response) as List)
    //     .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
    //     .toList();

    setState(() {
      _messages = test;
    });
  }
}
