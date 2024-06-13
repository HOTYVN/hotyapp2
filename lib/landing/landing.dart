import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoty/main/main_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Landing extends StatefulWidget {

  @override
  _landing createState() => _landing();
}

class _landing extends State<Landing> {

  double _height = 1;
  WebViewController? _webViewController;

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    //웹뷰 안드로이드 설정
    if(Platform.isAndroid) {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      _webViewController = WebViewController.fromPlatformCreationParams(params)
        ..loadRequest(Uri.parse('http://www.hoty.company'))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
            NavigationDelegate(onNavigationRequest: (request) {
              //launchURL(request.url);
              return NavigationDecision.navigate;
            },


                onPageFinished: (y) async {
                  var y = await _webViewController!
                      .runJavaScriptReturningResult(
                      "document.documentElement.scrollHeight");
                  double? _y = double.tryParse(y.toString());
                  debugPrint('parse : $_y');
                  _height = _y!;
                  setState(() {

                  });
                }
            ));
      //웹뷰 IOS 설정
    } else if (Platform.isIOS) {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller =
      WebViewController.fromPlatformCreationParams(params);

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url)  async {
              debugPrint('Page finished loading: $url');
              var y = await _webViewController!
                  .runJavaScriptReturningResult(
                  "document.documentElement.scrollHeight");
              double? _y = double.tryParse(y.toString());
              debugPrint('parse : $_y');
              _height = _y!;
              setState(() {
                // print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww');
              });
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('''
           Page resource error:
           code: ${error.errorCode}
           description: ${error.description}
           errorType: ${error.errorType}
           isForMainFrame: ${error.isForMainFrame}
          ''');
            },
            onNavigationRequest: (NavigationRequest request) {
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
          ),
        )
        ..addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        )
        ..loadRequest(Uri.parse('http://www.hoty.company'));

      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      _webViewController = controller;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(3,),
        child: Column(
          children: [
            SizedBox(
              height: 3,
            )
          ],
        ),
      ),
      body: WebViewWidget(
        controller: _webViewController!,
      ),
      floatingActionButton: SizedBox(
        width: 70 * (MediaQuery.of(context).size.width / 360),
        height: 40 * (MediaQuery.of(context).size.height / 360),
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 0,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ));
            },
            tooltip: 'Increment',
            backgroundColor: Colors.transparent,
            child : Column(
              children: [
               /* Container(
                  width: 70,
                  height: 35,
                  color: Colors.blue,
                  child: Text(
                    "뒤로가기"
                  ),
                )*/
                Image(image: AssetImage("assets/back_home.png"),
                    width: 70 * (MediaQuery.of(context).size.width / 360),
                    height: 35 * (MediaQuery.of(context).size.height / 360)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}