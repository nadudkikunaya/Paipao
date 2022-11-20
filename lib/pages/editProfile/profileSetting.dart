import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/developerMenu.dart';
import 'package:paipao/pages/editProfile/editProfile.dart';

showLoaderDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7), child: Text(message)),
      ],
    ),
  );
}

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(children: [
              Expanded(
                  child: TextButton(
                      onPressed: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      }),
                      style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        overlayColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.shade300),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black),
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Text('แก้ไขข้อมูลผู้ใช้')))),
            ]),
            Row(children: [
              Expanded(
                  child: TextButton(
                      onPressed: (() async {
                        showLoaderDialog(
                            context, 'เรากำลังลงชื่อคุณออกจากระบบ');
                        await FirebaseAuth.instance.signOut().then((value) {
                          print("Logged out");
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return DeveloperMenu();
                          }), (r) {
                            return false;
                          });
                        });
                      }),
                      style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        overlayColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.shade300),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black),
                      ),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: Text('ออกจากระบบ')))),
            ]),
          ],
        ),
      ),
    );
  }
}
