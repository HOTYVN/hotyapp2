import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/photo/photo_album_user.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


class todayView extends StatefulWidget{
  final int article_seq;
  final String title_catcode;
  final String cat_name;
  final String table_nm;

  const todayView({super.key, required this.article_seq, required this.title_catcode, required this.cat_name, required this.table_nm});

  @override
  _todayView createState() => _todayView();
}

class _todayView extends State<todayView> {
  var table_nm = ""; // 오늘의정보 테이블네임

  bool isLiked = false; // 좋아요상태
  String likes_yn = '';


  Map<String, dynamic> getresult = {};
  List<dynamic> result = [];

  Map viewresult = {};
  Map viewresult2 = {};
  List<dynamic> fileresult = [];
  List<dynamic> next_result = [];
  String apptitle = "";
  var reg_id = "admin";

  String htmlContent = '';
  String? board_seq ;

  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> cattitle = []; // 카테고리타이틀

  var urlpath = 'http://www.hoty.company';

  Future<dynamic> getviewdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/community/view3.do',
      //'http://www.hoty.company/mf/community/view.do',
    );

    try {

      if(table_nm == "TODAY_INFO") {
        board_seq = "9";
      }

      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : table_nm,
        "reg_id" : reg_id,
        "board_seq" : board_seq,
        "main_category" : widget.title_catcode,
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];
        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];
        /*print("files");
        print(getresult['files']);*/

        getresult.forEach((key, value) {
          if(key == 'data'){
            viewresult.addAll(value);
          }
          if(key == 'files'){
            fileresult.addAll(value);
          }
          if(key == 'next'){
            viewresult2.addAll(value);
          }
          if(key == 'next_list'){
            next_result.addAll(value);
            print("next_result");
            print(value);
          }
        });



        if(viewresult['title'] != null) {
          apptitle = viewresult['title'];
          htmlContent = viewresult['conts'];
        }

        // 좋아요 유무
        if(viewresult['like_yn'] != null) {
          var like_cnt = viewresult['like_yn'];
          print(like_cnt);
          if(like_cnt > 0) {
            isLiked = true;
          }
        }
        print(viewresult);
        print(fileresult);

      }

    }
    catch(e){
      print(e);
    }
  }


  Future<dynamic> updatelike() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/islike.do',
    );

    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : table_nm,
        "title" : apptitle,
        "likes_yn" : likes_yn,
        "reg_id" : reg_id,
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(response.statusCode == 200) {

      }

    }
    catch(e){
      print(e);
    }
  }

