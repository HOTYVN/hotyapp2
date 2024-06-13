import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/webview_conts.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/icons/my_icons.dart';
import 'package:hoty/common/modifyinfo/modify_infomation.dart';
import 'package:hoty/common/prenextlist/pnlist.dart';
import 'package:hoty/community/device_id.dart';
import 'package:hoty/main/main_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:http/http.dart' as http;

import '../common/Nodata.dart';
import '../common/dialog/loginAlert.dart';
import '../common/dialog/showDialog_modal.dart';
import '../common/js/common_js.dart';
import '../common/photo/view_photo.dart';
import '../counseling/counseling_guide.dart';
import '../login/login.dart';
import '../service/service_guide.dart';
import 'common/photo_view.dart';
import 'providers/living_provider.dart';

class LivingView extends StatefulWidget {
  final int article_seq;
  final String table_nm;
  final String title_catcode;
  final Map params;

  const LivingView({Key? key,
    required this.article_seq,
    required this.table_nm,
    required this.title_catcode,
    required this.params,
  }) : super(key:key);

  @override
  _LivingView createState() => _LivingView();

}

class _LivingView extends State<LivingView> {
  final GlobalKey title_key = GlobalKey();
  final GlobalKey title_key2 = GlobalKey();

  var longurl = "";
  var url1 = "https://hotyapp.page.link/?link=https://hotyapp.page.link?";
  var url2 = "type=view@@table_nm=LIVING_INFO@@article_seq=";
  var url3 = "&apn=com.hotyvn.hoty";
  var shorturl = "";

  double _height = 1;
  Map viewresult = {};
  Map previewresult = {};
  Map nextviewresult = {};
  List<dynamic> pnlistresult = []; // 프리뷰 앞뒤 5개씩



  List<dynamic> fileresult = [];
  List<dynamic> coderesult = []; // 공통코드 리스트

  List<dynamic> iconresult = [];
  List<dynamic> phoneresult = [];

  String apptitle = "";
  bool isLiked = false; // 좋아요상태
  String likes_yn = '';
  var reg_id = "";
  /*var urlpath = 'http://www.hoty.company';*/
  var urlpath = 'http://www.hoty.company';
  List<String> gubun = ['C101','C102','C103','C104'];
  List<dynamic> title_catname = []; // 메뉴타이틀테고리 리스트
  List<dynamic> areaname = []; // 지역카테고리 리스트
  String cattitle = "";
  var board_seq = 11;

  var nowcnt = 1;
  var nowImgpath = '';

  Widget prenextview = Container();//리뷰용


  Future<dynamic> setImg() async {
    if(fileresult.length > 0) {
      for(int i=0; i<fileresult.length; i++) {
        nowImgpath =
            urlpath
                +'/upload/'
                +widget.table_nm
                +'/'
                +fileresult[0]["yyyy"]
                +'/'
                +fileresult[0]["mm"]
                +'/'
                +fileresult[0]["uuid"];
      }
    }

  }

  Future<dynamic> getUrl() async {


    longurl = url1 + url2 + widget.article_seq.toString() + url3;

    print(longurl);

    var url = Uri.parse(
      //'http://www.hoty.company/mf/url/shorturl.do',
      'http://www.hoty.company/mf/url/shorturl.do',
    );

    Map params = {
      "url" : longurl
    };

    var body = json.encode(params);
    // print(body);
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if(response.statusCode == 200) {
      var resultstatus = json.decode(response.body)['resultstatus'];
      print("############################");
      print(json.decode(response.body)['url']);

      shorturl = json.decode(response.body)['url'];
    }
    setState(() {

    });
  }


  Future<dynamic> getviewdata() async {
    Map params = {
      "article_seq" : widget.article_seq,
      "table_nm" : widget.table_nm,
      "board_seq": board_seq.toString(),
      "main_category" : widget.title_catcode,
      "reg_id" : reg_id != "" ? reg_id : await getMobileId(),
      "likes_yn" : likes_yn,

    };
    Map<String, dynamic> rst = {};
    List<dynamic> getresult = [];

    rst = await livingProvider().getviewdata(params);
    print("#######################");
    print(rst);

    // 뷰 데이터
    viewresult = rst['result']; // 뷰데이터
    fileresult = rst['files']; // 파일리스트
    previewresult = rst['pre_view'];
    nextviewresult = rst['next_view'];
    pnlistresult = rst['pnlist']; // 프리뷰리스트
    if(rst["icon_list"] != null) {
      iconresult = rst["icon_list"];
    }
    if(rst["phone_list"] != null) {
      phoneresult = rst["phone_list"];
      print(phoneresult);
    }

    if(viewresult['title'] != null) {
      apptitle = viewresult['title']; //뷰타이틀
    }
    // print(apptitle);

    // 좋아요 유무
    if(viewresult['like_yn'] != null) {
      var like_cnt = viewresult['like_yn'];
      print(like_cnt);
      if(like_cnt > 0) {
        isLiked = true;
      }
    }

    nowImgpath = (urlpath+'${viewresult['main_img_path']}${viewresult['main_img']}');

    if(viewresult["etc10"] != null && viewresult["etc10"] != "" && viewresult["review_yn"] == 'Y') {
        dynamic Maps = await fetchPlaceRating(viewresult["etc10"]);
        print("지도값 체크입니다.");
        print(Maps);
        if (Maps["result"] != null) {
          viewresult["place_rating"] = Maps["result"]["rating"];
          viewresult["place_rating_cnt"] = Maps["result"]["user_ratings_total"];
        }
        setState(() {

        });
    }
  }

