import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/constants/responsive.dart';
import 'package:healthcare/controllers/controller.dart';
import 'package:healthcare/screens/components/dashboard_content.dart';
import 'package:healthcare/screens/components/dashboard_content_Secretary.dart';
import 'package:healthcare/screens/components/drawer_menu_Secretary.dart';

import 'components/drawer_menu.dart';
import 'package:provider/provider.dart';

class DashBoardScreenSecretary extends StatelessWidget {
  const DashBoardScreenSecretary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: DrawerMenuSecretary(),
      key: context.read<Controller>().scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: DrawerMenuSecretary(),
              ),
            Expanded(
              flex: 5,
              child: DashboardContentSecretary(),
            )
          ],
        ),
      ),
    );
  }
}
