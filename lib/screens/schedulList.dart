import 'dart:convert';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/patientModel.dart';
import 'package:healthcare/models/scheduleModel.dart';
import 'package:http/http.dart' as http;

class schedulList extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<schedulList> {
  DateTime? _selectedDate;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  TextEditingController _timeController = TextEditingController();
  TextEditingController _confirmedController = TextEditingController();
  final CollectionReference schedulesCollection =
      FirebaseFirestore.instance.collection('schedules');

  String? mtoken = "";

  @override
  void initState() {
    super.initState();
  }

  void sendPushMessage(String token, String body, String title) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("usertokens")
        .doc("user1")
        .get();

    String mtoken = snap['token'];

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAABNojoJw:APA91bFEXkctUjfrHk5rrXGOrfya7tE8Nh5zbADlK6K6TEEPMST9Z0dXMSIvOAql1lmNbSqh-lAIanQmml-F4ox_DDJhN_VxQSf9btj0PO1TEWeLoIfaIfkHgGZIh3SeHDIBqPm-LvV8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            "to": mtoken,
          },
        ),
      );
      print(mtoken);
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFF0074d9),
            pinned: true,
            expandedHeight: 300, // Adjust as needed
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Schedule"),
              background: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'images/white.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    onChanged: (value) {
                      print("Search: $value");
                      setState(() {});
                    },
                    cursorColor: Color(0xFF0074d9),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Search by Name',

                      // Your search bar decoration
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        color: Color(0xFF0074d9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        minWidth: 200,
                        elevation: 5.0,
                        height: 60,
                        child: Text(
                          "Add Appointment",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          _showCreateScheduleDialog(context);
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<List<scheduleModel>>(
              stream: readSchedule(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot);
                  return Text('Something went wrong');
                } else if (snapshot.hasData) {
                  final schedules = snapshot.data!;
                  final filteredSchedules = _nameController.text.isEmpty
                      ? schedules
                      : schedules
                          .where((schedule) => schedule.person_name
                              .toLowerCase()
                              .contains(_nameController.text.toLowerCase()))
                          .toList();

                  return Column(
                    children: filteredSchedules.map(buildSchedule).toList(),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSchedule(scheduleModel schedule) => SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
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
                  child: Container(
                    height: 230,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              size: 120, color: Color(0xFF0074d9)),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                "${schedule.person_name}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0074d9),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: Colors.black54,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${schedule.phone}",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
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
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF0074d9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    _showMyDialog(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    deleteSchedule(
                                        "person_name", schedule.person_name);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );

  Stream<List<scheduleModel>> readSchedule() => FirebaseFirestore.instance
      .collection('schedules')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => scheduleModel.fromJson(doc.data()))
          .toList());

  Future<void> _showMyDialog(BuildContext context) async {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _timeController = TextEditingController();
    TextEditingController _confirmedController = TextEditingController();
    final CollectionReference schedulesCollection =
        FirebaseFirestore.instance.collection('schedules');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Edit Appointment',
            style: TextStyle(color: Color(0xFF0074d9)),
          )),
          content: Container(
            width: 300, // Adjust the width as needed
            height: 320,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xFF0074d9))),
                    hintText: "Patient Name",
                    icon:
                        Icon(Icons.person, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xFF0074d9))),
                    hintText: "Date",
                    icon: Icon(Icons.date_range,
                        size: 20, color: Color(0xFF0074d9)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Patient Phone",
                    icon: Icon(Icons.phone, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xFF0074d9))),
                    hintText: "Time",
                    icon: Icon(Icons.timelapse,
                        size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _confirmedController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xFF0074d9))),
                    hintText: "Confirmation",
                    icon: Icon(Icons.confirmation_num,
                        size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Assuming you want to update the document where the 'person_name' is equal to a specific value
                  String fieldName = 'person_name';
                  String fieldValue = _nameController.text.trim();

                  // Query to find the document
                  QuerySnapshot querySnapshot = await schedulesCollection
                      .where(fieldName, isEqualTo: fieldValue)
                      .get();

                  // Check if the document exists
                  if (querySnapshot.docs.isNotEmpty) {
                    // Get the first document (you can adjust this logic based on your requirements)
                    DocumentSnapshot documentSnapshot =
                        querySnapshot.docs.first;

                    // Check if the chosen time already exists on the selected date
                    bool isTimeAlreadyScheduled = await schedulesCollection
                        .where('date', isEqualTo: _dateController.text.trim())
                        .where('time', isEqualTo: _timeController.text.trim())
                        .where(FieldPath.documentId,
                            isNotEqualTo: documentSnapshot.id)
                        .get()
                        .then((scheduleSnapshot) =>
                            scheduleSnapshot.docs.isNotEmpty);

                    if (isTimeAlreadyScheduled) {
                      // Show a warning that the time is already scheduled
                      _showTimeAlreadyScheduledWarning(context);
                    } else {
                      // Create a Map with the fields to update
                      Map<String, dynamic> fieldsToUpdate = {
                        'date': _dateController.text.trim(),
                        'phone': _phoneController.text.trim(),
                        'time': _timeController.text.trim(),
                        'confirmed': _confirmedController.text.trim(),
                      };

                      // Update the document with the new values
                      await documentSnapshot.reference.update(fieldsToUpdate);

                      print('Document updated successfully.');
                      Navigator.of(context).pop();
                    }
                  } else {
                    print('Document not found.');
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print('Error updating document: $e');
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Create Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0074d9),
              ),
            ),
          ),
          content: Container(
            width: 400,
            height: 320,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Patient Name",
                    icon:
                        Icon(Icons.person, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Patient Phone",
                    icon: Icon(Icons.phone, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Date",
                    icon: Icon(Icons.date_range,
                        size: 20, color: Color(0xFF0074d9)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Time",
                    icon: Icon(Icons.timelapse,
                        size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmedController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Confirmation",
                    icon: Icon(Icons.confirmation_num,
                        size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                      left: 14.0,
                      bottom: 8.0,
                      top: 8.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF0074d9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Check if the time is already scheduled
                bool isTimeAlreadyScheduled = await checkIfTimeAlreadyScheduled(
                    _timeController.text.trim(), _dateController.text.trim());

                if (isTimeAlreadyScheduled) {
                  // Show a warning that the time is already scheduled
                  _showTimeAlreadyScheduledWarning(context);
                } else {
                  // Create the schedule if the time is not already scheduled
                  await createSchedule().whenComplete(() async {
                    DocumentSnapshot snap = await FirebaseFirestore.instance
                        .collection("usertokens")
                        .doc("user1")
                        .get();

                    String token = snap['token'];
                    print("HELLO:${token}");

                    sendPushMessage(
                        token,
                        "You have a new Appoitment Details : ${_nameController.text.trim()}, Date: ${_dateController.text.trim()}, time: ${_timeController.text.trim()}",
                        "New Appointment");
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF0074d9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> checkIfTimeAlreadyScheduled(String time, String date) async {
    // Query Firestore to check if the time is already scheduled
    QuerySnapshot scheduleSnapshot = await FirebaseFirestore.instance
        .collection("schedules")
        .where("date", isEqualTo: date)
        .where("time", isEqualTo: time)
        .get();

    return scheduleSnapshot.docs.isNotEmpty;
  }

  void _showTimeAlreadyScheduledWarning(BuildContext context) {
    // Show a warning dialog if the time is already scheduled
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0074d9),
            ),
          ),
          content: Text('The selected time is already scheduled.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF0074d9),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> createSchedule() async {
    final docUser = schedulesCollection.doc();
    final schedule = scheduleModel(
      id: docUser.id,
      person_name: _nameController.text.trim(),
      date: _dateController.text.trim(),
      time: _timeController.text.trim(),
      phone: _phoneController.text.trim(),
      confirmed: _confirmedController.text.trim(),
    );
    final json = schedule.toJson();
    await docUser.set(json);
    print('Document created successfully.');
  }

  Future<void> deleteSchedule(String fieldName, String fieldValue) async {
    try {
      // Query to find the document
      QuerySnapshot querySnapshot = await schedulesCollection
          .where(fieldName, isEqualTo: fieldValue)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (you can adjust this logic based on your requirements)
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Reference to the document you want to delete
        DocumentReference documentReference = documentSnapshot.reference;

        // Delete the document
        await documentReference.delete();

        print('Document deleted successfully.');
      } else {
        print('Document not found.');
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  // Example of how to use the deleteSchedule function
  void exampleDelete() async {
    // Replace 'field_name' and 'field_value' with the actual field and value criteria
    String fieldName = 'field_name';
    String fieldValue = 'field_value';

    await deleteSchedule(fieldName, fieldValue);
  }
}
