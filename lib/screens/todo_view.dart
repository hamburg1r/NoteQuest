import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:nil/nil.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todo_form.dart';
import 'package:notequest/utils.dart';
import 'package:notequest/widgets/list.dart';

class TodoView extends ConsumerStatefulWidget {
  const TodoView({
    this.todo,
    this.parents = const [],
    this.logger,
    super.key,
  });

  final TodoModel? todo;
  final List<String> parents;
  final Logger? logger;

  @override
  ConsumerState<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends ConsumerState<TodoView> {
  late TodoModel? todo = widget.todo;
  late List<String> parents = widget.parents;
  late List<String> taskList = [];
  late String? markdown;
  late final Logger? logger = widget.logger;
  Map<String, TodoPair> todos = {};

  void setCurrentFromID(String todoId) {
    try {
      // logger?.t()
      setState(() {
        todo = todos[todoId]!.todo;
      });
    } catch (nullError) {
      ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('$todoId not found!!'),
        ),
      );
    }
  }

  void openChild(String todoId) {
    if (todo != null) {
      parents = [...parents, todo!.id];
    }
    setCurrentFromID(todoId);
  }

  void previousOrExit() {
    if (parents.isEmpty) {
      logger?.t('Going to previous Screen');
      Navigator.of(context).pop();
      return;
    } else {
      logger?.t('Going up the parent tree');
      setCurrentFromID(parents.last);
    }
    parents.removeLast();
  }

  void deleteCurrent() {
    var trash = todo!;
    previousOrExit();
    ref.read(todoListProvider.notifier).removeTodo(trash);
  }

  Widget addTodoButton() {
    return FilledButton.tonal(
      onPressed: () {
        logger?.t('Calling todoFormPage for adding new todo');
        makeRoute(
          context,
          TodoForm(
            parent: todo,
            logger: logger,
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    todos = ref.watch(todoListProvider);
    todo = todos[todo?.id]?.todo;
    if (todo != null) {
      markdown = todos[todo!.id]?.markdown;
      taskList = todo!.subTasks;
    } else {
      markdown = null;
      taskList = [];
    }
    return Scaffold(
      appBar: AppBar(
        // title: Text(todo.title),
        leading: IconButton(
          onPressed: () {
            logger?.t('Back button pressed');
            previousOrExit();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: todo == null ? Text("Available todos") : null,
        actions: [
          if (todo != null)
            IconButton(
              onPressed: () {
                makeRoute(
                  context,
                  TodoForm(
                    id: todo!.id,
                    logger: logger,
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
          if (todo != null) ...[
            IconButton(
              onPressed: deleteCurrent,
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                makeRoute(
                  context,
                  TodoInfo(
                    todo: todo!,
                    logger: logger,
                  ),
                );
              },
              icon: Icon(Icons.info),
            ),
          ],
        ],
      ),
      // body: MarkdownWidget(
      //   shrinkWrap: true,
      //   data: markdown!,
      // ),
      body: CustomScrollView(
        slivers: [
          if (todo != null)
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Text(
                  todo!.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Divider(),
                if (todo!.hasMarkdown) ...[
                  MarkdownWidget(
                    shrinkWrap: true,
                    data: markdown!,
                  ),
                  Divider(),
                ],
              ]),
            ),
          TodoTiles(
            onClick: (todopair) => () {
              openChild(todopair.todo.id);
            },
            whenEmpty: todo != null
                ? addTodoButton()
                : Center(
                    child: Text(
                      "No todos available",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
            trailing: todo != null ? addTodoButton() : nil,
            nonPinned: taskList.isNotEmpty || todo == null
                ? getTodos(
                    taskList,
                    todos,
                  )
                : null,
            nonPinnedMenu: genMenu(
              context: context,
              ref: ref,
              parent: todo?.id,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox.square(
              dimension: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class TodoInfo extends StatelessWidget {
  const TodoInfo({
    required this.todo,
    super.key,
    this.logger,
  });
  final TodoModel todo;
  final Logger? logger;

  @override
  Widget build(BuildContext context) {
    logger?.i("Using Todo: $todo");
    var textStyle = Theme.of(context).textTheme;
    tile(String title, String info) {
      return [
        Text(
          title,
          style: textStyle.headlineSmall,
        ),
        Text(
          info,
          style: textStyle.labelLarge,
        ),
        Divider(),
      ];
    }

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ...tile("ID:", todo.id),
          if (todo.parents.isNotEmpty)
            ...tile("Parents:", todo.parents.join('\n')),
          if (todo.subTasks.isNotEmpty)
            ...tile("Parents:", todo.subTasks.join('\n')),
          if (todo.scheduledTime != null)
            ...tile("Scheduled Time", customDateFormat(todo.scheduledTime!)),
          if (todo.dueTime != null)
            ...tile("Due Time", customDateFormat(todo.dueTime!)),
          ...tile("State", todo.state.name.toUpperCase()),
          ...tile("Priority", todo.priority.name.toUpperCase()),
          if (todo.hasMarkdown) ...[
            Text(
              "Contains markdown",
              style: textStyle.headlineSmall,
            ),
            Divider()
          ],
        ],
        // children: [
        //   // title("ID:"),
        //   // info(todo.id),
        //   // Divider(),
        //   // title("ID:"),
        //   // ...tile("ID", todo.id),
        // ],
      ),
    );
  }
}
