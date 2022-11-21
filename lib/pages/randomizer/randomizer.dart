import 'package:flutter/material.dart';
//import 'package:fortune_wheel/spinwheelscreen.dart';
import 'package:paipao/pages/randomizer/spinwheel.dart';
import 'package:rxdart/rxdart.dart';

class Randomizer extends StatefulWidget {
  const Randomizer({super.key});

  @override
  State<Randomizer> createState() => _RandomizerState();
}

class _RandomizerState extends State<Randomizer> {
  //create variable

  var _formKey = GlobalKey<FormState>();
  TextEditingController itemController = TextEditingController();
  String _nameError = "กรุณใส่สิ่งที่ต้องการสุ่มอย่างน้อย 2 สิ่่ง";
  var error_messege = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("สร้างกงล้อสุ่ม"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains(",")) {
                    return 'กรุณากรอกข้อมูลอย่างน้อย 2 สิ่งขึ้นไป';
                  }
                  return null;
                },
                controller: itemController,
                decoration: InputDecoration(
                    hintText:
                        "โปรดใส่สิ่งที่่คุณอยากจะนำมาสุ่มเเล้วคั่นด้วย comma",
                    labelText: "สิ่งที่ต้องการจะสุ่ม",
                    errorText: error_messege,
                    labelStyle: TextStyle(fontSize: 32, color: Colors.black),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.name,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                //So in onPressed () We can adding some task in {} to make a click buttons do something
                onPressed: () {
                  List<String> Items = itemController.text.split(",");
                  //print(Items);
                  if (_formKey.currentState!.validate() && Items.length > 1) {
                    // Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context)
                    //       {
                    //         return  SpinWheel(InputList: Items);
                    //       },
                    //     ),
                    //   );

                  }
                },
                child: const Text('สร้าง')),
            SizedBox(
              height: 50,
            ),
            Image.network(
                "https://cdn-icons-png.flaticon.com/512/1787/1787504.png"),
          ],
        ),
      ),
    );
  }
}
