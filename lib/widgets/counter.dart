import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  Counter({this.controller, super.key});

  CounterController? controller;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late CounterController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? CounterController(count: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: () {}, child: Icon(Icons.plus_one)),
        TextButton(onPressed: () {}, child: Icon(Icons.plus_one)),
      ],
    );
  }
}

class CounterController {
  int count;

  CounterController({this.count = 0});
}
