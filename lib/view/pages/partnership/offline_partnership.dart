import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/accout_details.dart';
import 'package:grace_nation/core/models/preferences.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/partnership.dart';
import 'package:grace_nation/core/services/payment.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:flutter/services.dart';
import 'package:grace_nation/view/pages/partnership/partnership_page.dart';
import 'package:grace_nation/view/shared/widgets/alert_widget.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/confirmation_widget.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';

class OfflinePartnership extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfflinePartnershipState();
  }
}

class _OfflinePartnershipState extends State<OfflinePartnership>
    with SingleTickerProviderStateMixin {
  final paymentApi = PaymentApi();
  final partnerApi = PartnershipApi();
  Preferences? preferences;
  AccountDetails? usdDetails;
  AccountDetails? nairaDetails;

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  bool completed = false;
  bool congratulated = false;
  int paymentId = 0;
  String reference = "";
  @override
  void initState() {
    getPreferences();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });
    _getPaymentId();
    super.initState();
    controller.forward();
  }

  getPreferences() async {
    preferences =
        await Provider.of<AppProvider>(context, listen: false).getPreferences();
    for (int i = 0; i < preferences!.bankAccounts!.length; i++) {
      if (preferences!.bankAccounts![i].accountType == "Naira Account (NGN)") {
        nairaDetails = preferences!.bankAccounts![i];
      } else if (preferences!.bankAccounts![i].accountType ==
          "Dollar Account (USD)") {
        usdDetails = preferences!.bankAccounts![i];
      } else {}
    }
  }

  _setComplete(bool value) {
    setState(() {
      completed = value;
    });
  }

  _getPaymentId() async {
    final payInit =
        Provider.of<AppProvider>(context, listen: false).paymentInit;
    final payMap = await paymentApi.initializeOfflinePayment(
      amount: payInit.amount,
      currency: payInit.currency,
      supportType: payInit.supportType,
      paymentType: 'transfer',
      frequency: payInit.frequency,
      startDate: payInit.startDate,
      endDate: payInit.endDate,
    );

    if (payMap['status'] == 'success') {
      final payload = payMap['data'];
      paymentId = payload['id'];
      reference = payload["reference"];
      _setComplete(true);
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
                title: 'Initialization Failed',
                description:
                    'We could not initiate your partnership plan, try again.',
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

  Widget keyText(String text, context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget valueText(String text, context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
    );
  }

  Widget titleText(String text, context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Future<void> _copyToClipboard(context, String number) async {
    Clipboard.setData(ClipboardData(text: number)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: babyBlue,
          content: const Text('Copied to clipboard'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return !congratulated
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).hoverColor,
            body: SafeArea(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 210,
                    width: 210,
                    decoration:
                        BoxDecoration(color: babyBlue, shape: BoxShape.circle),
                    child: Container(
                      alignment: Alignment.center,
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          color: Theme.of(context).hoverColor,
                          shape: BoxShape.circle),
                      child: Container(
                        child: SvgPicture.asset(
                            'assets/images/congrats-check.svg'),
                      ),
                    ),
                  ),
                  SizedBox(height: 84),
                  Text(
                    'Congatulations!!!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      //color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Partnership Goal Created',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      // color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 50),
                  CustomButton(
                      text: 'Continue to Payment',
                      onTap: () {
                        setState(() {
                          congratulated = true;
                        });
                      })
                ],
              )),
            ))
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBarWidget(
              actionScreen: true,
              title: 'Account Details',
              actions: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationWidget(
                              title: "Return to Home page",
                              description:
                                  "Do you wish to cancel partnership and return to homepage?",
                              callback: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return PartnershipPage();
                                }));
                              },
                              actionText: "Yes",
                              exitText: "No");
                        });
                  },
                  icon: Icon(Icons.close,
                      size: 30, color: white //Color.fromARGB(255, 158, 31, 22),
                      )),
              appBar: AppBar(),
            ),
            body: (nairaDetails == null || usdDetails == null)
                ? Center(
                    child: CircularProgressIndicator(
                      color: babyBlue,
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      SizedBox(height: 24),
                      titleText('Naira Account (NGN)', context),
                      SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Bank Name: ', context),
                              ),
                              Expanded(
                                child: valueText(
                                    nairaDetails!.bankName ?? "", context),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Account Name: ', context),
                              ),
                              Expanded(
                                child: valueText(
                                    nairaDetails!.accountName ?? "", context),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Account Number: ', context),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    valueText(nairaDetails!.accountNumber ?? "",
                                        context),
                                    GestureDetector(
                                      onTap: () {
                                        _copyToClipboard(context, '0049488042');
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: babyBlue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Sort Code: ', context),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    valueText(
                                        nairaDetails!.sortCode ?? "", context),
                                    GestureDetector(
                                      onTap: () {
                                        _copyToClipboard(context, '0049488042');
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: babyBlue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      titleText('Dollar Account (USD)', context),
                      SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Bank Name: ', context),
                              ),
                              Expanded(
                                child: valueText(
                                    usdDetails!.bankName ?? "", context),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Account Name: ', context),
                              ),
                              Expanded(
                                child: valueText(
                                    usdDetails!.accountName ?? "", context),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Account Number: ', context),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    valueText(usdDetails!.accountNumber ?? "",
                                        context),
                                    GestureDetector(
                                      onTap: () {
                                        _copyToClipboard(context, '0049488042');
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: babyBlue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: keyText('Sort Code: ', context),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    valueText(
                                        usdDetails!.sortCode ?? "", context),
                                    GestureDetector(
                                      onTap: () {
                                        _copyToClipboard(context, '0049488042');
                                      },
                                      child: Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: babyBlue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
            floatingActionButton: completed != true
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: white,
                      size: 27.5,
                    ),
                    onPressed: () async {
                      final newContext = Navigator.of(context);
                      final payInit =
                          Provider.of<AppProvider>(context, listen: false)
                              .paymentInit;

                      String newPartnership =
                          await partnerApi.createOfflinePartnership(
                        amount: payInit.amount,
                        currency: payInit.currency,
                        supportType: payInit.supportType,
                        paymentType: 'transfer',
                        reference: reference,
                        frequency: payInit.frequency,
                        startDate: payInit.startDate,
                        endDate: payInit.endDate,
                        paymentId: paymentId,
                      );
                      if (newPartnership == 'success') {
                        newContext.push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return PartnershipPage();
                        }));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertWidget(
                                title: 'Something went wrong',
                                description: newPartnership);
                          },
                        );
                      }
                    },
                  ),
          );
  }
}
