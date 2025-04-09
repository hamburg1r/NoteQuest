import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class InputWithChips extends StatefulWidget {
  const InputWithChips({
    required this.label,
    this.controller,
    super.key,
    this.logger,
  });

  final String label;
  // This was useless ;-;
  final TagController? controller;
  final Logger? logger;

  @override
  State<InputWithChips> createState() => _InputWithChipsState();
}

class _InputWithChipsState extends State<InputWithChips> {
  late TextEditingController _controller;
  late final Logger? logger = widget.logger;
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
      logger?.i("Recieved $text, length: ${text.length}");
    }
  }

  void createChip(String text) {
    // TODO: save avatar icons: priority low
    var avatarIcon = Container(
      decoration: BoxDecoration(
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        shape: BoxShape.circle,
      ),
    );

    if (text != '') {
      logger?.i('Creating chips: $text');
      setState(() {
        chips[text] = InputChip(
          label: Text(text),
          avatar: avatarIcon,
          onDeleted: () => setState(() {
            chips.remove(text);
            updateController();
          }),
        );
        updateController();
      });
    }
  }

  void updateController() {
    widget.controller?.items = chips.keys.toList();
    logger?.i("Updated TagController: ${widget.controller?.items}");
  }

  @override
  Widget build(BuildContext context) {
    logger?.t('InputWithChips build called');
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
