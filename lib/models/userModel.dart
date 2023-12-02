import 'package:cloud_firestore/cloud_firestore.dart';

class userModel {
  String? id;
  final String name;
  final String phone;
  //final String? image;

  userModel({
    this.id = '',
    required this.name,
    //required this.image,
    required this.phone,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'Name': name,
        'Phone': phone,
        //'image': image,
      };
  static userModel fromJson(Map<String?, dynamic> json) => userModel(
        id: json['id'],
        name: json['name'],
        phone: json['Phone'],
        //image: json['image'],
      );

  userModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot['id'],
        name = snapshot['Name'],
        phone = snapshot['Phone'];
  //image = snapshot['image'];
}
