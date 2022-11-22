import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/models/partnership.dart';
import 'package:grace_nation/core/models/transactions.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/providers/auth_provider.dart';
import 'package:grace_nation/core/services/partnership.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/partnership/partnership_widget.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/custom_fab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnershipPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PartnershipPageState();
  }
}

class _PartnershipPageState extends State<PartnershipPage>
    with TickerProviderStateMixin {
  bool isLoading = false;
  final partnerApi = PartnershipApi();
  List<Partnership> _partnership = [];
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  double broadcasterProgress = 20;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

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
  void initState() {
    _getPartnerships();
    super.initState();
  }

  void _getPartnerships() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> p = await partnerApi.listPartnerships();

    print("P IS $p");
    List data = p["data"] ?? [];
    List<Partnership> partness = [];
    for (int i = 0; i < data.length; i++) {
      Partnership partnership = Partnership.fromJson(data[i]);
      List<Transactions> transacsss = [];
      String m = partnership.supportCategory;
      Provider.of<AuthProvider>(context, listen: false).supportTypes.add(m);
      List transacs = data[i]["transactions"];
      for (int j = 0; j < transacs.length; j++) {
        final transactions = Transactions.fromJson(transacs[j]);
        transacsss.add(transactions);
      }
      partnership.transactions = List.from(transacsss.reversed);
      partness.add(partnership);
    }
    _partnership = partness;
    print("NUMBER OF PARTNERSHIPS IS ${_partnership.length}");
    setState(() {
      isLoading = false;
    });
  }

  Widget helpWidget() {
    return Container(
      height: 180,
      width: 226,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Need help related to your partnership?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              decoration: TextDecoration.none,
              color: Theme.of(context).primaryColorDark,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.asset('assets/icons/whatsapp.png'),
              SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  String str = Provider.of<AppProvider>(context, listen: false)
                      .preferences
                      .whatsappNumber!;

                  _launchUrl('whatsapp://send?phone=$str');
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact),
                child: Text(
                  'WhatsApp Support',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                'assets/icons/phone-call.png',
                color: Theme.of(context).iconTheme.color,
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  _launchUrl(
                      'tel:${Provider.of<AppProvider>(context, listen: false).preferences.supportNumber}');
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  'Telephone Support',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List partnerships = [1, 2];
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: false,
          title: 'Partnership',
          appBar: AppBar(),
        ),
        drawer: AppDrawer(),
        floatingActionButton: CustomFAB(onTap: () {
          context.goNamed(createPartnershipRouteName);
        }),
        body: isLoading
            ? Container(
                color: Colors.black.withOpacity(0.005),
                child: Center(
                  child: CircularProgressIndicator(
                    color: babyBlue,
                  ),
                ))
            : RefreshIndicator(
                color: Colors.white,
                backgroundColor: babyBlue,
                displacement: 75,
                semanticsLabel: "Pull down to refresh",
                onRefresh: () async {
                  // Replace this delay with the code to be executed during refresh
                  // and return asynchronous code
                  return Future<void>.delayed(const Duration(milliseconds: 600),
                      () {
                    _getPartnerships();
                  });
                },
                notificationPredicate: (ScrollNotification notification) {
                  return notification.depth == 0;
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      _partnership.isEmpty
                          ? Container(
                              child: ListView(
                                padding:
                                    EdgeInsets.symmetric(horizontal: xPadding),
                                children: [
                                  SizedBox(height: 24),
                                  Image.asset(
                                    'assets/images/partner-question.png',
                                    fit: BoxFit.scaleDown,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'You have not created any partnership support yet, please click on the + button to start now. God bless you as you give your financial support to help the church grow and reach more lifes. ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 24),
                              // reverse: true,
                              //   shrinkWrap: true,
                              itemCount: _partnership.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                    onTap: () {
                                      String text =
                                          _partnership[index].supportCategory;
                                      Provider.of<AppProvider>(context,
                                              listen: false)
                                          .selectPartnership(
                                              _partnership[index]);
                                      context.goNamed(
                                          partnershipDetailRouteName,
                                          params: {'text': text});
                                    },
                                    child: PartnershipWidget(
                                        partnership: _partnership[index]));
                              },
                            ),
                      Positioned(
                        top: MediaQuery.of(context).size.height / 3.6,
                        child: InkWell(
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierLabel: "Barrier",
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: Duration(milliseconds: 200),
                              pageBuilder: (_, __, ___) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Center(child: helpWidget());
                                });
                              },
                              transitionBuilder: (_, anim, __, child) {
                                Tween<Offset> tween;
                                if (anim.status == AnimationStatus.reverse) {
                                  tween = Tween(
                                      begin: Offset(0, 1), end: Offset.zero);
                                } else {
                                  tween = Tween(
                                      begin: Offset(0, 1), end: Offset.zero);
                                }

                                return SlideTransition(
                                  position: tween.animate(anim),
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            // color: Colors.red,
                            padding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 3, right: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              boxShadow: [
                                BoxShadow(
                                    color: darkGray.withOpacity(0.55),
                                    blurRadius: 7,
                                    spreadRadius: -3,
                                    offset: const Offset(2, 1)),
                              ],
                            ),
                            //width: 36,
                            child: Column(
                              //  mainAxisAlignment: MainAxisAlignment.start,
                              //crossAxisAlignment: Cr,
                              children: <Widget>[
                                RotatedBox(
                                  quarterTurns: -1,
                                  child: SvgPicture.asset(
                                    'assets/icons/help-message.svg',
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                                RotatedBox(
                                    quarterTurns: -1,
                                    child: SizedBox(
                                      width: 5,
                                    )),
                                RotatedBox(
                                  quarterTurns: -1,
                                  child: Text('Help'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 3.6,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context.goNamed(profileRouteName);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 16, bottom: 12),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(0, 143, 172, 1),
                                      Color.fromRGBO(0, 169, 203, 1)
                                    ],
                                  )),
                              // height: 55,
                              // width: 55,

                              child: (Provider.of<AuthProvider>(context)
                                              .user
                                              .avatar ==
                                          "" ||
                                      Provider.of<AuthProvider>(context)
                                              .user
                                              .avatar ==
                                          null)
                                  ? CircleAvatar(
                                      radius: 27.5,
                                      backgroundColor: deepBlue,
                                      child: Icon(
                                        CupertinoIcons.person_solid,
                                        size: 30,
                                        color: white.withOpacity(0.88),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 27.5,
                                      backgroundColor: deepBlue,
                                      backgroundImage: NetworkImage(
                                          Provider.of<AuthProvider>(context)
                                              .user
                                              .avatar!),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
