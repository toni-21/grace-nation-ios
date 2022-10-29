import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:provider/provider.dart';

class NavBar extends StatelessWidget {
  final bool isMainPage;
  const NavBar({Key? key, this.isMainPage = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 9),
          child: GNav(
            rippleColor: babyBlue.withOpacity(0.3),
            hoverColor: babyBlue.withOpacity(0.3),
            gap: 8,
            tabBorderRadius: 10,
            activeColor: babyBlue,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: babyBlue.withOpacity(0.2),
            color: darkGray,
            tabs: [
              GButton(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                icon: Icons.home,
                leading: ImageIcon(AssetImage('assets/icons/home.png'),
                    color: Provider.of<AppProvider>(context, listen: true).getSelectedTab == 0 ? babyBlue : darkGray),
                text: 'Home',
              ),
              GButton(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                icon: Icons.headphones,
                leading: ImageIcon(AssetImage('assets/icons/headphones.png'),
                    color: Provider.of<AppProvider>(context, listen: true).getSelectedTab == 1 ? babyBlue : darkGray),
                text: 'Messages',
              ),
              GButton(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                icon: CupertinoIcons.tv,
                leading: ImageIcon(AssetImage('assets/icons/tv.png'),
                    color: Provider.of<AppProvider>(context, listen: true).getSelectedTab == 2 ? babyBlue : darkGray),
                text: 'Liberation TV',
              ),
              GButton(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                icon: Icons.clean_hands,
                leading: ImageIcon(AssetImage('assets/icons/give_money.png'),
                    color: Provider.of<AppProvider>(context, listen: true).getSelectedTab == 3 ? babyBlue : darkGray),
                text: 'Give',
              ),
            ],
            selectedIndex: Provider.of<AppProvider>(context, listen: false).getSelectedTab,
            onTabChange: (index) {
              //Provider.of<AppProvider>(context, listen: false).goToTab(-1);
              Provider.of<AppProvider>(context, listen: false).goToTab(index);
              switch (index) {
                case 0:
                  Provider.of<AppProvider>(context, listen: false).goToDrawer(0);
                  context.go('/homepage');
                  break;
                case 1:
                  Provider.of<AppProvider>(context, listen: false).goToDrawer(5);
                  context.go('/messages');
                  break;
                case 2:
                  Provider.of<AppProvider>(context, listen: false).goToDrawer(0);
                  context.go('/liberationTV');
                  break;
                case 3:
                  Provider.of<AppProvider>(context, listen: false).goToDrawer(1);
                  context.go('/give');
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
