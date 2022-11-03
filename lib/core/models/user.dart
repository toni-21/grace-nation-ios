import 'package:grace_nation/core/models/support_category.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final int? id;
  final String? memberId;
  final String? uuid;
  final String? phone;
  final String? gender;
  final String? occupation;
  final String? address;
  final String? avatar;
  final String accessToken;
  List<SupportCategory>? supportCategory;
  final Map<String, dynamic>? country;
  final Map<String, dynamic>? state;

  User(
      {required this.firstName,
      required this.lastName,
      this.id,
      this.phone,
      required this.email,
      this.memberId,
      required this.uuid,
      this.address,
      this.avatar,
      this.gender,
      this.occupation,
      this.country,
      this.state,
      this.supportCategory,
      required this.accessToken});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["user"]["id"],
      firstName: json["user"]["first_name"],
      lastName: json["user"]["last_name"],
      uuid: json["user"]["uuid"],
      memberId: json["user"]["member_id"],
      email: json["user"]["email"],
      phone: json["user"]["phone"],
      avatar: json["user"]["avatar"],
      address: json["user"]["address"],
      gender: json["user"]["gender"],
      occupation: json["user"]["occupation"],
      supportCategory: null,
      accessToken: json["token"]["access_token"]);

  factory User.fromUserJson(Map<String, dynamic> json, String token) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        uuid: json["uuid"],
        memberId: json["member_id"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        address: json["address"],
        gender: json["gender"],
        occupation: json["occupation"],
        supportCategory: null,
        accessToken: token,
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "id": id,
        "member_id": memberId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "avatar": avatar,
        "phoneNumber": phone,
        "occupation": occupation,
        "gender": gender,
        "country": country,
        "state": state,
        "address": address,
      };
}
