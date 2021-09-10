import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WhatsAppWebView extends StatefulWidget {
  @override
  _WhatsAppWebViewState createState() => _WhatsAppWebViewState();
}

class _WhatsAppWebViewState extends State<WhatsAppWebView> {
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      userAgent: 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/60.0',
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsAppWeb App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onPressed: () => showAboutDialog(
              context: context,
              applicationIcon: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset('images/whatsapp.png'),
              ),
              applicationName: 'WhatsApp\nWeb App',
              applicationLegalese: 'Copyright (c) 2021 MU Poujhit',
              applicationVersion: '1.0.5',
            ),
          )
        ],
      ),
      //Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:15.0) Gecko/20100101 Firefox/15.0.1
      // body: Container(
      //   height: MediaQuery.of(context).size.height,
      //   child: WebView(
      //     debuggingEnabled: true,
      //     onWebViewCreated: (controller) => print('hello'),
      //     initialUrl: 'https://web.whatsapp.com/',
      //     javascriptMode: JavascriptMode.unrestricted,
      //     userAgent: "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/60.0",
      //   ),
      // ),
      body: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(url: Uri.parse("https://web.whatsapp.com/")),
            initialOptions: options,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
            },
            onLoadStop: (controller, url) async {
              pullToRefreshController.endRefreshing();
            },
            onLoadError: (controller, url, code, message) {
              pullToRefreshController.endRefreshing();
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                pullToRefreshController.endRefreshing();
              }
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Icon(Icons.refresh),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      webViewController?.reload();
                    } else if (Platform.isIOS) {
                      webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
