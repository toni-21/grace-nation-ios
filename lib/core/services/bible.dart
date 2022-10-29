import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/bible_verse.dart';
import 'package:http/http.dart' as http;


class BibleApi {
  Future<BibleVerse> dailyVerse() async {
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };
    try {
      final response = await http.get(
        Uri.parse(
            'https://labs.bible.org/api/?passage=votd&type=json&formatting=plain'),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);
      final map = decodedResponse[0];
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("VERSE OF THE DAY SUCCESS");

        return BibleVerse(
            bookname: map['bookname'],
            chapter: map['chapter'],
            verse: map['verse'],
            text: map['text']);
      } else {
        debugPrint("VERSE OF THE DAY FAILED");

        return BibleVerse(
            bookname: null, chapter: null, verse: null, text: null);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
