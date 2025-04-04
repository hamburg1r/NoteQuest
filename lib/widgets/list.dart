import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart';
import 'package:notequest/screens/todoform.dart';
import 'package:notequest/utils.dart';

import '../models/todo.dart';

class TodoTiles extends ConsumerWidget {
  final Map<dynamic, TodoPair>? data;
  final Widget leading;
  final Widget whenEmpty;
  final Widget trailing;
  final Function(TodoPair)? menu;
  const TodoTiles({
    this.data,
    this.leading = nil,
    this.whenEmpty = nil,
    this.trailing = nil,
    this.menu,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data?.isNotEmpty ?? false) {
      return ListView.separated(
        itemCount: data!.length,
        itemBuilder: (BuildContext context, int index) {
          print(index);
          String id = data!.keys.toList()[index];
          TodoPair todoPair = data![id]!;
          return ListTile(
            leading: Text((index).toString()),
            title: Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  todoPair.todo.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (menu != null) menu!(todoPair),
              ],
            ),
            subtitle: _TodoDetails(
              todo: todoPair,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      );
    } else {
      return whenEmpty;
    }
  }
}

class _TodoDetails extends StatelessWidget {
  const _TodoDetails({
    // ignore: unused_element
    super.key,
    required this.todo,
  });

  final TodoPair todo;

  @override
  Widget build(BuildContext context) {
    final subtextColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(150);
    final subtextTextStyle =
        Theme.of(context).textTheme.labelSmall!.copyWith(color: subtextColor);

    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(todo.todo.state.name.toUpperCase()),
            Text(todo.todo.priority.toString())
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Placeholder(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.todo.hasMarkdown)
                  Text(
                    style: subtextTextStyle,
                    '+ notes',
                  ),
                if (todo.todo.subTasks.isNotEmpty)
                  Text(
                    style: subtextTextStyle,
                    '${todo.todo.subTasks.length} subtasks',
                  ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                if (todo.todo.scheduledTime != null)
                  Row(
                    children: [
                      Icon(
                        color: subtextColor,
                        Icons.calendar_month,
                      ),
                      Text(
                        style: subtextTextStyle,
                        customDateFormat(
                          todo.todo.scheduledTime!,
                          true,
                        ),
                      ),
                    ],
                  ),
                if (todo.todo.dueTime != null)
                  Row(
                    children: [
                      Icon(
                        color: subtextColor,
                        Icons.schedule,
                      ),
                      Text(
                        style: subtextTextStyle,
                        customDateFormat(
                          todo.todo.dueTime!,
                          true,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        if (todo.todo.tag.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 5,
              children: <Widget>[
                for (String tag in todo.todo.tag)
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
    );
  }
}
