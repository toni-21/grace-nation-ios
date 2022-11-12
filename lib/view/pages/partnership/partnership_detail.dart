import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/services/payment.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grace_nation/core/models/partnership.dart';
import 'package:grace_nation/core/models/transactions.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';

class PartnershipDetail extends StatefulWidget {
  final String text;
  const PartnershipDetail({Key? key, required this.text}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PartnershipDetailState();
  }
}

class _PartnershipDetailState extends State<PartnershipDetail>
    with SingleTickerProviderStateMixin {
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  final fileController = TextEditingController();
  final paymentApi = PaymentApi();
  late Partnership pts;
  bool _isLoading = false;
  PlatformFile? document;
  var filePath = "";
  var fileName = "";

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    pts = Provider.of<AppProvider>(context, listen: false).selectedPartnership;

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

  FilePickerResult? Result;

  Widget completedTransaction(Transactions trc) {
    String paymentDate = trc.paymentDate ?? "2022";
    double amount = trc.amount;
    String currency = pts.currency == "NGN" ? '₦' : '\$';
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partnership Funding',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  paymentDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context)
                        .primaryColorDark, // Color(0xFF243656).withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$currency${formatter.format(amount.truncate())}",
                style: GoogleFonts.roboto(
                  color: greenPayment,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget missedTransaction(Transactions trc) {
    String currency = pts.currency == "NGN" ? '₦' : '\$';
    String paymentDate = trc.paymentDate ?? "2022";
    double amount = trc.amount;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partnership Funding',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  paymentDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    // color: Color(0xFF243656).withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Missed payment',
                  style: TextStyle(
                    color: redPayment,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$currency${formatter.format(amount.truncate())}",
                  style: GoogleFonts.roboto(
                    color: redPayment,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        // isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return addRecord(context, trc.uuid);
                        });
                  },
                  child: Container(
                    width: 75,
                    padding:
                        EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: babyBlue,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Add Record',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget partnershipWidget() {
    int numberofTransations = pts.transactions!.length;
    int currentPayment = (numberofTransations * pts.amount).truncate();
    String freq = pts.frequency == 'monthly' ? 'mth' : pts.frequency;
    String currency = pts.currency == "NGN" ? '₦' : '\$';
    double calcProgress =
        (currentPayment / pts.totalPayable == 0 ? 1 : pts.totalPayable) *
            MediaQuery.of(context).size.width /
            1.125;

    DateTime time = DateTime.parse(pts.endDate);
    String date = DateFormat.yMd().format(time);
    String image = currentPayment == pts.totalPayable
        ? 'assets/images/partner-crown-gold.svg'
        : 'assets/images/partner-crown-ash.svg';
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                pts.supportCategory,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text('$currency${formatter.format(pts.amount.truncate())}/$freq',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  pts.supportType,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Text('${pts.paymentType} Payments',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 12, bottom: 5),
                  height: 36,
                  //width: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(18.5),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width:
                            calcProgress, // MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(18.5),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: MediaQuery.of(context).size.height / 75,
                        child:
                            Text('$currency${formatter.format(currentPayment)}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  //color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                )),
                      ),
                      Positioned(
                        right: 12,
                        top: 6,
                        child: SvgPicture.asset(image),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'End Date: ${date}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text('$currency${formatter.format(pts.totalPayable)}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: babyBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget titleText(
    String text,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 10,
              //  right: 2,
            ),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropdownField(String hintText, List<DropDownValueModel> list,
      [bool paymentType = false]) {
    return SizedBox(
      height: 50,
      child: DropDownTextField(
        textFieldDecoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
          filled: true,
          fillColor: Theme.of(context).hoverColor,
          contentPadding: EdgeInsets.only(top: 6, left: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Color.fromRGBO(173, 173, 173, 0.3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: babyBlue,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        listSpace: 0,
        enableSearch: false,
        dropDownIconProperty: IconProperty(
          icon: Icons.keyboard_arrow_down_outlined,
          size: 30,
          color: deepBlue,
        ),
        clearIconProperty: IconProperty(color: Colors.black),
        dropDownList: list,
        dropDownItemCount: (list.length / 2).truncate(),
        onChanged: ((value) {}),
        validator: (String? value) {
          if (value == null) {
            return 'value must not be empty';
          }
        },
      ),
    );
  }

  addRecord(BuildContext context, String id) {
    return Container(
      height: 284,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.75),
              offset: Offset(3, 2),
              blurRadius: 7)
        ],
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(physics: ClampingScrollPhysics(), children: [
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                        // color: Color.fromARGB(255, 0, 3, 29),
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 4.5),
                Text(
                  'Add Record',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Divider(thickness: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  titleText('Payment Evidence'),
                  GestureDetector(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'txt',
                          'docx',
                          'pdf',
                          'jpg',
                          'png',
                          'jpeg'
                        ],
                      );
                      if (result == null) return;

                      //open single file
                      final file = result.files.first;

                      print('Name: ${file.name}');
                      setState(() {
                        fileController.text = file.name;
                        document = file;
                        // document = File(file.path!);
                      });
                    },
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: fileController,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.upload_file_outlined,
                            color: deepBlue,
                          ),
                          hintText: 'Select File',
                          hintStyle: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          enabled: false,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Color.fromRGBO(173, 173, 173, 0.3),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: babyBlue,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null) {
                            return 'value must not be empty';
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                      text: 'Submit',
                      onTap: () {
                        if (document == null) return;
                        _submitForm(document!, id);
                      }),
                  SizedBox(height: 36),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  void _submitForm(PlatformFile file, String id) async {
    setState(() {
      _isLoading = true;
    });
    String response = await paymentApi.addPaymentEvidence(file: file, uuid: id);
    setState(() {
      _isLoading = false;
    });
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
                title: 'Payment Evidence Submitted',
                description:
                    'Your payment record has been sent for verification',
                callback: () {
                  Navigator.of(context).pop();
                },
              ),
            );
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
                title: 'Submission Failed',
                description: response,
              ),
            );
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBarWidget(
        appBar: AppBar(),
        actionScreen: true,
        title: widget.text,
      ),
      body: SafeArea(
          child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [
              SizedBox(height: 24),
              InkWell(onTap: () {}, child: partnershipWidget()),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String transacId = (pts.transactions == null ||
                              pts.transactions!.isEmpty)
                          ? pts.uuid
                          : pts.transactions![0].uuid;
                      showModalBottomSheet(
                          isScrollControlled: true,
                          // isDismissible: false,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return addRecord(context, transacId);
                          });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Add Payment Record',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                itemCount:
                    pts.transactions == null ? 0 : pts.transactions!.length,
                itemBuilder: (BuildContext context, int index) {
                  Transactions trc = pts.transactions![index];
                  int status = trc.status;

                  return status == 1
                      ? completedTransaction(trc)
                      : missedTransaction(trc);
                },
              ),
            ],
          ),
          _isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: babyBlue,
                    ),
                  ))
              : Container()
        ],
      )),
    );
  }
}
