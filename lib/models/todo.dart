import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoState {
  todo,
  doing,
  done,
  next,
}

enum TodoPriority {
  low(Colors.green),
  medium(Colors.blue),
  high(Colors.orange),
  urgent(Colors.red);

  final MaterialColor color;
  const TodoPriority(this.color);
}

@unfreezed
class TodoModel with _$TodoModel {
  factory TodoModel({
    required String id,
    required String title,
    @Default(TodoPriority.low) TodoPriority priority,
    @Default([]) List<String> tag,
    @Default(TodoState.todo) TodoState state,
    DateTime? scheduledTime,
    DateTime? dueTime,
    @Default([]) List<String> subTasks,
    @Default([]) List<String> parents,
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
class TodoList extends _$TodoList {
  late final Box<Map<dynamic, dynamic>> _todoBox =
      Hive.box<Map<dynamic, dynamic>>('todos');
  late final Box<String> _todoMarkdowns = Hive.box<String>('markdowns');
  late final Logger? logger = kDebugMode ? Logger() : null;

  // FIXME: needs to be future maybe???
  @override
  Map<String, TodoPair> build() {
    logger?.t('Initial state set');
    return updateState();
  }

  void addSubTask(
    TodoModel todo,
    String childId, {
    bool update = true,
  }) {
    logger?.d('Adding $childId to ${todo.toString()}');
    _todoBox.put(
      todo.id,
      todo
          .copyWith(
            subTasks: todo.subTasks..add(childId),
          )
          .toJson(),
    );
    if (update) updateState();
  }

  void removeSubTask(
    TodoModel todo,
    String childId, {
    bool update = true,
  }) {
    logger?.d('Removing $childId from ${todo.toString()}');
    _todoBox.put(
      todo.id,
      todo
          .copyWith(
            subTasks: todo.subTasks..remove(childId),
          )
          .toJson(),
    );
    if (update) updateState();
  }

  void addParent(
    TodoModel todo,
    String parentId, {
    bool update = true,
  }) {
    logger?.d('Adding parent: $parentId');
    todo.parents.add(parentId);
    _todoBox.put(todo.id, todo.toJson());
    if (update) updateState();
  }

  void removeParent(
    TodoModel todo,
    String parentId, {
    bool update = true,
  }) {
    logger?.d('Removing parent: $parentId');
    todo.parents.remove(parentId);
    _todoBox.put(todo.id, todo.toJson());
    if (update) updateState();
  }

  void addTodo(
    TodoModel todo, {
    String? markdown,
    TodoModel? parent,
    bool update = true,
  }) {
    logger?.t('Updating todos');
    _todoBox.put(todo.id, todo.toJson());
    if (parent != null) {
      logger?.d('Adding task to a parent');
      logger?.i('Parent: ${parent.id}');
      addParent(todo, parent.id, update: false);
      addSubTask(parent, todo.id, update: false);
    } else {
      logger?.d('Adding task to main screen');
      ref.read(todoMainScreenProvider.notifier).add(todo.id);
    }
    if (markdown != null) _todoMarkdowns.put(todo.id, markdown);
    if (update) updateState();
  }

  void removeTodo(
    TodoModel todo, {
    bool update = true,
  }) {
    logger?.t('Removing todo: ${todo.id}');
    for (String parent in todo.parents) {
      var parentTask = ref.watch(todoListProvider)[parent]!.todo;
      removeSubTask(parentTask, todo.id, update: false);
    }

    for (String subTask in todo.subTasks) {
      var subTaskTodo = ref.watch(todoListProvider)[subTask]!.todo;
      removeParent(subTaskTodo, todo.id, update: false);
    }
    ref.read(todoMainScreenProvider.notifier).remove(todo.id);
    _todoBox.delete(todo.id);
    _todoMarkdowns.delete(todo.id);
    if (update) updateState();
  }

  //Future<Map<dynamic, dynamic>> updateState() async {
  Map<String, TodoPair> updateState() {
    logger?.t('Updating state');
    state = {};
    logger?.t('cleared state variable');
    logger?.t('running for each');
    for (String key in _todoBox.keys) {
      logger?.i('Got k: $key');
      state[key] = TodoPair(
        TodoModel.fromJson(_todoBox.get(key)!.cast<String, dynamic>()),
        _todoMarkdowns.get(key),
      );
    }
    // logger?.d('Got todos for type: $type');
    logger?.i(state);
    return state;
  }
}

@riverpod
class TodoMainScreen extends _$TodoMainScreen {
  late final Box<List<String>> _mainScreenTodos =
      Hive.box<List<String>>('mainScreenTodos');
  late final List<String> _main = _mainScreenTodos.get('main') ?? [];
  late final List<String> _pinned = _mainScreenTodos.get('pinned') ?? [];
  late final Logger? logger = kDebugMode ? Logger() : null;

  // FIXME: Future?
  @override
  Map<String, List<String>> build() {
    return updateState();
  }

  void add(
    String id, {
    bool update = true,
  }) {
    logger?.i('Adding $id');
    if (_main.contains(id)) return;
    _main.add(id);
    if (update) updateState();
  }

  void remove(
    String id, {
    bool update = true,
  }) {
    logger?.i('Removing $id');
    _main.remove(id);
    _pinned.remove(id);
    if (update) updateState();
  }

  void pin(
    String id, {
    bool keepMain = false,
    bool update = true,
  }) {
    logger?.i('Pining $id');
    if (_pinned.contains(id)) return;
    if (!keepMain) _main.remove(id);
    _pinned.add(id);
    if (update) updateState();
  }

  void unpin(
    String id, {
    bool update = true,
  }) {
    logger?.i('Unpinning $id');
    if (ref.watch(todoListProvider)[id]?.todo.parents.isEmpty ?? false) {
      add(id, update: false);
    }
    _pinned.remove(id);
    if (update) updateState();
  }

  Map<String, List<String>> updateState() {
    logger?.d('Updating State');
    _mainScreenTodos.put('main', _main);
    _mainScreenTodos.put('pinned', _pinned);
    state = {
      'main': _main,
      'pinned': _pinned,
    };
    logger?.i(state);
    return state;
  }
}
