import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/auth_provider.dart';
import 'package:grace_nation/core/services/authentication.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';

class VerifyAccount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VerifyAccountState();
  }
}

class _VerifyAccountState extends State<VerifyAccount>
    with TickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();
  final authApi = AuthApi();

  String completeString = "";
  final _formKey = GlobalKey<FormState>();

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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    completeString = pin1Controller.text +
        pin2Controller.text +
        pin3Controller.text +
        pin4Controller.text +
        pin5Controller.text +
        pin6Controller.text;
    print("COMPLETE STRING IS $completeString");
    String response = await Provider.of<AuthProvider>(context, listen: false)
        .verify(otp: int.parse(completeString), email: emailController.text);

    if (response == 'success') {
      Timer(Duration(milliseconds: 2400),
          () => context.goNamed(partnerLoginRouteName));
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
                    title: 'Verification Successful',
                    description: 'Your account has been verified',
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
              title: 'Verification unsuccessful',
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

  void _resendCode(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String response =
        await authApi.resendVerification(email: emailController.text);

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
                    title: 'OTP resent Successfully',
                    description: 'Please check your email for the OTP',
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
              title: 'OTP Resend unsuccessful',
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

  Widget otpItem(BuildContext context, TextEditingController pin) {
    return Expanded(
      child: Container(
        height: 45,
        width: 50,
        margin: EdgeInsets.only(right: 4, left: 4, bottom: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).disabledColor.withOpacity(0.85),
                //   darkGray.withOpacity(0.85),
                blurRadius: 7,
                spreadRadius: -3,
                offset: const Offset(0, 7)),
          ],
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: pin,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          onSaved: (value) {},

          // style: TextStyle(
          //   color: Colors.black,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 17.5,
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Verify Acount',
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: <Widget>[
              SizedBox(height: 12),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                width: 75,
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
                        color: Color.fromRGBO(123, 127, 158, 1), fontSize: 18),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 36, bottom: 5),
                child: Text(
                  'Verify Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      color: Color.fromARGB(255, 58, 54, 63)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 20),
                child: Text(
                  'Please enter your E-mail address and the 6-digit number sent to your E-mail.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    //    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        // height: 57,
                        child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: SvgPicture.asset(
                                  'assets/icons/prefix-email.svg',
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
                              labelText: 'Email address',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 12.0),
                            ),
                            validator: (String? value) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)) {
                                return "please return a valid email";
                              }
                            }),
                      ),
                      SizedBox(height: 24),
                      Row(children: [
                        otpItem(context, pin1Controller),
                        otpItem(context, pin2Controller),
                        otpItem(context, pin3Controller),
                        otpItem(context, pin4Controller),
                        otpItem(context, pin5Controller),
                        otpItem(context, pin6Controller),
                      ]),
                    ],
                  )),
              SizedBox(height: 36),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: CustomButton(
                    text: 'Continue',
                    onTap: () {
                      _submitForm(context);
                      //context.goNamed(partnerLoginRouteName);
                    }),
              ),
              SizedBox(height: 36),
              Padding(
                padding: EdgeInsets.only(top: 18, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't get the code? ",
                      softWrap: true,
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .color!
                              .withOpacity(0.5),
                          fontSize: 13),
                    ),
                    InkWell(
                      onTap: () {
                        //context.goNamed(partnerLoginRouteName);
                        _resendCode(context);
                      },
                      child: Text(
                        'Resend code',
                        softWrap: true,
                        style: TextStyle(
                            color: babyBlue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
