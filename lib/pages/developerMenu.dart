import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/login.dart';
import 'package:paipao/pages/auth/registerDetail2.dart';
import 'package:paipao/pages/auth/registerDetail3.dart';
import 'package:paipao/pages/chat/chatRoom.dart';
import 'package:paipao/pages/explore/createAnnouncement.dart';
import 'package:paipao/pages/explore/matchMakingFilter.dart';
import 'package:paipao/pages/explore/waitingRoom.dart';
import 'package:paipao/pages/factory.dart';
import 'mainWrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeveloperMenu extends StatefulWidget {
  const DeveloperMenu({super.key});
  // const DeveloperMenu({super.key, required this.title});
  // final String title;

  @override
  State<DeveloperMenu> createState() => _DeveloperMenuState();
}

class _DeveloperMenuState extends State<DeveloperMenu> {
  String uid = 'null';
  showLoaderDialog(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7), child: Text(message)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: alert);
      },
    );
  }

  void loginDemo(String email, String password) async {
    showLoaderDialog(context, 'เรากำลังลงชื่อคุณเข้าสู่ระบบ');
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((credential) async {
        DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();

        setState(() {
          uid = credential.user!.uid;
        });
        Map<String, dynamic>? data = await doc.data();

        if (data?['approved'] == false) {
          throw FirebaseAuthException(code: 'not-approved');
        }

        if (!mounted) return;
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('login สำเร็จแล้ว $email')),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบอีเมลล์นี้ในระบบ')),
        );
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
        );
      } else if (e.code == 'not-approved') {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'บัญชีของคุณยังอยู่ในขั้นตอนตรวจสอบ กรุณารอพอภายใน 24 ชม.')),
        );
      } else {
        // Any other FirebaseAuthExceptions
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } catch (e) {
      // Other Exceptions unrelated to FirebaseAuthException
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer Menu'),
      ),
      body: Center(
          // ignore: avoid_unnecessary_containers
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Developer Menu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
            ),
            Center(
              child: Text('user: $uid'),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    loginDemo('test01@paipao.app', '123456');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: Text('Login as demo1'),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    loginDemo('test02@paipao.app', '123456');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                  child: Text('Login as demo2'),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    loginDemo('test03@paipao.app', '123456');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100),
                  child: Text('Login as demo3'),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    loginDemo('test04@paipao.app', '123456');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100),
                  child: Text('Login as demo4'),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return WaitingRoom(
                              activity: 'ร้านเหล้า',
                              minNumJoin: 3,
                            );
                          });
                    });
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return WaitingRoom();
                    //     });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Test Component'),
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  child: Text('Login'),
                )),
                // Expanded(
                //     child: ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(builder: (context) => const ChatRoom()),
                //     );
                //   },
                //   style:
                //       ElevatedButton.styleFrom(backgroundColor: Colors.green),
                //   child: Text('SkipPage'),
                // )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainWrapper()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                  child: Text('MainMenu'),
                )),
              ],
            ),
            // StreamBuilder(
            //   stream:
            //       FirebaseFirestore.instance.collection('users').snapshots(),
            //   builder: (context, snapshot) {
            //     return Expanded(
            //         // height: MediaQuery.of(context).size.height * 0.5,
            //         child: ListView(children: makeListWidget(snapshot.data)));
            //   },
            // )
          ],
        ),
      )),
    );
  }

  List<Widget> makeListWidget(QuerySnapshot<Map<String, dynamic>>? data) {
    return data!.docs.map((doc) {
      return ListTile(title: Text(doc['name'].toString()));
    }).toList();
  }
}
