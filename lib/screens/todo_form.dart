import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/widgets/date_time_picker.dart';
import 'package:notequest/widgets/inputchip.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo_form.g.dart';

class TodoForm extends ConsumerStatefulWidget {
  const TodoForm({
    this.id,
    this.parent,
    super.key,
    this.logger,
  });

  final String? id;
  final TodoModel? parent;

  final Logger? logger;

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final Map<String, dynamic> childControllers = {
    'title': TextEditingController(),
    'tag': TagController(),
    'priority': TextEditingController(),
    'state': TextEditingController(),
    'scheduledTime': DateTimePickerController(),
    'dueTime': DateTimePickerController(),
    'description': TextEditingController(),
  };
  late final String uuid = widget.id ?? Uuid().v4();
  late final TodoPair? todo = ref.watch(todoListProvider)[uuid];
  late final Logger? logger = widget.logger;

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
      logger?.d('Disposing controllers: $controller');
    }
    super.dispose();
  }

  // FIXME: remove this unused function
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
    if (todo != null) {
      TodoModel todoModel = todo!.todo;
      String? markdown = todo!.description;
      (childControllers['title'] as TextEditingController).text =
          todoModel.title;
      (childControllers['tag'] as TagController).items = todoModel.tag;
      (childControllers['priority'] as TextEditingController).text =
          todoModel.priority.name;
      (childControllers['state'] as TextEditingController).text =
          todoModel.state.name;
      (childControllers['scheduledTime'] as DateTimePickerController).dateTime =
          todoModel.scheduledTime;
      (childControllers['dueTime'] as DateTimePickerController).dateTime =
          todoModel.dueTime;
      if (todoModel.hasMarkdown) {
        (childControllers['description'] as TextEditingController).text =
            markdown!;
      }
    }

    //String dropdownValue = 3.toString();

    // TODO: modularize this piece of shit
    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Column(
        children: [
          _TodoDetails(
            childControllers: childControllers,
            logger: logger,
          ),
          SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    logger?.d('Canceled adding todos');
                    Navigator.pop(context);
                  },
                  child: Text("cancel"),
                ),
                FilledButton(
                  onPressed: () {
                    logger?.t('Saving');
                    logger?.t(childControllers.keys);
                    if ((childControllers['title'] as TextEditingController)
                        .text
                        .isNotEmpty) {
                      logger?.t('Title not empty');
                      logger?.i(uuid);
                      logger?.i(
                          (childControllers['title'] as TextEditingController)
                              .text);
                      logger?.i((childControllers['priority']
                              as TextEditingController)
                          .text);
                      logger?.i(TodoPriority.values.asNameMap());
                      logger?.i(TodoPriority.values.asNameMap()[
                          (childControllers['priority']
                                  as TextEditingController)
                              .text
                              .toLowerCase()]);
                      logger
                          ?.i((childControllers['tag'] as TagController).items);
                      logger?.i(TodoState.values.asNameMap()[
                          (childControllers['state'] as TextEditingController)
                              .text
                              .toLowerCase()]!);
                      logger?.i((childControllers['scheduledTime']
                              as DateTimePickerController)
                          .dateTime);
                      logger?.i((childControllers['dueTime']
                              as DateTimePickerController)
                          .dateTime);
                      logger?.i((childControllers['description']
                              as TextEditingController)
                          .text
                          .isNotEmpty);
                      var todo = TodoModel(
                        id: uuid,
                        title:
                            (childControllers['title'] as TextEditingController)
                                .text,
                        priority: TodoPriority.values.asNameMap()[
                            (childControllers['priority']
                                    as TextEditingController)
                                .text
                                .toLowerCase()]!,
                        tag: (childControllers['tag'] as TagController).items,
                        state: TodoState.values.asNameMap()[
                            (childControllers['state'] as TextEditingController)
                                .text
                                .toLowerCase()]!,
                        scheduledTime: (childControllers['scheduledTime']
                                as DateTimePickerController)
                            .dateTime,
                        dueTime: (childControllers['dueTime']
                                as DateTimePickerController)
                            .dateTime,
                        hasMarkdown: (childControllers['description']
                                as TextEditingController)
                            .text
                            .isNotEmpty,
                      );
                      logger?.i(todo);
                      String? markdown = (childControllers['description']
                              as TextEditingController)
                          .text;
                      if (markdown == '') {
                        markdown = null;
                      }
                      ref.read(todoListProvider.notifier).addTodo(
                            todo,
                            markdown: markdown,
                            parentModel: widget.parent,
                          );
                      Navigator.pop(context);
                    } else {
                      ref
                          .read(errorMessageProvider.notifier)
                          .setMessage("This field cannot be empty");
                    }
                  },
                  child: Text("save"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoDetails extends ConsumerWidget {
  const _TodoDetails({
    required this.childControllers,
    // ignore: unused_element
    super.key,
    this.logger,
  });

  final Map<String, dynamic> childControllers;
  final Logger? logger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger?.t('building todo details');
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
            padding: padding,
            child: InputWithChips(
              label: "Tag",
              controller: childControllers['tag'],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: padding,
                child: DropdownMenu(
                  controller: childControllers['state'],
                  initialSelection: TodoState.values.asNameMap()[
                          (childControllers['state'] as TextEditingController)
                              .text
                              .toLowerCase()] ??
                      TodoState.todo,
                  width: MediaQuery.of(context).size.width / 2 - 8,
                  dropdownMenuEntries: <DropdownMenuEntry<TodoState>>[
                    for (var value in TodoState.values)
                      DropdownMenuEntry(
                        value: value,
                        label: value.name.toUpperCase(),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: padding,
                child: DropdownMenu(
                  controller: childControllers['priority'],
                  initialSelection: TodoPriority.values.asNameMap()[
                          (childControllers['priority']
                                  as TextEditingController)
                              .text
                              .toLowerCase()] ??
                      TodoPriority.low,
                  width: MediaQuery.of(context).size.width / 2 - 8,
                  dropdownMenuEntries: <DropdownMenuEntry<TodoPriority>>[
                    for (var value in TodoPriority.values)
                      DropdownMenuEntry(
                        value: value,
                        label: value.name.toUpperCase(),
                        leadingIcon: Container(
                          height:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          width:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          decoration: BoxDecoration(
                            color: value.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: padding,
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
