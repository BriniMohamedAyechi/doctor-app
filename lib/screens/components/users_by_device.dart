import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/screens/components/radial_painter.dart';
import 'package:intl/intl.dart';

class UsersByDevice extends StatefulWidget {
  const UsersByDevice({Key? key}) : super(key: key);

  @override
  _UsersByDeviceState createState() => _UsersByDeviceState();
}

class _UsersByDeviceState extends State<UsersByDevice> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize with the current date
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.only(top: appPadding),
        child: Column(
          children: [
            _buildDatePicker(),
            FutureBuilder<int>(
              future: _getPatientsCount(selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final patientsCount = snapshot.data ?? 0;

                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Patients Capacity for ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(appPadding),
                        padding: EdgeInsets.all(appPadding),
                        height: 230,
                        child: CustomPaint(
                          foregroundPainter: RadialPainter(
                            bgColor: textColor.withOpacity(0.1),
                            lineColor: primaryColor,
                            percent: (patientsCount / 20).clamp(0.0, 1.0),
                            width: 18.0,
                          ),
                          child: Center(
                            child: Text(
                              '${((patientsCount / 20) * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: appPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: primaryColor,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: appPadding / 2,
                                ),
                                Text(
                                  'Occupied',
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: textColor.withOpacity(0.2),
                                  size: 10,
                                ),
                                SizedBox(
                                  width: appPadding / 2,
                                ),
                                Text(
                                  'Available',
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      margin: EdgeInsets.only(bottom: appPadding),
      child: ElevatedButton(
        onPressed: () {
          _selectDate(context);
        },
        child: Text(
            'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<int> _getPatientsCount(DateTime selectedDate) async {
    // Format the selectedDate to match the format stored in Firebase
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

    // Fetch documents from Firestore for the selected date
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('schedules')
        .where('date', isEqualTo: formattedDate)
        .get();

    return snapshot.size;
  }
}
