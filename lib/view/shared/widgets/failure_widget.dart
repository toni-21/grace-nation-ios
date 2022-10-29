import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';

class FailureWidget extends StatelessWidget {
  final String title;
  final String description;

  const FailureWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);
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
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/failed.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                decoration: TextDecoration.none,
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 7.5),
            Text(
              description,
              // 'We could not initiate your partnership plan, try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                decoration: TextDecoration.none,
                color: Theme.of(context).focusColor.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 175,
              child: CustomButton(
                  text: 'Continue',
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
