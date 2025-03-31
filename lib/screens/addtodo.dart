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

Future<void> todoFormPage(context, {id}) => Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Add Todo'),
          ),
          body: TodoForm(id: id),
        ),
      ),
    );

class TodoForm extends ConsumerStatefulWidget {
  const TodoForm({this.id, super.key});

  final String? id;

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final Map<String, dynamic> childControllers = {
    'title': TextEditingController(),
    'tag': TagController(),
    'priority': CounterController(initialValue: 3),
    'state': TextEditingController(),
    'scheduledTime': DateTimePickerController(),
    'dueTime': DateTimePickerController(),
    'description': TextEditingController(),
  };
  late final String uuid = widget.id ?? Uuid().v4();
  late final TodoModel? todo = ref.watch(todoListProvider)[uuid];

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
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: modularize this piece of shit
    if (todo != null) {
      (childControllers['title'] as TextEditingController).text = todo!.title;
      (childControllers['tag'] as TagController).items = todo!.tag;
      (childControllers['priority'] as CounterController).count =
          todo!.priority;
      (childControllers['state'] as TextEditingController).text =
          todo!.state.name;
      (childControllers['scheduledTime'] as DateTimePickerController).dateTime =
          todo!.scheduledTime;
      (childControllers['dueTime'] as DateTimePickerController).dateTime =
          todo!.dueTime;
      if (todo!.hasMarkdown) {
        // TODO: load markdown from saved file
        (childControllers['subTask'] as TextEditingController).text = '';
      }
    }

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
                      if ((childControllers['title'] as TextEditingController)
                          .text
                          .isNotEmpty) {
                        var todo = TodoModel(
                          id: uuid,
                          title: (childControllers['title']
                                  as TextEditingController)
                              .text,
                          priority: (childControllers['priority']
                                  as CounterController)
                              .count,
                          tag: childControllers['tag'].items,
                          state: TodoState.values.asNameMap()[
                              childControllers['state'].text.toLowerCase()]!,
                          scheduledTime:
                              childControllers['scheduledTime'].dateTime,
                          dueTime: childControllers['dueTime'].dateTime,
                          hasMarkdown: (childControllers['description']
                                  as TextEditingController)
                              .text
                              .isNotEmpty,
                        );
                        ref.read(todoListProvider.notifier).updateTodos(
                              todo,
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
              textCapitalization: TextCapitalization.sentences,
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
            controller:
                (childControllers['description'] as TextEditingController),
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
  @override
  String? build() {
    return null;
  }

  void setMessage(String? msg) {
    state = msg;
  }
}
