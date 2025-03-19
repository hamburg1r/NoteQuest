String customDateFormat(DateTime date,
    [bool period = true, String dateTimeSep = ' ']) {
  String timeStr = period
      ? "${(date.hour % 12).toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour / 12 < 1 ? 'AM' : 'PM'}"
      : "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  String dateStr =
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
  if (date.year != DateTime.now().year) dateStr += "/${date.year}";
  return timeStr + dateTimeSep + dateStr;
}
