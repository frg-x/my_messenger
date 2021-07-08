import 'dart:convert';

UserProfile userFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.email,
    required this.gender,
    required this.maritalStatus,
    required this.preferLanguage,
    required this.avatarUrl,
  });

  String id;
  String firstName;
  String lastName;
  String phone;
  String address;
  String email;
  String gender;
  String maritalStatus;
  String preferLanguage;
  String avatarUrl;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phone: json["phone"],
        address: json["address"],
        email: json["email"],
        gender: json["gender"],
        maritalStatus: json["maritalStatus"],
        preferLanguage: json["preferLanguage"],
        avatarUrl: json["avatarUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "address": address,
        "email": email,
        "gender": gender,
        "maritalStatus": maritalStatus,
        "preferLanguage": preferLanguage,
        "avatarUrl": avatarUrl,
      };
}
