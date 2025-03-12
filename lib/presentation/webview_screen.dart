import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String text = '';
  @override
  void initState() {
    super.initState();
    text = Get.arguments['link'];
  }

  InAppWebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Webview')),
      body: InAppWebView(
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
            ),
            android: AndroidInAppWebViewOptions(useHybridComposition: true),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            )),
        onWebViewCreated: (controller) {
          this.controller = controller;
          this
              .controller
              ?.loadUrl(urlRequest: URLRequest(url: Uri.parse(text.trim())));
        },
      ),
    );
  }
}
