import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/patientModel.dart';
import 'package:healthcare/screens/aiAgent.dart';

class patientsList extends StatefulWidget {
  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<patientsList> {
  TextEditingController _searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstVisitedController = TextEditingController();
  final TextEditingController diseaseController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFF0074d9),
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Patients List"),
              background: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'images/white.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    cursorColor: Color(0xFF0074d9),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Search by Name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        color: Color(0xFF0074d9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        minWidth: 200,
                        elevation: 5.0,
                        height: 50,
                        child: Text(
                          "Search",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          // Perform search action
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      MaterialButton(
                        color: Color(0xFF0074d9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        minWidth: 200,
                        elevation: 5.0,
                        height: 50,
                        child: Text(
                          "ADD Patient",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          showPatientFormDialog(context);
                        },
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<List<patientModel>>(
              stream: readPatients(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot);
                  return Text('Something went wrong');
                } else if (snapshot.hasData) {
                  final patients = snapshot.data!;
                  final filteredPatients = _searchController.text.isEmpty
                      ? patients
                      : patients
                          .where((patient) =>
                              '${patient.name} ${patient.lastname}'
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase()))
                          .toList();

                  return Column(
                    children: filteredPatients.map(buildPatient).toList(),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPatient(patientModel patient) => SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 100, color: Color(0xFF0074d9)),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${patient.name} ${patient.lastname}'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0074d9),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Disease: ${patient.disease}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Last Date: ${patient.firstVisited}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Phone : ${patient.phone}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text('CIN: ${patient.CIN}'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                _editPatientDialog(context, patient);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                _deletePatient(patient);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Material(
                                        child: AiAgent(),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.local_hospital,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );

  Future<void> _editPatientDialog(
      BuildContext context, patientModel patient) async {
    TextEditingController _nameController =
        TextEditingController(text: '${patient.name} ${patient.lastname}');
    TextEditingController _diseaseController =
        TextEditingController(text: patient.disease);
    TextEditingController _firstVisitedController =
        TextEditingController(text: patient.firstVisited);
    TextEditingController _phoneController =
        TextEditingController(text: patient.phone);
    TextEditingController _cinController =
        TextEditingController(text: patient.CIN);

    final CollectionReference patientsCollection =
        FirebaseFirestore.instance.collection('patients');

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(
            child: Text(
              'Edit Patient',
              style: TextStyle(color: Color(0xFF0074d9)),
            ),
          ),
          content: Container(
            width: 350,
            height: 350,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Patient Name",
                    icon:
                        Icon(Icons.person, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Phone",
                    icon:
                        Icon(Icons.person, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _cinController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "CIN",
                    icon:
                        Icon(Icons.person, size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _diseaseController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "Disease",
                    icon: Icon(Icons.local_hospital,
                        size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _firstVisitedController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF0074d9)),
                    ),
                    hintText: "First Visited",
                    icon: Icon(Icons.calendar_today,
                        size: 20, color: Color(0xFF0074d9)),
                    fillColor: Colors.white,
                    filled: true,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Assuming you want to update the document where the 'name' and 'lastname' are equal to specific values
                  String fieldName = 'CIN';
                  String fieldValue = _nameController.text.trim();
                  String lastName = patient.lastname;

                  // Query to find the document
                  QuerySnapshot querySnapshot = await patientsCollection
                      .where(fieldName, isEqualTo: fieldValue)
                      .where('lastname', isEqualTo: lastName)
                      .get();

                  // Check if the document exists
                  if (querySnapshot.docs.isNotEmpty) {
                    // Get the first document (you can adjust this logic based on your requirements)
                    DocumentSnapshot documentSnapshot =
                        querySnapshot.docs.first;

                    // Create a Map with the fields to update
                    Map<String, dynamic> fieldsToUpdate = {
                      'disease': _diseaseController.text.trim(),
                      'firstVisited': _firstVisitedController.text.trim(),
                      'CIN': _cinController.text.trim(),
                      'Phone': _phoneController.text.trim(),
                    };

                    // Update the document with the new values
                    await documentSnapshot.reference.update(fieldsToUpdate);

                    print('Patient updated successfully.');
                  } else {
                    print('Patient not found.');
                  }
                } catch (e) {
                  print('Error updating patient: $e');
                }

                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
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
      image: "",
      CIN: cinController.text.trim(),
    );
    final json = patient.toJson();
    await docUser.set(json);
  }

  Future<void> showPatientFormDialog(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(
              'Add a patient',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color((0xFF0074d9)),
              ),
            ),
            content: Container(
              width: 500,
              child: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.person, size: 100, color: Color((0xFF0074d9))),
                      SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color((0xFF0074d9))),
                          ),
                          hintText: "Name",
                          icon: Icon(Icons.person,
                              size: 20, color: Color((0xFF0074d9))),
                          fillColor: Colors.white,
                          filled: true,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color((0xFF0074d9))),
                          ),
                          hintText: "Last Name",
                          icon: Icon(Icons.account_circle,
                              size: 20, color: Color((0xFF0074d9))),
                          fillColor: Colors.white,
                          filled: true,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ),
                        controller: lastnameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Last Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color((0xFF0074d9))),
                          ),
                          hintText: "Num CIN",
                          icon: Icon(Icons.account_circle,
                              size: 20, color: Color((0xFF0074d9))),
                          fillColor: Colors.white,
                          filled: true,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ),
                        controller: cinController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'CIN is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color((0xFF0074d9))),
                          ),
                          hintText: "Phone",
                          icon: Icon(Icons.phone,
                              size: 20, color: Color((0xFF0074d9))),
                          fillColor: Colors.white,
                          filled: true,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ),
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
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
                            borderSide: BorderSide(color: Color((0xFF0074d9))),
                          ),
                          hintText: "First Visited",
                          icon: Icon(Icons.date_range,
                              size: 20, color: Color((0xFF0074d9))),
                          fillColor: Colors.white,
                          filled: true,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ),
                        controller: firstVisitedController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'First Visited date is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color((0xFF0074d9))),
                          ),
                          hintText: "Disease",
                          icon: Icon(Icons.local_hospital,
                              size: 20, color: Color((0xFF0074d9))),
                          fillColor: Colors.white,
                          filled: true,
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                        ),
                        controller: diseaseController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Disease is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 20),
                      MaterialButton(
                        color: Color((0xFF0074d9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        minWidth: 200,
                        elevation: 5.0,
                        height: 40,
                        child: Text(
                          "ADD",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () async {
                          {
                            await createPatient();
                            Navigator.of(context).pop(); // Close the dialog
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletePatient(patientModel patient) async {
    final CollectionReference patientsCollection =
        FirebaseFirestore.instance.collection('patients');

    try {
      // Assuming you want to delete the document where the 'name' and 'lastname' are equal to specific values
      String fieldName = 'CIN';
      String fieldValue = patient.CIN;
      String lastName = patient.lastname;

      // Query to find the document
      QuerySnapshot querySnapshot = await patientsCollection
          .where(fieldName, isEqualTo: fieldValue)
          .where('lastname', isEqualTo: lastName)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (you can adjust this logic based on your requirements)
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Delete the document
        await documentSnapshot.reference.delete();

        print('Patient deleted successfully.');
      } else {
        print('Patient not found.');
      }
    } catch (e) {
      print('Error deleting patient: $e');
    }
  }

  Stream<List<patientModel>> readPatients() => FirebaseFirestore.instance
      .collection('patients')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => patientModel.fromJson(doc.data()))
          .toList());
}
