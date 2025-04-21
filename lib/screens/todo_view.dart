import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:notequest/models/todo.dart';
import 'package:notequest/screens/todo_form.dart';
import 'package:notequest/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(todo.title),
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
            onPressed: () {
              ref.read(todoListProvider.notifier).removeTodo(todo);
              // TODO: show parent todo or exit
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      // body: MarkdownWidget(
      //   shrinkWrap: true,
      //   data: ref.watch(todoListProvider)[todo.id]!.markdown!,
      // ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Text(
            todo.title,
          ),
          if (todo.hasMarkdown)
            MarkdownWidget(
              shrinkWrap: true,
              data: ref.watch(todoListProvider)[todo.id]!.markdown!,
            ),
        ],
      ),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       floating: true,
      //     ),
      //   ],
      // ),
    );
  }
}
