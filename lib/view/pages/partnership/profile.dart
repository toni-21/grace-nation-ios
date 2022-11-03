// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/support_category.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/authentication.dart';
import 'package:grace_nation/view/pages/partnership/accessible_details.dart';
import 'package:grace_nation/view/shared/widgets/alert_widget.dart';
import 'package:grace_nation/core/models/user.dart';
import 'package:grace_nation/core/providers/auth_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/app/app_screen.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  bool _enableNotifications = true;
  List<SupportCategory> categories = [];
  final authApi = AuthApi();

  static String getIconcolor(String text) {
    switch (text) {
      case 'Kingdom Broadcaster':
        return 'assets/images/profile-iron-crown.svg';
      case 'Kingdom Amplifier':
        return 'assets/images/profile-gold-crown.svg';
      case 'Kingdom Vessel':
        return 'assets/images/profile-bronze-crown.svg';
      case 'Kingdom Advancer':
      default:
        return 'assets/images/profile-silver-crown.svg';
    }
  }

  Future<void> getValues() async {
    await Provider.of<AuthProvider>(context, listen: false).getUSerDetails();
    categories =
        Provider.of<AuthProvider>(context, listen: false).user.supportCategory!;
    print(
        "support categories are  ${Provider.of<AuthProvider>(context, listen: false).user.supportCategory.toString()}");
  }

  @override
  void initState() {
    getValues();
    super.initState();
  }

  Widget kingdomType({required String text, required String key}) {
    bool present = Provider.of<AuthProvider>(context, listen: false)
        .supportTypes
        .contains(key);
    int count = 0;
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name == key) {
        present = true;
        count = categories[i].count;
      }
    }
    String colorPath = getIconcolor(key);
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).hoverColor,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SvgPicture.asset(
                colorPath,
                color: !present ? darkGray.withOpacity(0.125) : null,
              ),
              Text(
                '+${count.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w400,
                  fontSize: 8,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
            child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ))
      ],
    );
  }

  Widget actionTile(
      {required String text,
      required Function onTap,
      required bool isSvg,
      Widget? trailing,
      bool isLogout = false,
      String? asset,
      IconData? icon}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          text,
          style: TextStyle(
            color: isLogout ? Colors.red : Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: isSvg
                ? SvgPicture.asset(asset!)
                : Icon(
                    icon!,
                    color: isLogout ? Colors.red : Colors.black,
                  )),
        trailing: trailing ??
            Icon(
              Icons.keyboard_arrow_right,
              color: Theme.of(context).primaryColorDark,
              size: 28,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User profile = Provider.of<AuthProvider>(context, listen: false).user;

    var cont = Navigator.of(context);
    signout(context) async {
      String response =
          await Provider.of<AuthProvider>(context, listen: false).signout();
      if (response == 'success') {
        Provider.of<AppProvider>(context, listen: false).goToDrawer(0);
        Provider.of<AppProvider>(context, listen: false).goToTab(0);
        cont.push(MaterialPageRoute(builder: (BuildContext context) {
          return AppScreen(tab: 'homepage');
        }));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertWidget(
                title: 'Something went wrong', description: response);
          },
        );
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: true,
          title: 'Profile Settings',
          appBar: AppBar(),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 24, right: 24, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        //  color: white,
                        color: Theme.of(context).backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      height: 142,
                      width: 142,
                      child: SizedBox(
                        height: 132,
                        width: 132,
                        child: Stack(
                          children: [
                            (Provider.of<AuthProvider>(context).user.avatar ==
                                        "" ||
                                    Provider.of<AuthProvider>(context)
                                            .user
                                            .avatar ==
                                        null)
                                ? CircleAvatar(
                                    radius: 132 / 2,
                                    backgroundColor: deepBlue,
                                    child: Icon(
                                      CupertinoIcons.person_solid,
                                      size: 80,
                                      color: white.withOpacity(0.88),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 132 / 2,
                                    backgroundColor: deepBlue,
                                    // backgroundImage: FileImage(File(
                                    //     Provider.of<AuthProvider>(context)
                                    //         .user
                                    //         .avatar!)),
                                    backgroundImage: NetworkImage(
                                        Provider.of<AuthProvider>(context)
                                            .user
                                            .avatar!),
                                  ),
                            Positioned(
                              right: 2,
                              bottom: 7.5,
                              child: GestureDetector(
                                onTap: () async {
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                                  );
                                  if (result == null) return;

                                  //open single file
                                  final file = result.files.first;
                                  print('name is ${file.name}');
                                  print('path is ${file.path}');

                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .toggleIsLoading(true);

                                  // final pickedFile = await _picker.pickImage(
                                  //     source: ImageSource.gallery);
                                  // if (pickedFile == null) return;

                                  final response =
                                      await authApi.updateAvatar(file: file);

                                  if (response == 'success') {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .getUSerDetails();
                                    // setState(() {
                                    //   //    _imageFile = pickedFile;
                                    // });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertWidget(
                                              title: 'Something went wrong',
                                              description:
                                                  'Please try agin later');
                                        });
                                  }

                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .toggleIsLoading(false);
                                },
                                child: CircleAvatar(
                                    radius: 14.2,
                                    backgroundColor: white,
                                    child: SvgPicture.asset(
                                        'assets/icons/profile-edit.svg')),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      '${profile.firstName} ${profile.lastName}',
                      style: TextStyle(
                        color: deepBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      profile.email,
                      style: TextStyle(
                        color: darkGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      profile.phone.toString(),
                      style: TextStyle(
                        color: darkGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Partner ID : ${profile.memberId ?? ""}',
                      style: TextStyle(
                        color: babyBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              kingdomType(
                                  text: 'Kingdom \nBroadcaster',
                                  key: 'Kingdom Broadcaster'),
                              SizedBox(height: 18),
                              kingdomType(
                                  text: 'Kingdom \nAmplifier',
                                  key: 'Kingdom Amplifier'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              kingdomType(
                                  text: 'Kingdom \nVessel',
                                  key: 'Kingdom Vessel'),
                              SizedBox(height: 18),
                              kingdomType(
                                  text: 'Kingdom \nAdvancer',
                                  key: 'Kingdom Advancer')
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    actionTile(
                      text: 'FAQs',
                      onTap: () {
                        context.goNamed(faqRouteName);
                      },
                      isSvg: false,
                      icon: CupertinoIcons.doc_plaintext,
                    ),
                    actionTile(
                      text: 'Partnership Account Details',
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return AccessibleDetails();
                        }));
                      },
                      isSvg: false,
                      icon: CupertinoIcons.money_dollar,
                    ),
                    actionTile(
                      text: 'Enable Notifications',
                      onTap: () {},
                      isSvg: true,
                      asset: 'assets/icons/profile-notifications.svg',
                      trailing: SizedBox(
                        width: 30,
                        child: CupertinoSwitch(
                            activeColor: babyBlue,
                            value:
                                Provider.of<AppProvider>(context, listen: true)
                                    .enableNotifications,
                            onChanged: (value) {
                              Provider.of<AppProvider>(context, listen: false)
                                  .setNotifications(value);
                            }),
                      ),
                    ),
                    actionTile(
                      text: 'Security',
                      onTap: () {
                        context.goNamed(securityRouteName);
                      },
                      isSvg: true,
                      asset: 'assets/icons/profile-security.svg',
                    ),
                    actionTile(
                        text: 'Log out',
                        isLogout: true,
                        onTap: () {
                          signout(context);
                        },
                        isSvg: false,
                        icon: Icons.power_settings_new,
                        trailing: SizedBox(width: 1))
                  ],
                ),
              ),
            ),
            Provider.of<AuthProvider>(context).isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: babyBlue,
                      ),
                    ))
                : Container()
          ],
        ));
  }
}
