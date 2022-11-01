import 'dart:async';

import 'package:flutter/cupertino.dart';
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
import 'package:url_launcher/url_launcher.dart';

class PartnerRegistration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PartnerRegistrationState();
  }
}

class _PartnerRegistrationState extends State<PartnerRegistration>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isMember = false;
  bool isConfirming = false;
  bool confirmationFailed = false;
  bool accept = false;
  bool passobscure = true;
  bool confirmobscure = true;

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

  _checkMembership() async {
    setState(() {
      isConfirming = true;
    });
    String email = _emailController.text;
    Map<String, dynamic> _response =
        await authApi.membershipCheck(emailId: email);
    if (_response.isEmpty) {
      setState(() {
        confirmationFailed = true;
        isConfirming = false;
      });
    } else {
      setState(() {
        confirmationFailed = false;
        _firstNameController.text = _response["first_name"];
        _lastNameController.text = _response["last_name"];
        isConfirming = false;
      });
    }
  }

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

  void _submitForm(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (!_formKey.currentState!.validate()) {
      return;
    } else if (accept == false) {
      return;
    } else {
      String response = await Provider.of<AuthProvider>(context, listen: false)
          .signUp(
              email: _emailController.text,
              password: _passwordController.text,
              phoneNumber: _phoneController.text,
              passwordConfirmation: _confirmPasswordController.text,
              alreadyAMember: isMember,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text);

      if (response == 'success') {
        showGeneralDialog(
          context: context,
          barrierLabel: "Barrier",
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (_, __, ___) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: SuccessWidget(
                    title: 'Registration Successful',
                    description: 'Welcome to Grace Nation!',
                    callback: () {
                      context.goNamed(verifyAccountRouteName);
                    },
                  ),
                );
              },
            );
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
                title: 'Registration unsuccessful',
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

  Widget textField(String text, TextEditingController controller, String icon,
      [bool isPerson = false]) {
    return SizedBox(
      //  height: 57,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 6),
            child: isPerson
                ? Icon(
                    Icons.person_outline_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 25,
                  )
                : SvgPicture.asset(icon,
                    fit: BoxFit.scaleDown,
                    color: Theme.of(context).iconTheme.color),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: babyBlue),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          filled: true,
          fillColor: Theme.of(context).hoverColor,
          labelText: text,
        ),
        validator: (String? value) {
          if (value!.length < 1) {
            return 'This value cannot be empty';
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Register as Partner',
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: xPadding, right: xPadding),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
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
                            color: Color.fromRGBO(123, 127, 158, 1),
                            fontSize: 18),
                      )),
                  SizedBox(height: 48),
                  Stack(
                    children: [
                      textField('Email', _emailController,
                          'assets/icons/prefix-email.svg'),
                      isConfirming
                          ? Positioned(
                              top: 15,
                              right: 15,
                              child: Container(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: babyBlue,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: babyBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          side: BorderSide(
                            color: Theme.of(context).iconTheme.color!,
                          ),
                          value: isMember,
                          onChanged: (value) {
                            setState(() {
                              isMember = value!;
                            });

                            if (value == true) {
                              _checkMembership();
                            }
                            if (value == false) {
                              setState(() {
                                confirmationFailed = false;
                              });
                            }
                          }),
                      Text(
                        'I am a registered Grace Nation member',
                        softWrap: true,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .color!
                              .withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  confirmationFailed
                      ? Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Account not found, Please contact data department',
                            style: TextStyle(color: Colors.red, fontSize: 10),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 24),
                  textField('First Name', _firstNameController, '', true),
                  SizedBox(height: 24),
                  textField('Last Name', _lastNameController, '', true),
                  SizedBox(height: 24),
                  SizedBox(
                    //height: 57,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.phone_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 25,
                            )),
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
                        labelText: 'Phone Number',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                      ),
                      validator: (String? value) {
                        if (value == null || value.length < 1) {
                          return "This value cannot be empty";
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    //  height: 57,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: passobscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: passobscure
                              ? Icon(CupertinoIcons.eye_slash,
                                  size: 25,
                                  color: Theme.of(context).iconTheme.color)
                              : Icon(CupertinoIcons.eye,
                                  size: 25,
                                  color: Theme.of(context).iconTheme.color),
                          onPressed: () {
                            setState(() {
                              passobscure = !passobscure;
                            });
                          },
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: SvgPicture.asset(
                              'assets/icons/prefix-padlock.svg',
                              fit: BoxFit.scaleDown,
                              color: Theme.of(context).iconTheme.color),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: babyBlue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                        filled: true,
                        fillColor: Theme.of(context).hoverColor,
                        labelText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value!.length < 1) {
                          return 'This value cannot be empty';
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    //  height: 57,
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: confirmobscure,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: SvgPicture.asset(
                              'assets/icons/prefix-padlock.svg',
                              fit: BoxFit.scaleDown,
                              color: Theme.of(context).iconTheme.color),
                        ),
                        suffixIcon: IconButton(
                          icon: confirmobscure
                              ? Icon(CupertinoIcons.eye_slash,
                                  size: 25,
                                  color: Theme.of(context).iconTheme.color)
                              : Icon(CupertinoIcons.eye,
                                  size: 25,
                                  color: Theme.of(context).iconTheme.color),
                          onPressed: () {
                            setState(() {
                              confirmobscure = !confirmobscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: babyBlue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 12.0),
                        filled: true,
                        fillColor: Theme.of(context).hoverColor,
                        labelText: 'Confirm Password',
                      ),
                      validator: (String? value) {
                        if (value!.length < 1) {
                          return 'This value cannot be empty';
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: babyBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          side: BorderSide(color: babyBlue),
                          value: accept,
                          onChanged: (value) {
                            setState(() {
                              accept = value!;
                            });
                          }),
                      Text(
                        'I accept all the ',
                        softWrap: true,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .color!
                              .withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchUrl(
                              'https://gracenation.ng/termsandcondition');
                        },
                        child: Text(
                          'terms and conditions',
                          softWrap: true,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                        text: 'Register',
                        onTap: () {
                          _submitForm(context);
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 18, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
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
                            context.goNamed(partnerLoginRouteName);
                          },
                          child: Text(
                            'Log In',
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
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
