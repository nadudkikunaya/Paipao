import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SpinWheel extends StatefulWidget {
  List<String> InputList;
  SpinWheel({super.key,required this.InputList});

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  String rewards = "0";  //int reward = 0; init value

  

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<String> items = widget.InputList;

    return Scaffold(
      appBar: AppBar(
        title: Text("กงล้อสุ่ม"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 450,
              
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                styleStrategy: UniformStyleStrategy(
                  borderColor: Colors.black,
                  borderWidth: 5,
                  color: Colors.red,
                ),
                items: [
                  for(int i = 0; i < items.length; i++)...<FortuneItem>{
                    FortuneItem(child: Text(items[i],style: TextStyle(fontSize: 22,color: Colors.white),)),
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Text( rewards.toString() ,
                            style: TextStyle(fontSize: 30,color: Colors.white),),
                            Text(" ถูกเลือก ! ",style: TextStyle(fontSize: 35,color:Colors.orangeAccent) ,)
                          ],
                        )),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: 50,
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  selected.add(Fortune.randomInt(0, items.length));
                });
              },
  
              child: Container(
                height: 70,
                width: 200,
                color: Colors.redAccent,
                
                child: Center(
                  child: Text("หมุน",style: TextStyle(fontSize: 25,color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}