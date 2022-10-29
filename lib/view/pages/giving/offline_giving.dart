import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:flutter/services.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:provider/provider.dart';

class OfflineGiving extends StatelessWidget {
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

  String getGivingType(String type) {
    switch (type) {
      case 'offering_and_seed':
        return 'Offering/Seed';
      case 'tithe':
        return 'Tithe';
      case 'tv_support':
        return 'TV Support';
      case 'building_support':
        return 'Building Support';
      case 'welfare':
        return 'Welfare';
      default:
        return 'Offering/Seed';
    }
  }

  String getBankName(String type) {
    switch (type) {
      case 'offering_and_seed':
        return 'Diamond/Access Bank';
      case 'tithe':
        return 'Zenith Bank Nigeria';
      case 'tv_support':
        return 'UBA - Nigeria';
      case 'building_support':
        return 'Diamond/Access Bank';
      case 'welfare':
        return 'Guarantee Trust Bank';
      default:
        return 'Diamond/Access Bank';
    }
  }

  String getAccountName(String type) {
    switch (type) {
      case 'offering_and_seed':
        return 'Mountain of Liberation Miracle Ministries';
      case 'tithe':
        return 'Chris Okafor World Outreach Ministries';
      case 'tv_support':
        return 'Mountain of Liberation Miracle Ministries';
      case 'building_support':
        return 'Mountain of Liberation Miracle Ministries';
      case 'welfare':
        return 'Greater Liberation City International Ministires';
      default:
        return 'Mountain of Liberation Miracle Ministries';
    }
  }

  String getAccountNo(String type) {
    switch (type) {
      case 'offering_and_seed':
        return '0049488042';
      case 'tithe':
        return '1015557088';
      case 'tv_support':
        return '1017919426';
      case 'building_support':
        return '0049488042';
      case 'welfare':
        return '0739773563';
      default:
        return '0049488042';
    }
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

  _accountDetails(
      {required BuildContext context,
      required String type,
      String? alternateBankName,
      String? alternateBankNo}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText('Nigeria Account (NGN)', context),
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
                      // 'Diamond/Access Bank',
                      alternateBankName ?? getBankName(type),
                      context),
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
                        //'Mountain of Liberation Miracle Ministries',
                        getAccountName(type),
                        context)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      valueText(
                          //    '0049488042',
                          alternateBankNo ?? getAccountNo(type),
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
            // Row(
            //   children: [
            //     Expanded(
            //       child: keyText('Sort Code: '),
            //     ),
            //     Expanded(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           valueText(''),
            //           GestureDetector(
            //             onTap: () {
            //               _copyToClipboard(context, '0049488042');
            //             },
            //             child: Icon(
            //               Icons.copy,
            //               size: 20,
            //               color: babyBlue,
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String givingType =
        Provider.of<AppProvider>(context, listen: false).givingType;
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'give'});
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: true,
          title: 'Account Details',
          specialPop: true,
          appBar: AppBar(),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            SizedBox(height: 12),
            Text(
              getGivingType(givingType),
              //textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            _accountDetails(context: context, type: givingType),
            givingType == 'offering_and_seed'
                ? _accountDetails(
                    context: context,
                    type: givingType,
                    alternateBankName: 'Fidelity Bank',
                    alternateBankNo: '5080086316')
                : Container(),
            givingType == 'offering_and_seed'
                ? _accountDetails(
                    context: context,
                    type: givingType,
                    alternateBankName: 'UBA',
                    alternateBankNo: '1022182510')
                : Container()
          ],
        ),
      ),
    );
  }
}
