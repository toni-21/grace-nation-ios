import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/notification.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsApi {
  Future<List<Notifications>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    List<Notifications> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $accessToken"
    };
    try {
      debugPrint(' endpoint is ${AppConfig.notifications}');
      final response = await http.get(
        Uri.parse(AppConfig.notifications),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("NOTIFICATIONS LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          Notifications notifications = Notifications.fromJson(map);
          result.add(notifications);
        }
        return result;
      } else {
        debugPrint("NOTIFICATIONS LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
