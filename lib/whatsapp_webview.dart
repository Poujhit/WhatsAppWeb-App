import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:whatsappweb/license.dart';

class WhatsAppWebView extends StatefulWidget {
  @override
  _WhatsAppWebViewState createState() => _WhatsAppWebViewState();
}

class _WhatsAppWebViewState extends State<WhatsAppWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

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
              applicationLegalese: License.licenseText,
              applicationVersion: '1.0.2',
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: WebView(
          initialUrl: 'https://web.whatsapp.com/',
          javascriptMode: JavascriptMode.unrestricted,
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36",
        ),
      ),
    );
  }
}
