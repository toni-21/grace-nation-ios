import 'package:flutter/material.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/view/pages/app/give_screen.dart';
import 'package:grace_nation/view/pages/app/homepage.dart';
import 'package:grace_nation/view/pages/app/liberationtv_screen.dart';
import 'package:grace_nation/view/pages/app/messages.dart';
import 'package:grace_nation/view/pages/downloads/audio_player.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/navbar.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatefulWidget {
  final int index;
  AppScreen({required String tab, Key? key})
      : index = indexFrom(tab),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppScreenState();
  }

  static int indexFrom(String tab) {
    switch (tab) {
      case 'messages':
        return 1;
      case 'liberationTV':
        return 2;
      case 'give':
        return 3;
      case 'homepage':
      default:
        return 0;
    }
  }
}

class _AppScreenState extends State<AppScreen> {
  static List<Widget> pages = <Widget>[
    HomePage(),
    MessagesScreen(),
    LiberationTVScreen(),
    GiveScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    String getTitle() {
      switch (widget.index) {
        case 0:
          return '';
        case 1:
          return 'Messages';
        case 2:
          return 'Liberation TV';
        case 3:
          return 'Offerings and Tithes';
        default:
          return '';
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
        key: Provider.of<AppProvider>(context, listen: false).scaffoldKey,
        appBar: AppBarWidget(
            appBar: AppBar(), actionScreen: false, title: getTitle()),
        drawer: AppDrawer(),
        body: IndexedStack(
          index: Provider.of<AppProvider>(context, listen: true)
                  .getSelectedTab
                  .isNegative
              ? 4
              : Provider.of<AppProvider>(context, listen: true).getSelectedTab,
          children: pages,
        ),
        bottomNavigationBar: NavBar());
  }
}
