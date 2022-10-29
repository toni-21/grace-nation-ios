import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final String description;
  const AlertWidget({Key? key, required this.title, required this.description})
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
        padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
        decoration: BoxDecoration(
          color:  Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/failed.png',
              height: 75,
              width: 75,
            ),
            SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                decoration: TextDecoration.none,
                color:  Theme.of(context).focusColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                decoration: TextDecoration.none,
                color:  Theme.of(context).focusColor.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: 150,
              height: 45,
              child: CustomButton(
                text: 'Back',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
