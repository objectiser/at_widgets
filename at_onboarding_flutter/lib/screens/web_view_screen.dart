import 'dart:io';

import 'package:at_onboarding_flutter/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String? url;
  final String? title;

  const WebViewScreen({Key? key, this.url, this.title}) : super(key: key);
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'FAQ',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: ColorConstants.appColor,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String value) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                    ColorConstants.appColor,
                  )),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
