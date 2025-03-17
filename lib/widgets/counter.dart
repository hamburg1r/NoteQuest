import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({this.controller, super.key});

  final CounterController? controller;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late CounterController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? CounterController(initialValue: 0);
  }

  @override
  Widget build(BuildContext context) {
    BorderSide border =
        BorderSide(color: ColorScheme.of(context).secondaryFixedDim);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            maximumSize: Size(double.infinity, double.infinity),
            shape: RoundedRectangleBorder(
              side: border,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              controller.count--;
            });
          },
          child: Icon(Icons.remove_circle),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            maximumSize: Size(double.infinity, double.infinity),
            foregroundColor: ColorScheme.of(context).secondaryFixedDim,
            //backgroundColor: ColorScheme.of(context).secondaryFixedDim,
            shape: RoundedRectangleBorder(
              side: border,
              //borderRadius: BorderRadius.only(
              //  topLeft: Radius.circular(10),
              //  bottomLeft: Radius.circular(10),
              //),
            ),
          ),
          child: Text(controller.count.toString()),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            maximumSize: Size(double.infinity, double.infinity),
            shape: RoundedRectangleBorder(
              side: border,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              controller.count++;
            });
          },
          child: Icon(Icons.add_circle),
        ),
      ],
    );
  }
}

class CounterController {
  int _count;
  set count(int value) {
    _count = value < 0 ? 0 : value;
  }

  int get count => _count;

  CounterController({initialValue = 0}) : _count = initialValue;
}
