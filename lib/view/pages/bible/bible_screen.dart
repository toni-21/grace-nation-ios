import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class BibleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BibleScreenState();
  }
}

class _BibleScreenState extends State<BibleScreen> {
  int currentIndex = 0;
  VoidCallback listener = () {};
  bool pageLoaded = false;
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


  void refreshPage() async {
    setState(() {
      pageLoaded = true;
    });
    if (Platform.isAndroid) {
      webViewController?.reload();
    } else if (Platform.isIOS) {
      webViewController?.loadUrl(
          urlRequest: URLRequest(url: await webViewController?.getUrl()));
    }
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        pageLoaded = false;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    refreshPage();
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(
          color: Colors.blue,
        ),
        onRefresh: refreshPage);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomInset: false,
        appBar:
            AppBarWidget(actionScreen: false, appBar: AppBar(), title: 'Bible'),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: InAppWebView(
                  initialOptions: options,
                  initialData: InAppWebViewInitialData(
                    data: bible,
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
              ),
              pageLoaded
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
        ),
      ),
    );
  }
}

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
<iframe src="https://biblia.com/api/plugins/embeddedbible?layout=minimal&amp;width=400&amp;height=600&amp;historyButtons=false&amp;startingReference=Ge1.1&amp;resourceName=nkjv" width="100%" height="100% "></iframe>
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
