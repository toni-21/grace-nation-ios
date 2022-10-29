import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:float_column/float_column.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';

class AboutUsScreen extends StatelessWidget {
  _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Launching url went wrong');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tsf = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
            actionScreen: false, appBar: AppBar(), title: 'About Us'),
        drawer: AppDrawer(),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              FloatColumn(
                children: [
                  Floatable(
                    float: FCFloat.end,
                    maxWidthPercentage: 0.47,
                    padding:
                        const EdgeInsetsDirectional.only(end: 12, start: 5),
                    child: Image(
                        image: AssetImage('assets/images/pastor_profile.png')),
                  ),
                  WrappableText(
                    //  textAlign: TextAlign.,
                    textScaleFactor: tsf,
                    text: TextSpan(
                      text: '\nDr. ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        //color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Chris Okafor',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              ' is a dynamic multi-faceted preacher the Lord has decanted His spirit upon, elevated him high in the divine echelon of grace and power which has propelled him to mega dimensions of barrier breaking in Christendom.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Text(
                    'He is the senior pastor of Grace Nation International a.k.a Liberation City registered as Mountain of Liberation and Miracles Ministries, the chief host and president of Liberation TV worldwide, the stalwart of Chris Okafor World Outreach Ministries (COWOM), the grand patron of Chris Okafor Humanity Foundation (COHF) and the provost of the Liberation Bible Institute.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\nDr. Chris Okafor is a progeny of Christ, bestowed with the fivefold ministry gifts of our Lord Jesus Christ. A dynamic teacher with a plethora of wisdom, knowledge and understanding of the word of God and divine ability to decipher, decrypt and demystify the deeper meanings and messages of the bible hereby delivering to mankind God’s epistle... ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            //color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _launchUrl(
                              'https://gracenation.ng/pages/chrisokafor'),
                          child: Text(
                            'read more',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ]),
                  Text(
                    '\nVISION STATEMENT',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'To reach the world with prophetic mantle, commanding total liberation, deliverance and restoration for all round upliftment and fulfilment.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '\nMISSION STATEMENT',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'To take the gospel of our Lord Jesus Christ to the world, fulfilling the great commission and liberating mankind from the kingdom of darkness by prophetic intervention, depopulating the kingdom of darkness and making Jesus popular, turning sinners to saints.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '\nOUR CORE OBJECTIVE',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Snatch them from the world, teach them, deliver them, preserve them and keep them rapturable.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '\nOUR CORE VALUES',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Love, Accountability, Righteousness, Discipline, Excellence and Friendliness. As at today, Grace Nation has 62 Branches all around the world.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                      child: Text(
                        'Read more about Grace Nation',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () => _launchUrl(
                          'https://gracenation.ng/pages/gracenation')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
