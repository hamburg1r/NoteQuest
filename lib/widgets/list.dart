import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';

class TodoTiles extends ConsumerWidget {
  const TodoTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProvider = ref.watch(todoListProvider);
    final List<TodoModel>? data = listProvider.valueOrNull;
    if (data != null && data.isNotEmpty) {
      return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return TileWithOptions();
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

class TileWithOptions extends StatelessWidget {
  final Widget? title;
  final Widget? summary;
  final Widget? icon;
  const TileWithOptions({this.title, this.summary, this.icon, super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      // leading: , // todo icon possibly?
      title: title,
      subtitle: summary,
    );
  }
}
