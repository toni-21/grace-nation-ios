import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/services/authentication.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/alert_widget.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';

class ResetPasssword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPassswordState();
  }
}

class _ResetPassswordState extends State<ResetPasssword>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final authApi = AuthApi();
  final TextEditingController emailController = TextEditingController();

  void _requestReset(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String response =
        await authApi.requestPassswordReset(email: emailController.text);

    if (response == 'success') {
      context.goNamed(setNewPasswordRouteName);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Change Password',
        appBar: AppBar(),
      ),
      drawer: AppDrawer(),
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
                  'Reset Password',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      color: Color.fromARGB(255, 58, 54, 63)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 20),
                child: Text(
                  'Email Address or Phone Number',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  //   height: 57,
                  decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: darkGray.withOpacity(0.85),
                      //       blurRadius: 7,
                      //       spreadRadius: -3,
                      //       offset: const Offset(0, 6)),
                      // ],
                      ),
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
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      labelText: 'Email or phone',
                    ),
                    validator: (String? value) {
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!)) {
                        return "please return a valid email";
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 45),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: CustomButton(
                    text: 'Reset Password',
                    onTap: () {
                      _requestReset(context);
                    }),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(top: 18, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
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
                        context.goNamed(partnerRegistrationRouteName);
                      },
                      child: Text(
                        'Sign Up',
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
