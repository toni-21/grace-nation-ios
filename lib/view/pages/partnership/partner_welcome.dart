import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';

class PartnerWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Partner Welcome',
        appBar: AppBar(),
      ),
    
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: xPadding, vertical: 30),
          children: [
            Text(
              'Dear Ministry Partners,',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Calvary greetings to you in the name of our Lord Jesus Christ, who by His mercies and divine ordination has elected me a labourer in His vineyard. It gives me great pleasure to know that you have chosen to be a part of what God is doing through our ministry, taking the gospel of Jesus Christ and the liberation mandate across the world.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Your generosity and commitment as a Kingdom covenant partner (KCP) will help in advancing the frontiers of Gods Kingdom here on earth through our various ministry directorate and outreaches as we also continually covet your prayers in fulfilling this mandate.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'My prayer for you is that your gifts and labour of love will not go unrewarded and may your seeds be a memorial for your reckoning.\nAmen.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 25),
            Text('Yours in His Vineyard',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
            Text('Dr. Chris Okafor',
                style: GoogleFonts.kaushanScript(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )),
            Text(
              'Senior Pastor',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              children: [
                Text(
                  'Want to know more about Kingdom Covenant Partners (KCP)? Visit our website here',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'https://partnership.gracenation.ng/',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 36),
            CustomButton(
                text: 'Register Now',
                onTap: () {
                  context.goNamed(partnerRegistrationRouteName);
                })
          ],
        ),
      ),
    );
  }
}
