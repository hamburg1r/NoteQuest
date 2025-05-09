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
      todo.copyWith(
        subTasks: [...todo.subTasks, childId],
      ).toJson(),
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
            subTasks: todo.subTasks.where((id) => id != childId).toList(),
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
    _todoBox.put(
      todo.id,
      todo.copyWith(
        parents: [...todo.parents, parentId],
      ).toJson(),
    );

    if (update) updateState();
  }

  void removeParent(
    TodoModel todo,
    String parentId, {
    bool update = true,
  }) {
    logger?.d('Removing parent: $parentId');
    _todoBox.put(
      todo.id,
      todo
          .copyWith(
            parents: todo.parents
                .where(
                  (id) => id != parentId,
                )
                .toList(),
          )
          .toJson(),
    );

    if (update) updateState();
  }

  // FIXME: add logic for passing either todomodel or id
  void addTodo(
    TodoModel todoModel, {
    String? markdown,
    TodoModel? parentModel,
    bool update = true,
  }) {
    logger?.t('Updating todos');
    _todoBox.put(todoModel.id, todoModel.toJson());
    if (parentModel != null) {
      logger?.d('Adding task to a parent');
      logger?.i('Parent: ${parentModel.id}');
      addParent(todoModel, parentModel.id, update: false);
      addSubTask(parentModel, todoModel.id, update: false);
    } else {
      logger?.d('Adding task to main screen');
      ref.read(todoMainScreenProvider.notifier).add(todoModel.id);
    }
    if (markdown != null) _todoMarkdowns.put(todoModel.id, markdown);
    if (update) updateState();
  }

  void removeTodo(
    TodoModel todo, {
    bool update = true,
  }) {
    logger?.t('Removing todo: ${todo.id}');
    for (String parent in todo.parents) {
      var parentTask = state[parent]!.todo;
      removeSubTask(parentTask, todo.id, update: false);
    }

    for (String subTask in todo.subTasks) {
      var subTaskTodo = state[subTask]!.todo;
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
