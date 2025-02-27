import 'package:flutter/material.dart';
import '../widgets/list.dart';

class Todo extends StatelessWidget {
	const Todo({super.key});

	@override
	Widget build(BuildContext context) {
		return TodoTiles();
	}
}
