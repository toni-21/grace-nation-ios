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

  String getGivingType(int type) {
    switch (type) {
      case 1:
        return 'Offering/Seed';
      case 2:
        return 'Tithe';
      case 3:
        return 'TV Support';
      case 4:
        return 'Building Support';
      case 5:
        return 'Welfare';
      default:
        return 'Offering/Seed';
    }
  }

  String getBankName(int type) {
    switch (type) {
      case 1:
        return 'Diamond/Access Bank';
      case 2:
        return 'Zenith Bank Nigeria';
      case 3:
        return 'UBA - Nigeria';
      case 4:
        return 'Diamond/Access Bank';
      case 5:
        return 'Guarantee Trust Bank';
      default:
        return 'Diamond/Access Bank';
    }
  }

  String getAccountName(int type) {
    switch (type) {
      case 1:
        return 'Mountain of Liberation Miracle Ministries';
      case 2:
        return 'Chris Okafor World Outreach Ministries';
      case 3:
        return 'Mountain of Liberation Miracle Ministries';
      case 4:
        return 'Mountain of Liberation Miracle Ministries';
      case 5:
        return 'Greater Liberation City International Ministires';
      default:
        return 'Mountain of Liberation Miracle Ministries';
    }
  }

  String getAccountNo(int type) {
    switch (type) {
      case 1:
        return '0049488042';
      case 2:
        return '1015557088';
      case 3:
        return '1017919426';
      case 4:
        return '0049488042';
      case 5:
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
      required int type,
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
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int givingTypeId =
        Provider.of<AppProvider>(context, listen: false).givingTypeId;
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
              getGivingType(givingTypeId),
              //textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            _accountDetails(context: context, type: givingTypeId),
            givingTypeId == 1
                ? _accountDetails(
                    context: context,
                    type: givingTypeId,
                    alternateBankName: 'Fidelity Bank',
                    alternateBankNo: '5080086316')
                : Container(),
            givingTypeId == 1
                ? _accountDetails(
                    context: context,
                    type: givingTypeId,
                    alternateBankName: 'UBA',
                    alternateBankNo: '1022182510')
                : Container()
          ],
        ),
      ),
    );
  }
}
