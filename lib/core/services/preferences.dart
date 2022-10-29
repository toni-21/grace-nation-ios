import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/accout_details.dart';
import 'package:grace_nation/core/models/preferences.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;

class PreferencesApi {
  Future<Preferences> getPreferences() async {
    Preferences prefs = Preferences();
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.preferences}');
      final response = await http.get(
        Uri.parse(AppConfig.preferences),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PREFERENCES SUCCESSFUL");
        List accounts =
            decodedResponse['data']['partnership_bank_accounts'] as List;
        List<AccountDetails> details = [];
        for (int i = 0; i < accounts.length; i++) {
          final AccountDetails det = AccountDetails.fromJson(accounts[i]);
          details.add(det);
          print("${det.toString()} added account");
        }
        final Map<String, dynamic> json = decodedResponse['data'];

        return Preferences(
            embedCode: json["embed_code"],
            bankAccounts: details,
            supportNumber: json["support_number"],
            whatsappNumber: json["whatsapp_number"]);
      } else {
        debugPrint("PREFERENCES FAILED");
        print(decodedResponse["message"]);
        return prefs;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
