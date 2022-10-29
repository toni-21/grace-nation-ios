import 'package:grace_nation/core/models/country.dart';

class States {
  int id;
  String name;
  Country? country;

  States({required this.id, required this.name, this.country});

  factory States.fromJson(Map<String, dynamic> json) => States(
        id: json['id'],
        name: json['name'],
        country:
            Country(id: json['country']['id'], name: json['country']['name']),
      );
}
