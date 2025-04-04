import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoState {
  todo,
  doing,
  done,
  next,
}

@unfreezed
class TodoModel with _$TodoModel {
  factory TodoModel({
    required String id,
    required String title,
    @Default(3) int priority,
    @Default([]) List<String> tag,
    @Default(TodoState.todo) TodoState state,
    DateTime? scheduledTime,
    DateTime? dueTime,
    @Default([]) List<String> subTasks,
    @Default(false) bool hasMarkdown,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}

class TodoPair {
  final TodoModel todo;
  final String? description;
  String? get markdown => description;

  const TodoPair(this.todo, [this.description]);
}

@riverpod
//Box<TodoModel> todoList(Ref ref) => Hive.box<TodoModel>('todos');
class TodoList extends _$TodoList {
  late final _todoBox = Hive.box('todos');
  late final _todoMarkdowns = Hive.box('markdowns');

  // FIXME: needs to be future maybe???
  @override
  Map<dynamic, TodoPair> build() {
    return updateState();
  }

  void updateTodos(TodoModel todo, [String? text]) {
    _todoBox.put(todo.id, todo.toJson());
    _todoMarkdowns.put(todo.id, text);
    updateState();
  }

  void removeTodo(TodoModel todo) {
    // TODO: undo mechanism and handle main menu todo list
    _todoBox.delete(todo.id);
    _todoMarkdowns.delete(todo.id);
    updateState();
  }

  //Future<Map<dynamic, dynamic>> updateState() async {
  Map<dynamic, TodoPair> updateState() {
    var markdowns = _todoMarkdowns.toMap();
    state = _todoBox.toMap().map((key, value) {
      // TODO: check if mapentry is equivalent to {}
      return MapEntry(
        key,
        TodoPair(
          TodoModel.fromJson(value),
          markdowns[key],
        ),
      );
    });
    return state;
  }
}
