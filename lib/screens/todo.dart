import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:notequest/widgets/counter.dart';
import 'package:notequest/widgets/inputchip.dart';
import '../widgets/list.dart';

class Todo extends StatelessWidget {
  final Function(Text) appbar;
  const Todo(this.appbar, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(Text('Todo')),
      body: TodoTiles(),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        //onPressed: () => showModalBottomSheet(
        //	context: context,
        //	enableDrag: true,
        //	isScrollControlled: true,
        //	builder: (ctx) => AddTodo()
        //),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Add Todo'),
                ),
                body: SafeArea(child: AddTodo()),
              ),
            )),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late TextEditingController _titleController;
  final TagController _tagController = TagController();
  final CounterController _priorityController =
      CounterController(initialValue: 3);
  late TextEditingController _subTaskController;
  late TextEditingController _scheduledTimeController;
  late TextEditingController _dueTimeController;
  late StreamSubscription<bool> kbSub;
  //int highestPriority = 3;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subTaskController = TextEditingController();
    _scheduledTimeController = TextEditingController();
    _dueTimeController = TextEditingController();
    kbSub = KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTaskController.dispose();
    _scheduledTimeController.dispose();
    _dueTimeController.dispose();
    super.dispose();
  }

  Widget inputBox(String label, {bool autofocus = false}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Form(
        child: FocusTraversalGroup(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            autofocus: autofocus,
            decoration:
                InputDecoration(border: OutlineInputBorder(), labelText: label),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = const EdgeInsets.all(4.0);
    decoration(label) => InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        );

    //String dropdownValue = 3.toString();

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: padding,
                child: TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: decoration('Title'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InputWithChips(
                  label: "Tag",
                  controller: _tagController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Counter(
                      controller: _priorityController,
                    ),
                  ],
                ),
              ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("cancel"),
            ),
            FilledButton(
                onPressed: () {
                  // TODO: Implement saving mechanism
                  print(_titleController.text);
                  print(_tagController.items);
                  //Navigator.pop(context);
                },
                child: Text("save"))
          ],
      ],
    );
  }
}
