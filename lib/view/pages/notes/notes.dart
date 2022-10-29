import 'package:flutter/material.dart';
import 'package:grace_nation/view/pages/notes/notes_entry.dart';
import 'package:grace_nation/view/pages/notes/notes_list.dart';
import 'package:provider/provider.dart';
import 'package:grace_nation/core/providers/app_provider.dart';

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<AppProvider>(context, listen: false).loadNoteList();
    // });
    Provider.of<AppProvider>(context, listen: false).loadNoteList();
    return IndexedStack(
      index: Provider.of<AppProvider>(context, listen: true)
          .noteStackIndex, //model.stackIndex,
      children: [NotesList(), NotesEntry()],
    );
  }
}
