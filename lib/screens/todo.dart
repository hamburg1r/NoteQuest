import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todo_form.dart';
import 'package:notequest/screens/todo_view.dart';
import 'package:notequest/utils.dart';
import '../widgets/list.dart';

class Todo extends ConsumerWidget {
  final Function(Text, List<Widget>) appbar;
  final Logger? logger;
  const Todo(
    this.appbar, {
    super.key,
    this.logger,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> mainTodoIds = ref.watch(todoMainScreenProvider)['main'] ?? [];
    List<String> pinnedTodoIds =
        ref.watch(todoMainScreenProvider)['pinned'] ?? [];

    Map<String, TodoPair> todoList = ref.watch(todoListProvider);

    logger?.t('Running Todo build method');
    return Scaffold(
      appBar: appbar(
        Text('Todo'),
        [
          IconButton(
            onPressed: () {
              makeRoute(
                context,
                TodoView(
                  logger: logger,
                ),
              );
            },
            icon: Icon(Icons.notes),
            tooltip: "All notes",
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          TodoTiles(
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
            ),
            pinnedMenu: genMenu(
              context: context,
              ref: ref,
            ),
            pinned: pinnedTodoIds.isNotEmpty
                ? getTodos(
                    pinnedTodoIds,
                    todoList,
                    logger,
                  )
                : null,
            nonPinned: mainTodoIds.isNotEmpty
                ? getTodos(
                    mainTodoIds,
                    todoList,
                    logger,
                  )
                : null,
            onClick: (TodoPair todopair) => () {
              makeRoute(
                context,
                TodoView(
                  todo: todopair.todo,
                  logger: logger,
                ),
              );
            },
            logger: logger,
          ),
        ],
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
