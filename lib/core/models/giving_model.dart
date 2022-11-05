class GivingInit {
  final double amount;
  final String currency;
  final int givingTypeId;

  GivingInit({
    required this.amount,
    required this.currency,
    required this.givingTypeId,
  });

  factory GivingInit.fromJson(Map<String, dynamic> json) => GivingInit(
        amount: double.parse(json["amount"].toString()),
        currency: json["currency"],
        givingTypeId: json["giving_type_id"],
      );
}

class GivingType{
  int id;
  String name;
  int status;
  String statusReadable;

  GivingType(
      {required this.id,
      required this.name,
      required this.status,
      required this.statusReadable});

  factory GivingType.fromJson(Map<String, dynamic> json) => GivingType(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        statusReadable: json['status_readable'],
      );
}
