import 'package:flutter/material.dart';
import 'package:notequest/screens/todoform.dart';
import '../widgets/list.dart';

class Todo extends StatelessWidget {
  final Function(Text) appbar;
  const Todo(this.appbar, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(Text('Todo')),
      body: TodoTiles(),
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
