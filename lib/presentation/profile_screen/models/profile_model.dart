import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
//part 'profileModel.g.dart';

//@JsonSerializable()
class ProfileModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String role;
  bool isVerified;
  String jwtToken;

  ProfileModel(this.firstName, this.lastName, this.email, this.phone, this.role,
      this.isVerified, this.jwtToken);

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return new ProfileModel(json['firstName'], json['lastName'], json["email"],
        json['phone'], json["role"], json["isVerified"], json["jwtToken"]);
  }
}
