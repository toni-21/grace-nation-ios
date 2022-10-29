class Transactions {
  final int id;
  final String uuid;
  final String reference;
  final String type;
  final String? paymentGateway;
  final double amount;
  final String currency;
  final int status;
  final String statusReadable;
  final String? pendedAt;
  final String? failedAt;
  final String? completedAt;
  final int paid;
  final String description;
  final String? paymentDate;

  Transactions(
      {required this.id,
      required this.uuid,
      required this.reference,
      required this.type,
      this.paymentGateway,
      required this.amount,
      required this.currency,
      required this.paid,
      required this.description,
      required this.status,
      required this.statusReadable,
      this.pendedAt,
      this.completedAt,
      this.failedAt,
     this.paymentDate});

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        id: json["id"],
        uuid: json["uuid"],
        reference: json["reference"],
        type: json["type"],
        amount: double.parse(json["amount"].toString()),
        currency: json["currency"],
        paid: json["paid"],
        description: json["description"],
        status: json["status"],
        statusReadable: json["status_readable"],
        paymentDate: json["payment_date"],
      );
}
