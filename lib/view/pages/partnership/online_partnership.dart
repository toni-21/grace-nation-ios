// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/partnership.dart';
import 'package:grace_nation/core/services/payment.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/pages/partnership/partnership_congrats.dart';
import 'package:grace_nation/view/shared/widgets/alert_widget.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/confirmation_widget.dart';
import 'package:grace_nation/view/shared/widgets/failure_widget.dart';
import 'package:grace_nation/view/shared/widgets/success_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlinePartnership extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnlinePartnershipState();
  }
}

class _OnlinePartnershipState extends State<OnlinePartnership>
    with SingleTickerProviderStateMixin {
  final payApi = PaymentApi();
  final ptApi = PartnershipApi();
  bool _isLoading = false;

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  bool completed = false;

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

  webviewContainer({
    required BuildContext context,
    required String url,
    required double amount,
    required String currency,
    required int supportType,
    required String paymentType,
    required String frequency,
    required String startDate,
    required String endDate,
    required int payId,
  }) {
    bool hasCompletedProcessing = false;
    bool haveCallBacksBeenCalled = false;
    BuildContext savedContext = context;
    final cont = Navigator.of(context);

    _processResponse(Uri url, String? status, String? txRef, String? id) async {
      print("STATUS IS $status!!");
      if ("successful" == status) {
        print('id is .. $id and txref is $txRef');
        //  callBack.onTransactionSuccess(id!, txRef!);
        setState(() {
          _isLoading = true;
        });
        Navigator.pop(this.context);
        String newPartnership = await ptApi.createPartnership(
          amount: amount,
          currency: currency,
          supportType: supportType,
          paymentType: paymentType,
          frequency: frequency,
          startDate: startDate,
          endDate: endDate,
          transactionId: int.parse(id!),
          paymentId: payId,
        );
        setState(() {
          _isLoading = false;
        });
        if (newPartnership == 'success') {
          //context.goNamed(congratsRouteName);
          cont.push(MaterialPageRoute(builder: (BuildContext context) {
            return PartnershipCongrats();
          }));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertWidget(
                  title: 'Something went wrong', description: newPartnership);
            },
          );
        }
      } else {
        /// callBack.onCancelled();
        print('Transaction cancelled');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(
              'Transaction cancelled',
              style: TextStyle(color: white),
            ),
          ),
        );
        Navigator.pop(context);
      }
      haveCallBacksBeenCalled = true;
      print('CALL BACKS HAVE BEEN CALLED, CLOSING NOW!!');
      //close();
    }

    // @override
    // Future onLoadStop(url) async {}

    Future<void> _launchUrl(Uri url) async {
      print('lauched url');
      if (!await launchUrl(url)) {
        throw 'Could not launch $url';
      }
    }

    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        // userAgent: userAgent,
        cacheEnabled: true,
        useOnLoadResource: true,
        useOnDownloadStart: true,
        javaScriptCanOpenWindowsAutomatically: true,
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        transparentBackground: true,
        disableContextMenu: true,
        supportZoom: false,
        disableHorizontalScroll: false,
        disableVerticalScroll: false,
        useShouldOverrideUrlLoading: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true, useWideViewPort: false),
    );
    debugPrint('user is number is $url');
    InAppWebViewController? webViewController;
    Widget view = InAppWebView(
      initialOptions: options,
      initialUrlRequest: URLRequest(
        url: Uri.parse(url),
      ),
      onWebViewCreated: (controller) async {
        webViewController = controller;
        //await _launchUrl(Uri.parse(url));
        controller.addJavaScriptHandler(
            handlerName: 'myHandlerName',
            callback: (args) {
              // print arguments coming from the JavaScript side!
              print(args);
              // return data to the JavaScript side!
              //return {'bar': 'bar_value', 'baz': 'baz_value'};
            });
      },
      onLoadStart: (controller, url) async {
        final status = url?.queryParameters["status"];
        final txRef = url?.queryParameters["tx_ref"];
        final id = url?.queryParameters["transaction_id"];
        final hasRedirected = status != null && txRef != null;
        if (hasRedirected && url != null) {
          hasCompletedProcessing = hasRedirected;
          _processResponse(url, status, txRef, id);
        }
      },
      onLoadError: ((controller, url, code, message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(
              message,
              style: TextStyle(color: white),
            ),
          ),
        );
        Navigator.pop(context);
      }),
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url!;

        if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
            .contains(uri.scheme)) {
          await _launchUrl(Uri.parse(url));
          // and cancel the request
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
      },
    );

    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.8),
              offset: Offset(3, 2),
              blurRadius: 7)
        ],
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationWidget(
                            title: "Are you sure you want to close this modal?",
                            description:
                                "Your transaction may be not be completed",
                            callback: () {
                              Navigator.of(context).pop();
                            },
                            actionText: "Quit",
                            exitText: "Cancel");
                      },
                    );
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Divider(
                    thickness: 3,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Container(
                    height: 1, width: MediaQuery.of(context).size.width / 5),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 2, right: 2),
            child: Container(
              alignment: Alignment.topCenter,
              child: view,
            ),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: true,
          title: 'Create Partnership',
          appBar: AppBar(),
        ),
        body: SafeArea(
          child: Stack(children: [
            ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24, top: 32, bottom: 20),
                      // alignment: Alignment.center,
                      child: Text(
                        'Select Payment Method',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    )
                  ],
                ),
                InkWell(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      BuildContext mainContext = context;
                      final payInit =
                          Provider.of<AppProvider>(context, listen: false)
                              .paymentInit;
                      Provider.of<AppProvider>(context, listen: false)
                          .beginPaymentState();
                      final Map<String, dynamic> payMap =
                          await payApi.initializeFlutterwavePayment(
                        amount: payInit.amount,
                        currency: payInit.currency,
                        supportType: payInit.supportType,
                        paymentType: 'online',
                        frequency: payInit.frequency,
                        startDate: payInit.startDate,
                        endDate: payInit.endDate,
                      );
                      setState(() {
                        _isLoading = false;
                      });
                      if (payMap['status'] == 'success') {
                        final payload = payMap['data'];

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
                                  title: 'Initialization Successful',
                                  description:
                                      'Partnership plan was initiated successfully',
                                  callback: () async {
                                    Map<String, dynamic> paymentResponse =
                                        await payApi.gatewayPayment(
                                            context: context,
                                            amount:
                                                payload['amount'].toString(),
                                            referenceId: payload['reference'],
                                            publicKey: payload[
                                                'flutterwave_public_key'],
                                            planId: payload['gateway_plan_id']
                                                .toString(),
                                            name:
                                                "${payload['user']['first_name']} ${payload['user']['last_name']}",
                                            currency: payload['currency'],
                                            phoneNumber: payload['user']
                                                ['phone'],
                                            email: payload['user']['email']);

                                    if (paymentResponse['status'] ==
                                        'success') {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: false,
                                          enableDrag: false,
                                          backgroundColor: Colors.transparent,
                                          context: mainContext,
                                          builder: (BuildContext context) {
                                            return webviewContainer(
                                                context: context,
                                                url: paymentResponse['data']
                                                    ['link'],
                                                amount: payInit.amount,
                                                currency: payInit.currency,
                                                supportType:
                                                    payInit.supportType,
                                                paymentType: 'online',
                                                frequency: payInit.frequency,
                                                startDate: payInit.startDate,
                                                endDate: payInit.endDate,
                                                payId: payload['id']);
                                          });
                                    }
                                  },
                                ),
                              );
                            });
                          },
                          transitionBuilder: (_, anim, __, child) {
                            return ScaleTransition(
                              // position: tween.animate(anim),
                              scale: CurvedAnimation(
                                  parent: controller,
                                  curve: Curves.elasticInOut),
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
                            return StatefulBuilder(
                                builder: (context, setState) {
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
                              scale: CurvedAnimation(
                                  parent: controller,
                                  curve: Curves.elasticInOut),
                              child: FadeTransition(
                                opacity: anim,
                                child: child,
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 18, right: 18),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/flutterwave.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            height: 32,
                            width: 32,
                          ),
                          SizedBox(width: 15),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Give with Flutterwave',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),

                              // SizedBox(height: 5),
                              Text(
                                'Make payment using your debit card',
                                style: TextStyle(
                                    color: Color.fromRGBO(123, 127, 158, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ))
                        ],
                      ),
                    )),
                SizedBox(height: 25),
                InkWell(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(left: 18, right: 18),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/paypal.png'),
                                  fit: BoxFit.contain),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            height: 32,
                            width: 32,
                          ),
                          SizedBox(width: 15),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Give with Paypal',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),

                              // SizedBox(height: 5),
                              Text(
                                'Seamless payments using paypal',
                                style: TextStyle(
                                    color: Color.fromRGBO(123, 127, 158, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ))
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
          ]),
        ));
  }
}
