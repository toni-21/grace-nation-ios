class AccountDetails {
  String? bankName;
  String? sortCode;
  String? accountName;
  String? accountType;
  String? accountNumber;

  AccountDetails(
      {this.accountName,
      this.accountNumber,
      this.accountType,
      this.bankName,
      this.sortCode});

  factory AccountDetails.fromJson(Map<String, dynamic> json) => AccountDetails(
        bankName: json["bank_name"],
        sortCode: json["sort_code"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        accountType: json["account_type"],
      );

  @override
  String toString() {
    return "bankName: $bankName, accountName: $accountName, accountNumber: $accountNumber, accountType: $accountType,  sortCode: $sortCode";
  }
}
