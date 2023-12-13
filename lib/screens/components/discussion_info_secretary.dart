import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/models/scheduleModel.dart'; // Import your schedule model

class DiscussionInfoDetailSecretary extends StatelessWidget {
  const DiscussionInfoDetailSecretary({Key? key, required this.schedule})
      : super(key: key);

  final scheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: appPadding),
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Icon(
              Icons.person,
              size: 38,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.person_name,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Phone: ${schedule.phone}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Date : ${schedule.date} Time : ${schedule.time}',
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: textColor.withOpacity(0.5),
            size: 18,
          )
        ],
      ),
    );
  }
}
