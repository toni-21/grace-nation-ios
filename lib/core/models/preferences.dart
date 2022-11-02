import 'package:grace_nation/core/models/accout_details.dart';

class Preferences {
  String? embedCode;
  List<AccountDetails>? bankAccounts;
  String? supportNumber;
  String? whatsappNumber;
  String? flutterwaveKey;
  String? tiktokLink;
  String? facebookLink;
  String? youtubeLink;
  String? instagramLink;

  Preferences({
    this.bankAccounts,
    this.embedCode,
    this.supportNumber,
    this.whatsappNumber,
    this.flutterwaveKey,
    this.facebookLink,
    this.instagramLink,
    this.tiktokLink,
    this.youtubeLink,
  });

  @override
  String toString() {
    return "embedCode: $embedCode, banks: ${bankAccounts.toString()}, supportNumber: $supportNumber, whatsappNumber: $whatsappNumber";
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      embedCode: json["embed_code"],
      bankAccounts: null,
      supportNumber: json["support_number"],
      whatsappNumber: json["whatsapp_number"],
      flutterwaveKey: json["public_keys"]["ravepay"],
      tiktokLink: json["social_links"]["tiktok"],
      youtubeLink: json["social_links"]["youtube"],
      facebookLink: json["social_links"]["facebook"],
      instagramLink: json["social_links"]["instagram"],
    );
  }
}
