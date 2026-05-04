import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تثبيت وضع الشاشة رأسي فقط عشان يبان نيتف
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ربط الإشعارات
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية سوداء تمنع "الوميض الأبيض" وقت التحميل
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