// 공통코드 호출
  Future<dynamic> getcodedata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
      /*'http://www.hoty.company/mf/common/commonCode.do',*/
    );
    try {
      Map data = {
        // "pidx": widget.subtitle,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];
        var catlist = json.decode(response.body)['result'];

        coderesult = json.decode(response.body)['result'];

        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    print("#############################################");
    print(reg_id);
  }

  WebViewController? _webViewController;

  double _height = 1;
  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    _asyncMethod();
    _webViewController = WebViewController();
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
        ..loadRequest(Uri.parse('http://www.hoty.company/mf/webview.do?article_seq=${widget.article_seq}'))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
            NavigationDelegate(onNavigationRequest: (request) {
              launchURL(request.url);
              return NavigationDecision.prevent;
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
        ..loadRequest(Uri.parse('http://www.hoty.company/mf/webview.do?article_seq=${widget.article_seq}'));

      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      _webViewController = controller;
    }
    super.initState();
    table_nm = widget.table_nm;
    _asyncMethod();
    getviewdata().then((_) {
      getcodedata().then((_) {
        setState(() {
        });
      });
    });

  }

  TransformationController _transformationController = TransformationController();

  void imagereset() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    }
  }

  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double c_height = m_height;
    double m_width = (MediaQuery.of(context).size.width/360);
    bool isFold = pageWidth > 480 ? true : false;

    print("width : ${MediaQuery.of(context).size.width}");

    if(aspectRatio > 0.55) {
      if(isFold == true) {
        c_height = m_height * (m_width * aspectRatio);
        // c_height = m_height * ( aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 27 * (MediaQuery.of(context).size.width / 360),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 26 * (MediaQuery.of(context).size.width / 360),
          color: Colors.black,
          // alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
          onPressed: (){
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ));
            }
          },
        ),
        title:
        Container(
          // width: 240 * (MediaQuery.of(context).size.width / 360),
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          child: Text(
            "${getSubcodename(viewresult["main_category"])}",
            style: TextStyle(
              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xff0F1316),
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

      ),
      body: SingleChildScrollView(
        primary: table_nm == 'TODAY_INFO' ? true : false,
        child: Column(
          children: [
            if(viewresult.length > 0)
              if(table_nm == 'TODAY_INFO')
            gettitle(context),

            if(viewresult.length > 0)
              if(table_nm == 'HOTY_PICK')
                gettitle_hotypick(context),

            Container(
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              width: 360 * (MediaQuery.of(context).size.width / 360),
              child : Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
            ),
            if(viewresult.length > 0)
              if(table_nm == 'TODAY_INFO')
                getconts(context),


            if(next_result.length > 0)
              for(var i = 0; i < next_result.length; i++)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child: Column(
                    children: [
                      Divider(thickness: 4, height: 3 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                        gettitle2(context, next_result[i]["list"]["title"], next_result[i]["list"]["reg_dt"]),
                      Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                        if(table_nm == 'TODAY_INFO')
                          getconts2(context,next_result[i]["list"]["title"], next_result[i]["list"]["conts"], next_result[i]["files"]),
                    ],
                  ),
                ),

            if(table_nm == 'HOTY_PICK')
              Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                // height: 720 * (MediaQuery.of(context).size.height / 360),
                padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Webview_Conts(article_seq: widget.article_seq),
                    /*Container(
                  height: 700,
                  child: Webview_Conts(article_seq: widget.article_seq,),
                ),*/
                    SizedBox(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        height: MediaQuery.of(context).size.height < 1000 ? 260 * c_height : 200 * c_height,
                        child: WebViewWidget(
                          controller: _webViewController!,
                          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                            Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                            Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()),
                            Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                          },
                        )
                    ),

                   /* InteractiveViewer(
                      // boundaryMargin: const EdgeInsets.all(20.0),
                      // constrained: true,
                      //   scaleEnabled: true,
                        transformationController: _transformationController,
                        minScale: 0.1,
                        maxScale: 10,
                        child:
                        *//*Html(data: viewresult["conts"] ?? "",)*//*
                        SizedBox(
                            width: 360 * (MediaQuery.of(context).size.width / 360),
                            height: _height,
                            child: WebViewWidget(
                              controller: _webViewController!,
                              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
                                Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()),
                                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
                              },
                            )
                        ),
                    ),*/
                  ],
                ),
              ),



            //if(table_nm == 'HOTY_PICK')
            Container(
              margin: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                40 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
            ),

          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'Main_menu'),
    );
  }

  Container getconts(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 3 * (MediaQuery.of(context).size.height / 360)),
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                  // child: Text("Hello, this is Hoty a living assistant in Ho Chi Minh City. Today's exchange rate is"),
                  child: Html(
                    data: viewresult['conts'],
                  ),
                ),
                if(fileresult.length > 0)
                  for(var f=0; f<fileresult.length; f++)
                    GestureDetector(
                      onTap: (){
                        showDialog(context: context,
                            barrierDismissible: false,
                            barrierColor: Colors.black,
                            builder: (BuildContext context) {
                              return PhotoAlbum_User(apptitle: '${viewresult["title"]}',fileresult: fileresult, table_nm: widget.table_nm,);
                            }
                        );
                      },
                      child: Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child : Image(
                          image: CachedNetworkImageProvider('http://www.hoty.company/upload/TODAY_INFO/${fileresult[f]["yyyy"]}/${fileresult[f]['mm']}/${fileresult[f]['uuid']}'), fit: BoxFit.fill,
                        ),
                      ),
                    ),
              ],
            ),
          );
  }

  Container gettitle(BuildContext context) {
    return Container(
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            /*decoration: BoxDecoration (
                border : Border(
                    bottom: BorderSide(color: Color.fromRGBO(243, 246, 248, 1), width : 2 * (MediaQuery.of(context).size.width / 360))
                )
            ),*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container( //
                  width: 220 * (MediaQuery.of(context).size.width / 360),
                  child: Text("${viewresult['title']}",
                    style:
                    TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,

                    ),
                    maxLines: 1
                  ),
                ),
                Container(
                  width: 110 * (MediaQuery.of(context).size.width / 360),
                 margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child: Text("${viewresult['reg_dt']}", style: TextStyle(
                      color: Color(0xffC4CCD0),
                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),

                    ),
                  ),

                ),
              ],
            ),
          );
  }

  Container gettitle_hotypick(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      /*decoration: BoxDecoration (
                border : Border(
                    bottom: BorderSide(color: Color.fromRGBO(243, 246, 248, 1), width : 2 * (MediaQuery.of(context).size.width / 360))
                )
            ),*/
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container( //
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            child: Text("${viewresult['title']}",
                style:
                TextStyle(
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis
                ),
                maxLines: 2
            ),
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Text("${viewresult['reg_dt']}", style: TextStyle(
              color: Color(0xffC4CCD0),
              fontSize: 12 * (MediaQuery.of(context).size.width / 360),

            ),
            ),

          ),
        ],
      ),
    );
  }

  Container getconts2(BuildContext context, title, conts , files) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            // height: 20 * (MediaQuery.of(context).size.height / 360),
            // child: Text("Hello, this is Hoty a living assistant in Ho Chi Minh City. Today's exchange rate is"),
            child: Html(
              data: conts,
            ),
          ),
          if(files.length > 0)
            for(var f=0; f<files.length; f++)
              GestureDetector(
                onTap: (){
                  showDialog(context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.black,
                      builder: (BuildContext context) {
                        return PhotoAlbum_User(apptitle: '${title}',fileresult: files, table_nm: widget.table_nm,);
                      }
                  );
                },
                child: Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child : Image(
                    image: CachedNetworkImageProvider('http://www.hoty.company/upload/TODAY_INFO/${files[f]["yyyy"]}/${files[f]['mm']}/${files[f]['uuid']}'), fit: BoxFit.fill,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Container gettitle2(BuildContext context, title, reg_dt) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      /*decoration: BoxDecoration (
                border : Border(
                    bottom: BorderSide(color: Color.fromRGBO(243, 246, 248, 1), width : 2 * (MediaQuery.of(context).size.width / 360))
                )
            ),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container( //
            width: 220 * (MediaQuery.of(context).size.width / 360),
            child: Text("${title}",
                style:
                TextStyle(
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.bold,

                ),
                maxLines: 1
            ),
          ),
          Container(
            width: 110 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Text("${reg_dt}", style: TextStyle(
              color: Color(0xffC4CCD0),
              fontSize: 12 * (MediaQuery.of(context).size.width / 360),

            ),
            ),

          ),
        ],
      ),
    );
  }

  String getSubcodename(getcode) {
    var Codename = '';
    List<dynamic> main_catlist = [];

    coderesult.forEach((element) {
      if(element['idx'] == getcode) {
        Codename = element['name'];
      }
    });

    return Codename;
  }
}