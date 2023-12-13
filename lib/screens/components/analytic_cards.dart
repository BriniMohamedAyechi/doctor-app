import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'analytic_info_card.dart';

class AnalyticInfoCardGridView extends StatelessWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Data",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount:
              4, // Number of data types (e.g., patients, schedules, weather, date)
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return AnalyticInfoCard(
                    info: AnalyticInfo('Patients', 'patients'));
              case 1:
                return AnalyticInfoCard(
                    info: AnalyticInfo('Appointments', 'schedules'));
              case 2:
                return WeatherInfoCard();
              case 3:
                return DateInfoCard();
              default:
                return Container(); // Placeholder, you can modify this based on your needs
            }
          },
        ),
      ],
    );
  }
}
