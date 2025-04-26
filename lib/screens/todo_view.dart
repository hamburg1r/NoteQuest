import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todo_form.dart';
import 'package:notequest/utils.dart';
import 'package:notequest/widgets/list.dart';

class TodoView extends ConsumerStatefulWidget {
  const TodoView({
    required this.todo,
    this.parents = const [],
    this.logger,
    super.key,
  });

  final TodoModel todo;
  final List<String> parents;
  final Logger? logger;

  @override
  ConsumerState<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends ConsumerState<TodoView> {
  late TodoModel todo = widget.todo;
  late List<String> parents = widget.parents;
  late Logger? logger = widget.logger;

  void setCurrentFromID(String todoId) {
    try {
      // logger?.t()
      setState(() {
        todo = ref.watch(todoListProvider)[todoId]!.todo;
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
    parents.add(todo.id);
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
    previousOrExit();
    ref.read(todoListProvider.notifier).removeTodo(todo);
  }

  @override
  Widget build(BuildContext context) {
    final String? markdown = ref.watch(todoListProvider)[todo.id]?.markdown;
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
        actions: [
          IconButton(
            onPressed: () {
              makeRoute(
                context,
                TodoForm(
                  id: todo.id,
                  logger: logger,
                ),
              );
              setState(() {});
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: deleteCurrent,
            icon: Icon(Icons.delete),
          )
        ],
      ),
      // body: MarkdownWidget(
      //   shrinkWrap: true,
      //   data: markdown!,
      // ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Text(
            todo.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Spacer(),
          if (todo.hasMarkdown)
            MarkdownWidget(
              shrinkWrap: true,
              data: markdown!,
            ),
          TodoTiles(
              // nonPinned: todo.subTasks,
              ),
        ],
      ),
    );
  }
}
