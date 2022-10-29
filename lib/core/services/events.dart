import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/api_asset.dart';
import 'package:grace_nation/core/models/bible_verse.dart';
import 'package:grace_nation/core/models/event.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsApi {
  Future<List<Event>> getEvents() async {
    List<Event> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.events}');
      final response = await http.get(
        Uri.parse(AppConfig.events),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("EVENTS LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          final newEvent = Event.fromJson(map);
          result.add(newEvent);
        }
        // return List.from(result.reversed);
        return result;
      } else {
        debugPrint("EVENTS LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
