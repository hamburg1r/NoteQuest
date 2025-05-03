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
  required bool forPinnedTodos,
  required bool forSubTask,
  Logger? logger,
}) {
  return (TodoPair todo) {
    logger?.t('Creating menu button for todo list items');
    return MenuAnchor(
      // style: MenuStyle(maximumSize: MaterialStateProperty),
      menuChildren: [
        if (forPinnedTodos)
          MenuItemButton(
            onPressed: () {
              logger?.d('Unpinning ${todo.todo.id}');
              ref.read(todoMainScreenProvider.notifier).unpin(todo.todo.id);
            },
            child: const Text('Unpin'),
          ),
        if (!forPinnedTodos)
          MenuItemButton(
            onPressed: () {
              logger?.d('Pinning ${todo.todo.id}');
              ref.read(todoMainScreenProvider.notifier).pin(todo.todo.id);
            },
            child: const Text('Pin'),
          ),
        if (!forPinnedTodos && !forSubTask)
          MenuItemButton(
            onPressed: () {
              logger?.d('Removing ${todo.todo.id} from main screen');
              ref.read(todoMainScreenProvider.notifier).remove(todo.todo.id);
            },
            child: const Text('Remove from main Screen'),
          ),
        if (forPinnedTodos)
          MenuItemButton(
            onPressed: () {
              logger?.d('Editing ${todo.todo.id}');
              ref.read(todoMainScreenProvider.notifier).add(todo.todo.id);
            },
            child: const Text('Add to main Screen'),
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
