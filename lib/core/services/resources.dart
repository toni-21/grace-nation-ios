// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/models/download_info.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:http/http.dart' as http;
import 'package:grace_nation/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class ResourcesApi {
  String? _taskId;
  Future<String> getVideoLink({required String videoId}) async {
    Map<String, dynamic> body = {
      "link": "https://www.youtube.com/watch?v=$videoId"
    };

    Uri uri = Uri.parse("${AppConfig.host}/resources/download-from-youtube");
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );
    print(response.body.toString());
    final decodedResponse = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = decodedResponse;
      String url = data['data']['data']['link'];

      return url;
    } else {
      throw json.decode(response.body)['message'];
    }
  }

  downloadVideo({
    required String videoUrl,
    required String videoName,
    required Duration duration,
    required BuildContext context,
    //  required PublishSubject publishSubject,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String downloadUrl = await getVideoLink(videoId: videoUrl);

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = await getApplicationDocumentsDirectory();
      String trimmedName = videoName.substring(0, min(videoName.length, 30));

      Directory vidDir = Directory("${dir.path}/videos/");
      bool exists = await vidDir.exists();
      if (!exists) vidDir = await Directory("${dir.path}/videos/").create();
      String savePath = vidDir.path;
      final vidDuration = AppConfig().printDuration(duration);
      prefs.setString('duration-$trimmedName', vidDuration);
      print(savePath);
      try {
        final taskId = await FlutterDownloader.enqueue(
          url: downloadUrl,
          savedDir: savePath,
          fileName: videoName,
          showNotification:
              false, // show download progress in status bar (for Android)
          openFileFromNotification: false,
          saveInPublicStorage:
            false, // click on notification to open downloaded file (for Android)
        );
        _taskId = taskId;
        // await FlutterDownloader.registerCallback(callback);
        // await Dio().download(
        //   downloadUrl,
        //   savePath,
        //   onReceiveProgress: (received, total) {
        //     if (total != -1) {
        //       print("${(received / total * 100).toStringAsFixed(0)}%");

        //       Provider.of<AppProvider>(context, listen: false)
        //           .setDownloading(true);
        //       Provider.of<AppProvider>(context, listen: false)
        //           .setProgressString(
        //               "${((received / total) * 100).toStringAsFixed(0)}%");
        //     }
        //   },
        // );
        Provider.of<AppProvider>(context, listen: false).setDownloading(false);
        Provider.of<AppProvider>(context, listen: false)
            .setProgressString("Completed");
        print("Image is saved to download folder.");

        //_extractAudio(savePath, trimmedName);
      } catch (e) {
      return e.toString();
      }
    } else {
      print("No permission to read and write.");
    }
  }

  Future<void> deleteDownload(String id) async {
    await FlutterDownloader.remove(
      taskId: id,
      shouldDeleteContent: true,
    );
  }

  Future<void> cancelDownload(String id) async {
    await FlutterDownloader.cancel(
      taskId: id,
    );
  }
}
