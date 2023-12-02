import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/screens/aiAgent.dart';
import 'package:healthcare/screens/components/drawer_list_tile.dart';
import 'package:healthcare/screens/patientsList.dart';
import 'package:healthcare/screens/schedulList.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(appPadding),
            child: Container(
              height: 200,
              width: 300,
              child: Image.asset(
                "images/heartcare-high-resolution-logo-transparent.png",
                height: 200,
                width: 200,
              ),
            ),
          ),
          DrawerListTile(
              title: 'Dash Board',
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {
                print('You Click Dash Board');
              }),
          DrawerListTile(
              title: 'Patients',
              svgSrc: 'assets/icons/BlogPost.svg',
              tap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Material(
                        child: patientsList(),
                      );
                    },
                  ),
                );
              }),
          DrawerListTile(
              title: 'Message', svgSrc: 'assets/icons/Message.svg', tap: () {}),
          DrawerListTile(
              title: 'Schedule',
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Material(
                        child: schedulList(),
                      );
                    },
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              title: 'Settings',
              svgSrc: 'assets/icons/Setting.svg',
              tap: () {}),
          DrawerListTile(
              title: 'Logout', svgSrc: 'assets/icons/Logout.svg', tap: () {}),
        ],
      ),
    );
  }
}
