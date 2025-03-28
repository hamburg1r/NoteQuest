// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoModelImpl _$$TodoModelImplFromJson(Map<String, dynamic> json) =>
    _$TodoModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 3,
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
          .toList(),
    );

Map<String, dynamic> _$$TodoModelImplToJson(_$TodoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'priority': instance.priority,
      'tag': instance.tag,
      'state': _$TodoStateEnumMap[instance.state]!,
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'dueTime': instance.dueTime?.toIso8601String(),
      'subTasks': instance.subTasks,
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

String _$todoListHash() => r'13170323e0726bbfc2fc33cd93c48f42800cf8da';

/// See also [TodoList].
@ProviderFor(TodoList)
final todoListProvider =
    AutoDisposeNotifierProvider<TodoList, List<TodoModel>>.internal(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoList = AutoDisposeNotifier<List<TodoModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
