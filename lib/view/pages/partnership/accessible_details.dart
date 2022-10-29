import 'package:flutter/material.dart';
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
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';

class AccessibleDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccessibleDetailsState();
  }
}

class _AccessibleDetailsState extends State<AccessibleDetails>
    with SingleTickerProviderStateMixin {
  Preferences? preferences;
  AccountDetails? usdDetails;
  AccountDetails? nairaDetails;

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  getPreferences() async {
    preferences =
        await Provider.of<AppProvider>(context, listen: false).getPreferences();
    for (int i = 0; i < preferences!.bankAccounts!.length; i++) {
      if (preferences!.bankAccounts![i].accountType == "Naira Account (NGN)") {
        setState(() {
          nairaDetails = preferences!.bankAccounts![i];
        });
      } else if (preferences!.bankAccounts![i].accountType ==
          "Dollar Account (USD)") {
        setState(() {
          usdDetails = preferences!.bankAccounts![i];
        });
      } else {}
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
    return Scaffold(
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
                          context.go(partnershipPageRouteName);
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
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: keyText('Bank Name: ', context),
                        ),
                        Expanded(
                          child:
                              valueText(nairaDetails!.bankName ?? "", context),
                        ),
                      ],
                    ),
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
                    Row(
                      children: [
                        Expanded(
                          child: keyText('Account Number: ', context),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              valueText(
                                  nairaDetails!.accountNumber ?? "", context),
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: keyText('Sort Code: ', context),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              valueText(nairaDetails!.sortCode ?? "", context),
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
                          child: valueText(usdDetails!.bankName ?? "", context),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: keyText('Account Name: ', context),
                        ),
                        Expanded(
                          child:
                              valueText(usdDetails!.accountName ?? "", context),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: keyText('Account Number: ', context),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              valueText(
                                  usdDetails!.accountNumber ?? "", context),
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: keyText('Sort Code: ', context),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              valueText(usdDetails!.sortCode ?? "", context),
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
    );
  }
}
