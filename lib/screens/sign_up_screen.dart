import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthcare/controllers/controller.dart';
import 'package:healthcare/firebase_authentication/firebase_auth_services.dart';
import 'package:healthcare/screens/dash_board_screen.dart';
import 'package:healthcare/screens/home_screen.dart';
import 'package:healthcare/screens/login_screen.dart';
import 'package:healthcare/widgets/navbar_roots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final FirebaseAuthService _auth = FirebaseAuthService();

TextEditingController _nameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _phoneController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

bool isSigningUp = false;

@override
void dispose() {
  _nameController.dispose();
  _emailController.dispose();
  _phoneController.dispose();
  _passwordController.dispose();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passToggle = true;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(right: 650, left: 650),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Container(
                  height: 400,
                  width: 600,
                  child: Image.asset(
                    'images/heartcare-high-resolution-logo-transparent.png', // Change to the desired image
                    width: 1000,
                    height: 1000,
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Password"),
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
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _signUp();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: 350,
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
                        "Create Account",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return Material(
                                child: loginScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Log In",
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
      ),
    );
  }

  void _signUp() async {
    try {
      setState(() {
        isSigningUp = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;
      String phone = _phoneController.text;

      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      createUser();

      setState(() {
        isSigningUp = false;
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
        Fluttertoast.showToast(msg: "User Already Exists");
      }
    } catch (e) {
      print("An error occurred: $e");
      Fluttertoast.showToast(msg: "An error occurred: $e");
    }
  }

  Future<void> createUser() async {
    try {
      // Get the current authenticated user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        // Handle the case where there is no authenticated user
        print('No authenticated user');
        return;
      }

      // Use the UID as the document ID
      final docUser =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      // You can customize this part based on your userModel
      final json = {
        'id': currentUser.uid,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      };

      await docUser.set(json);
    } catch (error) {
      // Handle errors
      print('Error creating user: $error');
    }
  }
}
