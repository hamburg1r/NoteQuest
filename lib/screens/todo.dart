import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todoform.dart';
import '../widgets/list.dart';

class Todo extends ConsumerWidget {
  final Function(Text) appbar;
  const Todo(this.appbar, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          return MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  //ref.read(todoListProvider.notifier).removeTodo(todo);
                  todoFormPage(context, id: todo.todo.id);
                },
                child: const Text('Edit'),
              ),
              MenuItemButton(
                onPressed: () {
                  ref.read(todoListProvider.notifier).removeTodo(todo.todo);
                },
                child: const Text('Delete'),
              ),
            ],
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                //focusNode: _buttonFocusNode,
                onPressed: () {
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
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        //onPressed: () => showModalBottomSheet(
        //	context: context,
        //	enableDrag: true,
        //	isScrollControlled: true,
        //	builder: (ctx) => AddTodo()
        //),
        onPressed: () => todoFormPage(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
