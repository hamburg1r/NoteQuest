import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

class TodoTiles extends ConsumerWidget {
  const TodoTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProvider = ref.watch(todoListProvider);
    final List<TodoModel> data = listProvider;
    if (data.isNotEmpty) {
      return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return TileWithOptions(
            icon: Text(index.toString()),
            title: Text(
              data[index].title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            summary: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  children: <Widget>[
                    for (String tag in data[index].tag)
                      InputChip(
                        // TODO: load saved avatar icons
                        avatar: Container(
                          decoration: BoxDecoration(
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            shape: BoxShape.circle,
                          ),
                        ),
                        label: Text(tag),
                      ),
                  ],
                ),
              ],
            ),
            todo: data[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      );
    } else {
      return Center(
          child: Text(
        "Press on + to add todo",
        style: Theme.of(context).textTheme.displaySmall,
      ));
    }
  }
}

class TileWithOptions extends ConsumerWidget {
  final Widget? title;
  final Widget? summary;
  final Widget? icon;
  final TodoModel todo;
  const TileWithOptions(
      {this.title, this.summary, this.icon, required this.todo, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      // leading: , // todo icon possibly?
      title: title,
      subtitle: summary,
      trailing: MenuAnchor(
        menuChildren: [
          MenuItemButton(
            onPressed: () {
              ref.read(todoListProvider.notifier).addTodo(
                    TodoModel(
                      id: 'asdf',
                      title: 'hello',
                    ),
                  );
              print(ref.watch(todoListProvider));
            },
            child: const Text('Shit'),
          ),
          MenuItemButton(
            onPressed: () {
              ref.read(todoListProvider.notifier).removeTodo(todo);
              print(ref.watch(todoListProvider));
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
      ),
    );
  }
}
