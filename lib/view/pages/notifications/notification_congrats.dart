import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/branch/branch_result.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/navbar.dart';

class NotificationsCongrats extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationsCongratsState();
  }
}

class _NotificationsCongratsState extends State<NotificationsCongrats> {
  bool isPlaying = false;
  final _controller = ConfettiController();

  @override
  void initState() {
    print('INITING');
    _controller.play();
    Timer(Duration(milliseconds: 2400), () => _controller.stop());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          appBar: AppBarWidget(
            actionScreen: true,
            appBar: AppBar(),
            title: 'Notification',
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 24,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 90),
                  Image.asset('assets/images/notification-crown.png'),
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'You have completed your One Year support for ',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Kingdom Advancement! 🎉',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: babyBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 90),
                  CustomButton(
                      text: 'Continue',
                      onTap: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _controller,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          gravity: 0.25,
          emissionFrequency: 0.1,
        )
      ],
    );
  }
}
