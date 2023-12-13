import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/scheduleModel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthcare/constants/constants.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  late List<scheduleModel> _schedules;

  @override
  void initState() {
    super.initState();
    _schedules = [];
    _loadSchedules();
  }

  void _loadSchedules() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('schedules').get();
    setState(() {
      _schedules =
          snapshot.docs.map((doc) => scheduleModel.fromSnapshot(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2023, 12, 31),
        focusedDay: _focusedDay ?? DateTime.now(),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _showAppointmentDetails(context, selectedDay);
          }
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: lightTextColor),
          weekendStyle: TextStyle(color: lightTextColor),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            bool hasSchedule = _hasSchedule(date);
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: hasSchedule ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: hasSchedule ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _hasSchedule(DateTime date) {
    String formattedDate = _formatDate(date);
    return _schedules.any((schedule) => schedule.date == formattedDate);
  }

  void _showAppointmentDetails(BuildContext context, DateTime date) {
    String formattedDate = _formatDate(date);
    List<scheduleModel> selectedSchedules =
        _schedules.where((schedule) => schedule.date == formattedDate).toList();

    if (selectedSchedules.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Appointments for ${_formatDate(date)} : ',
              style: TextStyle(color: Color(0xFF0074d9))),
          content: SingleChildScrollView(
            child: Column(
              children: selectedSchedules.map((schedule) {
                return ListTile(
                    title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Patient name :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${schedule.person_name}'),
                        SizedBox(
                          width: 10, // Adjust the width as needed
                        ),
                        Text(
                          "Time :",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${schedule.time}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ));
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
