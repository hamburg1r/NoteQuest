import 'package:freezed_annotation/freezed_annotation.dart';
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
    List<String>? subTasks,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}

@riverpod
class TodoList extends _$TodoList {
  // TODO: Create map which uses map to save todo data: priority moderate
  @override
  List<TodoModel> build() {
    return <TodoModel>[];
  }

  void addTodo(TodoModel todo) {
    // TODO: Saving mechanism: priority low
    state = [...state, todo];
  }

  void removeTodo(TodoModel todo) {
    // TODO: Deleting mechanism: priority low
    state = List.from(state)..remove(todo);
  }
}
