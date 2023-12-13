import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/constants/responsive.dart';
import 'package:healthcare/controllers/controller.dart';
import 'package:healthcare/screens/components/profile_info.dart';
import 'package:healthcare/screens/components/search_field.dart';
import 'package:healthcare/screens/settings_screen.dart';
import 'package:healthcare/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: context.read<Controller>().controlMenu,
            icon: Icon(
              Icons.menu,
              color: textColor.withOpacity(0.5),
            ),
          ),
        Expanded(child: SearchField()),
        ProfileInfo(userId: user!.uid),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 8),
                  Text(user.email ?? ""),
                ],
              ),
              enabled: false,
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Navigate to the settings screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingScreen(),
                    ),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  // Implement logout logic
                  FirebaseAuth.instance.signOut();
                  // Navigate to the MessagesScreen after logout
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
