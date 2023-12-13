import 'package:cloud_firestore/cloud_firestore.dart';

class patientModel {
  String? id;
  final String name;
  final String lastname;
  final String age;
  final String CIN;
  final String phone;
  final String firstVisited;
  final String disease;
  final String? image;

  patientModel({
    this.id = '',
    required this.name,
    required this.image,
    required this.phone,
    required this.lastname,
    required this.firstVisited,
    required this.disease,
    required this.age,
    required this.CIN,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'Name': name,
        'Phone': phone,
        'lastname': lastname,
        'firstvisted': firstVisited,
        'disease': disease,
        'age': age,
        'CIN': CIN,
        //'image': image,
      };
  static patientModel fromJson(Map<String?, dynamic> json) => patientModel(
      id: json['id'],
      name: json['Name'],
      phone: json['Phone'],
      lastname: json['lastname'],
      firstVisited: json['firstvisted'],
      disease: json['disease'],
      image: json['image'],
      age: json['age'],
      CIN: json['CIN']);

  patientModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['id'],
        name = snapshot['Name'],
        phone = snapshot['Phone'],
        lastname = snapshot['lastname'],
        firstVisited = snapshot['firstvisted'],
        disease = snapshot['disease'],
        image = snapshot['image'],
        age = snapshot['age'],
        CIN = snapshot['CIN'];
}
