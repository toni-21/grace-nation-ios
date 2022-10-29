import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/api_asset.dart';
import 'package:grace_nation/core/models/bible_verse.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:grace_nation/core/models/testimonies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestimoniesApi {
  Future<List<Testimony>> getTestimonies() async {
    List<Testimony> result = [];
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.testimonies}');
      final response = await http.get(
        Uri.parse(AppConfig.testimonies),
        headers: requestHeaders,
      );
      debugPrint(response.body);
      final decodedResponse = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("TESTIMONIES LIST SUCCESSFUL");

        final List data = decodedResponse['data'];
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> map = data[i];
          Testimony testimony = Testimony(
            uuid: map['uuid'],
            title: map['title'],
            description: map['description'],
            testifier: map['testifier'],
            createdAt: map["created_at"],
            imagefileName: map['image'].toString() == '[]'
                ? ""
                : map['image']['file_name'],
            imageId: map['image'].toString() == '[]' ? "" : map['image']['id'],
            imageUrl:
                map['image'].toString() == '[]' ? "" : map['image']['url'],
            imagefilePath: map['image'].toString() == '[]'
                ? ""
                : map['image']['file_path'],
            // imagefilePath: map['image']['file_path'],
          );
          result.add(testimony);
        }
        return List.from(result.reversed);
      } else {
        debugPrint("TESTIMONIES LIST FAILED");
        print(decodedResponse["message"]);
        return result;
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> newTestimony({
    required String title,
    required String description,
    required String testifier,
    required String email,
    PlatformFile? image,
    PlatformFile? video,
  }) async {
    Map<String, String> body = {
      'title': title,
      'description': description,
      'testifier': testifier,
      'email': email,
    };

    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
    };
    try {
      debugPrint(' endpoint is ${AppConfig.testimonies}');
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(AppConfig.testimonies),
      );

      if (image != null) {
        var imageFile = await http.MultipartFile.fromPath(
          "payment_evidence",
          image.path!,
          filename: image.name,
        );
        request.files.add(imageFile);
        print("IMAGE FILE ADDED");
      }
      if (video != null) {
        var videoFile = await http.MultipartFile.fromPath(
          "payment_evidence",
          video.path!,
          filename: video.name,
        );
        request.files.add(videoFile);
        print("VIDEO FILE ADDED");
      }

      request.headers.addAll(requestHeaders);
      request.fields.addAll(body);
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      print(responseData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("ADD EVENT SUCCESSFUL");
        return 'success';
      } else {
        print(response.statusCode);
        print("ADD EVENT FAILED");
        return responseData['message'];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
