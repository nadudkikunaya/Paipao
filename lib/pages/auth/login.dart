import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerWaitApprove.dart';
import 'package:paipao/pages/main_wrapper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TabController _tabBarController;

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'เข้าสู่ระบบ'),
    Tab(text: 'สมัครสมาชิก'),
  ];
  final _formLoginKey = GlobalKey<FormState>();
  final _formRegisterKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabBarController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Wrap(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width - 40,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width - 40,
                        child: TabBar(
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            controller: _tabBarController,
                            tabs: myTabs)),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child:
                          TabBarView(controller: _tabBarController, children: [
                        Expanded(
                            child: Form(
                          key: _formLoginKey,
                          child: Wrap(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text('ชื่อผู้ใช้'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter some text';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    label: Text('รหัสผ่าน'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter some text';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainWrapper()));
                                      if (_formLoginKey.currentState!
                                          .validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('กำลังประมวลผล')),
                                        );
                                      }
                                    },
                                    child: const Text('เข้าสู่ระบบ'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Form(
                          key: _formRegisterKey,
                          child: Wrap(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text('ชื่อผู้ใช้'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter some text';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    label: Text('รหัสผ่าน'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter some text';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    label: Text('ยืนยันรหัสผ่าน'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return 'Please enter some text';
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterWaitApprove()));
                                      // if (_formRegisterKey.currentState!
                                      //     .validate()) {
                                      //   // If the form is valid, display a snackbar. In the real world,
                                      //   // you'd often call a server or save the information in a database.
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(
                                      //     const SnackBar(
                                      //         content: Text('กำลังประมวลผล')),
                                      //   );
                                      // }
                                    },
                                    child: const Text('ยืนยัน'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
