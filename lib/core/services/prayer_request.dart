import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/api_asset.dart';
import 'package:grace_nation/core/models/bible_verse.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerRequestApi {
  Future<String> prayerRequest({
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required int maritalStatus,
    required String prayerRequest,
  }) async {
    String defaultCountryCode = "+234";
    if (phone.startsWith("0")) {
      phone = phone.replaceFirst("0", defaultCountryCode);
      print(phone);
    } else {
      phone = defaultCountryCode + phone;
    }
    Map<String, dynamic> body = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "gender": gender,
      "marital_status": maritalStatus,
      "hereby": "hereby statement",
      "prayer_request": prayerRequest,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.prayerRequest}');
      final response = await http.post(
        Uri.parse(AppConfig.prayerRequest),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PRAYER SUBMITTED SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("PRAYER SUBMISSION FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
