import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/login.dart';

class RegisterWaitApprove extends StatelessWidget {
  const RegisterWaitApprove({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.height - 40,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'คุณลงทะเบียนสำเร็จแล้ว',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Material(
                        color: Colors.green,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.check,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    //color: Colors.amber,
                    child: Flexible(
                        child: Text(
                      'ทางแอดมินจะตรวจสอบข้อมูลและเปิดการใช้งานให้'
                      'ภายใน 24 ชั่วโมง',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStatePropertyAll<Color>(Colors.green),
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                      ),
                      child: Text('รับทราบ'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
