import 'package:flutter/foundation.dart';

class AudioTrack {
  String title;
  String source;
  Uint8List? image;
  DateTime date;

  AudioTrack(
      {required this.title,
      required this.source,
      required this.date,
      this.image});

  @override
  String toString() {
    return "title: $title, source: $source, date: ${date.toString()}, image: ${image != null ? "true" : "false"}";
  }
}
