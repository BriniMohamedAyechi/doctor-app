import 'package:flutter/material.dart';
import 'package:healthcare/models/scheduleModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondScheduleScreen extends StatefulWidget {
  @override
  _SecondScheduleScreenState createState() => _SecondScheduleScreenState();
}

TextEditingController _secondSearchController = TextEditingController();

class _SecondScheduleScreenState extends State<SecondScheduleScreen> {
  late Stream<List<scheduleModel>> _secondFilteredScheduleStream;

  @override
  void initState() {
    super.initState();
    _secondFilteredScheduleStream = readSecondSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Second Schedule",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0074d9), // Set blue color here
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _secondSearchController,
                      onChanged: (value) {
                        setState(() {
                          _secondFilteredScheduleStream =
                              filterSecondSchedule(value);
                        });
                      },
                      cursorColor: Color(0xFF0074d9),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFF0074d9)),
                        ),
                        hintText: "Search by Name",
                        icon: Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF0074d9),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                          left: 14.0,
                          bottom: 8.0,
                          top: 8.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0074d9)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<List<scheduleModel>>(
                  stream: _secondFilteredScheduleStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot);
                      return Text('Something went wrong');
                    } else if (snapshot.hasData) {
                      final schedules = snapshot.data!;
                      return Column(
                        children: schedules.map(buildSchedule).toList(),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<scheduleModel>> readSecondSchedule() => FirebaseFirestore.instance
      .collection('secondSchedules')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => scheduleModel.fromJson(doc.data()))
          .toList());

  Stream<List<scheduleModel>> filterSecondSchedule(String search) =>
      FirebaseFirestore.instance
          .collection('secondSchedules')
          .where('person_name', isGreaterThanOrEqualTo: search)
          .where('person_name', isLessThan: search + 'z')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => scheduleModel.fromJson(doc.data()))
              .toList());

  Widget buildSchedule(scheduleModel schedule) => Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "${schedule.person_name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("images/doctor1.jpg"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                thickness: 1,
                height: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${schedule.date}",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${schedule.time}",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue, // Set blue color here
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${schedule.confirmed}",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}
