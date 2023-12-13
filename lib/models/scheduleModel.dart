import 'package:cloud_firestore/cloud_firestore.dart';

class scheduleModel {
  String? id;
  final String date;
  final String person_name;
  final String phone;
  final String time;
  final String confirmed;
  //final String? image;

  scheduleModel({
    this.id = '',
    required this.person_name,
    required this.phone,
    //required this.image,
    required this.date,
    required this.time,
    required this.confirmed,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'person_name': person_name,
        'date': date,
        'time': time,
        'confirmed': confirmed,
        'phone': phone,
        //'image': image,
      };
  static scheduleModel fromJson(Map<String?, dynamic> json) => scheduleModel(
      id: json['id'],
      person_name: json['person_name'],
      date: json['date'],
      time: json['time'],
      confirmed: json['confirmed'],
      phone: json['phone']
      //image: json['image'],
      );

  scheduleModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['id'],
        person_name = snapshot['person_name'],
        date = snapshot['date'],
        time = snapshot['time'],
        phone = snapshot['phone'],
        confirmed = snapshot['confirmed'];
  //image = snapshot['image'];
}
