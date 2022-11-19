import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/giving_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grace_nation/utils/constants.dart';

class GivingPayment {
  Future<Map<String, dynamic>> initializePayment({
    required double amount,
    required String currency,
    required int givingTypeId,
    String? memberId,
  }) async {
    Map<String, dynamic> map = {};
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    print(accessToken);
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      "giving_type_id": givingTypeId,
      "member_id": memberId
    };
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.initializeGivings}');
      final response = await http.post(
        Uri.parse(AppConfig.initializeGivings),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        debugPrint("GIVINGS SINITIALIZE SUCCESSFUL");
        map = {'status': 'success', 'data': decodedResponse['data']};
        return map;
      } else {
        debugPrint("GIVINGS INITIALIZE FAILED");
        map = {'status': 'failed', 'message': decodedResponse["message"]};
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<GivingType>> fetchGivingTypes() async {
    List<GivingType> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.givingTypes}');
      final response = await http.get(Uri.parse(AppConfig.givingTypes),
          headers: requestHeaders);
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("GivingType LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          final newGivingType = GivingType.fromJson(map);
          result.add(newGivingType);
        }
        return result;
      } else {
        debugPrint("GivingType LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> recordPayment({
    required String reference,
    required int givingTypeId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    print(accessToken);
    Map<String, dynamic> body = {
      "reference": reference,
      "giving_type_id": givingTypeId,
    };
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.givingRecordPayment}');
      final response = await http.post(
        Uri.parse(AppConfig.givingRecordPayment),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("GIVINGS RECORD SUCCESSFUL");
        return 'success';
      } else {
        debugPrint("GIVINGS RECORD FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> gatewayPayment(
      {required BuildContext context,
      required String amount,
      required String referenceId,
      required String planId,
      required String publicKey,
      required String currency,
      required String email}) async {
    var client = http.Client();
    Map<String, dynamic> map = {};

    final Map<String, dynamic> customer = {'email': email};

    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      "tx_ref": referenceId,
      "redirect_url": 'https://www.google.com',
      "customer": customer,
      "payment_plan": planId,
      "payment_options": "card",
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer $publicKey"
    };

    //static const _PROD_BASE_URL = "https://api.ravepay.co/v3/sdkcheckout/";
    String url =
        'https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/payments';
    final uri = Uri.parse(url);
    try {
      final response = await client.post(
        uri,
        body: json.encode(body),
        headers: {
          HttpHeaders.authorizationHeader: publicKey,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      map = decodedResponse;
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("FLUTTER WAVE REQUEST SUCCESSFUL");
        return map;
      } else {
        debugPrint("FLUTTER WAVE REQUEST REQUEST FAILED");
        String message = decodedResponse["message"];
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
