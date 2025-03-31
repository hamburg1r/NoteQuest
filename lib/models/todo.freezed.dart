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
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(0)
  set id(String value) => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(1)
  set title(String value) => throw _privateConstructorUsedError;
  @HiveField(2)
  int get priority => throw _privateConstructorUsedError;
  @HiveField(2)
  set priority(int value) => throw _privateConstructorUsedError;
  @HiveField(3)
  List<String> get tag => throw _privateConstructorUsedError;
  @HiveField(3)
  set tag(List<String> value) => throw _privateConstructorUsedError;
  @HiveField(4)
  TodoState get state => throw _privateConstructorUsedError;
  @HiveField(4)
  set state(TodoState value) => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get scheduledTime => throw _privateConstructorUsedError;
  @HiveField(5)
  set scheduledTime(DateTime? value) => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get dueTime => throw _privateConstructorUsedError;
  @HiveField(6)
  set dueTime(DateTime? value) => throw _privateConstructorUsedError;
  @HiveField(7)
  List<String>? get subTasks => throw _privateConstructorUsedError;
  @HiveField(7)
  set subTasks(List<String>? value) => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get hasMarkdown => throw _privateConstructorUsedError;
  @HiveField(8)
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
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) int priority,
      @HiveField(3) List<String> tag,
      @HiveField(4) TodoState state,
      @HiveField(5) DateTime? scheduledTime,
      @HiveField(6) DateTime? dueTime,
      @HiveField(7) List<String>? subTasks,
      @HiveField(8) bool hasMarkdown});
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
    Object? subTasks = freezed,
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
              as int,
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
      subTasks: freezed == subTasks
          ? _value.subTasks
          : subTasks // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) int priority,
      @HiveField(3) List<String> tag,
      @HiveField(4) TodoState state,
      @HiveField(5) DateTime? scheduledTime,
      @HiveField(6) DateTime? dueTime,
      @HiveField(7) List<String>? subTasks,
      @HiveField(8) bool hasMarkdown});
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
    Object? subTasks = freezed,
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
              as int,
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
      subTasks: freezed == subTasks
          ? _value.subTasks
          : subTasks // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hasMarkdown: null == hasMarkdown
          ? _value.hasMarkdown
          : hasMarkdown // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodoModelImpl implements _TodoModel {
  _$TodoModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) this.priority = 3,
      @HiveField(3) this.tag = const [],
      @HiveField(4) this.state = TodoState.todo,
      @HiveField(5) this.scheduledTime,
      @HiveField(6) this.dueTime,
      @HiveField(7) this.subTasks,
      @HiveField(8) this.hasMarkdown = false});

  factory _$TodoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoModelImplFromJson(json);

  @override
  @HiveField(0)
  String id;
  @override
  @HiveField(1)
  String title;
  @override
  @JsonKey()
  @HiveField(2)
  int priority;
  @override
  @JsonKey()
  @HiveField(3)
  List<String> tag;
  @override
  @JsonKey()
  @HiveField(4)
  TodoState state;
  @override
  @HiveField(5)
  DateTime? scheduledTime;
  @override
  @HiveField(6)
  DateTime? dueTime;
  @override
  @HiveField(7)
  List<String>? subTasks;
  @override
  @JsonKey()
  @HiveField(8)
  bool hasMarkdown;

  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, priority: $priority, tag: $tag, state: $state, scheduledTime: $scheduledTime, dueTime: $dueTime, subTasks: $subTasks, hasMarkdown: $hasMarkdown)';
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
      {@HiveField(0) required String id,
      @HiveField(1) required String title,
      @HiveField(2) int priority,
      @HiveField(3) List<String> tag,
      @HiveField(4) TodoState state,
      @HiveField(5) DateTime? scheduledTime,
      @HiveField(6) DateTime? dueTime,
      @HiveField(7) List<String>? subTasks,
      @HiveField(8) bool hasMarkdown}) = _$TodoModelImpl;

  factory _TodoModel.fromJson(Map<String, dynamic> json) =
      _$TodoModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @HiveField(0)
  set id(String value);
  @override
  @HiveField(1)
  String get title;
  @HiveField(1)
  set title(String value);
  @override
  @HiveField(2)
  int get priority;
  @HiveField(2)
  set priority(int value);
  @override
  @HiveField(3)
  List<String> get tag;
  @HiveField(3)
  set tag(List<String> value);
  @override
  @HiveField(4)
  TodoState get state;
  @HiveField(4)
  set state(TodoState value);
  @override
  @HiveField(5)
  DateTime? get scheduledTime;
  @HiveField(5)
  set scheduledTime(DateTime? value);
  @override
  @HiveField(6)
  DateTime? get dueTime;
  @HiveField(6)
  set dueTime(DateTime? value);
  @override
  @HiveField(7)
  List<String>? get subTasks;
  @HiveField(7)
  set subTasks(List<String>? value);
  @override
  @HiveField(8)
  bool get hasMarkdown;
  @HiveField(8)
  set hasMarkdown(bool value);

  /// Create a copy of TodoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoModelImplCopyWith<_$TodoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
