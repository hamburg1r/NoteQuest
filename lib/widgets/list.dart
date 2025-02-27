import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoTiles extends StatelessWidget {
	final List<TodoModel> data;
	const TodoTiles(this.data, {super.key});

	@override
	Widget build(BuildContext context) {
		return ListView.separated(
			itemCount: data.length,
			itemBuilder: (BuildContext context, int index) {
				return ListTile(
					titleAlignment: ListTileTitleAlignment.top,
					// leading: , // todo icon possibly?
					title: Text(data[index].title),
					subtitle: Row(
						children: <Widget>[
							Text(data[index].scheduledTime.toString())
						],
					),
				);
			},
			separatorBuilder: (BuildContext context, int index) => Divider(),
		);
	}
}
