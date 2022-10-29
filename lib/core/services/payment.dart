import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grace_nation/utils/constants.dart';

class PaymentApi {
  Future<Map<String, dynamic>> initializeOfflinePayment({
    required double amount,
    required String currency,
    required int supportType,
    required String paymentType,
    required String frequency,
    required String startDate,
    required String endDate,
    String? paymentId,
  }) async {
    Map<String, dynamic> map = {};
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    print(accessToken);
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      "support_type": supportType,
      "payment_type": paymentType,
      "frequency": frequency,
      "start_date": startDate,
      "end_date": endDate,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.initializePayment}');
      final response = await http.post(
        Uri.parse(AppConfig.initializePayment),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PAYMENT INITIALIZE SUCCESSFUL");
        map = {'status': 'success', 'data': decodedResponse['data']};
        return map;
      } else {
        debugPrint("PAYMENT INITIALIZE FAILED");
        map = {'status': 'failed', 'message': decodedResponse["message"]};
        return map;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<Map<String, dynamic>> initializeFlutterwavePayment({
    required double amount,
    required String currency,
    required int supportType,
    required String paymentType,
    required String frequency,
    required String startDate,
    required String endDate,
    String? paymentId,
  }) async {
    Map<String, dynamic> map = {};
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    print(accessToken);
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      "support_type": supportType,
      "payment_type": "card",
      "frequency": frequency,
      "start_date": startDate,
      "end_date": endDate,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.initializePayment}');
      final response = await http.post(
        Uri.parse(AppConfig.initializePayment),
        body: json.encode(body),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PAYMENT INITIALIZE SUCCESSFUL");
        map = {'status': 'success', 'data': decodedResponse['data']};
        return map;
      } else {
        debugPrint("PAYMENT INITIALIZE FAILED");
        map = {'status': 'failed', 'message': decodedResponse["message"]};
        return map;
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
      required String name,
      required String currency,
      required String phoneNumber,
      required String email}) async {
    var client = http.Client();
    Map<String, dynamic> map = {};

    final Map<String, dynamic> customer = {
      'name': name,
      'phonenumber': phoneNumber,
      'email': email
    };

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

  Future<String> addPaymentEvidence({
    required PlatformFile file,
    required String uuid
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    String uuids = prefs.getString('uuid')!;

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      if (file.path == "" || file.path == null) {
        return "No file provided";
      }
      print('REQEST IS ..${AppConfig.partnerships}/payments/$uuids/evidence');
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${AppConfig.partnerships}/payments/$uuid/evidence'),
      );

      var text = await http.MultipartFile.fromPath(
        "payment_evidence",
        file.path!,
        filename: file.name,
      );
      request.headers.addAll(requestHeaders);
      request.files.add(text);
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      print(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("ADD RECORD SUCCESSFUL");
        return 'success';
      } else {
        print(response.statusCode);
        print("ADD RECORD FAILED");
        return responseData['message'];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