  // 좋아요
  Future<dynamic> updatelike() async {
    String like_status = "";

    Map params = {
      "article_seq" : widget.article_seq,
      "table_nm" : widget.table_nm,
      "title" : apptitle,
      "likes_yn" : likes_yn,
      "reg_id" : reg_id != "" ? reg_id : await getMobileId(),
    };
    like_status = await livingProvider().updatelike(params);
  }

  // 공통코드 호출
  Future<dynamic> setcode() async {
    //코드 전체리스트 가져오기
    coderesult = await livingProvider().getcodedata();

    // 타이틀코드,지역코드
    coderesult.forEach((value) {
      if(value['idx'] == widget.title_catcode) {
        cattitle = value['name'];
      }
      if(value['pidx'] == 'C1'){
        title_catname.add(value);
      }
      if(value['pidx'] == 'C2'){
        areaname.add(value);
      }
    });


  }

  WebViewController? _webViewController;

  Future<dynamic> fetchPlaceRating(String placeId) async {
    final apiKey = 'AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs';
    final apiUrl = 'https://maps.googleapis.com/maps/api/place/details/json?fields=rating,user_ratings_total';

    final response = await http.get(Uri.parse('$apiUrl&place_id=$placeId&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      /*final double rating = data['result']['rating'] ?? 0;*/
      return data;
    } else {
      throw Exception('Failed to load place rating');
    }
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    print(reg_id);
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<dynamic> getpnlist() async {
    // prenextview = await getPreNext(context);
    prenextview = await PreNextList(
      article_seq: widget.article_seq,
      table_nm: widget.table_nm,
      main_cat: widget.title_catcode,
      pre_article_seq: '${previewresult['article_seq']}',
      next_article_seq: '${nextviewresult['article_seq']}',
      pnlist: pnlistresult,
      coderesult: coderesult,
      params: widget.params,
    );
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    setState(() {
      /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Scrollable.ensureVisible(
          title_key.currentContext!,
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Scrollable.ensureVisible(
          title_key2.currentContext!,
        );
      });*/
    });
  }

  //테스트
  Map prev_cnt = {};
  Map next_cnt = {};
  Map prev_article = {};
  Map next_article = {};
   // var Baseurl = "http://192.168.0.109/mf";
  var Baseurl = "http://www.hoty.company/mf";
  List<dynamic> pnlist = [];

  List<dynamic> sub_category = [];
  List<dynamic> checklist = [];
  List<dynamic> area_category = [];


  List<dynamic> listcat01 = []; // cat01 체크리스트
  List<dynamic> listcat02 = []; // cat02 체크리스트
  List<dynamic> listcat03 = []; // cat03 체크리스트
  List<dynamic> listcat04 = []; // cat04 체크리스트
  List<dynamic> listcat05 = []; // cat05 체크리스트
  List<dynamic> listcat06 = []; // cat06 체크리스트
  List<dynamic> listcat07 = []; // cat07 체크리스트
  List<dynamic> listcat08 = []; // cat08 체크리스트
  List<dynamic> listcat09 = []; // cat09 체크리스트
  List<dynamic> listcat10 = []; // cat10 체크리스트
  List<dynamic> listcat11 = []; // cat11 체크리스트


  // list 호출
  Future<dynamic> getlistdata() async {
    Map<String, dynamic> rst = {};
    Map<String, dynamic> getresult = {};

    var totalpage = '';

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
        Baseurl + "/living/pnlist.do"
    );
    // print('######3333333333333333333333');
    // print(widget.params['keyword'].toString());
    var _keyword = '';
    var _sort_nm = '';
    if(widget.params['keyword'] != null) {
      _keyword = widget.params['keyword'];
    }
    if(widget.params['sort_nm'] != null) {
      _sort_nm = widget.params['sort_nm'];
    }

    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : widget.table_nm,
        "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
        "sort_nm" : _sort_nm,
        "keyword" : _keyword,
        "condition" : widget.params['condition'].toString() ?? '',
        "main_category" : widget.title_catcode,
        "sub_category" : sub_category.toList(),
        "checklist" : checklist.toList(),
        "area_category" : area_category.toList(),
        "listcat01" : listcat01.toList(),
        "listcat02" : listcat02.toList(),
        "listcat03" : listcat03.toList(),
        "listcat04" : listcat04.toList(),
        "listcat05" : listcat05.toList(),
        "listcat06" : listcat06.toList(),
        "listcat07" : listcat07.toList(),
        "listcat08" : listcat08.toList(),
        "listcat09" : listcat09.toList(),
        "listcat10" : listcat10.toList(),
        "listcat11" : listcat11.toList(),
        "stay_yn" : widget.params['stay_yn'],
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



        print(resultstatus);
        print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];

