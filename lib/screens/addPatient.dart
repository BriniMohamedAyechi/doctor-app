import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/functionalities/getImage.dart';
import 'package:healthcare/models/patientModel.dart';
import 'package:healthcare/screens/home_screen.dart';
import 'package:healthcare/widgets/navbar_roots.dart';
import 'package:image_picker/image_picker.dart';

class PatientForm extends StatefulWidget {
  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstVisitedController = TextEditingController();
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  String? imageUrl;
  File? image;
  bool loading = false;

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        firstVisitedController.text = "${picked.toLocal()}"
            .split(' ')[0]; // Format the selected date as needed.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 200, left: 200, right: 200, top: 50),
          child: Column(
            children: <Widget>[
              Text(
                'Add a patient',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(
                height: 30,
              ),
              Icon(Icons.person, size: 200, color: Colors.deepPurple),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: "Name",
                  icon: Icon(Icons.person, size: 20, color: Colors.deepPurple),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: "Last Name",
                  icon: Icon(Icons.account_circle,
                      size: 20, color: Colors.deepPurple),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                controller: lastnameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Last Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: "Num CIN",
                  icon: Icon(Icons.account_circle,
                      size: 20, color: Colors.deepPurple),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                controller: cinController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'CIN is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: "Phone",
                  icon: Icon(Icons.phone, size: 20, color: Colors.deepPurple),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                controller: phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: "First Visited",
                  icon: Icon(Icons.date_range,
                      size: 20, color: Colors.deepPurple),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                controller: firstVisitedController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'First Visited date is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                cursorColor: Colors.black,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  hintText: "Disease",
                  icon: Icon(Icons.local_hospital,
                      size: 20, color: Colors.deepPurple),
                  fillColor: Colors.white,
                  filled: true,
                  enabled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                ),
                controller: diseaseController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Disease is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                minWidth: 200,
                elevation: 5.0,
                height: 40,
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                onPressed: () async {
                  await createPatient()
                      .whenComplete(() => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Material(
                                  child:
                                      NavBarRoots(), // Replace YourHomePage with the page you want to navigate to
                                );
                              },
                            ),
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createPatient() async {
    final docUser = FirebaseFirestore.instance.collection('patients').doc();
    final patient = patientModel(
      id: docUser.id,
      name: nameController.text.trim(),
      lastname: lastnameController.text.trim(),
      firstVisited: firstVisitedController.text.trim(),
      disease: diseaseController.text.trim(),
      phone: phoneController.text.trim(),
      image: imageUrl,
      CIN: cinController.text.trim(),
    );
    final json = patient.toJson();
    await docUser.set(json);
  }

  Future selecImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result == null) return;
  }

  Future<String?> uploadImage(File file, String path) async {
    String image = path;
    try {
      Reference ref = FirebaseStorage.instance.ref().child(path + "/" + image);
      UploadTask upload = ref.putFile(file);
      await upload.whenComplete(() => null);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}
