import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String id;
  String title;
  String? desciption;
  String? avatar;
  String? location;
  bool hasDelivery;
  Timestamp createdAt;

  Store({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.hasDelivery,
    this.desciption,
    this.avatar,
    this.location,
  });

  factory Store.fromSnapshot(DocumentSnapshot data) {
    dynamic json = data.data();
    return Store(
      id: data.id,
      title: json['seller_name'],
      createdAt: json['created_at'],
      desciption: json['seller_information'],
      avatar: json['seller_img'],
      location: json['seller_address'],
      hasDelivery: json['has_delivery'] ?? true,
    );
  }
}
