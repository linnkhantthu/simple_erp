import 'package:flutter/cupertino.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String mail;
  final String token;

  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.mail,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mail: json['mail'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'mail': mail,
        'token': token
      };
}
