import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todoform.dart';
import '../widgets/list.dart';

class Todo extends ConsumerWidget {
  final Function(Text) appbar;
  final Logger? logger;
  const Todo(
    this.appbar, {
    super.key,
    this.logger,
  });

  // FIXME: Future?
  Map<String, TodoPair>? getTodos(WidgetRef ref, String type) {
    List<String> todoIds = ref.watch(todoMainScreenProvider)[type] ?? [];
    logger?.i('todoIds recieved: $todoIds');
    Map<String, TodoPair> todoList = ref.watch(todoListProvider);
    logger?.t('retrived all todos');
    Map<String, TodoPair> out = {};
    logger?.i('$todoList');
    for (String id in todoIds) {
      logger?.i('checking for $id got:${todoList[id].toString()}');
      out[id] = todoList[id]!;
    }
    if (out.isEmpty) return null;
    logger?.d('Got todos for type: $type');
    logger?.i(out);
    return out;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger?.t('Running Todo build method');
    return Scaffold(
      appBar: appbar(Text('Todo')),
      body: TodoTiles(
        //leading: Text('leading'),
        //trailing: Text('trailing'),
        whenEmpty: Center(
          child: Text(
            "Press on + to add todo",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        menu: (TodoPair todo) {
          logger?.t('Creating menu button for todo list items');
          return MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  logger?.d('Editing ${todo.todo.id}');
                  todoFormPage(context, id: todo.todo.id);
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
        },
        pinned: getTodos(ref, 'pinned'),
        nonPinned: getTodos(ref, 'main'),
        logger: logger,
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        //onPressed: () => showModalBottomSheet(
        //	context: context,
        //	enableDrag: true,
        //	isScrollControlled: true,
        //	builder: (ctx) => AddTodo()
        //),
        onPressed: () {
          logger?.t('Calling todoFormPage for adding new todo');
          todoFormPage(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
