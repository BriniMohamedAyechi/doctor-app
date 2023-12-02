import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/controllers/controller.dart';
import 'package:healthcare/screens/dash_board_screen.dart';
import 'package:healthcare/screens/home_screen.dart';
import 'package:healthcare/screens/home_screen_Secratary.dart';
import 'package:healthcare/screens/messages_screen.dart';
import 'package:healthcare/screens/messages_screen_Secratary.dart';
import 'package:healthcare/screens/schedulList.dart';
import 'package:healthcare/screens/schedule_screen.dart';
import 'package:healthcare/screens/settings_screen.dart';
import 'package:healthcare/screens/settings_screen_Secratary.dart';
import 'package:provider/provider.dart';

class navbar_rootsSecratary extends StatefulWidget {
  @override
  State<navbar_rootsSecratary> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<navbar_rootsSecratary> {
  int _selectedIndex = 0;
  final _screens = [
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Controller(),
        )
      ],
      child: DashBoardScreen(),
    ),
    messages_screen_Secratary(),
    schedulList(),
    settings_screen_Secratary(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF0074d9),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.chat_bubble_text_fill,
                ),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}
