import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/userModel.dart';
import 'package:healthcare/screens/addPatient.dart';
import 'package:healthcare/screens/aiAgent.dart';
import 'package:healthcare/screens/appointment_screen.dart';
import 'package:healthcare/screens/patientsList.dart';

class HomeScreen extends StatelessWidget {
  List<Map<String, dynamic>> dashItems = [
    {
      'icon': Icons.add,
      'label': 'Add Patient',
      'screen': PatientForm(),
    },
    {
      'icon': Icons.person,
      'label': 'Patients List',
      'screen': patientsList(),
    },
    {
      'icon': Icons.add,
      'label': 'AI Agent',
      'screen': AiAgent(),
    },
  ];

  userModel? user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset(
                      'images/heartcare-high-resolution-logo-transparent.png', // Change to the desired image
                      width: 1000,
                      height: 1000,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("images/doctor1.jpg"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(dashItems.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Material(
                            child: dashItems[index]['screen'],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            dashItems[index]['icon'],
                            color: Color(0xFF0074d9),
                            size: 35,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          dashItems[index]['label'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 15),
            ),
          ],
        ),
      ),
    );
  }
}
