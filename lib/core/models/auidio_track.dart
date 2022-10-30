import 'dart:io';

class AudioTrack {
  String title;
  String source;
  File? image;
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
