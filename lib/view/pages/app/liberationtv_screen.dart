import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grace_nation/core/services/prayer_request.dart';
import 'package:grace_nation/view/pages/notes/notes.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class LiberationTVScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LiberationTVScreenState();
  }
}

class _LiberationTVScreenState extends State<LiberationTVScreen> {
  int currentIndex = 0;
  VoidCallback listener = () {};
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final prayerRequestController = TextEditingController();
  final genderController = SingleValueDropDownController();
  int? status;
  String? gender;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      // userAgent: userAgent,
      cacheEnabled: true,
      useOnLoadResource: true,

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

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  final Uri _url = Uri.parse('https://gracenation.ng/pages/gracenation');

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  Widget prayerRequestPage(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 24, right: 24, top: 36, bottom: 20),
        child: Form(
          child: Column(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.85),
                        blurRadius: 7,
                        spreadRadius: -3,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: TextFormField(
                  cursorColor: babyBlue,
                  controller: firstNameController,
                  decoration: InputDecoration(
                    hintText: "Firstname",
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
                  validator: (String? value) {
                    if (value == null) {
                      return 'value must not be empty';
                    }
                  },
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.85),
                        blurRadius: 7,
                        spreadRadius: -3,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: TextFormField(
                  cursorColor: babyBlue,
                  controller: lastNameController,
                  decoration: InputDecoration(
                    hintText: "Lastname",
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
                  validator: (String? value) {
                    if (value == null) {
                      return 'value must not be empty';
                    }
                  },
                ),
              ),
              SizedBox(height: 24),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.85),
                        blurRadius: 7,
                        spreadRadius: -3,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: babyBlue,
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "Phone no",
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
                  validator: (String? value) {
                    if (value == null) {
                      return 'value must not be empty';
                    }
                  },
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
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
                      child: DropDownTextField(
                        controller: genderController,
                        textFieldDecoration: InputDecoration(
                          hintText: "Gender",
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        listSpace: 0,
                        listTextStyle: TextStyle(color: black),
                        enableSearch: false,
                        dropDownIconProperty: IconProperty(color: darkGray),
                        clearIconProperty: IconProperty(color: darkGray),
                        dropDownList: const [
                          DropDownValueModel(name: 'male', value: "male"),
                          DropDownValueModel(name: 'female', value: "female"),
                        ],
                        dropDownItemCount: 2,
                        onChanged: ((value) {
                          if (value == null || value == "") {
                            return;
                          } else {
                            setState(() {
                              gender = value.value;
                            });
                          }
                        }),
                        validator: (String? value) {
                          if (value == null) {
                            return 'value must not be empty';
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 22),
                  Expanded(
                    child: Container(
                      height: 40,
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
                      child: DropDownTextField(
                        textFieldDecoration: InputDecoration(
                          hintText: "Status",
                          filled: true,
                          fillColor: Theme.of(context).hoverColor,
                          contentPadding: EdgeInsets.only(top: 6, left: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        listSpace: 0,
                        listTextStyle: TextStyle(color: black),
                        enableSearch: false,
                        dropDownIconProperty: IconProperty(color: darkGray),
                        clearIconProperty: IconProperty(color: darkGray),
                        dropDownList: const [
                          DropDownValueModel(name: 'single', value: 0),
                          DropDownValueModel(name: 'married', value: 1),
                          DropDownValueModel(name: 'widowed', value: 2),
                        ],
                        dropDownItemCount: 3,
                        onChanged: ((value) {
                          if (value == null || value == "") {
                            return;
                          } else {
                            setState(() {
                              status = value.value;
                            });
                          }
                        }),
                        validator: (String? value) {
                          if (value == null) {
                            return 'value must not be empty';
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color:
                            Theme.of(context).disabledColor.withOpacity(0.85),
                        blurRadius: 7,
                        spreadRadius: -3,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: TextFormField(
                  minLines: 6,
                  maxLines: 20,
                  cursorColor: babyBlue,
                  controller: prayerRequestController,
                  decoration: InputDecoration(
                    hintText: "Enter your prayer request",
                    filled: true,
                    fillColor: Theme.of(context).hoverColor,
                    contentPadding: EdgeInsets.only(top: 6, left: 12),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null) {
                      return 'value must not be empty';
                    }
                  },
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                height: 48,
                width: 345,
                child: ElevatedButton(
                  onPressed: () async {
                    final api = PrayerRequestApi();
                    final response = await api.prayerRequest(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phone: phoneController.text,
                      gender: gender ?? 'male',
                      maritalStatus: status ?? 0,
                      prayerRequest: prayerRequestController.text,
                    );
                    if (response == 'success') {
                      setState(() {
                        firstNameController.text = "";
                        lastNameController.text = "";
                        phoneController.text = "";
                        prayerRequestController.text = "";

                        status = null;
                        gender = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        content: Text(
                          'Prayer Request Sent Successfully',
                          style: TextStyle(color: white),
                        ),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        content: Text(
                          response,
                          style: TextStyle(color: white),
                        ),
                      ));
                    }
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
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            Container(
              height: 248, // MediaQuery.of(context).size.height / 3,
              width: 640,
              child: InAppWebView(
                //   key: webViewKey,
                initialOptions: options,
                initialData: InAppWebViewInitialData(
                  data: player,
                  baseUrl: Uri.parse('https://iframe.viewmedia.tv?channel=011'),
                  encoding: 'utf-8',
                  mimeType: 'text/html',
                ),
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  print('CREATED WEB!');
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    "http",
                    "https",
                    "file",
                    "chrome",
                    "data",
                    "javascript",
                    "about"
                  ].contains(uri.scheme)) {
                    await _launchUrl(url);
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onLoadError: (controller, url, code, message) {
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                    urlController.text = this.url;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
              // progress < 1.0
              //     ? LinearProgressIndicator(value: progress)
              //     : Container(),
            ),

            // the tab bar with two items
            SizedBox(
              height: 60,
              child: AppBar(
                toolbarHeight: 60,
                elevation: 5,
                backgroundColor: Theme.of(context).hoverColor,
                bottom: TabBar(
                  indicatorColor: Colors.transparent,
                  labelPadding: EdgeInsets.all(0),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return states.contains(MaterialState.focused)
                          ? null
                          : Colors.transparent;
                    },
                  ),
                  onTap: ((value) {
                    setState(() {
                      currentIndex = value;
                    });
                  }),
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 7.5,
                      ),
                      child: Material(
                        color: currentIndex != 0
                            ? Theme.of(context).hoverColor
                            : null,
                        elevation: currentIndex == 0 ? 5 : 0,
                        borderRadius: BorderRadius.all(Radius.circular(
                          12,
                        )),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          margin: EdgeInsets.only(bottom: 2, top: 2),
                          child: Text(
                            'Notes',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5),
                      child: Material(
                        color: currentIndex != 1
                            ? Theme.of(context).hoverColor
                            : null,
                        elevation: currentIndex == 1 ? 5 : 0,
                        borderRadius: BorderRadius.all(Radius.circular(
                          12,
                        )),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          margin: EdgeInsets.only(bottom: 2, top: 2),
                          child: Text(
                            'Bible',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.5, right: 10),
                      child: Material(
                        color: currentIndex != 2
                            ? Theme.of(context).hoverColor
                            : null,
                        elevation: currentIndex == 2 ? 5 : 0,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                          margin: EdgeInsets.only(bottom: 2, top: 2),
                          child: Text(
                            'Prayer Request',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            //create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // first tab bar view widget
                  Notes(),
                  // second tab bar view widget

                  Container(
                    height: 600,
                    width: MediaQuery.of(context).size.width,
                    child: InAppWebView(
                      //     key: webViewKey,
                      initialOptions: options,
                      //   initialUrlRequest: URLRequest(
                      //   url:
                      //       Uri.parse("https://biblia.com/plugins/embeddedbible"),
                      // ),
                      initialData: InAppWebViewInitialData(
                        data: bible,
                        // baseUrl: Uri.parse(
                        //     'https://biblia.com/plugins/embeddedbible'),
                        encoding: 'utf-8',
                        mimeType: 'text/html',
                      ),
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        print('CREATED BIBLE!');
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          await _launchUrl(url);
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                    // progress < 1.0
                    //     ? LinearProgressIndicator(value: progress)
                    //     : Container(),
                  ),

                  // third tab bar view widget
                  prayerRequestPage(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String iframeHttp =
    '<iframe src="https://iframe.viewmedia.tv?channel=011" width="100%" height="100%" frameborder="0" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>';

String get player => '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                height: 100%;
                width: 100%;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
    $iframeHttp
    </body>
    </html>
  ''';

String get bible => '''
   <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #FFFFFFF;
                height: 100%;
                width: 100%;
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
<iframe src="https://biblia.com/api/plugins/embeddedbible?layout=normal&amp;width=400&amp;height=600&amp;startingReference=Ge1.1&amp;resourceName=nkjv" width="100%" height="100% "></iframe>
    <script>     
        var frame = document.querySelector("iframe");
        header = frame.contentDocument.querySelector("header");
        header.remove();
        footer = frame.contentDocument.querySelector("footer");
        footer.remove();
    </script>
    </body>
    </html>
  ''';
