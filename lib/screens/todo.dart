import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todo_form.dart';
import 'package:notequest/screens/todo_view.dart';
import 'package:notequest/utils.dart';
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
    logger?.i('todoList recieved: $todoIds');
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
          // TODO: check after todo view is added
          if (!forPinnedTodos && !forSubTask)
            MenuItemButton(
              onPressed: () {
                logger?.d('Removing ${todo.todo.id} from main screen');
                ref.read(todoMainScreenProvider.notifier).add(todo.todo.id);
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
        nonPinnedMenu: genMenu(
          context: context,
          ref: ref,
          forPinnedTodos: false,
          forSubTask: false,
        ),
        pinnedMenu: genMenu(
          context: context,
          ref: ref,
          forPinnedTodos: true,
          forSubTask: false,
        ),
        pinned: getTodos(ref, 'pinned'),
        nonPinned: getTodos(ref, 'main'),
        onClick: (TodoPair todopair) => () {
          makeRoute(context, TodoView(todo: todopair.todo));
        },
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
          makeRoute(
            context,
            TodoForm(
              logger: logger,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
