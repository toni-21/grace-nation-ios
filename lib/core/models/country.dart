class Country {
  int id;
  String name;
  String? sortname;
  int? phoneCode;

  Country(
      {required this.id, required this.name, this.sortname, this.phoneCode});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'],
        name: json['name'],
        sortname: json['sortname'],
        phoneCode: json['phone_code'],
      );

  bool isEqual(Country model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
