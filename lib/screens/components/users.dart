import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';

import 'bar_chart_users.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calendar",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: textColor,
            ),
          ),
          Expanded(
            child: CalendarView(),
          )
        ],
      ),
    );
  }
}
