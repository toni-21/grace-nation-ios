import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/user.dart';
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

class Security extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecurityState();
  }
}

class _SecurityState extends State<Security>
    with SingleTickerProviderStateMixin {
  final authApi = AuthApi();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _confirm = false;
  bool newObscureText = true;
  bool confirmObscureText = false;
  late User _user;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _user = Provider.of<AuthProvider>(context, listen: false).user;
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    super.initState();
  }

  void _submitForm(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      String response = await authApi.changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        phone: _user.phone!,
        lastName: _user.lastName,
        firstName: _user.firstName,
      );

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
                      title: 'Update Successful',
                      description: 'Your password has been changed successfully',
                      callback: () {
                        context.goNamed(profileRouteName);
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
                title: 'Update Failed',
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

  Widget textField(
      {required String text,
      required String icon,
      required TextEditingController controller,
      required bool obscureText,
      required bool suffix}) {
    return SizedBox(
      // height: 57,
      child: TextFormField(
        obscureText: text == 'Enter New Password'
            ? newObscureText
            : text == 'Confirm New Password'
                ? confirmObscureText
                : false,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: !suffix
              ? null
              : IconButton(
                  icon: obscureText
                      ? Icon(CupertinoIcons.eye_slash,
                          size: 25, color: Theme.of(context).iconTheme.color)
                      : Icon(CupertinoIcons.eye,
                          size: 25, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    setState(() {
                      text == 'Enter New Password'
                          ? newObscureText = !newObscureText
                          : confirmObscureText = !confirmObscureText;
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
          hintText: text,
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        ),
        validator: text != 'Confirm New Password'
            ? (String? value) {
                if (value == null || value.length < 1) {
                  return 'password must not be empty';
                }
              }
            : (String? value) {
                if (confirmPasswordController.text !=
                    newPasswordController.text) {
                  return "password does not match";
                }
              },
      ),
    );
  }

  late AnimationController controller;
  late Animation<double> scaleAnimation;

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
          child: Form(
            key: _formKey,
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
                    text: 'Enter Old Password',
                    icon: 'assets/icons/prefix-padlock.svg',
                    controller: oldPasswordController,
                    obscureText: false,
                    suffix: false),
                SizedBox(height: 24),
                textField(
                    text: 'Enter New Password',
                    icon: 'assets/icons/prefix-padlock.svg',
                    controller: newPasswordController,
                    obscureText: newObscureText,
                    suffix: true),
                SizedBox(height: 24),
                textField(
                    text: 'Confirm New Password',
                    icon: 'assets/icons/prefix-padlock.svg',
                    controller: confirmPasswordController,
                    obscureText: confirmObscureText,
                    suffix: true),
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
                          if (_confirm == false) {
                            return;
                          } else {
                            _submitForm(context);
                          }
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
