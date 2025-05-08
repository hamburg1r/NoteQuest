// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todo_form.dart';

String customDateFormat(
  DateTime date, [
  bool period = true,
  String dateTimeSep = ' ',
]) {
  String timeStr = period
      ? "${(date.hour % 12).toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour / 12 < 1 ? 'AM' : 'PM'}"
      : "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  String dateStr =
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  if (date.year != DateTime.now().year) dateStr += "/${date.year}";
  return timeStr + dateTimeSep + dateStr;
}

Future<void> makeRoute(context, screen) => Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => screen,
      ),
    );

// FIXME: Future?
Map<String, TodoPair>? getTodos(
  List<String> todos,
  Map<String, TodoPair> todoList, [
  Logger? logger,
]) {
  Map<String, TodoPair> out = {};
  logger?.i('$todoList');
  if (todos.isEmpty) return todoList;
  for (String id in todos) {
    logger?.i('checking for $id got:${todoList[id].toString()}');
    out[id] = todoList[id]!;
  }
  if (out.isEmpty) return null;
  logger?.i(out);
  return out;
}

MenuAnchor Function(TodoPair todo) genMenu({
  required BuildContext context,
  required WidgetRef ref,
  String? parent,
  Logger? logger,
}) {
  return (TodoPair todo) {
    var _todoMainScreenNotifier = ref.read(todoMainScreenProvider.notifier);
    var _todoMainScreenProvider = ref.watch(todoMainScreenProvider);
    var _todoListNotifier = ref.read(todoListProvider.notifier);
    var _todoListProvider = ref.watch(todoListProvider);

    bool existsOnMainScreen =
        _todoMainScreenProvider['main']!.contains(todo.todo.id);
    bool isPinned = _todoMainScreenProvider['pinned']!.contains(todo.todo.id);

    logger?.t('Creating menu button for todo list items');
    return MenuAnchor(
      // style: MenuStyle(maximumSize: MaterialStateProperty),
      menuChildren: [
        if (isPinned)
          MenuItemButton(
            onPressed: () {
              logger?.d('Unpinning ${todo.todo.id}');
              _todoMainScreenNotifier.unpin(todo.todo.id);
            },
            child: const Text('Unpin'),
          ),
        if (!isPinned)
          MenuItemButton(
            onPressed: () {
              logger?.d('Pinning ${todo.todo.id}');
              _todoMainScreenNotifier.pin(todo.todo.id);
            },
            child: const Text('Pin'),
          ),
        if (existsOnMainScreen)
          MenuItemButton(
            onPressed: () {
              logger?.d('Removing ${todo.todo.id} from main screen');
              _todoMainScreenNotifier.remove(todo.todo.id);
            },
            child: const Text('Remove from main Screen'),
          ),
        if (!existsOnMainScreen)
          MenuItemButton(
            onPressed: () {
              logger?.d('Adding ${todo.todo.id} to main screen');
              _todoMainScreenNotifier.add(todo.todo.id);
            },
            child: const Text('Add to main Screen'),
          ),
        if (parent != null)
          MenuItemButton(
            onPressed: () {
              logger?.d('Removing ${todo.todo.id} from $parent');
              _todoListNotifier.removeSubTask(
                _todoListProvider[parent]!.todo,
                todo.todo.id,
              );
              _todoListNotifier.removeParent(todo.todo, parent);
            },
            child: const Text('Remove Subtask'),
          ),
        MenuItemButton(
          onPressed: () {
            logger?.d('Editing ${todo.todo.id}');
            makeRoute(
              context,
              TodoForm(
                id: todo.todo.id,
                logger: logger,
              ),
            );
          },
          child: const Text('Edit'),
        ),
        MenuItemButton(
          onPressed: () {
            logger?.d('Deleting ${todo.todo.id}');
            ref.read(todoListProvider.notifier).removeTodo(todo.todo);
          },
          child: const Text('Delete'),
        ),
      ],
      builder: (_, MenuController controller, Widget? child) {
        return IconButton(
          //focusNode: _buttonFocusNode,
          onPressed: () {
            logger?.t('Menu button pressed for: ${todo.todo.id}');
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  };
}
