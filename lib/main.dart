import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  OneSignal.initialize("1d3faf09-9e8a-4975-b29f-cb0063b21568"); 
  OneSignal.Notifications.requestPermission(true);

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyWebView(),
  ));
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});
  
  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  InAppWebViewController? webViewController;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    setupNotificationListener();
  }

  void setupNotificationListener() {
    OneSignal.Notifications.addClickListener((event) {
      String? launchUrl = event.notification.launchUrl;
      if (launchUrl != null && webViewController != null) {
        webViewController!.loadUrl(
          urlRequest: URLRequest(url: WebUri(launchUrl))
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (webViewController != null && await webViewController!.canGoBack()) {
              webViewController!.goBack();
              return false;
            }
            return true;
          },
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri("https://ahmedgamalplatform.omarelfergany9.workers.dev/"),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  useHybridComposition: true,
                  userAgent: "Omar_Super_App_2026",
                  cacheMode: CacheMode.LOAD_DEFAULT,
                  supportZoom: false,
                  allowsInlineMediaPlayback: true,
                  disableContextMenu: true,
                  overScrollMode: OverScrollMode.NEVER,
                  disallowOverScroll: true,
                  selectionHighlightColor: Colors.transparent,
                  builtInZoomControls: false,
                  displayZoomControls: false,
                  disableHorizontalScroll: true,
                  saveFormData: false,
                  transparentBackground: true,
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  if (!["http", "https"].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
              if (_progress < 1.0)
                LinearProgressIndicator(
                  value: _progress,
                  color: const Color(0xFF00F2FF),
                  backgroundColor: Colors.transparent,
                  minHeight: 2.5,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
