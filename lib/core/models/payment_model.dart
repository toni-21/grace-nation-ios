enum PaymentType {
  offline,
  online,
}

enum CreateFormType { currency, frequency, paymenttype, supporttype }

class PaymentInit {
  final int supportType;

  final String paymentOption;
  final double amount;
  final String currency;
  final String frequency;
  final String startDate;
  final String endDate;

  PaymentInit({
    required this.supportType,
    required this.frequency,
    required this.paymentOption,
    required this.amount,
    required this.currency,
    required this.startDate,
    required this.endDate,
  });

  factory PaymentInit.fromJson(Map<String, dynamic> json) => PaymentInit(
        supportType: json["id"],
        frequency: json["uuid"],
        paymentOption: json["reference"],
        amount: double.parse(json["amount"].toString()),
        currency: json["currency"],
        startDate: json["type"],
        endDate: json["paid"],
      );
}
