
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StocialUser {

  static final StocialUser _user = StocialUser._internal();

  factory StocialUser() {
    return _user;
  }

  StocialUser._internal();

  DocumentReference? docRef;
  String? name;
  String? uid;
  String? email;
  String? cpfCEI;
  String? passwordCEI;
  bool updatedCEI = false;

  void set(DocumentSnapshot snapshot) {
    final data = snapshot.data()!;
    print(jsonEncode(data));
    this.docRef = snapshot.reference;
    uid = data['uid'];
    name = data['name'];
    email = data['email'];
    cpfCEI = data['cpfCEI'];
    updatedCEI = data['updatedCEI'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'cpfCEI': cpfCEI,
      'passwordCEI': passwordCEI,
      'updatedCEI': updatedCEI
    };
  }
}