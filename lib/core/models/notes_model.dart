import 'package:flutter/material.dart';

class Note extends ChangeNotifier {
  int? id;
  String? title;
  String? content;
  String? date;

  Note({this.content, this.date, this.id, this.title});

  @override
  String toString() {
    return "{id = $id , title = $title , content = $content, date = $date}";
  }
}
