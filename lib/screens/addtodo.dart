import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/widgets/counter.dart';
import 'package:notequest/widgets/date_time_picker.dart';
import 'package:notequest/widgets/inputchip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'addtodo.g.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final Map<String, dynamic> childControllers = {
    'title': TextEditingController(),
    'tag': TagController(),
    'priority': CounterController(initialValue: 3),
    'state': TextEditingController(),
    'scheduledTime': DateTimePickerController(),
    'dueTime': DateTimePickerController(),
    'subTask': TextEditingController(),
  };
  late final String uuid = Uuid().v4();

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible && mounted) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    for (var controller in childControllers.values) {
      if (controller is TextEditingController) controller.dispose();
      print('');
      print(controller);
      print('');
    }
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
    // TODO: modularize this piece of shit

    //String dropdownValue = 3.toString();

    return Column(
      children: [
        _TodoDetails(
          childControllers: childControllers,
        ),
        SizedBox(height: 7),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel"),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return FilledButton(
                    onPressed: () {
                      if (childControllers['title'].text.isNotEmpty) {
                        ref.read(todoListProvider.notifier).addTodo(
                              TodoModel(
                                id: uuid,
                                title: childControllers['title'].text,
                                priority: childControllers['priority'].count,
                                tag: childControllers['tag'].items,
                                state: TodoState.values.asNameMap()[
                                    childControllers['state']
                                        .text
                                        .toLowerCase()]!,
                                scheduledTime:
                                    childControllers['scheduledTime'].dateTime,
                                dueTime: childControllers['dueTime'].dateTime,
                              ),
                            );
                        Navigator.pop(context);
                      } else {
                        ref
                            .read(errorMessageProvider.notifier)
                            .setMessage("This field cannot be empty");
                      }
                      print(ref.watch(todoListProvider));
                    },
                    child: Text("save"),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodoDetails extends ConsumerWidget {
  const _TodoDetails({
    required this.childControllers,
    // ignore: unused_element
    super.key,
  });

  final Map<String, dynamic> childControllers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorText = ref.watch(errorMessageProvider);
    final EdgeInsets padding = const EdgeInsets.all(4.0);
    return Expanded(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: padding,
            child: TextFormField(
              controller: childControllers['title'],
              textInputAction: TextInputAction.next,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
                errorText: errorText,
              ),
              onChanged: (_) {
                ref.read(errorMessageProvider.notifier).setMessage(null);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InputWithChips(
              label: "Tag",
              controller: childControllers['tag'],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownMenu(
                  controller: childControllers['state'],
                  initialSelection: TodoState.todo,
                  width: MediaQuery.of(context).size.width / 2,
                  dropdownMenuEntries: <DropdownMenuEntry<TodoState>>[
                    for (var value in TodoState.values)
                      DropdownMenuEntry(
                        value: value,
                        label: value.name.toUpperCase(),
                      ),
                  ],
                ),
                Counter(
                  controller: childControllers['priority'],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateTimePicker(
                  label: 'Schedule Time',
                  controller: childControllers['scheduledTime'],
                ),
                DateTimePicker(
                  label: 'Due Time',
                  controller: childControllers['dueTime'],
                ),
              ],
            ),
          ),
          Divider(),
          Text(
            "Description:",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextField(
            maxLines: null,
          )
        ],
      ),
    );
  }
}

//Future<String?> errorMessage(Ref ref) async {
//  return null;
//}

@riverpod
class ErrorMessage extends _$ErrorMessage {
  String? message;
  String? build() {
    return message;
  }

  void setMessage(String? msg) {
    state = msg;
  }
}
