import 'package:grace_nation/core/models/accout_details.dart';

class Preferences {
  String? embedCode;
  List<AccountDetails>? bankAccounts;
  String? supportNumber;
  String? whatsappNumber;

  Preferences(
      {this.bankAccounts,
      this.embedCode,
      this.supportNumber,
      this.whatsappNumber});

  @override
  String toString() {
    return "embedCode: $embedCode, banks: ${bankAccounts.toString()}, supportNumber: $supportNumber, whatsappNumber: $whatsappNumber";
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    List<AccountDetails> details = [];
    return Preferences(
      embedCode: json["embed_code"],
      bankAccounts: null,
      supportNumber: json["support_number"],
      whatsappNumber: json["whatsapp_number"],
    );
  }
}
