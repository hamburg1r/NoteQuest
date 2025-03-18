import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker(
      {this.controller, this.label = "Select Date and Time", super.key});

  final DateTimePickerController? controller;
  final String label;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late final DateTimePickerController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? DateTimePickerController();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Row(
                children: [
                  Spacer(),
                  Text(controller.title),
                  Spacer(),
                ],
              ),
              //titlePadding: EdgeInsets.symmetric(horizontal: double.infinity),
              //alignment: AlignmentDirectional.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                DateTimeButtons(
                  controller: controller,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        controller.dateTime = null;
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.setDateTime();
                        print(controller.selectedDate);
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
      child: Text(controller.selectedDate ?? widget.label),
    );
  }
}

class DateTimeButtons extends StatefulWidget {
  const DateTimeButtons({required this.controller, super.key});

  final DateTimePickerController controller;

  @override
  State<DateTimeButtons> createState() => _DateTimeButtonsState();
}

class _DateTimeButtonsState extends State<DateTimeButtons> {
  set date(DateTime? value) {
    setState(() {
      widget.controller.date = value ?? DateTime.now();
    });
  }

  DateTime? get date => widget.controller.date;

  set time(TimeOfDay? value) {
    setState(() {
      widget.controller.time = value ?? TimeOfDay.now();
    });
  }

  TimeOfDay? get time => widget.controller.time;

  @override
  Widget build(BuildContext context) {
    final DateTime firstDate = DateTime(DateTime.now().year - 100);
    final DateTime lastDate = DateTime(DateTime.now().year + 100);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: FilledButton(
            onPressed: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((onValue) {
                time = onValue;
              });
            },
            child: Text(
              time != null ? widget.controller.timeString : "Time",
            ),
          ),
        ),
        Expanded(
          child: FilledButton(
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: firstDate,
                lastDate: lastDate,
              ).then((onValue) {
                date = onValue;
              });
            },
            child: Text(
              date != null ? widget.controller.dateString : "Date",
            ),
          ),
        ),
      ],
    );
  }
}

class DateTimePickerController {
  DateTime? dateTime;
  DateTime _date = DateTime.now();
  set date(DateTime value) {
    _date = value;
    if (dateTime != null) {
      dateTime = dateTime!.copyWith(
        year: value.year,
        month: value.month,
        day: value.day,
      );
    } else {
      dateTime = _date;
    }
  }

  DateTime get date => _date;

  TimeOfDay _time = TimeOfDay.now();
  set time(TimeOfDay value) {
    _time = value;
    if (dateTime != null) {
      dateTime = dateTime!.copyWith(
        hour: value.hour,
        minute: value.minute,
      );
    } else {
      dateTime = DateTime.now().copyWith(
        hour: value.hour,
        minute: value.minute,
      );
    }
  }

  TimeOfDay get time => _time;

  String get timeString =>
      "${time.hourOfPeriod.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  String get dateString => "${date.day}/${date.month}/${date.year}";
  String get title => "$dateString $timeString";
  String? get selectedDate => dateTime != null
      ? "${dateTime!.hour}:${dateTime!.minute} ${dateTime!.day}/${dateTime!.month}/${dateTime!.year}"
      : null;
  void unsetDateTime() {
    dateTime = null;
  }

  void setDateTime([DateTime? ref]) {
    if (ref != null) {
      dateTime = ref;
    } else {
      dateTime = _date.copyWith(
        hour: _time.hour,
        minute: _time.minute,
      );
    }
  }
}
