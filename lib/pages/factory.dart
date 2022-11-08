import 'package:flutter/material.dart';

class Factory extends StatefulWidget {
  const Factory({Key? key}) : super(key: key);

  @override
  State<Factory> createState() => _FactoryState();
}

class _FactoryState extends State<Factory> {
  final List<Color> colors = [
    Colors.green.shade400,
    Colors.green.shade900,
  ];
  late DraggableScrollableController _controller;

  @override
  void initState() {
    _controller = DraggableScrollableController();
    super.initState();
  }

  double initialSize = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: initialSize,
        minChildSize: 0,
        maxChildSize: 1,
        builder: (context, controller) {
          return Container(
            color: Colors.blueGrey.shade100,
            child: ListView.builder(
              controller: controller,
              itemCount: 30,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  height: 30,
                  color: colors[index % colors.length],
                  child: Center(child: Text('$index')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _controller.animateTo(
            _controller.size - 0.2,
            duration: const Duration(seconds: 3),
            curve: Curves.linear,
          );
          setState(() {
            initialSize = _controller.size;
          });
        },
        child: const Icon(Icons.expand_more),
      ),
    );
  }
}
