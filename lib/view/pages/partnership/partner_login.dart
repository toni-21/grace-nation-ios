import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/auth_provider.dart';
import 'package:grace_nation/core/services/authentication.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/partnership/verify_account.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';

class PartnerLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PartnerLoginState();
  }
}

class _PartnerLoginState extends State<PartnerLogin>
    with SingleTickerProviderStateMixin {
  bool obscureText = false;
  final _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void _submitForm(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      String response =
          await Provider.of<AuthProvider>(context, listen: false).login(
        emailId: _emailController.text,
        password: _passwordController.text,
      );

      if (response == 'success') {
        Timer(Duration(milliseconds: 2400), () {
          if (mounted) {
            context.goNamed(partnershipPageRouteName);
          }
        });
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
                      title: 'Login Successful',
                      description: 'Welcome back partner',
                      callback: () {
                        context.goNamed(partnershipPageRouteName);
                      }));
            });
          },
          transitionBuilder: (_, anim, __, child) {
            return ScaleTransition(
              // position: tween.animate(anim),
              scale: CurvedAnimation(
                  parent: controller, curve: Curves.elasticInOut),
              child: FadeTransition(
                opacity: anim,
                child: child,
              ),
            );
          },
        );
      } else {
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
                title: 'Login unsuccessful',
                description: response,
              ));
            });
          },
          transitionBuilder: (_, anim, __, child) {
            return ScaleTransition(
              // position: tween.animate(anim),
              scale: CurvedAnimation(
                  parent: controller, curve: Curves.elasticInOut),
              child: FadeTransition(
                opacity: anim,
                child: child,
              ),
            );
          },
        );
      }
    }
  }

  _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Provider.of<AuthProvider>(context, listen: false).toggleIsLoading(true);
    String response =
        await authApi.requestPassswordReset(email: _emailController.text);
    Provider.of<AuthProvider>(context, listen: false).toggleIsLoading(false);

    if (response == 'success') {
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
                    title: 'Request successful',
                    description: 'A reset link has been sent to your email',
                    callback: () {}));
          });
        },
        transitionBuilder: (_, anim, __, child) {
          return ScaleTransition(
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
              title: 'Request unsuccessful',
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

  Widget textField(String text, String icon, controller, bool password) {
    return SizedBox(
      // height: 57,
      child: TextFormField(
        obscureText: !password ? false : obscureText,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: !password
              ? null
              : IconButton(
                  icon: obscureText
                      ? Icon(CupertinoIcons.eye_slash,
                          size: 25, color: Theme.of(context).iconTheme.color)
                      : Icon(CupertinoIcons.eye,
                          size: 25, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 6),
            child: SvgPicture.asset(
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
          filled: true,
          fillColor: Theme.of(context).hoverColor,
          labelText: text,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        ),
        validator: password
            ? (String? value) {
                if (value == null) {
                  return 'password must not be empty';
                }
              }
            : (String? value) {
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value!)) {
                  return "please return a valid email";
                }
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: xPadding),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 12),
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      width: 60,
                      height: 75,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/lego-big.png'),
                            fit: BoxFit.contain),
                      ),
                    ),
                    SizedBox(height: 7.5),
                    Text(
                      'GRACE \nNATION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 17,
                        height: .95,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 7.5),
                    Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Liberation City',
                          style: TextStyle(
                              color: Color.fromRGBO(123, 127, 158, 1),
                              fontSize: 18),
                        )),
                    SizedBox(height: 48),
                    textField(
                        'Email/Partner ID',
                        'assets/icons/prefix-email.svg',
                        _emailController,
                        false),
                    SizedBox(height: 24),
                    textField('Password', 'assets/icons/prefix-padlock.svg',
                        _passwordController, true),
                    SizedBox(height: 48),
                    CustomButton(
                        text: 'Login',
                        onTap: () {
                          _submitForm(context);
                        }),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .color!
                                .withOpacity(
                                    0.5), // Colors.black.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.goNamed(resetPasswordRouteName);
                            //_resetPassword();
                          },
                          child: Text(
                            'Click Here',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: babyBlue),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Account Verification',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .color!
                                .withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      VerifyAccount()),
                            );
                          },
                          child: Text(
                            'Click Here',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: babyBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an account?',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .color!
                                .withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //  context.goNamed(setNewPasswordRouteName);
                            context.goNamed(partnerWelcomeRouteName);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: babyBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
        ),
      ),
    );
  }
}
