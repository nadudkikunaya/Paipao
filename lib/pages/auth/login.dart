import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerDetail1.dart';
import 'package:paipao/pages/mainWrapper.dart';

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
        heightFactor: 10,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child:
                          TabBarView(controller: _tabBarController, children: [
                        Column(
                          children: [
                            Expanded(
                                child: Form(
                              key: _formLoginKey,
                              child: Wrap(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    margin: EdgeInsets.only(top: 14),
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        label: Text('ชื่อผู้ใช้'),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                  Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        label: Text('รหัสผ่าน'),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
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
                                                  content:
                                                      Text('กำลังประมวลผล')),
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
                          ],
                        ),
                        Expanded(
                            child: Form(
                          key: _formRegisterKey,
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                margin: EdgeInsets.only(top: 14),
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
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
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
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
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                child: TextFormField(
                                  obscureText: false,
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
                                child: SizedBox(
                                  width: 100,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterDetail1()));
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
