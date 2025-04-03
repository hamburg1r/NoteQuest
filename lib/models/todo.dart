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
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) @Default(3) int priority,
    @HiveField(3) @Default([]) List<String> tag,
    @HiveField(4) @Default(TodoState.todo) TodoState state,
    @HiveField(5) DateTime? scheduledTime,
    @HiveField(6) DateTime? dueTime,
    @HiveField(7) List<String>? subTasks,
    @HiveField(8) @Default(false) bool hasMarkdown,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}

@riverpod
//Box<TodoModel> todoList(Ref ref) => Hive.box<TodoModel>('todos');
class TodoList extends _$TodoList {
  late final _todoBox = Hive.box('todos');

  // FIXME: needs to be future maybe???
  @override
  Map<dynamic, TodoModel> build() {
    return updateState();
  }

  void updateTodos(TodoModel todo) {
    _todoBox.put(todo.id, todo.toJson());
    updateState();
  }

  void removeTodo(TodoModel todo) {
    // TODO: Deleting mechanism: priority low
    _todoBox.delete(todo.id);
    updateState();
  }

  //Future<Map<dynamic, dynamic>> updateState() async {
  Map<dynamic, TodoModel> updateState() {
    state = _todoBox.toMap().map((key, value) {
      return MapEntry(key, TodoModel.fromJson(value));
    });
    return state;
  }
}
