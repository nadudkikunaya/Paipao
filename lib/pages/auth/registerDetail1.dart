import 'package:flutter/material.dart';
import 'package:paipao/pages/auth/registerDetail2.dart';
import 'package:paipao/pages/auth/registerWaitApprove.dart';

enum Gender { male, female, lgbt }

enum IsSmoking { no, yes }

enum IsDrinking { no, yes }

enum IsVegetarian { no, yes }

class RegisterDetail1 extends StatefulWidget {
  final Map<String, dynamic> regData;
  const RegisterDetail1({super.key, required this.regData}); // receive reg credentials from the last page (https://docs.flutter.dev/cookbook/navigation/passing-data)
  // To refer to said "regCred" in the state class below, refer to it as "widget.regCred" (https://stackoverflow.com/questions/50287995/passing-data-to-statefulwidget-and-accessing-it-in-its-state-in-flutter)

  @override
  State<RegisterDetail1> createState() => _RegisterDetail1State();
}

class _RegisterDetail1State extends State<RegisterDetail1> {
  final nameController = TextEditingController(),
        phoneNoController = TextEditingController();

  bool isDateSelected = false;
  late DateTime birthDate; // instance of DateTime
  String birthDateInString = 'วันเดือนปีเกิด';

  // I don't see why these radio buttons can be null. But the linter will complain otherwise.
  Gender? gender = Gender.male;
  IsSmoking? isSmoking = IsSmoking.no;
  IsDrinking? isDrinking = IsDrinking.no;
  IsVegetarian? isVegetarian = IsVegetarian.no;
  late final _formRegisterDetailKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      'ข้อมูลส่วนตัว',
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Expanded(
                      child: Form(
                          key: _formRegisterDetailKey,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    label: Text('ชื่อ-นามสกุล'),
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
                                  controller: nameController,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefix: Text('+66 '),
                                    prefixStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    label: Text('เบอร์โทรศัพท์'),
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
                                  controller: phoneNoController,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () async {
                                    final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (datePick != null) {
                                      setState(() {
                                        birthDate = datePick;
                                        isDateSelected = true;

                                        // put it here
                                        birthDateInString =
                                            '${birthDate.day}/${birthDate.month}/${birthDate.year}'; // 08/14/2019
                                      });
                                    }
                                  },
                                  child: TextFormField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                      label: Text(birthDateInString),
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
                              ),

                              // GestureDetector(
                              //     child: Icon(Icons.calendar_today),
                              //     onTap: () async {
                              //       final datePick = await showDatePicker(
                              //           context: context,
                              //           initialDate: DateTime.now(),
                              //           firstDate: DateTime(1900),
                              //           lastDate: DateTime(2100));
                              //       if (datePick != null &&
                              //           datePick != birthDate) {
                              //         setState(() {
                              //           birthDate = datePick;
                              //           isDateSelected = true;

                              //           // put it here
                              //           birthDateInString =
                              //               "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
                              //         });
                              //       }
                              //     })
                            ],
                          )),
                    ),
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'เพศ',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ชาย'),
                              leading: Radio<Gender>(
                                value: Gender.male,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('หญิง'),
                              leading: Radio<Gender>(
                                value: Gender.female,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('LGBTQA+'),
                              leading: Radio<Gender>(
                                value: Gender.lgbt,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'คุณสูบบุหรี่หรือไม่',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ไม่สูบ'),
                              leading: Radio<IsSmoking>(
                                value: IsSmoking.no,
                                groupValue: isSmoking,
                                onChanged: (IsSmoking? value) {
                                  setState(() {
                                    isSmoking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('สูบ'),
                              leading: Radio<IsSmoking>(
                                value: IsSmoking.yes,
                                groupValue: isSmoking,
                                onChanged: (IsSmoking? value) {
                                  setState(() {
                                    isSmoking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'คุณดื่มเหล้าเบียร์หรือไม่',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ไม่ดื่ม'),
                              leading: Radio<IsDrinking>(
                                value: IsDrinking.no,
                                groupValue: isDrinking,
                                onChanged: (IsDrinking? value) {
                                  setState(() {
                                    isDrinking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ดื่ม'),
                              leading: Radio<IsDrinking>(
                                value: IsDrinking.yes,
                                groupValue: isDrinking,
                                onChanged: (IsDrinking? value) {
                                  setState(() {
                                    isDrinking = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text(
                          'คุณเป็นมังสวิรัติหรือไม่',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Wrap(direction: Axis.horizontal, children: [
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.32,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('ไม่เป็น'),
                              leading: Radio<IsVegetarian>(
                                value: IsVegetarian.no,
                                groupValue: isVegetarian,
                                onChanged: (IsVegetarian? value) {
                                  setState(() {
                                    isVegetarian = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width:
                                (MediaQuery.of(context).size.width - 40) * 0.33,
                            child: ListTile(
                              horizontalTitleGap: 0,
                              title: const Text('เป็น'),
                              leading: Radio<IsVegetarian>(
                                value: IsVegetarian.yes,
                                groupValue: isVegetarian,
                                onChanged: (IsVegetarian? value) {
                                  setState(() {
                                    isVegetarian = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            widget.regData['name'] = nameController.text;
                            widget.regData['phoneNo'] = phoneNoController.text;
                            widget.regData['birthDate'] = birthDate;
                            widget.regData['gender'] = gender;
                            widget.regData['isSmoking'] = isSmoking;
                            widget.regData['isDrinking'] = isDrinking;
                            widget.regData['isVegetarian'] = isVegetarian;

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterDetail2(regData: widget.regData,)));
                          },
                          child: Text('อ่ะ ต่อไป')),
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
