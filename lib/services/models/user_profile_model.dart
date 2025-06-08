// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.name,
    this.phone,
    this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
      );

  String? name;
  String? phone;
  String? email;

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
      };
}
