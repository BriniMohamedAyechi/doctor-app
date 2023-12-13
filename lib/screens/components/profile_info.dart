import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare/constants/constants.dart';
import 'package:healthcare/constants/responsive.dart';
import 'package:healthcare/models/userModel.dart';

class ProfileInfo extends StatelessWidget {
  final String userId; // Pass the user ID to the widget

  const ProfileInfo({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<userModel>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          print('${userId}');
          return Text('Error: ${snapshot.error}');
        }

        final user = snapshot.data;

        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(appPadding),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    "assets/icons/Bell.svg",
                    height: 25,
                    color: textColor.withOpacity(0.8),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: appPadding),
              padding: EdgeInsets.symmetric(
                horizontal: appPadding,
                vertical: appPadding / 2,
              ),
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: appPadding / 2),
                    child: Text(
                      'Welcome ${user?.name ?? ""}',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ClipRect(
                    child: ClipOval(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 20, // Set the radius as needed
                        backgroundImage: AssetImage(
                            'images/avatar.png'), // Set your image path
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<userModel> _getUserData() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userModel.fromSnapshot(userSnapshot);
  }
}
