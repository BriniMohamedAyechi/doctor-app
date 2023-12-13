import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/screens/components/view_line_chart.dart';

class Viewers extends StatelessWidget {
  const Viewers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      width: 1000,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Article of the Day',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ArticleOfTheDayWidget(),
          ),
        ],
      ),
    );
  }
}
