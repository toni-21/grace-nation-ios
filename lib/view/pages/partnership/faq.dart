import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_collapsable.dart';

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: true,
          title: 'Frequently Asked Questions',
          appBar: AppBar(),
        ),
        body: SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: xPadding, vertical: 30),
            children: [
              CustomCollapsable(
                preview: Text(
                  '1. WHO IS A KINGDOM COVENANT PARTNER?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  'A kingdom covenant partner is one financially committed to the Grace Nation and the various ministry Directorates presided over by Gods servant Dr Chris Okafor on a monthly, quarterly or annual basis with specified kingdom love gifts. Like Aaron and hurl these ones uphold the hands of the visional of the liberation city in prayers and in giving to the necessity of the ministry.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 25),
              CustomCollapsable(
                preview: Text(
                  '2. WHAT IS THE PARTNERSHIP FOCUS?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  '''Partnerships  is focused on specific ministry undertaking to sustain and expand the reach of new and ongoing Programs and events. These includes '''
                  '''\nLIBERATION TV'''
                  '''\nGRACE NATION CHURCH EXPANSION PROJECT'''
                  '''\nGIVE US THIS DAY-DAILY DEVOTIONAL'''
                  '''\nCHRIS OKAFOR HUMANITY FOUNDATION'''
                  '''\nCHRIS OKAFOR WORLD OUTREACH MINISTRY.''',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 25),
              CustomCollapsable(
                preview: Text(
                  '3. PARTNERSHIP CATEGORIES:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  '''The partnership categories shall be but not limited'''
                  '''\nA. KINGDOM VESSEL-5,000-100,000'''
                  '''\nB. KINGDOM ADVANCER-100,000-500,000'''
                  '''\nC. KINGDOM AMPLIFIER -500,000-1,000,000'''
                  '''\nD. KINGDOM BROADCASTER-1M and Above.''',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 25),
              CustomCollapsable(
                preview: Text(
                  '4. PRIVILEGES OF KINGDOM COVENANT PARTNERS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  '''\nRegular update of ministry activities, outreaches and other events'''
                  '''\nFree  Access to some online ministry materials such as messages, e-books and copies of daily devotionals.'''
                  '''\nInvitation to the annual KCP awards and dinner with senior pastor'''
                  '''\nPartnership acknowledgment certificate'''
                  '''\nAnniversary messages from or on behalf of the Senior Pastor.'''
                  '''\nAnnual Ministry Gift from Senior Pastor.''',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ));
  }
}
