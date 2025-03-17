import 'dart:math';

import 'package:flutter/material.dart';

class InputWithChips extends StatefulWidget {
  const InputWithChips({required this.label, this.controller, super.key});

  final String label;
  // This was useless ;-;
  final TagController? controller;

  @override
  State<InputWithChips> createState() => _InputWithChipsState();
}

class _InputWithChipsState extends State<InputWithChips> {
  late TextEditingController _controller;
  Map<String, Widget> chips = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get tags => chips.keys.toList();

  void _handleText() {
    final List<String> text = _controller.text.split(' ');
    //_controller.text = text[text.length - 1];
    if (text.length > 1) {
      _controller.text = text[text.length - 1];
      for (var i = 0; i <= text.length - 1; i++) {
        createChip(text[i]);
      }
      print("Recieved $text, length: ${text.length}");
    }
  }

  void createChip(String text) {
    if (text != '')
      setState(() {
        print('From create chip: $text');
        chips[text] = InputChip(
            label: Text(text),
            avatar: Container(
              decoration: BoxDecoration(
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                shape: BoxShape.circle,
              ),
            ),
            onDeleted: () => setState(() {
                  chips.remove(text);
                  updateController();
                }));
        updateController();
      });
  }

  void updateController() {
    widget.controller?.items = chips.keys.toList();
    print("updated TagController: ${widget.controller?.items}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.label,
          ),
          controller: _controller,
        ),
        Wrap(
          children: <Widget>[...chips.values],
        )
      ],
    );
  }
}

class TagController {
  List<String> items = [];
}
