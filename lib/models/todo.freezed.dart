// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) {
  return _TodoModel.fromJson(json);
}

/// @nodoc
mixin _$TodoModel {
  String get id => throw _privateConstructorUsedError;
  set id(String value) => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  TodoPriority get priority => throw _privateConstructorUsedError;
  set priority(TodoPriority value) => throw _privateConstructorUsedError;
  List<String> get tag => throw _privateConstructorUsedError;
  set tag(List<String> value) => throw _privateConstructorUsedError;
  TodoState get state => throw _privateConstructorUsedError;
  set state(TodoState value) => throw _privateConstructorUsedError;
  DateTime? get scheduledTime => throw _privateConstructorUsedError;
  set scheduledTime(DateTime? value) => throw _privateConstructorUsedError;
  DateTime? get dueTime => throw _privateConstructorUsedError;
  set dueTime(DateTime? value) => throw _privateConstructorUsedError;
  List<String> get subTasks => throw _privateConstructorUsedError;
  set subTasks(List<String> value) => throw _privateConstructorUsedError;
  List<String> get parents => throw _privateConstructorUsedError;
  set parents(List<String> value) => throw _privateConstructorUsedError;
  bool get hasMarkdown => throw _privateConstructorUsedError;
  set hasMarkdown(bool value) => throw _privateConstructorUsedError;

  /// Serializes this TodoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoModelCopyWith<TodoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoModelCopyWith<$Res> {
  factory $TodoModelCopyWith(TodoModel value, $Res Function(TodoModel) then) =
      _$TodoModelCopyWithImpl<$Res, TodoModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      TodoPriority priority,
      List<String> tag,
      TodoState state,
      DateTime? scheduledTime,
      DateTime? dueTime,
      List<String> subTasks,
      List<String> parents,
      bool hasMarkdown});
}

/// @nodoc
class _$TodoModelCopyWithImpl<$Res, $Val extends TodoModel>
    implements $TodoModelCopyWith<$Res> {
  _$TodoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? priority = null,
    Object? tag = null,
    Object? state = null,
    Object? scheduledTime = freezed,
    Object? dueTime = freezed,
    Object? subTasks = null,
    Object? parents = null,
    Object? hasMarkdown = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TodoPriority,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as List<String>,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as TodoState,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueTime: freezed == dueTime
          ? _value.dueTime
          : dueTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subTasks: null == subTasks
          ? _value.subTasks
          : subTasks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parents: null == parents
          ? _value.parents
          : parents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasMarkdown: null == hasMarkdown
          ? _value.hasMarkdown
          : hasMarkdown // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodoModelImplCopyWith<$Res>
    implements $TodoModelCopyWith<$Res> {
  factory _$$TodoModelImplCopyWith(
          _$TodoModelImpl value, $Res Function(_$TodoModelImpl) then) =
      __$$TodoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      TodoPriority priority,
      List<String> tag,
      TodoState state,
      DateTime? scheduledTime,
      DateTime? dueTime,
      List<String> subTasks,
      List<String> parents,
      bool hasMarkdown});
}

/// @nodoc
class __$$TodoModelImplCopyWithImpl<$Res>
    extends _$TodoModelCopyWithImpl<$Res, _$TodoModelImpl>
    implements _$$TodoModelImplCopyWith<$Res> {
  __$$TodoModelImplCopyWithImpl(
      _$TodoModelImpl _value, $Res Function(_$TodoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? priority = null,
    Object? tag = null,
    Object? state = null,
    Object? scheduledTime = freezed,
    Object? dueTime = freezed,
    Object? subTasks = null,
    Object? parents = null,
    Object? hasMarkdown = null,
  }) {
    return _then(_$TodoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TodoPriority,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as List<String>,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as TodoState,
      scheduledTime: freezed == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dueTime: freezed == dueTime
          ? _value.dueTime
          : dueTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      subTasks: null == subTasks
          ? _value.subTasks
          : subTasks // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parents: null == parents
          ? _value.parents
          : parents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasMarkdown: null == hasMarkdown
          ? _value.hasMarkdown
          : hasMarkdown // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodoModelImpl with DiagnosticableTreeMixin implements _TodoModel {
  _$TodoModelImpl(
      {required this.id,
      required this.title,
      this.priority = TodoPriority.low,
      this.tag = const [],
      this.state = TodoState.todo,
      this.scheduledTime,
      this.dueTime,
      this.subTasks = const [],
      this.parents = const [],
      this.hasMarkdown = false});

  factory _$TodoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoModelImplFromJson(json);

  @override
  String id;
  @override
  String title;
  @override
  @JsonKey()
  TodoPriority priority;
  @override
  @JsonKey()
  List<String> tag;
  @override
  @JsonKey()
  TodoState state;
  @override
  DateTime? scheduledTime;
  @override
  DateTime? dueTime;
  @override
  @JsonKey()
  List<String> subTasks;
  @override
  @JsonKey()
  List<String> parents;
  @override
  @JsonKey()
  bool hasMarkdown;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TodoModel(id: $id, title: $title, priority: $priority, tag: $tag, state: $state, scheduledTime: $scheduledTime, dueTime: $dueTime, subTasks: $subTasks, parents: $parents, hasMarkdown: $hasMarkdown)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TodoModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('priority', priority))
      ..add(DiagnosticsProperty('tag', tag))
      ..add(DiagnosticsProperty('state', state))
      ..add(DiagnosticsProperty('scheduledTime', scheduledTime))
      ..add(DiagnosticsProperty('dueTime', dueTime))
      ..add(DiagnosticsProperty('subTasks', subTasks))
      ..add(DiagnosticsProperty('parents', parents))
      ..add(DiagnosticsProperty('hasMarkdown', hasMarkdown));
  }

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoModelImplCopyWith<_$TodoModelImpl> get copyWith =>
      __$$TodoModelImplCopyWithImpl<_$TodoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoModelImplToJson(
      this,
    );
  }
}

abstract class _TodoModel implements TodoModel {
  factory _TodoModel(
      {required String id,
      required String title,
      TodoPriority priority,
      List<String> tag,
      TodoState state,
      DateTime? scheduledTime,
      DateTime? dueTime,
      List<String> subTasks,
      List<String> parents,
      bool hasMarkdown}) = _$TodoModelImpl;

  factory _TodoModel.fromJson(Map<String, dynamic> json) =
      _$TodoModelImpl.fromJson;

  @override
  String get id;
  set id(String value);
  @override
  String get title;
  set title(String value);
  @override
  TodoPriority get priority;
  set priority(TodoPriority value);
  @override
  List<String> get tag;
  set tag(List<String> value);
  @override
  TodoState get state;
  set state(TodoState value);
  @override
  DateTime? get scheduledTime;
  set scheduledTime(DateTime? value);
  @override
  DateTime? get dueTime;
  set dueTime(DateTime? value);
  @override
  List<String> get subTasks;
  set subTasks(List<String> value);
  @override
  List<String> get parents;
  set parents(List<String> value);
  @override
  bool get hasMarkdown;
  set hasMarkdown(bool value);

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoModelImplCopyWith<_$TodoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
