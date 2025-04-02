import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notequest/screens/addtodo.dart';
import 'package:notequest/utils.dart';
import '../models/todo.dart';

class TodoTiles extends ConsumerWidget {
  const TodoTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProvider = ref.watch(todoListProvider);
    final Map<dynamic, TodoModel> data = listProvider;

    final subtextColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(150);
    final subtextTextStyle =
        Theme.of(context).textTheme.labelSmall!.copyWith(color: subtextColor);

    if (data.isNotEmpty) {
      return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var id = data.keys.toList()[index];
          var todo = data[id]!;
          return ListTile(
            leading: Text((index + 1).toString()),
            title: Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todo.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                MenuAnchor(
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        //ref.read(todoListProvider.notifier).removeTodo(todo);
                        todoFormPage(context, id: id);
                        print(ref.watch(todoListProvider));
                      },
                      child: const Text('Edit'),
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
              ],
            ),
            subtitle: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(todo.state.name.toUpperCase()),
                    Text(todo.priority.toString())
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Placeholder(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO: make this permanent: priority high
                        Text(
                          style: subtextTextStyle,
                          '+ notes',
                        ),
                        Text(
                          style: subtextTextStyle,
                          '0 subtasks',
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        if (todo.scheduledTime != null)
                          Row(
                            children: [
                              Icon(
                                color: subtextColor,
                                Icons.calendar_month,
                              ),
                              Text(
                                style: subtextTextStyle,
                                customDateFormat(
                                  todo.scheduledTime!,
                                  true,
                                ),
                              ),
                            ],
                          ),
                        if (todo.dueTime != null)
                          Row(
                            children: [
                              Icon(
                                color: subtextColor,
                                Icons.schedule,
                              ),
                              Text(
                                style: subtextTextStyle,
                                customDateFormat(
                                  todo.dueTime!,
                                  true,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                if (todo.tag.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 5,
                      children: <Widget>[
                        for (String tag in todo.tag)
                          InputChip(
                            // TODO: load saved avatar icons: priority low
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
                  ),
              ],
            ),
            //todo: todo,
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
