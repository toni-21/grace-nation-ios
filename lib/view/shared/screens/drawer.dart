import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppDrawerState();
  }
}

class _AppDrawerState extends State<AppDrawer> {
  final scrollController = ScrollController();
  int selectedIndex = 0;

  _launchURL(String url) async {
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

  Widget _createDrawerItem(
      {required bool selected,
      required String text,
      required GestureTapCallback onTap,
      required BuildContext context,
      String? route}) {
    return ListTile(
      contentPadding: EdgeInsets.all(1),
      minLeadingWidth: 12,
      title: text == "Messages"
          ? Row(
              children: [
                Text(text,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    )),
                SizedBox(width: 5),
                SvgPicture.asset('assets/icons/youtube.svg')
              ],
            )
          : Text(text,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              )),
      leading: Container(
        width: 10,
        height: 33,
        color: selected ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      onTap: onTap,
      dense: false,
    );
  }

  final List<Color> gradient = [
    white,
    white,
    lightBabyBlue,
    lightBabyBlue,
  ];

  @override
  Widget build(BuildContext context) {
    double fillPercent = 10;
    double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    final themeChange = Provider.of<ThemeProvider>(context);
    return Container(
      // color: babyBlue,
      child: Drawer(
        elevation: 0,
        backgroundColor: themeChange.darkTheme
            ? Color.fromARGB(255, 57, 61, 78)
            : lightBabyBlue,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                      width: 242.95,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(53.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: 65,
                            height: 75,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/lego-big.png'),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GRACE NATION',
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              (Text(
                                'Liberation City',
                                style: TextStyle(
                                  color: Color.fromRGBO(123, 127, 158, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                            ],
                          ))
                        ],
                      )),
                  IconButton(
                      padding: EdgeInsets.only(left: 8),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                      iconSize: 32,
                      color: Theme.of(context).primaryColor)
                ],
              ),
              Container(
                height: 118,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/drawer-pic.png'),
                      fit: BoxFit.fitWidth),
                ),
              ),
              Expanded(
                child: Container(
                  //    height: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      opacity: 0.15,
                      image: AssetImage('assets/images/big-logo.png'),
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    //  controller: scrollController,
                    children: [
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  0,
                          text: 'Home',
                          route: homeRouteName,
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(0);
                            context.goNamed(homeRouteName,
                                params: {'tab': 'homepage'});
                            Provider.of<AppProvider>(context, listen: false)
                                .goToTab(0);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  1,
                          text: 'Offerings & Giving',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(1);
                            context.go('/give');
                            Provider.of<AppProvider>(context, listen: false)
                                .goToTab(3);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  2,
                          text: 'Partners',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(2);
                            context.goNamed(partnerLoginRouteName);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  3,
                          text: 'Branch Locator',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(3);
                            context.goNamed(branchLocatorRouteName);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  4,
                          text: 'Broadcast Schedule',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(4);
                            context.goNamed(broadcastScheduleRouteName);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  5,
                          text: 'Messages',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(5);
                            context.go('/messages');
                            Provider.of<AppProvider>(context, listen: false)
                                .goToTab(1);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  6,
                          text: 'Downloads',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(6);
                            context.goNamed(downloadsRouteName);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  7,
                          text: 'Testimonies',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(7);
                            context.goNamed(testimoniesRouteName);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  8,
                          text: 'Events',
                          context: context,
                          onTap: () {
                            Provider.of<AppProvider>(context, listen: false)
                                .goToDrawer(8);
                            context.goNamed(eventsRouteName);
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  9,
                          text: 'Live Chat',
                          context: context,
                          onTap: () {
                            setState(() {
                              Provider.of<AppProvider>(context, listen: false)
                                  .goToDrawer(9);
                              context.goNamed(bibleRouteName);
                            });
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  10,
                          text: 'About Us',
                          route: aboutRouteName,
                          context: context,
                          onTap: () {
                            setState(() {
                              Provider.of<AppProvider>(context, listen: false)
                                  .goToDrawer(10);
                              context.goNamed(aboutRouteName);
                            });
                          }),
                      _createDrawerItem(
                          selected:
                              Provider.of<AppProvider>(context, listen: false)
                                      .getSelectedDrawer ==
                                  11,
                          text: 'Contact and Support',
                          context: context,
                          onTap: () {
                            setState(() {
                              Provider.of<AppProvider>(context, listen: false)
                                  .goToDrawer(11);
                              context.goNamed(contactRouteName);
                            });
                          }),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20, left: 27.5, bottom: 14),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _launchURL(
                                  Provider.of<AppProvider>(context,
                                              listen: false)
                                          .preferences
                                          .instagramLink ??
                                      "",
                                );
                              },
                              child: Image.asset('assets/icons/instagram.png'),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                _launchURL(
                                  Provider.of<AppProvider>(context,
                                              listen: false)
                                          .preferences
                                          .tiktokLink ??
                                      "",
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/tiktok.svg',
                                height: 30,
                                width: 30,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                _launchURL(
                                  Provider.of<AppProvider>(context,
                                              listen: false)
                                          .preferences
                                          .youtubeLink ??
                                      "",
                                );
                              },
                              child:
                                  SvgPicture.asset('assets/icons/youtube.svg'),
                            ),
                            SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                _launchURL(
                                  Provider.of<AppProvider>(context,
                                              listen: false)
                                          .preferences
                                          .facebookLink ??
                                      "",
                                );
                              },
                              child:
                                  SvgPicture.asset('assets/icons/facebook.svg'),
                            ),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 27.5, top: 6, bottom: 14),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _launchURL(
                                    'https://gracenation.ng/store/books');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      Theme.of(context).cardColor,
                                      Theme.of(context).canvasColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                width: 90,
                                height: 35,
                                child: Center(
                                    child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      size: 18,
                                      color: white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'e-Store',
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.mode_night,
                              color: Colors.black,
                            ),
                            Container(
                              height: 30, //set desired REAL HEIGHT
                              width: 45, //set desired REAL WIDTH
                              child: Transform.scale(
                                transformHitTests: false,
                                scale: .75,
                                child: CupertinoSwitch(
                                  value: !themeChange.darkTheme,
                                  onChanged: (value) {
                                    setState(() {
                                      themeChange.darkTheme = !value;
                                      themeChange.darkThemePreference
                                          .setDarkTheme(!value);
                                    });
                                  },
                                  activeColor: babyBlue,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.sunny,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
