import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SpinWheel extends StatefulWidget {
  Map<String, Map<String, dynamic>> participants;
  SpinWheel({super.key, required this.participants});

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  TextEditingController _fieldController = TextEditingController();
  String rewards = "0"; //int reward = 0; init value

  List<String> nameList = [];
  List<String> items = [];
  bool loading = true;

  setNameList() {
    widget.participants.forEach((key, value) {
      nameList.add(widget.participants[key]?['firstName']);
    });
    setState(() {
      items = nameList.toList();
      print(items);
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setNameList();
    super.initState();
  }

  @override
  void dispose() {
    _fieldController.dispose();
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("กงล้อสุ่ม"),
      ),
      body: Center(
        child: loading
            ? Text('loading')
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              controller: _fieldController,
                              decoration: InputDecoration(
                                  label: Text('พิมพ์อะไรสักอย่าง'),
                                  fillColor: Colors.grey.shade100),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  items.add(_fieldController.text);
                                  _fieldController.clear();
                                });
                              },
                              child: Text('ตกลง')),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  items = nameList.toList();
                                });
                              },
                              child: Text('สมาชิกทั้งหมด'),
                            )),
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  items = [];
                                });
                              },
                              child: Text('เคลียร์'),
                            ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 450,
                      child: items.length <= 1
                          ? CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                items.length == 0 ? '' : items.first,
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 15),
                              child: FortuneWheel(
                                selected: selected.stream,
                                animateFirst: false,
                                styleStrategy: UniformStyleStrategy(
                                  borderColor: Colors.black,
                                  borderWidth: 5,
                                  color: Colors.red,
                                ),
                                items: [
                                  for (int i = 0;
                                      i < items.length;
                                      i++) ...<FortuneItem>{
                                    FortuneItem(
                                        child: Text(
                                      items[i],
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    )),
                                  },
                                ],
                                onAnimationEnd: () {
                                  setState(() {
                                    rewards = items[selected.value];
                                  });
                                  print(rewards);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Container(
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                rewards.toString(),
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                " ถูกเลือก ! ",
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    color: Colors.orangeAccent),
                                              )
                                            ],
                                          )),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (items.length <= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('กรุณากรอกข้อมูลขั้นต่ำ 2 อย่าง')),
                          );
                        }
                        setState(() {
                          selected.add(Fortune.randomInt(0, items.length));
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 200,
                        color: items.length <= 1
                            ? Colors.grey.shade100
                            : Colors.redAccent,
                        child: Center(
                          child: Text(
                            "หมุน",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
