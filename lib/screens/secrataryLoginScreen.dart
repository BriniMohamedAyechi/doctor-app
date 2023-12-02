import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/controllers/controller.dart';
import 'package:healthcare/firebase_authentication/firebase_auth_services.dart';
import 'package:healthcare/screens/dash_board_screen.dart';
import 'package:healthcare/screens/sign_up_screen.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class secrataryLoginScreen extends StatefulWidget {
  @override
  State<secrataryLoginScreen> createState() => _loginScreenState();
}

bool _isSigning = false;
final FirebaseAuthService _auth = FirebaseAuthService();

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _loginScreenState extends State<secrataryLoginScreen> {
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 600),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 500,
                  height: 400,
                  child: Image.asset(
                    'images/heartcare-high-resolution-logo-transparent.png',
                    height: 1000,
                    width: 1000,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Email",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: passToggle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;
                      });
                    },
                    child: passToggle
                        ? Icon(CupertinoIcons.eye_slash_fill)
                        : Icon(CupertinoIcons.eye_fill),
                  ),
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  _signIn();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF0074d9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have any account?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0074d9),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return Material(
              child: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => Controller(),
                  )
                ],
                child: DashBoardScreen(),
              ),
            );
          },
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Email password mismatch");
    }
  }
}
