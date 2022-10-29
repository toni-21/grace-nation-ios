import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/auth_provider.dart';
import 'package:grace_nation/core/services/authentication.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';

class SetNewPasssword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SetNewPassswordState();
  }
}

class _SetNewPassswordState extends State<SetNewPasssword>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

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

  void _resetPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String response = await authApi.resetPassword(
        token:
            Provider.of<AuthProvider>(context, listen: false).user.accessToken,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text);

    if (response == 'success') {
      context.goNamed(partnerLoginRouteName);
      showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
                child: SuccessWidget(
                    title: 'Password Reset Successfully',
                    description: 'Please login to continue',
                    callback: () {
                      context.goNamed(partnerLoginRouteName);
                    }));
          });
        },
        transitionBuilder: (_, anim, __, child) {
          return ScaleTransition(
            // position: tween.animate(anim),
            scale:
                CurvedAnimation(parent: controller, curve: Curves.elasticInOut),
            child: FadeTransition(
              opacity: anim,
              child: child,
            ),
          );
        },
      );
    } else {
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text("Something went wrong"),
      //     content: Text(response),
      //     actions: <Widget>[
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         child: Container(
      //           decoration: BoxDecoration(
      //               color: babyBlue, borderRadius: BorderRadius.circular(5)),
      //           padding: const EdgeInsets.only(
      //               top: 4.5, left: 7.5, right: 7.5, bottom: 4.5),
      //           child: Text(
      //             "Back",
      //             style: TextStyle(
      //               color: white,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );

      showGeneralDialog(
        context: context,
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
                child: FailureWidget(
              title: 'Password reset unsuccessful',
              description: response,
            ));
          });
        },
        transitionBuilder: (_, anim, __, child) {
          return ScaleTransition(
            // position: tween.animate(anim),
            scale:
                CurvedAnimation(parent: controller, curve: Curves.elasticInOut),
            child: FadeTransition(
              opacity: anim,
              child: child,
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Change Password',
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: <Widget>[
              SizedBox(height: 12),
              Container(
                height: 120,
                width: 83.34,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/partner-new-logo.png'),
                      fit: BoxFit.fitHeight),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Liberation City',
                  style: TextStyle(
                      color: Color.fromRGBO(123, 127, 158, 1), fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36, bottom: 5),
                child: Text('Set New Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                        color: Color.fromRGBO(38, 32, 44, 1))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 20),
                child: Text(
                    'Your new password must be different from a previously used password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
              // Container(
              //   height: 57,
              //   decoration: BoxDecoration(
              //       // boxShadow: [
              //       //   BoxShadow(
              //       //       color: darkGray.withOpacity(0.85),
              //       //       blurRadius: 7,
              //       //       spreadRadius: -3,
              //       //       offset: const Offset(0, 6)),
              //       // ],
              //       ),
              //   child: TextField(
              //     obscureText: true,
              //     //controller: passwordController,
              //     decoration: InputDecoration(
              //       prefixIcon: Padding(
              //         padding: EdgeInsets.only(left: 6),
              //         child: SvgPicture.asset(
              //           'assets/icons/prefix-email.svg',
              //           fit: BoxFit.scaleDown,
              //         ),
              //       ),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(color: babyBlue),
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       filled: true,
              //       fillColor: white,
              //       labelText: 'Email or phone',
              //     ),
              //   ),
              // ),

              Container(
                // height: 57,
                decoration: BoxDecoration(),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: SvgPicture.asset(
                        'assets/icons/prefix-padlock.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: babyBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: white,
                    hintText: '******************',
                  ),
                  validator: (String? value) {
                    if (value!.length < 1) {
                      return 'password must not be empty';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordConfirmationController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: SvgPicture.asset(
                        'assets/icons/prefix-padlock.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 12, bottom: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: babyBlue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: white,
                    hintText: 'enter the new password again',
                  ),
                  validator: (String? value) {
                    if (value!.length < 1) {
                      return 'password must not be empty';
                    }
                  },
                ),
              ),

              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      text: 'Reset Password',
                      onTap: () {
                        _resetPassword(context);
                        // context.goNamed(partnerLoginRouteName);
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
