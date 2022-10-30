import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/view/pages/notifications/notifications_page.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBar appBar;
  bool? actionScreen = false;
  final bool? specialPop;
  final Widget? actions;
  AppBarWidget({
    Key? key,
    this.title,
    this.specialPop = false,
    this.actions,
    required this.actionScreen,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: title == null
          ? null
          : Text(title!,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: white)),
      centerTitle: true,
      flexibleSpace: Container(
        child: Stack(
          children: [
            Positioned(
              left: 65,
              bottom: 10,
              child: Image(
                image: AssetImage('assets/icons/header_ellipse.png'),
                color: Colors.white,
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              left: 85,
              bottom: 20,
              child: Image(
                image: AssetImage('assets/icons/header_ellipse.png'),
                color: Colors.white,
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              left: 90,
              bottom: 30,
              child: Image(
                image: AssetImage('assets/icons/header_ellipse.png'),
                color: Colors.white,
                fit: BoxFit.fitHeight,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      leading: (actionScreen!
          ? IconButton(
              padding: EdgeInsets.only(left: 15),
              onPressed: () {
                specialPop!
                    ? context.goNamed(homeRouteName, params: {'tab': 'give'})
                    : Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios),
            )
          : IconButton(
              padding: EdgeInsets.only(left: 15),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: SvgPicture.asset('assets/icons/hamburger.svg'),
            )),
      actions: actionScreen!
          ? actions == null
              ? null
              : [actions!]
          : Provider.of<AppProvider>(context, listen:true).enableNotifications == false
              ? null
              : [
                  IconButton(
                    padding: EdgeInsets.only(right: 15),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return NotificationsPage();
                      }));
                    },
                    icon: SvgPicture.asset('assets/icons/notification.svg'),
                  ),
                ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
