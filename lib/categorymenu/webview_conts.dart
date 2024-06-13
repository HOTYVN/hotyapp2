import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview_Conts extends StatefulWidget {
  final int article_seq;

  const Webview_Conts({super.key, required this.article_seq});

  @override
  _Webview_Conts createState() => _Webview_Conts();
}

class _Webview_Conts extends State<Webview_Conts> {
  WebViewController? _webViewController;
  double _height = 1;
  // var article_seq = '';



  @override
  void initState() {
    _webViewController = WebViewController()
      // ..loadRequest(Uri.parse('http://hotyvn.com/landing/golf/2.html'))
      ..loadRequest(Uri.parse('http://www.hoty.company/mf/webview.do?article_seq=${widget.article_seq}'))
      // ..loadRequest(Uri.parse('http:/192.168.0.109/mf/webview.do?article_seq=${widget.article_seq}'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(onNavigationRequest: (request) {
      return NavigationDecision.prevent;
    },
        onPageFinished: (x) async {
          var x = await _webViewController!.runJavaScriptReturningResult("document.documentElement.scrollHeight");
          double? y = double.tryParse(x.toString());
          debugPrint('parse : $y');
          _height = y!;
        }
    ));
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
          height: _height,
          child: WebViewWidget(controller: _webViewController!),
    );
  }

}