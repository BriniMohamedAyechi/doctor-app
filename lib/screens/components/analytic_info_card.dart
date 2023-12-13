import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/screens/components/analytic_cards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticInfo {
  final String title;
  final String dataType;

  AnalyticInfo(this.title, this.dataType);
}

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({Key? key, required this.info}) : super(key: key);

  final AnalyticInfo info;

  Future<int> _getDataFromFirebase(String dataType) async {
    late int count;

    if (dataType == 'patients') {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('patients').get();
      count = snapshot.size;
    } else if (dataType == 'schedules') {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('schedules').get();
      count = snapshot.size;
    } else {
      // Handle other data types if needed
      count = 0;
    }

    return count;
  }

  Widget _buildIcon() {
    IconData iconData;

    switch (info.dataType) {
      case 'patients':
        iconData = Icons.person;
        break;
      case 'schedules':
        iconData = Icons.calendar_today;
        break;
      case 'weather':
        iconData = Icons.wb_sunny;
        break;
      case 'date':
        iconData = Icons.calendar_today;
        break;
      default:
        iconData = Icons.error_outline;
    }

    return Icon(
      iconData,
      size: 24,
      color: Color(0xFF0074d9),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getDataFromFirebase(info.dataType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final count = snapshot.data ?? 0;

        return Container(
          height: 80, // Adjust the height as needed
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(),
                SizedBox(height: 4),
                Text(
                  info.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "$count",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _getWeatherData() async {
    final apiKey =
        '3ec85e0d47cbdb2024631156a27283c5'; // Replace with your OpenWeatherMap API key
    final city = 'Sousse'; // Change the city as needed

    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getWeatherData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final weatherData = snapshot.data;

        final temperature =
            (weatherData?['main']['temp'] - 273.15).toStringAsFixed(1);
        final weatherDescription = weatherData?['weather'][0]['main'];

        return Container(
          height: 80, // Adjust the height as needed
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny,
                  size: 24,
                  color: Color(0xFF0074d9),
                ),
                SizedBox(height: 4),
                Text(
                  'Weather',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$temperature°C, $weatherDescription',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DateInfoCard extends StatelessWidget {
  const DateInfoCard({Key? key}) : super(key: key);

  String _getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Adjust the height as needed
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 24,
              color: Color(0xFF0074d9),
            ),
            SizedBox(height: 4),
            Text(
              'Date',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _getCurrentDate(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticCards extends StatelessWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnalyticInfoCardGridView(),
    );
  }
}
