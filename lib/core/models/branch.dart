import 'package:grace_nation/core/models/country.dart';
import 'package:grace_nation/core/models/state.dart';

class Branch {
  int id;
  String name;
  String uuid;
  String phone;
  String email;
  String address;
  String? city;
  String? area;
  String? street;
  States state;
  Country country;

  Branch(
      {required this.id,
      required this.name,
      required this.uuid,
      required this.phone,
      required this.email,
      required this.address,
      this.city,
      this.area,
      this.street,
      required this.state,
      required this.country});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json['id'],
        name: json['name'],
        uuid: json['uuid'],
        phone: json['phone'],
        email: json['email'],
        address: json['address'],
        city: json['city'],
        area: json['area'],
        street: json['street'],
        state: States(
          id: json['state']['id'],
          name: json['state']['name'],
        ),
        country: Country(
          id: json['country']['id'],
          name: json['country']['name'],
        ),
      );
}
