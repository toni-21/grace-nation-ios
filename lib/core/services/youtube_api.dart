import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:grace_nation/core/models/channel.dart';
import 'package:grace_nation/core/models/video.dart';
import 'package:grace_nation/utils/constants.dart';

class YoutubeApi {
  YoutubeApi._instantiate();

  static final YoutubeApi instance = YoutubeApi._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String? _nextPageToken;

  Future<List<Video>> fetchVideos({bool freshList = false}) async {
    Channel channel = Channel(
      id: AppConfig.channelId,
      title: "Chris Okafor",
      profilePictureUrl:
          "https://yt3.ggpht.com/UiEKk1OziSNt_nyViNMz2C-DNQK_Lfc1sGr0mkhEPXbJalASQ8ZqcsQ8yWVZT-WOg3AXzjfa=s88-c-k-c0x00ffffff-no-rj",
      uploadPlaylistId: AppConfig.okaforPlaylistlId,
    );

    // Refresh List if applicable
    if (freshList == true) {
      _nextPageToken = null;
    }

    Map<String, String> parameters = _nextPageToken == null
        ? {
            'part': 'snippet',
            'playlistId': AppConfig.okaforPlaylistlId,
            'maxResults': '8',
            'key': AppConfig.youtubeAPIKEY,
          }
        : {
            'part': 'snippet',
            'playlistId': AppConfig.okaforPlaylistlId,
            'maxResults': '8',
            'pageToken': _nextPageToken!,
            'key': AppConfig.youtubeAPIKEY,
          };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      for (int i = 0; i < videosJson.length; i++) {
        final Video video = Video.fromMap(videosJson[i]['snippet']);
        videos.add(video);
      }
      if (videos.isNotEmpty) {
        channel.videos = videos;
      } else {
        print('VIDEO list is empty');
      }
      return channel.videos!;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<Video> getVideoDetails({required Video video}) async {
    final completeVideo = video;

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': video.id,
      'key': AppConfig.youtubeAPIKEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/videos',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      Map<String, dynamic> videosJson = data['items'][0];
      String videoDuration = videosJson['contentDetails']['duration'];
      completeVideo.views = int.parse(videosJson["statistics"]["viewCount"]);
      int duration = convertTime(videoDuration);
      final newDuration = Duration(seconds: duration);
      // final result = _printDuration(newDuration);
      completeVideo.duration = newDuration;
      return completeVideo;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    String hourString = duration.inHours == 0
        ? ''
        : ('${int.parse(twoDigits(duration.inHours))}h ');
    String minuteString = int.parse(twoDigitMinutes) == 0
        ? ''
        : ('${int.parse(twoDigitMinutes)}m ');
    return "$hourString$minuteString${int.parse(twoDigitSeconds)}s";
  }

  int convertTime(String duration) {
    RegExp regex = new RegExp(r'(\d+)');
    List<String> a =
        regex.allMatches(duration).map((e) => e.group(0)!).toList();

    if (duration.indexOf('M') >= 0 &&
        duration.indexOf('H') == -1 &&
        duration.indexOf('S') == -1) {
      a = ["0", a[0], "0"];
    }

    if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1) {
      a = [a[0], "0", a[1]];
    }
    if (duration.indexOf('H') >= 0 &&
        duration.indexOf('M') == -1 &&
        duration.indexOf('S') == -1) {
      a = [a[0], "0", "0"];
    }

    int seconds = 0;

    if (a.length == 3) {
      seconds = seconds + int.parse(a[0]) * 3600;
      seconds = seconds + int.parse(a[1]) * 60;
      seconds = seconds + int.parse(a[2]);
    }

    if (a.length == 2) {
      seconds = seconds + int.parse(a[0]) * 60;
      seconds = seconds + int.parse(a[1]);
    }

    if (a.length == 1) {
      seconds = seconds + int.parse(a[0]);
    }
    return seconds;
  }
}
