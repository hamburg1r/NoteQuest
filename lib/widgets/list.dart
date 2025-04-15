import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nil/nil.dart';
import 'package:notequest/utils.dart';

import '../models/todo.dart';

class TodoTiles extends ConsumerWidget {
  final Map<String, TodoPair>? pinned;
  final Map<String, TodoPair>? nonPinned;
  final Widget leading;
  final Widget whenEmpty;
  final Widget trailing;
  final Function(TodoPair)? menu;

  final Logger? logger;

  const TodoTiles({
    this.pinned,
    this.nonPinned,
    this.leading = nil,
    this.whenEmpty = nil,
    this.trailing = nil,
    this.menu,
    super.key,
    this.logger,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger?.t('Running TodoTiles build method');
    if ((pinned?.isEmpty ?? true) && (nonPinned?.isEmpty ?? true)) {
      logger?.d('No data available for building the list');
      return whenEmpty;
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            if (pinned?.isNotEmpty ?? false) ...[
              Text(
                'Pinned:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              todoList(pinned!),
            ],
            if (nonPinned?.isNotEmpty ?? false) ...[
              if (pinned?.isNotEmpty ?? false)
                Text(
                  'Unpinned:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              todoList(nonPinned!),
            ],
          ]),
        ),
      ],
    );
  }

  ListView todoList(Map<String, TodoPair> todos) {
    List<String> todoList = todos.keys.toList();
    logger?.t('Building todoList');
    logger?.i(todos);
    return ListView.separated(
      itemCount: todos.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        String id = todoList[index];
        TodoPair todoPair = todos[id]!;
        return ListTile(
          leading: Text((index).toString()),
          title: Row(
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
            logger: logger,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
}

class _TodoDetails extends StatelessWidget {
  const _TodoDetails({
    // ignore: unused_element
    super.key,
    required this.todo,
    this.logger,
  });

  final TodoPair todo;
  final Logger? logger;

  @override
  Widget build(BuildContext context) {
    final subtextColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(150);
    final subtextTextStyle =
        Theme.of(context).textTheme.labelSmall!.copyWith(color: subtextColor);

    logger?.i(Theme.of(context).textTheme.labelSmall?.fontSize);

    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(todo.todo.state.name.toUpperCase()),
            Row(
              children: [
                Container(
                  height: Theme.of(context).textTheme.bodySmall?.fontSize,
                  width: Theme.of(context).textTheme.bodySmall?.fontSize,
                  // height: 20,
                  // width: 20,
                  decoration: BoxDecoration(
                    color: todo.todo.priority.color,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(todo.todo.priority.toString()),
              ],
            )
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
