import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/support_type.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PartnershipApi {
  Future<List<SupportType>> getSupportTypes() async {
    List<SupportType> supportList = [];
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.supportTypes}');
      final response = await http.get(
        Uri.parse(AppConfig.supportTypes),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("SUPPORT TYPE LIST SUCCESSFUL");
        final List map = decodedResponse['data'];
        for (int i = 0; i < map.length; i++) {
          Map<String, dynamic> jsn = map[i];
          final spType = SupportType.fromJson(jsn);
          supportList.add(spType);
        }
        return supportList;
      } else {
        debugPrint("SUPPORT TYPE LIST FAILED");
        String message = decodedResponse["message"];
        return supportList;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> listPartnerships() async {
    Map<String, dynamic> map = {};
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.partnerships}');
      final response = await http.get(
        Uri.parse(AppConfig.partnerships),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      map = decodedResponse;
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PARTNERSHIP LIST SUCCESSFUL");
        String message = 'success';
        return map;
      } else {
        debugPrint("PARTNERSHIP LIST FAILED");
        String message = decodedResponse["message"];
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> createPartnership({
    required double amount,
    required String currency,
    required int supportType,
    required String paymentType,
    required String frequency,
    String? startDate,
    required String endDate,
    required int transactionId,
    int? paymentId,
  }) async {
    Map<String, dynamic> map = {};
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";

    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      "support_type": supportType,
      "payment_type": paymentType,
      "frequency": frequency,
      "start_date": startDate,
      "end_date": endDate,
      "transaction_id": transactionId,
      "payment_id": paymentId,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.partnerships}');
      final response = await http.post(
        Uri.parse(AppConfig.partnerships),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      map = decodedResponse;
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PARTNERSHIP CREATED SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("CREATE PARTNERSHIP FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> createOfflinePartnership({
    required double amount,
    required String currency,
    required int supportType,
    required String paymentType,
    required String frequency,
    String? startDate,
    required String endDate,
    int? paymentId,
  }) async {
    Map<String, dynamic> map = {};
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";

    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      "support_type": supportType,
      "payment_type": 'offline',
      "frequency": frequency,
      "start_date": startDate,
      "end_date": endDate,
      "payment_id": paymentId,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.partnerships}');
      final response = await http.post(
        Uri.parse(AppConfig.partnerships),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      map = decodedResponse;
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PARTNERSHIP CREATED SUCCESSFUL");
        String message = 'success';
        return message;
      } else {
        debugPrint("CREATE PARTNERSHIP FAILED");
        String message = decodedResponse["message"];
        return message;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
