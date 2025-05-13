import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoCalendar extends ConsumerStatefulWidget {
  final Function(Text, List<Widget>) appbar;
  final Logger? logger;
  const TodoCalendar(
    this.appbar, {
    super.key,
    this.logger,
  });

  @override
  _TodoCalendarState createState() => _TodoCalendarState();
}

class _TodoCalendarState extends ConsumerState<TodoCalendar> {
  late Map<DateTime, List<TodoModel>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // _events = _groupTodosByDate(widget.todos);
  }

  DateTime _normalize(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  Map<DateTime, List<TodoModel>> _groupTodosByDate(List<TodoPair> todopairs) {
    Map<DateTime, List<TodoModel>> data = {};
    for (var todopair in todopairs) {
      var todo = todopair.todo;
      final date = todo.dueTime ?? DateTime.now();
      final normalizedDate = _normalize(date);
      widget.logger?.i(normalizedDate);

      if (data[normalizedDate] == null) {
        data[normalizedDate] = [];
      }
      data[normalizedDate]!.add(todo);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, TodoPair> todos = ref.watch(todoListProvider);
    _events = _groupTodosByDate(todos.values.toList());
    widget.logger?.i(_events);
    return Scaffold(
      appBar: widget.appbar(Text('Todo Calendar'), []),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _events[_normalize(day)] ?? [],
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = _normalize(selectedDay);
                _focusedDay = _normalize(focusedDay);
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                widget.logger?.i('calender builders me hu mai!!! $events');
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventMarker(events),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text("No date selected"))
                : ListView(
                    children: (_events[_selectedDay] ?? [])
                        .map((todo) => ListTile(
                              title: Text(todo.title),
                              subtitle: Text(todo.priority.name),
                              leading: Icon(
                                Icons.task,
                                color: todo.priority.color,
                              ),
                            ))
                        .toList(),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildEventMarker(List events) {
    return Row(
      children: events.map((e) {
        final priorityColor = (e as TodoModel).priority.color;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.5),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: priorityColor,
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }
}
