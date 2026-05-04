import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // لفتح الواتساب والاتصال
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تثبيت وضع الشاشة رأسي فقط
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // إعداد الإشعارات
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
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

  @override
  void initState() {
    super.initState();
    // تفعيل مستمع الإشعارات لفتح صفحات معينة (Deep Linking)
    setupNotificationListener();
  }

  void setupNotificationListener() {
    OneSignal.Notifications.addClickListener((event) {
      String? launchUrl = event.notification.launchUrl;
      if (launchUrl != null && webViewController != null) {
        // فتح الرابط المرسل في الإشعار فوراً
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
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://ahmedgamalplatform.omarelfergany9.workers.dev/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowsInlineMediaPlayback: true,
              useHybridComposition: true,
              supportZoom: false, // منع الزوم لتبدو واجهة نيتف
              overScrollMode: OverScrollMode.NEVER, // منع الارتداد
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            // --- ميزة رقم 2: التعامل مع الروابط الخارجية (واتساب، اتصال، إلخ) ---
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;

              // لو الرابط مش موقع (يعني واتساب أو تليفون أو إيميل)
              if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
                if (await canLaunchUrl(uri)) {
                  // افتح التطبيق الخارجي (واتساب مثلاً)
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                  // امنع الـ WebView من محاولة تحميل الرابط ده داخلياً
                  return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
        ),
      ),
    );
  }
}
        child: WillPopScope(
          onWillPop: () async {
            if (webViewController != null && await webViewController!.canGoBack()) {
              webViewController!.goBack();
              return false;
            }
            return true;
          },
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://ahmedgamalplatform.omarelfergany9.workers.dev/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowsInlineMediaPlayback: true,
              useHybridComposition: true,
              
              // --- اللمسات الاحترافية لإخفاء الويب ---
              supportZoom: false,          // منع تكبير الشاشة بالإيد
              builtInZoomControls: false, // إخفاء زراير الزوم
              displayZoomControls: false,
              disableVerticalScroll: false,
              disableHorizontalScroll: true, // منع الهز يمين وشمال
              overScrollMode: OverScrollMode.NEVER, // منع الارتداد (Bouncing) اللي بيبين إنه ويب
              saveFormData: false,         // منع جوجل من طلب حفظ الباسورد
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          ),
        ),
      ),
    );
  }
}
              return false;
            }
            return true;
          },
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://ahmedgamalplatform.omarelfergany9.workers.dev/"),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowsInlineMediaPlayback: true, // عشان الفيديوهات تشتغل جوه الصفحة
              useHybridComposition: true,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          ),
        ),
      ),
    );
  }
}
              javaScriptEnabled: true,
              transparentBackground: true, 
            ),
          ),
        ),
      ),
    );
  }
}
