import 'package:flutter/material.dart';
import 'package:notequest/screens/addtodo.dart';
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
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Add Todo'),
                ),
                body: SafeArea(child: AddTodo()),
              ),
            )),
        child: Icon(Icons.add),
      ),
    );
  }
}
