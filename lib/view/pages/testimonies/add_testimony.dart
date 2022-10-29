import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';

class AddTestimony extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTestimonyState();
  }
}

class _AddTestimonyState extends State<AddTestimony>
    with SingleTickerProviderStateMixin {
  bool termsAccepted = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  PlatformFile? image;
  PlatformFile? video;
  var filePath = "";
  var fileName = "";

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
    } else if (!termsAccepted) {
      return;
    } else {
      String response =
          await Provider.of<AppProvider>(context, listen: false).addTestimony(
        title: _titleController.text,
        description: _detailsController.text,
        testifier: _nameController.text,
        email: _emailController.text,
        video: video,
        image: image,
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
                      title: 'Testimony Submitted Successfully',
                      description: 'Thank you for sharing',
                      callback: () {
                        context.goNamed(testimoniesRouteName);
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
                title: 'Submission Unsuccessful',
                description: response == 'User is not logged in.'
                    ? 'User email was not submitted'
                    : response,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        appBar: AppBar(),
        actionScreen: true,
        title: "New Testimony",
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      //  height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.85),
                              blurRadius: 7,
                              spreadRadius: -3,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: TextFormField(
                        cursorColor: babyBlue,
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Full name of testifier",
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Text(
                                '*',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // validator: (String? value) {
                        //   if (value == null) {
                        //     return 'value must not be empty';
                        //   }
                        // },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      //   height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.85),
                              blurRadius: 7,
                              spreadRadius: -3,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: TextFormField(
                        cursorColor: babyBlue,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "your email address",
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Text(
                                '*',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // validator: (String? value) {
                        //   if (!RegExp(
                        //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        //       .hasMatch(value!)) {
                        //     return "please return a valid email";
                        //   }
                        // },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      // height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.85),
                              blurRadius: 7,
                              spreadRadius: -3,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: TextFormField(
                        controller: _titleController,
                        cursorColor: babyBlue,
                        decoration: InputDecoration(
                          hintText: "testimony title",
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Text(
                                '*',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // validator: (String? value) {
                        //   if (value == null) {
                        //     return 'value must not be empty';
                        //   }
                        // },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      //  height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.85),
                              blurRadius: 7,
                              spreadRadius: -3,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: TextFormField(
                        readOnly: true,
                        controller: _imageController,
                        cursorColor: babyBlue,
                        decoration: InputDecoration(
                          hintText: "upload image or video",
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(top: 12, right: 20),
                            child: Wrap(
                              spacing: 15,
                              direction: Axis.horizontal,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'png', 'jpeg'],
                                    );
                                    if (result == null) return;

                                    //open single file
                                    final file = result.files.first;

                                    print('Name: ${file.name}');
                                    setState(() {
                                      _imageController.text = file.name;
                                      image = file;
                                      // document = File(file.path!);
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/image-vector.svg',
                                    fit: BoxFit.scaleDown,
                                    height: 22,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['mp4'],
                                    );
                                    if (result == null) return;

                                    //open single file
                                    final file = result.files.first;

                                    print('Name: ${file.name}');
                                    setState(() {
                                      _imageController.text = file.name;
                                      video = file;
                                      // document = File(file.path!);
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/video-vector.svg',
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // validator: (String? value) {
                        //   if (value == null) {
                        //     return 'value must not be empty';
                        //   }
                        // },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.85),
                              blurRadius: 7,
                              spreadRadius: -3,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: TextFormField(
                        minLines: 12,
                        maxLines: 50,
                        cursorColor: babyBlue,
                        controller: _detailsController,
                        decoration: InputDecoration(
                          hintText: "Share the details here",
                          suffixText: '*',
                          suffixStyle:
                              TextStyle(color: Colors.red, fontSize: 20),
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // validator: (String? value) {
                        //   if (value == null) {
                        //     return 'value must not be empty';
                        //   }
                        // },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: babyBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            side: BorderSide(color: babyBlue),
                            value: termsAccepted,
                            onChanged: (value) {
                              setState(() {
                                termsAccepted = value!;
                              });
                            }),
                        Expanded(
                          child: Text(
                            'I hereby consent that the church can share my testimony in of of the media platforms. ',
                            softWrap: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color!
                                    .withOpacity(0.5),
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      height: 48,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm(context);
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Provider.of<AppProvider>(context).isLoading
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
    );
  }
}
