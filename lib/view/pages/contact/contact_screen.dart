import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';

class ContactScreen extends StatelessWidget {
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
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
            actionScreen: false,
            appBar: AppBar(),
            title: 'Contact and Support'),
        drawer: AppDrawer(),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Text(
                '\nHEADQUARTERS',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'PLOT 4-12 OSHOFISAN STREET OFF ODOZI STREET BY EREKE BUS-STOP, OJODU BERGER LAGOS, NIGERIA.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\nPRAYER & CONSELLING',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '''+234 803 272 9060\n'''
                '''+234 807 337 5176\n'''
                '''+234 816 241 0229\n'''
                '''+234 809 590 6161''',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\nFor more information, kindly reach out to us via our dedicated help page,',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                child: Text(
                  'Contact Grace Nation',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () => _launchUrl('https://gracenation.ng/pages/contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
