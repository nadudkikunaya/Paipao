import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerDetail1.dart';
import 'package:paipao/pages/mainWrapper.dart';

// https://stackoverflow.com/questions/51415236/show-circular-progress-dialog-in-login-screen-in-flutter-how-to-implement-progr
showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text('เรากำลังลงชื่อคุณเข้าสู่ระบบ')),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return WillPopScope(onWillPop: () async => false, child: alert);
    },
  );
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  // This map will be used to transfer user inputted data to the next Naviagtion page. (https://docs.flutter.dev/cookbook/navigation/passing-data)
  // We will user a hash map to pass values to other pages instead of classes; otherwise, the class will be nested too deep, since there are multiple pages.
  // Using map like this is kinda like a struct in other languages, actually.
  // If Dart had a struct then I'd would use it here (https://stackoverflow.com/questions/24762414/is-there-anything-like-a-struct-in-dart)

  final Map<String, dynamic> regData = {
    // login.dart (This page/credentials)
    'regEmail': Null, // String
    'regPassword': Null, // String

    // registerDeail1.dart (Personal Information)
    'name': Null, // String
    'phoneNo': Null, // String
    'birthDate': Null, // DateTime
    'gender': Null, // Gender
    'isSmoking': Null, // IsSmoking
    'isDrinking': Null, // IsDrinking
    'isVegetarian': Null, // IsVegetarian

    // registerDetail2.dart (Interests)
    'interests': Null, // List<>

    // registerDetail3.dart (Pictures)
    'profilePic': Null, // Picture?
    'nationalityCardPic': Null, // Picture?
  };

  // For accepting text from the TextFormField(s) (https://docs.flutter.dev/cookbook/forms/retrieve-input)
  final loginEmailController = TextEditingController(),
        loginPasswordController = TextEditingController(),
        regEmailController = TextEditingController(),
        regPasswordController = TextEditingController(),
        regPasswordConfirmController = TextEditingController();
  
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
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
    regPasswordConfirmController.dispose();
    
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
                                        label: Text('อีเมล'),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      // TODO: check email-format
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'โปรดกรอกข้อมูล';
                                        }
                                        return null;
                                      },
                                      controller: loginEmailController,
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'โปรดกรอกข้อมูล';
                                        }
                                        return null;
                                      },
                                      controller: loginPasswordController,
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
                                        onPressed: () async {
                                          if (_formLoginKey.currentState!
                                              .validate()) { // If the form is valid...
                                            showLoaderDialog(context);
                                            print(loginEmailController.text);
                                            print(loginPasswordController.text);
                                            try {
                                              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                                email: loginEmailController.text,
                                                password: loginPasswordController.text
                                              );
                                              if (!mounted) return;
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainWrapper()));
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
                                              } else {  // Any other FirebaseAuthExceptions
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(e.toString())),
                                                );
                                              }
                                            } catch (e) { // Other Exceptions unrelated to FirebaseAuthException
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(e.toString())),
                                              );
                                            }
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
                                    label: Text('อีเมล'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'โปรดกรอกข้อมูล';
                                    }
                                    return null;
                                  },
                                  controller: regEmailController,
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'โปรดกรอกข้อมูล';
                                    }
                                    return null;
                                  },
                                  controller: regPasswordController,
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
                                    label: Text('ยืนยันรหัสผ่าน'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'โปรดกรอกข้อมูล';
                                    } else if (value != regPasswordController.text) {
                                      return 'รหัสผ่านไม่ตรงกัน';
                                    }
                                    return null;
                                  },
                                  controller: regPasswordConfirmController,
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  width: 100,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formRegisterKey.currentState!
                                          .validate()) { // The validator in each TextFromField will effect the value of this
                                        // Retrieve inputted text and assign it to the map with their respective key
                                        regData['regEmail'] = regEmailController.text;
                                        regData['regPassword'] = regPasswordController.text;

                                        // Get to the next page
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterDetail1(regData: regData,)));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('โปรดกรอกข้อมูลให้ครบถ้วนและถูกต้อง')),
                                        );
                                        // showDialog(
                                        //   context: context,
                                        //   barrierDismissible: false,
                                        //   builder: (context) => AlertDialog(
                                        //     title: Text('Warning'),
                                        //     content: Text('Please enter the correct information to continue.'),
                                        //     actions: [
                                        //       TextButton(
                                        //         child: const Text('Okay'),
                                        //         onPressed: () {
                                        //           Navigator.of(context).pop();
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );
                                      }
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
