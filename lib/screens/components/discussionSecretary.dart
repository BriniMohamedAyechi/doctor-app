import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/models/scheduleModel.dart';
import 'package:healthcare/screens/components/discussion_info_detail.dart';
import 'package:healthcare/screens/components/discussion_info_secretary.dart';
import 'package:healthcare/screens/schedulList.dart';

class DiscussionsSecretary extends StatelessWidget {
  const DiscussionsSecretary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Material(
                          child: schedulList(),
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('schedules')
                  .orderBy(
                    "date",
                    descending: true,
                  )
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // You can show a loading indicator
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                var schedules = snapshot.data!.docs
                    .map((doc) => scheduleModel.fromSnapshot(doc))
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: schedules.length,
                  itemBuilder: (context, index) =>
                      DiscussionInfoDetailSecretary(
                    schedule: schedules[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
