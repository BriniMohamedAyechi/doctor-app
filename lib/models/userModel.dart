import 'package:cloud_firestore/cloud_firestore.dart';

class userModel {
  final String? id;
  final String name;
  final String phone;
  final String email;
  //final String? image;

  userModel(
      {this.id = '',
      required this.name,
      //required this.image,
      required this.phone,
      required this.email});
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        //'image': image,
      };
  static userModel fromJson(Map<String?, dynamic> json) => userModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        //image: json['image'],
      );

  userModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        email = snapshot['email'],
        phone = snapshot['phone'];
  //image = snapshot['image'];
}
