import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';

class Security extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecurityState();
  }
}

class _SecurityState extends State<Security>
    with SingleTickerProviderStateMixin {
  bool _confirm = false;
  Widget textField(String text, String icon, [bool isPerson = false]) {
    return SizedBox(
      height: 60,
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 6),
              child: isPerson
                  ? Icon(
                      Icons.person_outline_rounded,
                      color: Colors.black,
                      size: 25,
                    )
                  : SvgPicture.asset(
                      icon,
                      fit: BoxFit.scaleDown,
                      color: Theme.of(context).iconTheme.color,
                    ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: babyBlue),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 8),
            filled: true,
            fillColor: Theme.of(context).hoverColor,
            hintText: text,
            helperStyle: TextStyle(color: partnerHintText)),
      ),
    );
  }

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Security',
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change Password',
                style: TextStyle(
                  color: deepBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              textField(
                  'Enter Old Password', 'assets/icons/prefix-padlock.svg'),
              SizedBox(height: 24),
              textField(
                  'Enter New Password', 'assets/icons/prefix-padlock.svg'),
              SizedBox(height: 24),
              textField(
                  'Confirm New Password', 'assets/icons/prefix-padlock.svg'),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: babyBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      side: BorderSide(color: babyBlue),
                      value: _confirm,
                      onChanged: (value) {
                        setState(() {
                          _confirm = value!;
                        });
                      }),
                  Expanded(
                    child: Text(
                      'Confirm Password Change',
                      softWrap: true,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Padding(
                  padding: EdgeInsets.zero,
                  child: CustomButton(
                      text: 'Change Password',
                      onTap: () {
                        //   showGeneralDialog(
                        //     context: context,
                        //     barrierLabel: "Barrier",
                        //     barrierDismissible: true,
                        //     barrierColor: Colors.black.withOpacity(0.5),
                        //     transitionDuration: Duration(milliseconds: 200),
                        //     pageBuilder: (_, __, ___) {
                        //       return StatefulBuilder(
                        //           builder: (context, setState) {
                        //         return Center(
                        //             child: SuccessWidget(
                        //           title: 'Sucessful',
                        //           description:
                        //               'Your password was set successfully',
                        //           callback: () {},
                        //         ));
                        //       });
                        //     },
                        //     transitionBuilder: (_, anim, __, child) {
                        //       return ScaleTransition(
                        //         // position: tween.animate(anim),
                        //         scale: CurvedAnimation(
                        //             parent: controller,
                        //             curve: Curves.elasticInOut),
                        //         child: FadeTransition(
                        //           opacity: anim,
                        //           child: child,
                        //         ),
                        //       );
                        //     },
                        //   );
                        print('PRINT');
                        debugPrint('DEBUGPRINT');
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
