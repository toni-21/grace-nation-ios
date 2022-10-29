import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/core/models/notes_model.dart';
import 'package:grace_nation/core/services/notes_db_worker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/styles.dart';

class NotesEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotesEntryState();
  }
}

class _NotesEntryState extends State<NotesEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _save(BuildContext context) async {
    final now = DateTime.now();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final prov = Provider.of<AppProvider>(context, listen: false);
    String date = DateFormat('MM/dd/yyyy hh:mm a').format(now);
    print('edited at is $date');
    prov.selectedNote.title = prov.titleEditingController!.text;
    prov.selectedNote.content = prov.contentEditingController!.text;
    prov.selectedNote.date = date;

    if (prov.selectedNote.id == null) {
      await NotesDBWorker.db.create(prov.selectedNote);
    } else {
      await NotesDBWorker.db.update(prov.selectedNote);
    }
    prov.loadNoteList();
    prov.setNoteStackIndex(0);

    prov.titleEditingController = null;
    prov.contentEditingController = null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            "Note Saved",
            style: TextStyle(color: white),
          ),
          backgroundColor: babyBlue,
          duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context, listen: false);
    // setState(() {
    //   prov.selectedNote.title == null ? "" : prov.selectedNote.title!.trim();
    //   _contentEditingController.text = "";
    // });

    return Container(
      height: double.infinity,
      color: Theme.of(context).highlightColor,
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Theme.of(context)
                        .hintColor, // Colors.black.withOpacity(0.5),
                    decoration: InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    controller: prov.titleEditingController,
                    validator: (String? value) {
                      if (value == null) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    cursorColor: Theme.of(context).hintColor,
                    keyboardType: TextInputType.multiline,
                    controller: prov.contentEditingController,
                    minLines: 12,
                    maxLines: 12,
                    decoration: InputDecoration(
                      hintText: "Content",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    validator: (String? value) {
                      if (value == null) {
                        return "Please enter content";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border(
                  top: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Row(
                children: <Widget>[
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final prov =
                          Provider.of<AppProvider>(context, listen: false);
                      prov.titleEditingController = null;
                      prov.contentEditingController = null;
                      prov.setNoteStackIndex(0);
                    },
                  ),
                  Spacer(),
                  Text(
                    "Edited at ${prov.selectedNote.date ?? ""}",
                    style: TextStyle(
                      color: darkGray,
                      fontSize: 10,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    child: Text(
                      "Save",
                      style: TextStyle(color: babyBlue, fontSize: 16),
                    ),
                    onPressed: () {
                      _save(context);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
