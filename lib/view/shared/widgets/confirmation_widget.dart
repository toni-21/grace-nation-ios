import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';

class ConfirmationWidget extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final String exitText;
  final Function callback;
  const ConfirmationWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.callback,
      required this.actionText,
      required this.exitText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14, top: 16, bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: babyBlue,
              size: 45,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                decoration: TextDecoration.none,
                color: Theme.of(context).focusColor, // Color(0xFF243656),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              // description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                decoration: TextDecoration.none,
                color: Theme.of(context).focusColor.withOpacity(0.75),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 115,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      callback();
                    },
                    child: Text(
                      // "Delete",
                      actionText,
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: babyBlue,
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 115,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      // "Cancel",
                      exitText,
                      style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGray.withOpacity(0.36),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
