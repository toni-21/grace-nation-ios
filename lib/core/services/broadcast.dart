import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;

class BroadcastApi {
  Future<Map<String, dynamic>> getBroadcast() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.broadcast}');
      final response = await http.get(
        Uri.parse(AppConfig.broadcast),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("EVENTS LIST SUCCESSFUL");

        //final List data = decodedResponse['data'];
        // for (int i = 0; i < data.length; i++) {
        //   Map<String, dynamic> map = data[i];
        //   final newEvent = Event.fromJson(map);
        //   result.add(newEvent);
        // }
        return decodedResponse;
      } else {
        debugPrint("EVENTS LIST FAILED");
        print(decodedResponse["message"]);
        return decodedResponse;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
