import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoState {
	todo,
	done,
	doing,
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

	factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);
}

// class TodoModel {
// 	final String id;
// 	final String title;
// 	final int priority;
// 	final List<String> tag;
// 	final TodoState state;
// 	final DateTime? scheduledTime;
// 	final DateTime? dueTime;
// 	final List<String>? subTasks;
//
// 	TodoModel({
// 		required this.title,
// 		this.priority = 3,
// 		this.tag = const [],
// 		this.state = TodoState.todo,
// 		this.scheduledTime,
// 		this.dueTime,
// 		this.subTasks,
// 	}): id = Uuid().v4();
//
// 	TodoModel.fromJson(Map<String, dynamic> json):
// 		id = json['id'] as String,
// 		title = json['title'] as String,
// 		priority = json['priority'] as int,
// 		tag = json['tag'] as List<String>,
// 		state = json['state'] as TodoState,
// 		scheduledTime = json['scheduledTime']!=null? DateTime.fromMillisecondsSinceEpoch(json['scheduledTime'] as int): null,
// 		dueTime = json['dueTime']!=null? DateTime.fromMillisecondsSinceEpoch(json['dueTime'] as int): null,
// 		subTasks = (json['subTasks'] as List<dynamic>?)?.map((e) => e as String).toList();
//
// 	Map<Strin123g, dynamic> toJson() {
// 		return {
// 			'id': id,
// 			'title': title,
// 			'priority': priority,
// 			'tag': tag,
// 			'state': state.name,
// 			'scheduledTime': scheduledTime?.millisecondsSinceEpoch,
// 			'dueTime': dueTime?.millisecondsSinceEpoch,
// 			'subTasks': subTasks,
// 		};
// 	}
// }
