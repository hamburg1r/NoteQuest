import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notequest/models/todo.dart';

String customDateFormat(
  DateTime date, [
  bool period = true,
  String dateTimeSep = ' ',
]) {
  String timeStr = period
      ? "${(date.hour % 12).toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour / 12 < 1 ? 'AM' : 'PM'}"
      : "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  String dateStr =
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  if (date.year != DateTime.now().year) dateStr += "/${date.year}";
  return timeStr + dateTimeSep + dateStr;
}

Future<void> makeRoute(context, screen) => Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => screen,
      ),
    );

// FIXME: Future?
Map<String, TodoPair>? getTodos({
  required List<String> todos,
  required Map<String, TodoPair> todoList,
  Logger? logger,
}) {
  Map<String, TodoPair> out = {};
  logger?.i('$todoList');
  for (String id in todos) {
    logger?.i('checking for $id got:${todoList[id].toString()}');
    out[id] = todoList[id]!;
  }
  if (out.isEmpty) return null;
  logger?.i(out);
  return out;
}
