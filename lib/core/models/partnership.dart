import 'package:grace_nation/core/models/transactions.dart';

class Partnership {
  String firstName;
  String lastName;
  int id;
  String uuid;
  String supportType; //(e.g LIBERATION TV)
  String supportCategory;
  String currency;
  double amount;
  //payment_date === payment_type!!!
  String paymentType;
  //CHANGE StringS TO STRING
  String startDate;
  String endDate;
  double totalPayable;
  String frequency;
  List<Transactions>? transactions;
  int missedPayments;
  int status;
  String statusReadable;
  String? createdAt;
  String? updatedAt;

  Partnership(
      {required this.firstName,
      required this.lastName,
      required this.id,
      required this.uuid,
      required this.supportType,
      required this.supportCategory,
      required this.currency,
      required this.amount,
      required this.totalPayable,
      required this.frequency,
      required this.paymentType,
      this.transactions,
      required this.missedPayments,
      required this.startDate,
      required this.endDate,
      this.createdAt,
      this.updatedAt,
      required this.status,
      required this.statusReadable});

  factory Partnership.fromJson(Map<String, dynamic> json) => Partnership(
        firstName: json["partner"]["first_name"],
        lastName: json["partner"]["last_name"],
        id: json["id"],
        uuid: json["uuid"],
        supportType: json["suport_type"]["title"],
        supportCategory: json["support_category"]["name"],
        currency: json["currency"],
        totalPayable: double.parse(json["total_payable"].toString()),
        amount: double.parse(json["amount"].toString()),
        frequency: json["frequency"],
        paymentType: json["payment_date"],
        transactions: null,
        missedPayments: json["missed_payments"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        createdAt: json["created_at"],
        updatedAt: json["upated_at"],
        status: json["status"],
        statusReadable: json["status_readable"],
      );
}