        getresult.forEach((key, value) {
          if(key == 'pnlist'){
            pnlist.addAll(value);
          }
          if(key == 'prev_cnt'){
            prev_cnt.addAll(value);
          }
          if(key == 'next_cnt'){
            next_cnt.addAll(value);
          }
          if(key == 'prev_seq'){
            if(value != null){
              prev_article.addAll(value);
            }
          }
          if(key == 'next_seq'){
            if(value != null){
              next_article.addAll(value);
            }
          }
        });

      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }

    return rst;
  }

  final GlobalKey pre_article_key = GlobalKey();

  void setparam() {
    if(widget.params['sub_category'] != null) {
      sub_category.addAll(widget.params['sub_category']);
    }
    if(widget.params['checklist'] != null) {
      checklist.addAll(widget.params['checklist']);
    }
    if(widget.params['area_category'] != null) {
      area_category.addAll(widget.params['area_category']);
    }
    if(widget.params['listcat01'] != null) {
      listcat01.addAll(widget.params['listcat01']);
    }
    if(widget.params['listcat02'] != null) {
      listcat02.addAll(widget.params['listcat02']);
    }
    if(widget.params['listcat03'] != null) {
      listcat03.addAll(widget.params['listcat03']);
    }
    if(widget.params['listcat04'] != null) {
      listcat04.addAll(widget.params['listcat04']);
    }
    if(widget.params['listcat05'] != null) {
      listcat05.addAll(widget.params['listcat05']);
    }
    if(widget.params['listcat06'] != null) {
      listcat06.addAll(widget.params['listcat06']);
    }
    if(widget.params['listcat07'] != null) {
      listcat07.addAll(widget.params['listcat07']);
    }
    if(widget.params['listcat08'] != null) {
      listcat08.addAll(widget.params['listcat08']);
    }
    if(widget.params['listcat09'] != null) {
      listcat09.addAll(widget.params['listcat09']);
    }
    if(widget.params['listcat10'] != null) {
      listcat10.addAll(widget.params['listcat10']);
    }
    if(widget.params['listcat11'] != null) {
      listcat11.addAll(widget.params['listcat11']);
    }

  }


  @override
  void initState() {
    setparam();
    _asyncMethod();
    print("Platform.isAndroid : ${Platform.isAndroid}");
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
    setcode().then((_) {
      getviewdata().then((_) {
        getlistdata().then((_) {
          setState(() {
            // getpnlist();
            if(pnlist.length > 0) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Scrollable.ensureVisible(
                  pre_article_key.currentContext!,
                );
              });
            }
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Scrollable.ensureVisible(
                title_key.currentContext!,
              );
            });
            // _scrollController.jumpTo(0);
          });
        });

      });
    });
  }
  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    setState(() {
      _scrollController.jumpTo(0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( 28 * (MediaQuery.of(context).size.height / 360)),
        child: AppBar(
          titleSpacing: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            iconSize: 12 * (MediaQuery.of(context).size.height / 360),
            color: Color(0xff151515),
            alignment: Alignment.centerLeft,
            // padding: EdgeInsets.zero,
            // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
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
            margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // height: 22,
            // width: 240 * (MediaQuery.of(context).size.width / 360),
            child: Text(
              apptitle,
              style: TextStyle(
                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                color: Color(0xff0F1316),
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360),8 * (MediaQuery.of(context).size.width / 360), 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap:() {
                      /*showModalBottomSheet(
                        context: context,
                        clipBehavior: Clip.hardEdge,
                        barrierColor: Color(0xffE47421).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        builder: (BuildContext context) {
                          return share();
                        },
                      );*/
                      getUrl().then((_) {
                        setState(() {

                        });
                        _onShare(context, viewresult["title"], shorturl);
                      });
                    },
                    child: Icon(Icons.ios_share,color: Color(0xffC4CCD0),size: 24,),
                  ),
                  GestureDetector(
                    onTap: () {
                      _isLiked();
                    },
                    child: Row(
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Icon(
                            Icons.favorite,
                            color: Color(isLiked ? 0xffE47421 : 0xffC4CCD0),
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      /*body: SingleChildScrollView(
        child: Column(
          children: [
            if(viewresult.length > 0 )
              Container(
                child: getConts(context),
              ),
          ],
        ),
      ),*/
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(viewresult.length > 0 )
              Container(
                key: title_key,
                child: getConts(context),
              ),
            //웹뷰/
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
                      height: _height,
                      child: WebViewWidget(
                        controller: _webViewController!,
                      )
                  ),

                ],
              ),
            ),//웹뷰// 컨텐츠내용
            // if(viewresult.length > 0 )
            // prenextview, // 미리보기
            getPreNext(context),
            Divider(thickness: 5, height: 0 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
            if(viewresult.length > 0 )
              Follow_us(),
            Container(
              key: title_key2,
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
  Widget getPreNext(context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 110 * (MediaQuery.of(context).size.height / 360),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      color: Color(0xffF9FBFB),
      child: Column(
        children: [
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            height: 10 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360) , 0, 0),
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:() {
                          /*     if(prev_cnt['prev_cnt'] > 0) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LivingView(
                                  article_seq: prev_article['article_seq'],
                                  table_nm: widget.table_nm,
                                  title_catcode: widget.title_catcode, params: widget.params,
                                );
                              },
                            ));
                          }*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 1.5 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 14 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        child: Text(
                          "이전게시글",
                          style: TextStyle(
                            // color: Color(0xff151515),
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            fontFamily: 'NanumSquareEB',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "다음게시글",
                          style: TextStyle(
                            // color: Color(0xff151515),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NanumSquareEB',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:() {
                          /*    if(next_cnt['next_cnt'] > 0) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LivingView(
                                  article_seq: next_article['article_seq'],
                                  table_nm: widget.table_nm,
                                  title_catcode: widget.title_catcode, params: widget.params,
                                );
                              },
                            ));
                          }*/
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 1.5 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,size: 14 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xffE47421), )
              ),
            ),
          ),
          if(pnlist.length > 0)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 65 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
              // color: Colors.blue,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(prev_cnt['prev_cnt'] != null)
                      if(prev_cnt['prev_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 50 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '이전 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareEB',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    for(var i=0; i<pnlist.length; i++)
                      Container(
                        child: Row(
                          children: [
                            if(prev_article['article_seq'] != '' && prev_article['article_seq'] != null)
                              if(prev_article['article_seq'] == pnlist[i]['article_seq'])
                                GestureDetector(
                                  onTap:() {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(
                                      // fullscreenDialog: true,
                                      builder: (context) {
                                        return LivingView(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], title_catcode: pnlist[i]['main_category'], params: widget.params,);
                                      },
                                    ));
                                  },
                                  child: Container(
                                    key : pre_article_key,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 165 * (MediaQuery.of(context).size.width / 360),
                                          height: 50 * (MediaQuery.of(context).size.height / 360),
                                          decoration: BoxDecoration(
                                            image: pnlist[i]['main_img'] != null && pnlist[i]['main_img'] != '' ? DecorationImage(
                                                image:  CachedNetworkImageProvider(urlpath+'${pnlist[i]['main_img_path']}${pnlist[i]['main_img']}'),
                                                fit: BoxFit.cover
                                            ) : DecorationImage(
                                                image: AssetImage('assets/noimage.png'),
                                                fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                      0 , 0 ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff2F67D3),
                                                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      if(pnlist[i]['area_category'] != null && pnlist[i]['area_category'] != '' )
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Text(getCodename(pnlist[i]['area_category'], coderesult),
                                                            style: TextStyle(
                                                              fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                                              color: Colors.white,
                                                              // fontWeight: FontWeight.bold,
                                                              // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                    ],
                                                  )
                                              ),
                                              Container(
                                                  margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                      6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      if(pnlist[i]['like_yn'] != null && pnlist[i]['like_yn'] > 0)
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                        ),
                                                      if(pnlist[i]['like_yn'] == null || pnlist[i]['like_yn'] == 0)
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                        ),
                                                    ],
                                                  )
                                              )
                                            ],

                                          ),
                                        ),
                                        Container(
                                          width: 165 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                          constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text(
                                            '${pnlist[i]['title']}',
                                            // '${pnlist[i]['article_seq']}',
                                            style: TextStyle(
                                              fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                              // color: Colors.red,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'NanumSquareEB',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            // if(prev_article['article_seq'] == null || prev_article['article_seq'] == '')
                            if(prev_article['article_seq'] != pnlist[i]['article_seq'])
                              GestureDetector(
                                onTap:() {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                    // fullscreenDialog: true,
                                    builder: (context) {
                                      return LivingView(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], title_catcode: pnlist[i]['main_category'], params: widget.params,);
                                    },
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 50 * (MediaQuery.of(context).size.height / 360),
                                        decoration: BoxDecoration(
                                          image: pnlist[i]['main_img'] != null && pnlist[i]['main_img'] != '' ? DecorationImage(
                                              image:  CachedNetworkImageProvider(urlpath+'${pnlist[i]['main_img_path']}${pnlist[i]['main_img']}'),
                                              fit: BoxFit.cover
                                          ) : DecorationImage(
                                              image: AssetImage('assets/noimage.png'),
                                              fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                    0 , 0 ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff2F67D3),
                                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                ),
                                                child:Row(
                                                  children: [
                                                    if(pnlist[i]['area_category'] != null && pnlist[i]['area_category'] != '' )
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Text(getCodename(pnlist[i]['area_category'], coderesult),
                                                          style: TextStyle(
                                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                                            color: Colors.white,
                                                            // fontWeight: FontWeight.bold,
                                                            // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                  ],
                                                )
                                            ),
                                            Container(
                                                margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                    6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                  shape: BoxShape.circle,
                                                ),
                                                child:Row(
                                                  children: [
                                                    if(pnlist[i]['like_yn'] != null && pnlist[i]['like_yn'] > 0)
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                      ),
                                                    if(pnlist[i]['like_yn'] == null || pnlist[i]['like_yn'] == 0)
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                      ),
                                                  ],
                                                )
                                            )
                                          ],

                                        ),
                                      ),
                                      Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                        child: Text(
                                          '${pnlist[i]['title']}',
                                          // '${pnlist[i]['article_seq']}',
                                          style: TextStyle(
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NanumSquareEB',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if(next_cnt['next_cnt'] != null)
                      if(next_cnt['next_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 50 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '다음 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareEB',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          if(pnlist.length == 0)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 65 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
              // color: Colors.blue,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(prev_cnt['prev_cnt'] != null)
                      if(prev_cnt['prev_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 50 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '이전 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareEB',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    if(next_cnt['next_cnt'] != null)
                      if(next_cnt['next_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 50 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '다음 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareEB',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget getPreNext3(context) {
    return PreNextList(
      article_seq: widget.article_seq,
      table_nm: widget.table_nm,
      main_cat: widget.title_catcode,
      pre_article_seq: '${previewresult['article_seq']}',
      next_article_seq: '${nextviewresult['article_seq']}',
      pnlist: pnlistresult,
      coderesult: coderesult,
      params: widget.params,
    );
  }
  Widget getPreNext1(context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 120 * (MediaQuery.of(context).size.height / 360),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      color: Color(0xffF9FBFB),
      child: Column(
        children: [
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            height: 15 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360) , 0, 0),
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:() {
                          if(previewresult.length > 0) {
                            Navigator.push(context, MaterialPageRoute(
                              // fullscreenDialog: true,
                              builder: (context) {
                                return LivingView(
                                  article_seq: previewresult['article_seq'],
                                  table_nm: previewresult['table_nm'],
                                  title_catcode: previewresult['main_category'], params: {},);
                              },
                            ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 16,),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        child: Text(
                          "이전게시글",
                          style: TextStyle(
                            color: Color(0xff151515),
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            fontFamily: 'NanumSquareEB',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "다음게시글",
                          style: TextStyle(
                            color: Color(0xff151515),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NanumSquareEB',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:() {
                          if(nextviewresult.length > 0 ) {
                            Navigator.push(context, MaterialPageRoute(
                              // fullscreenDialog: true,
                              builder: (context) {
                                return LivingView(
                                  article_seq: nextviewresult['article_seq'],
                                  table_nm: nextviewresult['table_nm'],
                                  title_catcode: nextviewresult['main_category'], params: {},);
                              },
                            ));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,size: 16,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xffE47421), )
              ),
            ),
          ),
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            height: 70 * (MediaQuery.of(context).size.height / 360),
            // color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(previewresult.length > 0)
                  GestureDetector(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(
                        // fullscreenDialog: true,
                        builder: (context) {
                          return LivingView(article_seq: previewresult['article_seq'], table_nm: previewresult['table_nm'], title_catcode: previewresult['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: previewresult['main_img'] == null ? DecorationImage(
                                  image:  CachedNetworkImageProvider(urlpath+'${previewresult['main_img_path']}${previewresult['main_img']}'),
                                  fit: BoxFit.cover
                              ) : DecorationImage(
                                  image: AssetImage('assets/noimage.png'),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        if(previewresult['area_category'] != null && previewresult['area_category'] != '' )
                                          Container(
                                            padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text(getSubcodename(previewresult['area_category']),
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                                // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                      ],
                                    )
                                ),
                                Container(
                                    margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                        6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                      shape: BoxShape.circle,
                                    ),
                                    child:Row(
                                      children: [
                                        if(previewresult['like_yn'] != null && previewresult['like_yn'] > 0)
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                          ),
                                        if(previewresult['like_yn'] == null || previewresult['like_yn'] == 0)
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                          ),
                                      ],
                                    )
                                )
                              ],

                            ),
                          ),
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                            constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                            child: Text(
                              '${previewresult['title']}',
                              style: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if(previewresult.length == 0)
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Column(
                      children: [
                        Container(
                          width: 165 * (MediaQuery.of(context).size.width / 360),
                          height: 50 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            /*image: DecorationImage(
                              image: AssetImage('assets/no_search.png'),
                              // fit: BoxFit.cover
                            ),*/
                          ),
                          child: Column(
                            children: [
                              Container(
                                  height: 50 * (MediaQuery.of(context).size.height / 360),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      // image: AssetImage('assets/no_search2.png'),
                                        image: AssetImage('assets/noimage.png'),
                                        fit: BoxFit.cover
                                    ),
                                  )
                              ),
                            ],
                          ),
                          // color: Colors.amberAccent,
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Text(
                            "이전게시글이 없습니다",
                            style: TextStyle(
                              fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              fontFamily: 'NanumSquareB',
                              // fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if(nextviewresult.length > 0)
                  GestureDetector(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(
                        // fullscreenDialog: true,
                        builder: (context) {
                          return LivingView(article_seq: nextviewresult['article_seq'], table_nm: nextviewresult['table_nm'], title_catcode: nextviewresult['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: nextviewresult['main_img'] == null ? DecorationImage(
                                  image:  CachedNetworkImageProvider(urlpath+'${nextviewresult['main_img_path']}${nextviewresult['main_img']}'),
                                  fit: BoxFit.cover
                              ) : DecorationImage(
                                  image: AssetImage('assets/noimage.png'),
                                  fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        if(nextviewresult['area_category'] != null && nextviewresult['area_category'] != '' )
                                          Container(
                                            padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text(getSubcodename(nextviewresult['area_category']),
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                                // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                      ],
                                    )
                                ),
                                Container(
                                    margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                        6 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                    // width: 40 * (MediaQuery.of(context).size.width / 360),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                      shape: BoxShape.circle,
                                    ),
                                    child:Row(
                                      children: [
                                        if(nextviewresult['like_yn'] != null && nextviewresult['like_yn'] > 0)
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                          ),
                                        if(nextviewresult['like_yn'] == 0 || nextviewresult['like_yn'] == null )
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                          ),
                                      ],
                                    )
                                )
                              ],

                            ),
                          ),
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                            constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                            child: Text(
                              '${nextviewresult['title']}',
                              style: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if(nextviewresult.length == 0)
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Column(
                      children: [
                        Container(
                          width: 165 * (MediaQuery.of(context).size.width / 360),
                          height: 50 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            color: Color(0xffeeeeee),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            /*image: DecorationImage(
                              image: AssetImage('assets/no_search.png'),
                              // fit: BoxFit.cover
                            ),*/
                          ),
                          child: Column(
                            children: [
                              Container(
                                  height: 50 * (MediaQuery.of(context).size.height / 360),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      // image: AssetImage('assets/no_search2.png'),
                                        image: AssetImage('assets/noimage.png'),
                                        fit: BoxFit.cover
                                    ),
                                  )
                              ),
                            ],
                          ),
                          // color: Colors.amberAccent,
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Text(
                            "다음글이 없습니다.",
                            style: TextStyle(
                              fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              fontFamily: 'NanumSquareB',
                              // fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],

            ),
          ),
        ],
      ),
    );
  }

  Widget getConts(context) {
    return
      Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
            child: ViewInfo_Photo(mainfile: '${viewresult['main_img']}', fileresult: fileresult, table_nm: widget.table_nm, code_nm: getSubcodename(viewresult['area_category']),apptitle : '${viewresult['title']}'),
          ),
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            // height: 30 * (MediaQuery.of(context).size.height / 360),
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB( 1  * (MediaQuery.of(context).size.height / 360), 5  * (MediaQuery.of(context).size.height / 360),
                      0, 0),
                  width: 350 * (MediaQuery.of(context).size.width / 360),
                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                  child: Text(
                    "${viewresult['title']}",
                    style: TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      // color: Colors.white,
                      fontFamily: 'NanumSquareEB',
                      fontWeight: FontWeight.w800,
                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                    ),
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if(viewresult['place_rating'] != null && viewresult["place_rating_cnt"] != null && viewresult["review_yn"] == 'Y')
            Container(
                margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                width: 340 * (MediaQuery.of(context).size.width / 360),
                child:Row(
                  children: [
                    Text("구글평점 ",style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360),fontFamily: 'NanumSquareEB',),),
                    Text("${viewresult["place_rating"]}",style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360)),),
                    RatingBarIndicator(
                      unratedColor: Color(0xffC4CCD0),
                      rating: viewresult["place_rating"].toDouble(),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 8 * (MediaQuery.of(context).size.height / 360),
                      direction: Axis.horizontal,
                    ),
                    Text("(${viewresult["place_rating_cnt"]})",style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360),),),
                  ],
                )

            ),
          if(viewresult['adres'] != null && viewresult['address_yn'] == 'Y')
            Container(
                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                width: 340 * (MediaQuery.of(context).size.width / 360),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 1  * (MediaQuery.of(context).size.height / 360), 0, 0),
                      child:Icon(Icons.location_on_sharp, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB( 3  * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                      width: 300 * (MediaQuery.of(context).size.width / 360),
                      child: Text(
                        '${viewresult['adres']}',
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          // color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )

            ),
          for(var a = 0; a < phoneresult.length; a++)
            Container(
                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                width: 340 * (MediaQuery.of(context).size.width / 360),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   GestureDetector(
                     onTap: () {
                       launch("tel://${phoneresult[a]['phone']}");
                     },
                     child : Row(
                       children: [
                         Container(
                           child:Icon(Icons.phone_in_talk, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                         ),
                         Container(
                             margin : EdgeInsets.fromLTRB( 3  * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                             width: 300 * (MediaQuery.of(context).size.width / 360),
                             child: GestureDetector(
                               onTap : () {
                                 launch("tel://${phoneresult[a]['phone']}");
                               },
                               child : Row(
                                 children: [
                                   Text(
                                     '${phoneresult[a]['phone'] ?? ""}',
                                     style: TextStyle(
                                       fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                       // color: Colors.white,
                                       // fontWeight: FontWeight.bold,
                                       // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                     ),
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                   SizedBox(width: 5 * (MediaQuery.of(context).size.width / 360)),
                                   Text(
                                     '${phoneresult[a]['memo'] ?? ""}',
                                     style: TextStyle(
                                       fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                       // color: Colors.white,
                                       // fontWeight: FontWeight.bold,
                                       // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                     ),
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ],
                               ),
                             )
                         ),
                       ],
                     )
                   )
                  ],
                )

            ),
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            // height: 35 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),5 * (MediaQuery.of(context).size.height / 360),
                0, 0 * (MediaQuery.of(context).size.height / 360)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    /*width: 210 * (MediaQuery.of(context).size.width / 360),*/
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            child: Row(
                              children: [
                                Icon(Icons.favorite, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                Container(
                                  constraints: BoxConstraints(maxWidth : 60 * (MediaQuery.of(context).size.width / 360)),
                                  child: Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0,
                                        10 * (MediaQuery.of(context).size.width / 360), 0),
                                    child: Text(
                                      "${viewresult['like_cnt']}",
                                      style: TextStyle(
                                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        overflow: TextOverflow.ellipsis,
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          height : 8 * (MediaQuery.of(context).size.height / 360) ,
                          child :  DottedLine(
                            lineThickness:1,
                            dashLength: 2.0,
                            dashColor: Color(0xffC4CCD0),
                            direction: Axis.vertical,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye, size: 10 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                              Container(
                                constraints: BoxConstraints(maxWidth : 60 * (MediaQuery.of(context).size.width / 360)),
                                margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0,
                                    10 * (MediaQuery.of(context).size.width / 360), 0),
                                child: Text(
                                  "${viewresult['view_cnt']}",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    overflow: TextOverflow.ellipsis,
                                    // fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        for(var a = 0; a < iconresult.length; a++)
                          Container(
                              height : 10 * (MediaQuery.of(context).size.height / 360) ,
                              child : Row (
                                children: [
                                  DottedLine(
                                    lineThickness:1,
                                    dashLength: 2.0,
                                    dashColor: Color(0xffC4CCD0),
                                    direction: Axis.vertical,
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                                    child: Row(
                                      children: [
                                        Image(image: CachedNetworkImageProvider("http://www.hoty.company/images/app_icon/${iconresult[a]["icon"]}.png"), height: 8 * (MediaQuery.of(context).size.height / 360),),
                                        Container(
                                          margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                          child: Text(
                                            "${iconresult[a]["icon_nm"]}",
                                            style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              color: Color(0xff151515),
                                              overflow: TextOverflow.ellipsis,
                                              // fontWeight: FontWeight.bold,
                                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*if(viewresult["etc02"] != null && widget.title_catcode == "C2")
            GestureDetector(
                onTap: () {
                  launchURL(viewresult["etc02"]);
                },
                child :
                Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child : DottedBorder(
                      color: Color(0xffE47421),
                      dashPattern: [5,3],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(50),
                      child: Container(
                          width : 330 * (MediaQuery.of(context).size.width / 360),
                          height : 32 * (MediaQuery.of(context).size.height / 360),
                          *//*margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*//*
                          child : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(image: AssetImage("assets/delivery_button_icon.png"), width: 50 * (MediaQuery.of(context).size.width / 360),),
                              Container(
                                  width : 230 * (MediaQuery.of(context).size.width / 360),
                                  child : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("배달", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 * (MediaQuery.of(context).size.width / 360)),),
                                      Text(" 주문하러 ", style: TextStyle(color: Color(0xffE47421),fontWeight: FontWeight.bold, fontSize: 20 * (MediaQuery.of(context).size.width / 360)),),
                                      Text("가기", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20 * (MediaQuery.of(context).size.width / 360)),),
                                    ],
                                  )
                              ),
                              Icon(Icons.arrow_forward, color: Color(0xff151515),)
                            ],
                          )
                      ),
                    )
                )
            ),*/
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 부동산상담신청
                /*if(widget.title_catcode == "C1")
                GestureDetector(
                  onTap: () {
                    if(reg_id != null && reg_id != "") {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return  Counseling_guide(table_nm: "REAL_ESTATE");
                        },
                      ));
                    }

                    if(reg_id == null || reg_id == "") {
                      showModal(context, 'loginalert', '');
                    }
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                    padding: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    child: Container(
                      width: 120 * (MediaQuery.of(context).size.width / 360),
                      height: 14 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/c101_service.png'),
                            fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                    ),
                  ),
                ),*/
                // 서비스가이드
                // if(viewresult['sub_category'] == "C107" || viewresult['sub_category'] == "C108")
                /* GestureDetector(
                  onTap: () {
                    if(reg_id != null && reg_id != "") {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service_guide(table_nm : "ON_SITE");
                        },
                      ));
                    }

                    if(reg_id == null || reg_id == "") {
                      showModal(context, 'loginalert', '');
                    }
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                    padding: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    child: Container(
                      width: 120 * (MediaQuery.of(context).size.width / 360),
                      height: 14 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/living_service01.png'),
                            fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                    ),
                  ),
                ),*/
                // 출장서비스
                if(viewresult['sub_category'] == "C107")
                  GestureDetector(
                    onTap: () {
                      if(reg_id != null && reg_id != "") {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service_guide(table_nm : "ON_SITE");
                          },
                        ));
                      }

                      if(reg_id == null || reg_id == "") {
                        showModal(context, 'loginalert', '');
                      }
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                      padding: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      child: Container(
                        // width: 120 * (MediaQuery.of(context).size.width / 360),
                        // height: 14 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          color: Color(0xff719EF3),
                          borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                        ),
                        child: Container(
                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                              10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 4 * (MediaQuery.of(context).size.width / 360), 0),
                                child: Icon(My_icons.M0107, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  child: Text(
                                    '렌트카 상담신청',
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // 비자서비스
                if(viewresult['sub_category'] == "C108")
                  GestureDetector(
                    onTap: () {
                      if(reg_id != null && reg_id != "") {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service_guide(table_nm : "ON_SITE");
                          },
                        ));
                      }

                      if(reg_id == null || reg_id == "") {
                        showModal(context, 'loginalert', '');
                      }
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                      padding: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff2F67D3),
                          borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                        ),
                        child: Container(
                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                              10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 4 * (MediaQuery.of(context).size.width / 360), 0),
                                child: Icon(My_icons.M0108, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  child: Text(
                                    '비자 상담신청',
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // 정보수정요청
                if(viewresult['sub_category'] != "C107" && viewresult['sub_category'] != "C108")
                  Container(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                  ),
                GestureDetector(
                  onTap: () {
                    if(reg_id != null && reg_id != "") {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ModifyInfomation(article_seq: widget.article_seq,table_nm: widget.table_nm,article_title: apptitle,board_seq: board_seq,);
                        },
                      ));
                    }

                    if(reg_id == null || reg_id == "") {
                      showModal(context, 'loginalert', '');
                    }
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(12 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                    padding: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    child: Container(
                      /* decoration: BoxDecoration(
                        color: Color(0xff2F67D3),
                        borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                      ),*/
                      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 4 * (MediaQuery.of(context).size.width / 360), 0),
                            child: Image(image: AssetImage("assets/viza_icon.png"), width: 7 * (MediaQuery.of(context).size.height / 360),),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                              child: Text(
                                '정보 수정 요청',
                                style: TextStyle(
                                  fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 하단 컨텐츠
          /* Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            *//*margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*//*
            // width: 100 * (MediaQuery.of(context).size.width / 360),
            // height: 100 * (MediaQuery.of(context).size.width / 360),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xffE47421),  width: 5 * (MediaQuery.of(context).size.width / 360),),
                    ),
                  ),
                  child:Container(
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                    child:  Text('${cattitle} 정보',
                      style: TextStyle(
                        fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          /*   Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xffE47421), )
              ),
            ),
          ),*/
        ],
      );
  }


  void _isLiked() {

    setState(() {
      isLiked = !isLiked;
      if(isLiked) {
        likes_yn = 'Y';
        updatelike();
        setState(() {
          viewresult['like_cnt'] = viewresult['like_cnt'] + 1;
        });
      } else{
        likes_yn = 'N';
        updatelike();
        setState(() {
          viewresult['like_cnt'] = viewresult['like_cnt'] - 1;
        });
      }

    });
  }

  AlertDialog likealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "관심등록 성공! 관심내역은 마이페이지에서 확인 가능합니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            getviewdata().then((_){
              setState(() {
              });
            });
          },
        ),
      ],
    );
  }

  AlertDialog unlikealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "관심등록을 취소했습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            getviewdata().then((_){
              setState(() {
              });
            });
          },
        ),
      ],
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

  void _onShare(BuildContext context, text, link) async {
    final box = context.findRenderObject() as RenderBox?;

    // subject is optional but it will be used
    // only when sharing content over email
    await Share.share(text,
        subject: link,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

/*Widget share() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 60 * (MediaQuery.of(context).size.height / 360),
      decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.only(
          *//*topLeft: Radius.circular(20 * (MediaQuery.of(context).size.width / 360)),
          topRight: Radius.circular(20 * (MediaQuery.of(context).size.width / 360)),*//*
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 22 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  alignment: Alignment.center,
                  width: 280 * (MediaQuery.of(context).size.width / 360),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                    child:
                    Text("공유하기",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    icon: Icon(Icons.close,size: 32,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),

                )
              ],
            ),

          ),

          Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              decoration : BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                  )
              )
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 30 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Container(
                    width: 40 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/kakaotalk.png'),
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 40 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/Facebook.png'),
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 40 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Twitter.png'),
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 40 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/Telegram.png'),
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 40 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/linkshare.png'),
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 40 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/otheroption.png'),
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          *//*Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 20 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Text(
                  'Date',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              value: '',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),*//*

        ],
      ),
    );

  }*/


}