import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/models/notes_model.dart';
import 'package:grace_nation/core/services/notes_db_worker.dart';
import 'package:grace_nation/view/shared/widgets/confirmation_widget.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/styles.dart';

class NotesList extends StatelessWidget {
  Future _deleteNote(BuildContext context, Note note) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationWidget(
            title: "Delete Note",
            description: "Are you sure you want delete ${note.title}?",
            callback: () async {
              await NotesDBWorker.db.delete(note.id!);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  content: Text("Note Deleted")));
              Provider.of<AppProvider>(context, listen: false).loadNoteList();
            },
            actionText: "Delete",
            exitText: "Cancel");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AppProvider>(context, listen: false);
    final reversedList = List.from(prov.noteList.reversed);
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          ListView.builder(
              itemCount: prov.noteList.length, //
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 64),
              itemBuilder: (BuildContext context, int index) {
                Note note = reversedList[index];
                return ListTile(
                  horizontalTitleGap: 0,
                  minVerticalPadding: 0,
                  minLeadingWidth: 0,
                  onTap: () async {
                    Note n = await NotesDBWorker.db.get(note.id!);
                    print('note is .. $n');
                    prov.selectNoteBeingEdited(n);
                    prov.setNoteStackIndex(1);
                  },
                  leading: Padding(
                    padding: EdgeInsets.only(top: 5, right: 8),
                    child: CircleAvatar(backgroundColor: babyBlue, radius: 6),
                  ),
                  title: Text(
                    note.title!,
                    style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    //  "1st Oct. 1960",
                    note.date ?? "",
                    style: TextStyle(
                        color: darkGray,
                        fontSize: 10,
                        fontWeight: FontWeight.w400),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      _deleteNote(context, note);
                    },
                    child: SvgPicture.asset(
                      'assets/images/trash.svg',
                      height: 20,
                      width: 15,
                    ),
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 6, right: 12),
              child: FloatingActionButton(
                backgroundColor: babyBlue,
                onPressed: () {
                  Provider.of<AppProvider>(context, listen: false)
                      .setNoteStackIndex(1);
                  Provider.of<AppProvider>(context, listen: false)
                      .selectNoteBeingEdited(Note());
                },
                child: SvgPicture.asset(
                  'assets/icons/create-icon.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
