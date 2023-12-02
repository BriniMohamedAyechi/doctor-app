import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/firebase_authentication/firebase_api.dart';
import 'package:healthcare/firebase_options.dart';
import 'package:healthcare/screens/welcome_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCpj85ZkPrnrFyEidgCYpOC8CoziwmdIVw",
          authDomain: "doctor-application-4a3c6.firebaseapp.com",
          projectId: "doctor-application-4a3c6",
          storageBucket: "doctor-application-4a3c6.appspot.com",
          messagingSenderId: "20839637148",
          appId: "1:20839637148:web:2bebe7aa9a2cf8533b0d59",
          measurementId: "G-1VYPCMH3YK"));

  //await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? mtoken = "";

  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("usertokens").doc("user1").set({
      'token': token,
    });
  }

  showPushNotification() {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("NOTIFICATION TITLE: " + notification!.title.toString());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
