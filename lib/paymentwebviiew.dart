import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:guardini/orderdetails.dart';
import 'dart:async';
import 'dart:io' show Platform;

class PaymentWebView extends StatefulWidget {
  var full, orderid;
  PaymentWebView(this.full, this.orderid);
  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  var ending = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("success") && url.contains("guardini") || url.contains("fail") && url.contains("guardini")) {
        var timer = new Timer(const Duration(milliseconds: 5000), () {
          flutterWebviewPlugin.close();
          flutterWebviewPlugin.dispose();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrderDetails(widget.orderid),
          //   ),
          // );
          Navigator.pop(context);
          Navigator.pop(context);

        });
      }
    });
  }

  finish() {}
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS? WebviewScaffold(
      url: widget.full,
      appCacheEnabled: true,
      withLocalStorage: true,
      ignoreSSLErrors: true,
      withJavascript: true,

      appBar:new AppBar(
        title: new Text("Make Payment"),
      )
    ):WebviewScaffold(
      url: widget.full,
      appCacheEnabled: true,
      withLocalStorage: true,
      ignoreSSLErrors: true,
      withJavascript: true,
    );
  }
}
