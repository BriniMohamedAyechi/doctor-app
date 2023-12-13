import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/constants/responsive.dart';
import 'package:healthcare/screens/components/analytic_cards.dart';
import 'package:healthcare/screens/components/analytic_info_card.dart';
import 'package:healthcare/screens/components/custom_appbar.dart';
import 'package:healthcare/screens/components/discussionSecretary.dart';
import 'package:healthcare/screens/components/toDolistSecretary.dart';
import 'package:healthcare/screens/components/top_referals.dart';
import 'package:healthcare/screens/components/users.dart';
import 'package:healthcare/screens/components/users_by_device.dart';
import 'package:healthcare/screens/components/viewers.dart';

import 'discussions.dart';

class DashboardContentSecretary extends StatelessWidget {
  const DashboardContentSecretary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          AnalyticCards(),
                          SizedBox(
                            height: appPadding,
                          ),
                          Users(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context))
                            DiscussionsSecretary(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: DiscussionsSecretary(),
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            children: [
                              if (!Responsive.isMobile(context))
                                Expanded(
                                  child: ToDoListSecretary(),
                                  flex: 2,
                                ),
                              if (!Responsive.isMobile(context))
                                SizedBox(
                                  width: appPadding,
                                ),
                              Expanded(
                                flex: 3,
                                child: Viewers(),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) ToDoListSecretary(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) UsersByDevice(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: UsersByDevice(),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
