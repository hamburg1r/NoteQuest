// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoModelImpl _$$TodoModelImplFromJson(Map<String, dynamic> json) =>
    _$TodoModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: $enumDecodeNullable(_$TodoPriorityEnumMap, json['priority']) ??
          TodoPriority.low,
      tag: (json['tag'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      state: $enumDecodeNullable(_$TodoStateEnumMap, json['state']) ??
          TodoState.todo,
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
      dueTime: json['dueTime'] == null
          ? null
          : DateTime.parse(json['dueTime'] as String),
      subTasks: (json['subTasks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parents: (json['parents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasMarkdown: json['hasMarkdown'] as bool? ?? false,
    );

Map<String, dynamic> _$$TodoModelImplToJson(_$TodoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'priority': _$TodoPriorityEnumMap[instance.priority]!,
      'tag': instance.tag,
      'state': _$TodoStateEnumMap[instance.state]!,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'dueTime': instance.dueTime?.toIso8601String(),
      'subTasks': instance.subTasks,
      'parents': instance.parents,
      'hasMarkdown': instance.hasMarkdown,
    };

const _$TodoPriorityEnumMap = {
  TodoPriority.low: 'low',
  TodoPriority.medium: 'medium',
  TodoPriority.high: 'high',
  TodoPriority.urgent: 'urgent',
};

const _$TodoStateEnumMap = {
  TodoState.todo: 'todo',
  TodoState.doing: 'doing',
  TodoState.done: 'done',
  TodoState.next: 'next',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListHash() => r'84769f1ff862ea213b7567cced9610762bb8b51c';

/// See also [TodoList].
@ProviderFor(TodoList)
final todoListProvider =
    AutoDisposeNotifierProvider<TodoList, Map<String, TodoPair>>.internal(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoList = AutoDisposeNotifier<Map<String, TodoPair>>;
String _$todoMainScreenHash() => r'ab66dbe467a80c2bc962a2455bab88a3da84041a';

/// See also [TodoMainScreen].
@ProviderFor(TodoMainScreen)
final todoMainScreenProvider = AutoDisposeNotifierProvider<TodoMainScreen,
    Map<String, List<String>>>.internal(
  TodoMainScreen.new,
  name: r'todoMainScreenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoMainScreenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoMainScreen = AutoDisposeNotifier<Map<String, List<String>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
