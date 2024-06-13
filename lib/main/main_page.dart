import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/categorymenu/providers/living_provider.dart';
import 'package:hoty/common/dataManager.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/icons/my_icons.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/device_id.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/landing/landing.dart';
import 'package:hoty/main/layout/page_subject_button.dart';
import 'package:hoty/main/layout/page_type3.dart';
import 'package:hoty/main/layout/page_type4.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hoty/main/layout/page_type6.dart';


import 'package:hoty/main/main_menu.dart';
import 'package:hoty/main/main_menu_login.dart';
import 'package:hoty/main/main_notification.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';
import 'package:intl/intl.dart';

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../categorymenu/living_list.dart';
import '../common/follow_us.dart';
import '../guide/guide.dart';
import '../intro/Intro.dart';
import '../minigame/mini_game1.dart';
import '../minigame/mini_game2.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../service/service_guide.dart';
import 'layout/page_type1.dart';
import 'layout/page_type2.dart';
import 'layout/page_type5.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool isShow = false;

  bool isFold = false;
  double c_height = 0; // 기종별 height 값

  double _height = 1;
  String likes_yn = '';
  // banner
  final PageController _pageController = PageController();
  int _currentPage = 0;
  var Baseurl = "http://www.hoty.company/mf";
  var Base_Imgurl = "http://www.hoty.company";


  var _selecter = 'B01';
  String memberId = '';

  /* 미니게임api data 변수 초기화 */
  Map<String, dynamic> _data = {};
  String _title = '';
  String _quiz_question = '';
  String _quiz_answer = '';
  String _quiz_hint= '';
  String _qPoint = '';
  String _gameType = '';
  List<String> _rPointList = [];
  List<String> _wordsList = [];
  List<String> _colorList = [];
  String? _game_check;
  String? _group_seq;

  // 메인페이지 배너,섹션1~6
  var reg_id = "";
  var urlpath = 'http://www.hoty.company';
  List<dynamic> getresult = []; // 전체 list
  List<dynamic> bannerlist = []; // 배너데이터
  List<dynamic> section01List = []; // 섹션1
  Map<String,dynamic> section02List = {}; // 섹션2
  Map<String,dynamic> section03List = {}; // 섹션3
  List<dynamic> section04List = []; // 섹션4
  List<dynamic> section05List = []; // 섹션5
  List<dynamic> section06List = []; // 섹션6

  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> cattitle = []; // 카테고리타이틀
  List<dynamic> catname = []; // 세부카테고리

  Map<String, dynamic> exchange_rate = {};

  List<dynamic> popular_categoryList = [];
  List<dynamic> title_catList = []; // 추천 타이틀 카테고리

  dynamic hoty_recommend = {};

  String _notice_yn = '';


  // 메인페이지 배너,섹션1~6
  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      /*'http://192.168.0.13/mf/main/list.do',*/
      'http://www.hoty.company/mf/main/list.do',
      // 'http://www.hoty.company/mf/main/list.do',
    );

    try {
      Map data = {
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
        "interesting" : (await storage.read(key: "memberInteresting")) ?? "",
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


        bannerlist = json.decode(response.body)['popupzone1'];
        if((await storage.read(key:'memberId')) != null && (await storage.read(key:'memberId')) != "") {
          section01List = json.decode(response.body)['section01'];
        }

        section02List = json.decode(response.body)['section02'];
        section03List = json.decode(response.body)['section03'];
        section04List = json.decode(response.body)['section04'];
        section05List = json.decode(response.body)['section05'];
        section06List = json.decode(response.body)['section06'];

        final dataManager = DataManager();
        final loadedData = await dataManager.loadData();
        hoty_recommend = loadedData;
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> getlistdata2() async {

    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
        Baseurl + "/popup/list.do"
    );
    try {
      Map data = {
        "table_nm" : "main"
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        getresult = json.decode(response.body)['result'];
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(getresult);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> getpopularCategoryListdata() async {

    var popular_result = [];

    var url = Uri.parse(
      /*'http://www.hoty.company/mf/common/popular_category.do',*/
      'http://www.hoty.company/mf/common/popular_category.do',
      /*'http://www.hoty.company/mf/main/list.do',*/
      // 'http://192.168.0.109/mf/main/list.do',
    );

    try {
      Map data = {

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

        popular_result = json.decode(response.body)['result'];


      }

      popular_result.forEach((element) {
        if(element['gubun'] == 'P') {
          popular_categoryList.add(element);
        }
        if(element['gubun'] == 'T') {
          title_catList.add(element);
        }
      });
      print('###############################');
      print(popular_categoryList);
    }
    catch(e){
      print(e);
    }
  }

  Widget Recommend = Container();

  Future<dynamic> getExchange_rate() async {
    var url = Uri.parse(
      //'http://www.hoty.company/mf/main/exchange_rate.do',
      'http://www.hoty.company/mf/main/exchange_rate.do',
    );

    try {
      Map data = {
        "reg_id" : reg_id,
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


        exchange_rate = json.decode(response.body);
        print("##############22222##############");
        print(exchange_rate);
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

        // print(result);

/*        cattitle.forEach((element) {
          coderesult.forEach((value) {
            if(value['pidx'] == element['idx']){
              catname.add(value);
            }
          });
          // print(element['idx']);
        });*/

        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> updatelike(int aritcle_seq, String table_nm, apptitle) async {
    String like_status = "";

    Map params = {
      "article_seq" : aritcle_seq,
      "table_nm" : table_nm,
      "title" : apptitle,
      "likes_yn" : likes_yn,
      "reg_id" : reg_id != "" ? reg_id : await getMobileId(),
    };
    like_status = await livingProvider().updatelike(params);
    print(like_status);
    print("222");
  }

  Future<dynamic> UpdateAccessDate() async {
    var url = Uri.parse(
      //'http://www.hoty.company/mf/member/UpdateAccessDate.do',
      'http://www.hoty.company/mf/member/UpdateAccessDate.do',
    );

    try {
      Map data = {
        "member_id" : (await storage.read(key:'memberId')) ?? "",
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


        exchange_rate = json.decode(response.body);
        print("##############22222##############");
        print(exchange_rate);
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> UpdateAttendance() async {
    var url = Uri.parse(
      //'http://www.hoty.company/mf/member/UpdateAttendance.do',
      'http://www.hoty.company/mf/member/UpdateAttendance.do',
    );

    try {
      Map data = {
        "member_id" : (await storage.read(key:'memberId')) ?? "",
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


        exchange_rate = json.decode(response.body);
        print("##############22222##############");
        print(exchange_rate);
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      print("#################### flutter firebase link ####################");
      print(deepLink.path);
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      /*GetX를 사용하므로 path 로 인자값을 묶어서 이동하도록 처리*/
      print("#################### flutter firebase link2 ####################");
      print(dynamicLinkData.link);

      List<dynamic> param = [];
      String table_nm = "";
      String type = "";
      String category = "";
      int article_seq = 0;
      if(dynamicLinkData.link != null) {
        param = dynamicLinkData.link.toString().replaceAll("%3D", "=").split("@@");

        print("외부에서 연결된 링크입니다.");
        print(param);

        for (int i = 0; i < param.length; i++) {
          if(param[i] != null) {
            if (param[i].toString().contains("table_nm")) {
              if(param[i].toString().split("=") != null) {
                table_nm = param[i].toString().split("=")[1];
              }
            }
            if (param[i].toString().contains("type")) {
              type = param[i].toString().split("=")[1];
            }
            if (param[i].toString().contains("main_category")) {
              category = param[i].toString().split("=")[1];
            }
            if (param[i].toString().contains("article_seq")) {
              article_seq = int.parse(param[i].toString().split("=")[1]);
            }
          }
        }
      }

      print(table_nm);
      print(type);
      print(category);
      print(article_seq);


      final Uri deepLink = dynamicLinkData.link;
      print("딥 링크 알아보기");
      print(mounted);
      print(deepLink.queryParameters['category']);
      print(dynamicLinkData.link.path);
      //print("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);

      /*if(mounted) {*/
      if(type == "list") {

        if(table_nm == 'TODAY_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:TodayList(main_catcode: '', table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'HOTY_PICK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:TodayList(main_catcode: '', table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'KIN') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:KinList(success: false, failed: false,main_catcode: '',)
              );
            },
            ));
          });
        } else if (table_nm == 'LIVING_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:LivingList(title_catcode: 'C1',
                      check_sub_catlist: [],
                      check_detail_catlist: [],
                      check_detail_arealist: [])
              );
            },
            ));
          });
        } else if (table_nm == 'ON_SITE') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'AGENCY_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'PERSONAL_LESSON') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:LessonList(checkList: [])
              );
            },
            ));
          });
        } else if (table_nm == 'USED_TRNSC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:TradeList(checkList: [])
              );
            },
            ));
          });
        } else if (table_nm == 'DAILY_TALK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:CommunityDailyTalk(main_catcode: 'F101')
              );
            },
            ));
          });
        }

      } else if(type == "view") {
        if(table_nm == 'TODAY_INFO') {
          String cat_name = '';
          if(category == 'TD_001') {
            cat_name = '공지사항';
          } else if (category == 'TD_002') {
            cat_name = '뉴스';
          } else if (category == 'TD_003') {
            cat_name = '환율';
          } else if (category == 'TD_004') {
            cat_name = '영화';
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:todayView(article_seq: article_seq,
                      title_catcode: category,
                      cat_name: cat_name,
                      table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'HOTY_PICK') {
          String cat_name = '';
          if(category == 'HP_001') {
            cat_name = '오늘뭐먹지?';
          } else if (category == 'HP_002') {
            cat_name = '오늘뭐하지?';
          } else if (category == 'HP_003') {
            cat_name = '호치민 정착가이드';
          }

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:todayView(article_seq: article_seq,
                      title_catcode: category,
                      cat_name: cat_name,
                      table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'KIN') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:KinView(article_seq: article_seq,
                      table_nm: table_nm,
                      adopt_chk: '')
              );
            },
            ));
          });
        } else if (table_nm == 'LIVING_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:LivingView(article_seq: article_seq,
                    table_nm: table_nm,
                    title_catcode: category, params: {},)
              );
            },
            ));
          });
        } else if (table_nm == 'ON_SITE') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'AGENCY_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'PERSONAL_LESSON') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:LessonView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
              );
            },
            ));
          });
        } else if (table_nm == 'USED_TRNSC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:TradeView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
              );
            },
            ));
          });
        } else if (table_nm == 'DAILY_TALK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MaterialApp(
                  theme: ThemeData(
                      scaffoldBackgroundColor: Colors.white,
                      fontFamily: 'NanumSquareR',
                      appBarTheme: AppBarTheme(
                          color: Colors.white
                      )
                  ),
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: child!,
                    );
                  },
                  home:CommunityDailyTalkView(article_seq: article_seq,
                    table_nm: table_nm,
                    main_catcode: category, params: {},)
              );
            },
            ));
          });
        }
      }
      /*}*/


      /* Get.toNamed("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);*/
    }).onError((error) {
      // Handle errors
    });
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

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<String> notificationList = [];
  List<String> getStorageData(String item) {
    final box = GetStorage();
    notificationList = List<String>.from(box.read(item) ?? []);
    return List<String>.from(box.read(item) ?? []);
  }
  void removeStorageData(String item) {
    final box = GetStorage();
    box.remove(item);
  }

  var notification_check_value = "N";
  Future<dynamic> notification_check () async {
    var result = [];

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/notification.do',
    );

    try {
      Map data = {
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
        "table_nm" : '',
        "main_category" : '',
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        result = json.decode(response.body)['result'];
        setState(() {
          getStorageData("notification");
        });

        var notification = [];


        for(int i = 0; i < notificationList.length; i++) {
          if(notification.length == 0) {
            notification.add(notificationList[i]);
          }
          for(int j = 0; j < notification.length; j++) {
            if(!notification.contains(notificationList[i])) {
              notification.add(notificationList[i]);
            }
          }
        }
        setState(() {
          if(result.length == notification.length) {
            notification_check_value = "N";
          } else if(result.length > notification.length) {
            notification_check_value = "Y";
          }
        });

      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    userInfo();
    notification_check();
    getlistdata().then((_){
      setState(() {
      });// getExchange_rate();
      setState(() async {
        if (hoty_recommend["hoty_recommend"] == null &&
            (await storage.read(key: 'memberId')) != null &&
            (await storage.read(key: 'memberId')) != "" &&
            (await storage.read(key: "memberInteresting")) != null &&
            (await storage.read(key: "memberInteresting")) != "") {
          if (section01List != null && section01List.length > 0) {
            Recommend = getSection01(context);
            setState(() {

            });
          }
        }
        _getMinigame().then((value) => _loadStoredValue());
      });
    });
    initDynamicLinks();
    UpdateAccessDate();
    UpdateAttendance();
    getcodedata().then((_) {
      getpopularCategoryListdata().then((_) {
        setState(() {

        });
      });
      // Recommend = getSection01(context);
    });
    getlistdata2().then((value)  {
      setState(() {
      });
    });

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < bannerlist.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );

    });
/*    _getMinigame().then((value) {
      _loadStoredValue().then((value) {
        setState(() {
        });
      });

    });*/


  }

  var _show_cnt = 0;

  Future<void> _loadStoredValue() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    /* 미니게임 api 가져와서 담아주기 */
    await _prefs.setString("_title", _title);
    await _prefs.setString("_quiz_question", _quiz_question);
    await _prefs.setString("_quiz_answer", _quiz_answer);
    await _prefs.setString("_quiz_hint", _quiz_hint);
    await _prefs.setString("_qPoint", _qPoint);
    await _prefs.setStringList("_rPointList", _rPointList);
    await _prefs.setStringList("_wordsList", _wordsList);
    await _prefs.setStringList("_colorList", _colorList);

    setState(() {
      /*   Future.delayed(Duration.zero, () {
        if(_gameType == 'Q'){ //퀴즈게임일떄
          _show_cnt ++;
          showMiniGame2(context, _show_cnt);
        }else{
          _show_cnt ++;
          showMiniGame1(context, _show_cnt);
        }
      });*/
      memberId = _prefs.getString('memberId') ?? 'noData';
      if (_group_seq != "8" && _group_seq != "3" && _group_seq != null && _game_check == 'N' && (reg_id != '' && reg_id != null)) { // 당일게임체크여부 및 로그인여부
        Future.delayed(Duration.zero, () {
          if(_gameType == 'Q'){ //퀴즈게임일떄
            showMiniGame2(context, _show_cnt);
          }else{
            showMiniGame1(context, _show_cnt);
          }
        });
      }
      for(var i = 0 ; i < getresult.length; i++) {
        print(getresult[i]["popupzone_seq"]);
        print('!@#');
        if (_prefs.getString("notice_yn_${getresult[i]["popupzone_seq"]}") != 'N') {
          _show_cnt ++;
          _noticeModal(context, getresult[i], i);
          // isShow = false;
        }

        /*        if(i+1 == getresult.length) {
            if (_prefs.getString("notice_yn_${getresult[i]["popupzone_seq"]}") != 'N') {
              // isShow = true;// 다시보지 않기 상태일때
              _noticeModal(context, getresult[i], i);
            } else {
              // isShow = false;
            }
          } else {
            if (_prefs.getString("notice_yn_${getresult[i]["popupzone_seq"]}") != 'N') {
              _noticeModal(context, getresult[i], i);
              // isShow = false;
            }

          }*/
      }
    });
    //await _prefs.clear();  //SharedPreferences 초기화
  }

  /* 미니게임 정보 api */
  Future<void> _getMinigame() async {
    //final url = Uri.parse('http://10.0.2.2:8080/mf/minigame/mini_game.do');
    final url = Uri.parse('http://www.hoty.company/mf/minigame/mini_game.do');
    Map<String, dynamic> data = {
      "member_id": reg_id,
    };
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) { //성공했을때
        Map<String, dynamic> responseData = json.decode(response.body);
        _data = responseData['result']['view'];
        _title = _data['title'];
        _gameType = _data['game_type'];
        _game_check = _data['game_check'];
        if(_gameType == 'R'){
          _rPointList = (_data['r_point'] as String).split(',');
          _wordsList = (_data['words'] as String).split(',');
          _colorList = (_data['color'] as String).split(',');
        }else{
          _qPoint = _data['q_point'];
          _quiz_question = _data['quiz_question'];
          _quiz_answer = _data['quiz_answer'];
          _quiz_hint = _data['quiz_hint'];
        }
        // print(_data);
      } else {
        // print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> userInfo() async{
    final url = Uri.parse('http://www.hoty.company/mf/member/userInfo.do');
    print('###닉네임 수정#####');
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    try {
      Map data = {
        "member_id" : reg_id,
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String group_seq = responseData['result']['GROUP_SEQ'].toString();
        print('###닉네임 수정#####');
        print(group_seq);
        _group_seq = group_seq;
        if(group_seq == "3"){
          await storage.delete(key: "memberId");
          fail_dialog("블랙회원입니다.\n관리자에게 문의해주세요.");
        }else if(group_seq == "8"){
          await storage.delete(key: "memberId");
          fail_dialog("탈퇴하신 회원입니다.");
        } else {
          print("###닉네임 수정완료##### : ${responseData['result']}");
          await storage.write(key: "memberNick", value: responseData['result']['NICKNAME']);
          setState(() {

          });
        }
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void fail_dialog(String msg){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: textalert(context, "닫기"),
        );
      },
    );
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    if (currentBackPressTime == null ||
        currentTime.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    final dataManager = DataManager();
    await dataManager.deleteData();
    SystemNavigator.pop();
    return true;


  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    isFold = pageWidth > 480 ? true : false;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double m_width = (MediaQuery.of(context).size.width/360);
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;


    if(aspectRatio > 0.55) {
      if(isFold == true) {
        // c_height = m_height * (m_width * aspectRatio);
        c_height = m_height * (m_width * aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight( 30 * (MediaQuery.of(context).size.height / 360)),
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 30 * (MediaQuery.of(context).size.height / 360),
                leading: IconButton(icon: Icon(Icons.menu_rounded),color: Colors.black,alignment: Alignment.centerLeft,
                  iconSize: 14 * (MediaQuery.of(context).size.height / 360),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MainMenuLogin();
                      },
                    )); //테스트
                    // showMiniGame2(context);
                  },
                ),

                actions: [
                  IconButton(icon: Image(image: AssetImage("${notification_check_value == 'Y' ? 'assets/notification_on.png' : 'assets/notification_off.png'}"),width: 25 * (MediaQuery.of(context).size.width / 360),),
                    color: Colors.black,
                    alignment: Alignment.centerRight,
                    iconSize: 14 * (MediaQuery.of(context).size.height / 360),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          // return Intro();
                          // return Guide();
                          return MainNotification();
                        },
                      ));
                    },
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: true,
                title: Container(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 2 * (MediaQuery.of(context).size.height / 360),),
                    width: 90 * (MediaQuery.of(context).size.width / 360),
                    height: 30 * (MediaQuery.of(context).size.height / 360),
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                ),
                centerTitle: true,
              ),
            ],
          )
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SingleChildScrollView(
          child: Container(
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
            child: Column(
              children: [
                // 가로세로 비율
                /*Container(
                  width:    360 * (MediaQuery.of(context).size.width / 360) ,
                  height:    120 * (MediaQuery.of(context).size.height / 360),
                  child: Column(
                    children: [
                      Text('size.width : ${MediaQuery.of(context).size.width}',style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                      Text('size.height : ${MediaQuery.of(context).size.height}',style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                      Text('size.width/360 : ${MediaQuery.of(context).size.width/360}',style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                      Text('size.height/360 : ${MediaQuery.of(context).size.height/360}',style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                      Text('size : ${MediaQuery.of(context).size}',style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                      Text('c_height : ${c_height}',style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                      Text('가로세로 비율 : ${(MediaQuery.of(context).size.aspectRatio)}',
                        style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        // overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),),
                    ],
                  ),
                ),*/

                /*Container(
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child: Row(
                    // Vietnam VND
                    children: [
                      // 베트남 국기
                      Container(
                        width: 35 * (MediaQuery.of(context).size.width / 360),
                        child: Image(image: AssetImage('assets/vietnam_mark.png')),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.height / 360), 0,3 * (MediaQuery.of(context).size.height / 360),0),
                        child: Text(
                          "베트남",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff151515),
                            // overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                      Container(
                        height: 14 * (MediaQuery.of(context).size.width / 360),
                        child: DottedLine(
                          lineThickness:1,
                          dashLength: 1,
                          dashColor: Color(0xffC4CCD0),
                          direction: Axis.vertical,
                        ),
                      ),
                      if(exchange_rate["type"] == "up")
                        Container(
                          width: 25 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 0,0,0),
                          child: Icon(Icons.trending_up, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff27AE60),),
                        ),
                      if(exchange_rate["type"] == "down")
                        Container(
                          width: 25 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 0,0,0),
                          child: Icon(Icons.trending_down, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE31D1C),),
                        ),
                      Container(
                        margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.height / 360), 0,0,0),
                        child: Text(
                          "VND",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xffC4CCD0),
                            fontFamily: 'NanumSquareEB',
                            // overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                      if(exchange_rate["vnd"] != null)
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0,0,0),
                          child: Text(
                            "${exchange_rate["vnd"]}",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              // overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        )
                    ],
                  ),
                ),*/
                // Vietnam VND 요소 끝

                // getmainbanner(context),
            if(bannerlist.length > 0)
             Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: 90 * c_height,
                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: bannerlist2(context),
              ), // 슬라이드배너
                // if(isFold == false)
                //bannerlist3(context),
                // if(isFold == true)
                //   bannerlist3_fold(context),
                // getLivingCat(context),
                getTitleMenu(context),
                // 1.Recommendation for you

                // getSection01(context),
                Recommend,
                Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                // 2.popular category
                if(popular_categoryList != null && popular_categoryList.length > 0)
                  getSection02(context),
                Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                // 3.Ask Me Anything
                getSection03(context),
                Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                // 4.Ask Me Anything Latest
                getSection04(context),
                Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                // 5.Second-hand
                getSection05(context),
                Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                // 6.Private Tutoring
                getSection06(context),
                Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                // follow_un
                Follow_us(),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    40 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Theme(
        data: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'NanumSquareR',
          appBarTheme: AppBarTheme(
              color: Colors.white
          ),
        ),
        child: Footer(nowPage: 'Main_page',),

      ),

    );
  }

  Column bannerlist2(context){

    return Column(
      children: [
        Expanded(
          // flex: 1,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  if(bannerlist.length > 0)
                    for(var i=0; i<bannerlist.length; i++)
                      buildBanner('${bannerlist[i]['title']}', i,'${bannerlist[i]['file_path']}'),
                ],
              ),
              /*Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(bannerlist.length > 0)
                        for(var i=0; i<bannerlist.length; i++)
                          Container(
                            margin: EdgeInsets.all(3.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == i
                                  ? Colors.grey
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ],

    );
  }
  Widget buildBanner(String text, int index, file_path) {
    return GestureDetector(
        onTap: () {
          var title_living = ['M01','M02','M03','M04','M05'];

          if(bannerlist[index]["landing_target"] == "N") {
            if(bannerlist[index]["link_yn"] == "Y") {
              if(bannerlist[index]["type"] == "list") {

                // 박정범
                if(title_living.contains(bannerlist[index]["table_nm"])){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LivingList(title_catcode: bannerlist[index]["main_category"],
                        check_sub_catlist: [],
                        check_detail_catlist: [],
                        check_detail_arealist: []);
                  },
                  ));
                }
                if(bannerlist[index]["table_nm"] == 'M06'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Service_guide(table_nm : bannerlist[index]["main_category"]);
                    },
                  ));
                }
                if(bannerlist[index]["table_nm"] == 'M07'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      if(bannerlist[index]["main_category"] == 'USED_TRNSC') {
                        return TradeList(checkList: [],);
                      } else if(bannerlist[index]["main_category"] == 'PERSONAL_LESSON'){
                        return LessonList(checkList: [],);
                      } else {
                        return CommunityDailyTalk(main_catcode: bannerlist[index]["main_category"]);
                      }
                    },
                  ));
                }
                if(bannerlist[index]["table_nm"] == 'M08'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TodayList(main_catcode: '',table_nm : bannerlist[index]["main_category"]);
                    },
                  ));
                }
                // 지식인
                if(bannerlist[index]["table_nm"] == 'M09'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return KinList(success: false, failed: false,main_catcode: '',);
                    },
                  ));
                }


              } else if(bannerlist[index]["type"] == "view") {
                if(title_living.contains(bannerlist[index]["table_nm"])){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LivingView(article_seq: bannerlist[index]["article_seq"], table_nm: bannerlist[index]["table_nm"], title_catcode: bannerlist[index]["main_category"], params: {});
                  },
                  ));
                }
                if(bannerlist[index]["table_nm"] == 'M06'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Service_guide(table_nm : bannerlist[index]["main_category"]);
                    },
                  ));
                }
                if(bannerlist[index]["table_nm"] == 'M07'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      if(bannerlist[index]["main_category"] == 'USED_TRNSC') {
                        return TradeView(article_seq: bannerlist[index]["article_seq"], table_nm: bannerlist[index]["table_nm"], params: {}, checkList: []);
                      } else if(bannerlist[index]["main_category"] == 'PERSONAL_LESSON'){
                        return LessonView(article_seq: bannerlist[index]["article_seq"], table_nm: bannerlist[index]["table_nm"], params: {}, checkList: []);
                      } else {
                        return CommunityDailyTalkView(article_seq: bannerlist[index]["article_seq"], table_nm: bannerlist[index]["table_nm"], main_catcode: bannerlist[index]["main_category"], params: {});
                      }
                    },
                  ));
                }
                if(bannerlist[index]["table_nm"] == 'M08'){

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return todayView(article_seq: bannerlist[index]["article_seq"], title_catcode: bannerlist[index]["main_category"], cat_name: '', table_nm: bannerlist[index]["table_nm"]);
                    },
                  ));
                }
                // 지식인
                if(bannerlist[index]["table_nm"] == 'M09'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return KinView(article_seq: bannerlist[index]["article_seq"], table_nm: bannerlist[index]["table_nm"], adopt_chk: '');
                    },
                  ));
                }
              }
            }
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Landing();
            },
            ));
          }
        },
      child : Container(
        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정합니다.
          // color: Colors.blueGrey,
          image: DecorationImage(
              image: CachedNetworkImageProvider('$Base_Imgurl$file_path'),
              // image: NetworkImage(''),
              fit: BoxFit.cover
          ),
        ),
        // child: Center(child: Text(text)), // 타이틀글 사용시 주석해제
      )
    );
  }

  Container bannerlist3 (context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 90 * c_height,
      margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(bannerlist.length > 0)
              for(var i=0; i<bannerlist.length; i++)
                GestureDetector(
                  onTap: () {
                    var title_living = ['M01','M02','M03','M04','M05'];

                    if(bannerlist[i]["landing_target"] == "N") {
                      if(bannerlist[i]["link_yn"] == "Y") {
                        if(bannerlist[i]["type"] == "list") {

                          // 박정범
                          if(title_living.contains(bannerlist[i]["table_nm"])){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LivingList(title_catcode: bannerlist[i]["main_category"],
                                  check_sub_catlist: [],
                                  check_detail_catlist: [],
                                  check_detail_arealist: []);
                            },
                            ));
                          }
                          if(bannerlist[i]["table_nm"] == 'M06'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Service_guide(table_nm : bannerlist[i]["main_category"]);
                              },
                            ));
                          }
                          if(bannerlist[i]["table_nm"] == 'M07'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                if(bannerlist[i]["main_category"] == 'USED_TRNSC') {
                                  return TradeList(checkList: [],);
                                } else if(bannerlist[i]["main_category"] == 'PERSONAL_LESSON'){
                                  return LessonList(checkList: [],);
                                } else {
                                  return CommunityDailyTalk(main_catcode: bannerlist[i]["main_category"]);
                                }
                              },
                            ));
                          }
                          if(bannerlist[i]["table_nm"] == 'M08'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TodayList(main_catcode: '',table_nm : bannerlist[i]["main_category"]);
                              },
                            ));
                          }
                          // 지식인
                          if(bannerlist[i]["table_nm"] == 'M09'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return KinList(success: false, failed: false,main_catcode: '',);
                              },
                            ));
                          }


                        } else if(bannerlist[i]["type"] == "view") {
                          if(title_living.contains(bannerlist[i]["table_nm"])){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LivingView(article_seq: bannerlist[i]["article_seq"], table_nm: bannerlist[i]["table_nm"], title_catcode: bannerlist[i]["main_category"], params: {});
                            },
                            ));
                          }
                          if(bannerlist[i]["table_nm"] == 'M06'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Service_guide(table_nm : bannerlist[i]["main_category"]);
                              },
                            ));
                          }
                          if(bannerlist[i]["table_nm"] == 'M07'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                if(bannerlist[i]["main_category"] == 'USED_TRNSC') {
                                  return TradeView(article_seq: bannerlist[i]["article_seq"], table_nm: bannerlist[i]["table_nm"], params: {}, checkList: []);
                                } else if(bannerlist[i]["main_category"] == 'PERSONAL_LESSON'){
                                  return LessonView(article_seq: bannerlist[i]["article_seq"], table_nm: bannerlist[i]["table_nm"], params: {}, checkList: []);
                                } else {
                                  return CommunityDailyTalkView(article_seq: bannerlist[i]["article_seq"], table_nm: bannerlist[i]["table_nm"], main_catcode: bannerlist[i]["main_category"], params: {});
                                }
                              },
                            ));
                          }
                          if(bannerlist[i]["table_nm"] == 'M08'){

                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return todayView(article_seq: bannerlist[i]["article_seq"], title_catcode: bannerlist[i]["main_category"], cat_name: '', table_nm: bannerlist[i]["table_nm"]);
                              },
                            ));
                          }
                          // 지식인
                          if(bannerlist[i]["table_nm"] == 'M09'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return KinView(article_seq: bannerlist[i]["article_seq"], table_nm: bannerlist[i]["table_nm"], adopt_chk: '');
                              },
                            ));
                          }
                        }
                      }
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Landing();
                      },
                      ));
                    }
                  },
                  child : Container(
                    width: 335 * (MediaQuery.of(context).size.width / 360),
                    height: 90 * c_height,
                    // color: Colors.red,
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider('$Base_Imgurl${bannerlist[i]['file_path']}'),
                        fit: BoxFit.cover,
                        // colorFilter: ColorFilter.mode(Colors.red, BlendMode.color),
                      ),
                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    ),
                  ),
                )
          ],
        ),

      ),
    );
  }

  Container bannerlist3_fold (context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 90 * (MediaQuery.of(context).size.height / 360) * ((MediaQuery.of(context).size.width/360) * MediaQuery.of(context).size.aspectRatio),
      margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(bannerlist.length > 0)
              for(var i=0; i<bannerlist.length; i++)
                Container(
                  width: 335 * (MediaQuery.of(context).size.width / 360),
                  height: 90 * (MediaQuery.of(context).size.height / 360) * ((MediaQuery.of(context).size.width/360) * MediaQuery.of(context).size.aspectRatio),
                  // color: Colors.red,
                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider('$Base_Imgurl${bannerlist[i]['file_path']}'),
                      // fit: BoxFit.fill,
                      fit: BoxFit.cover,
                      // colorFilter: ColorFilter.mode(Colors.red, BlendMode.color),
                    ),
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                  ),
                ),
          ],
        ),

      ),
    );
  }


  Container getmainbanner(BuildContext context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: 100 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360)),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/banner_main01.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xffE47421), BlendMode.color),
        ),
        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
            // Learn More Start
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 190 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
                    child: Column(
                      children: [
                        Text(
                          "Life begins in HCMC with",
                          style: TextStyle(
                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "HOTY. Join to access all",
                          style: TextStyle(
                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "the information.",
                          style: TextStyle(
                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFBCD58),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 23 * (MediaQuery.of(context).size.width / 360), vertical: 6 * (MediaQuery.of(context).size.height / 360)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                      )
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Text('Learn More', style: TextStyle(fontSize: 18, color: Colors.white),),
                ),
              ],
              // Learn More END
            ),
          ),
          Container(
            width: 90 * (MediaQuery.of(context).size.width / 360),
            height: 90 * (MediaQuery.of(context).size.height / 360),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/hotyphone01.png'),
              ),
              // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
            ),
          ),
        ],
      ),
    );
  }

  Container getTitleMenu(BuildContext context) {
    var title_living = ['M01','M02','M03','M04','M05'];

    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 28 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for(int m2=0; m2<title_catList.length; m2++)
              Container(
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                child: Row(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB( 0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                        padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 0 * (MediaQuery.of(context).size.width / 360), 0),
                        height: 18 * c_height,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(120),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x14545B5F),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                padding: EdgeInsets.all(1.0), // 여백 설정
                              ),
                              onPressed: () {
                                // Navigator.pop(context);
                                if(title_living.contains(title_catList[m2]['table_nm'])){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: getTitlecode('${title_catList[m2]['table_nm']}','cidx'), check_sub_catlist: [getTitlecode('${title_catList[m2]['main_category']}','cidx')],
                                        check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                }
                                if(title_catList[m2]['table_nm'] == 'M06'){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Service_guide(table_nm : getTitlecode('${title_catList[m2]['main_category']}','cidx'));
                                    },
                                  ));
                                }
                                if(title_catList[m2]['table_nm'] == 'M07'){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      if(title_catList[m2]['main_category'] == 'M0701') {
                                        return TradeList(checkList: [],);
                                      } else if(title_catList[m2]['main_category'] == 'M0702'){
                                        return LessonList(checkList: [],);
                                      } else {
                                        return CommunityDailyTalk(main_catcode: getTitlecode('${title_catList[m2]['main_category']}','cidx'));
                                      }
                                    },
                                  ));
                                }
                                if(title_catList[m2]['table_nm'] == 'M08'){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return TodayList(main_catcode: '',table_nm : getTitlecode('${title_catList[m2]['main_category']}','cidx'));
                                    },
                                  ));
                                }
                                if(title_catList[m2]['table_nm'] == 'M10'){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return KinList(success: false, failed: false,main_catcode: '',);
                                    },
                                  ));
                                }
                              },
                              child: Row(
                                // padding: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0,3 * (MediaQuery.of(context).size.width / 360), 0),
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,
                                        0 * (MediaQuery.of(context).size.width / 360), 0),
                                    // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                    child:getSubIcons('${title_catList[m2]['main_category']}',context),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB( 0 * (MediaQuery.of(context).size.width / 360), 0,
                                        5 * (MediaQuery.of(context).size.width / 360), 0),
                                    padding: EdgeInsets.fromLTRB( 4 * (MediaQuery.of(context).size.width / 360), 0,
                                        4 * (MediaQuery.of(context).size.width / 360), 0),
                                    child: Text(
                                      getTitlecode('${title_catList[m2]['main_category']}','name'),
                                      style: TextStyle(
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff151515),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }

  // 코드아이콘
  Container getSubIcons(idx, BuildContext context) {
    var catcolor = Color(0xffE47421);
    var caticon = My_icons.M0101;
    // print(idx);
    if(idx != null) {
      // 생활정보
      if(idx == 'M0101'){
        caticon = My_icons.M0101;
        catcolor = Color(0xffE47421);
      }
      if(idx == 'M0102'){
        caticon = My_icons.M0102;
        catcolor = Color(0xff1C52DD);
      }
      if(idx == 'M0103'){
        caticon = My_icons.M0103;
        catcolor = Color(0xffFFC2C2);
      }
      if(idx == 'M0104'){
        caticon = My_icons.M0104;
        catcolor = Color(0xff0F8F78);
      }
      if(idx == 'M0105'){
        caticon = My_icons.M0105;
        catcolor = Color(0xffFBCD58);
      }
      if(idx == 'M0106'){
        caticon = My_icons.M0106;
        catcolor = Color(0xffC7A276);
      }
      if(idx == 'M0107'){
        caticon = My_icons.M0107;
        catcolor = Color(0xff719EF3);
      }
      if(idx == 'M0108'){
        caticon = My_icons.M0108;
        catcolor = Color(0xff2F67D3);
      }
      // 음식점
      if(idx == 'M0201'){
        caticon = My_icons.M0201;
        catcolor = Color(0xff925330);
      }
      if(idx == 'M0202'){
        caticon = My_icons.M0202;
        catcolor = Color(0xffEB5757);
      }
      if(idx == 'M0203'){
        caticon = My_icons.M0203;
        catcolor = Color(0xffB22222);
      }
      if(idx == 'M0204'){
        caticon = My_icons.M0204;
        catcolor = Color(0xff9B51E0);
      }
      // 취미
      if(idx == 'M0301'){
        caticon = My_icons.M0301;
        catcolor = Color(0xff85AEE3);
      }
      if(idx == 'M0302'){
        caticon = My_icons.M0302;
        catcolor = Color(0xffEB5757);
      }
      if(idx == 'M0303'){
        caticon = My_icons.M0303;
        catcolor = Color(0xff15B797);
      }
      if(idx == 'M0304'){
        caticon = My_icons.M0304;
        catcolor = Color(0xffBBC964);
      }
      // 의료
      if(idx == 'M0401'){
        caticon = My_icons.M0401;
        catcolor = Color(0xffFBCD58);
      }
      if(idx == 'M0402'){
        caticon = My_icons.M0402;
        catcolor = Color(0xff2D9CDB);
      }
      if(idx == 'M0403'){
        caticon = My_icons.M0403;
        catcolor = Color(0xffDE8F8F);
      }
      if(idx == 'M0404'){
        caticon = My_icons.M0404;
        catcolor = Color(0xff0F8F78).withOpacity(0.75);
      }
      // 교육
      if(idx == 'M0501'){
        caticon = My_icons.M0501;
        catcolor = Color(0xffDABE87);
      }
      if(idx == 'M0502'){
        caticon = My_icons.M0502;
        catcolor = Color(0xffD6AEE9);
      }
      // 서비스
      if(idx == 'M0601'){
        caticon = My_icons.M0601;
        catcolor = Color(0xff2F67D3);
      }
      if(idx == 'M0602'){
        caticon = My_icons.M0602;
        catcolor = Color(0xffFFC2C2);
      }
      if(idx == 'M0603'){
        caticon = My_icons.M0603;
        catcolor = Color(0xff925330);
      }
      // 커뮤니티
      if(idx == 'M0701'){
        caticon = My_icons.M0701;
        catcolor = Color(0xff53B5BB);
      }
      if(idx == 'M0702'){
        caticon = My_icons.M0702;
        catcolor = Color(0xff27AE60);
      }
      if(idx == 'M0703'){
        caticon = My_icons.M0703;
        catcolor = Color(0xffFBCD58);
      }
      if(idx == 'M0704'){
        caticon = My_icons.M0704;
        catcolor = Color(0xffBBC964);
      }
      if(idx == 'M0705'){
        caticon = My_icons.M0705;
        catcolor = Color(0xffE47421);
      }
      if(idx == 'M0706'){
        caticon = My_icons.M0706;
        catcolor = Color(0xff9B51E0);
      }
      // 호티의추천
      if(idx == 'M0801'){
        caticon = My_icons.M0801;
        catcolor = Color(0xff2F67D3);
      }
      if(idx == 'M0802'){
        caticon = My_icons.M0802;
        catcolor = Color(0xff2F67D3);
      }

      if(idx == "M1001") {
        caticon = My_icons.M1001;
        catcolor = Color(0xff3290FF);
      }


    }
    // 아이콘 세팅
    Icon subicon = Icon(caticon, size: 10 * c_height,  color: catcolor,);
    Image subimage = Image(image: AssetImage('assets/today_menu01_1.png'), height: 10 * (MediaQuery.of(context).size.height / 360),);

    var gubun = ['M0801','M0802','M0203'];
    // 아이콘미사용
    if(idx != null) {
      if(idx == 'M0203') {
        subimage = Image(image: AssetImage('assets/M0203.png'), height: 10 * c_height);
      }
      if(idx == 'M0801') {
        subimage = Image(image: AssetImage('assets/M0801.png'), height: 10 * c_height);
      }
      if(idx == 'M0802') {
        subimage = Image(image: AssetImage('assets/M0802.png'), height: 10 * c_height);
      }
    }

    return Container(
      child: subicon,
    );
  }
  // 코드네임
  String getTitlecode(idx,type) {
    var title_code = '';

    if(type == 'name'){
      coderesult.forEach((value) {
        if(value['idx'] == idx) {
          title_code = value['name'];
        }
      });
    } else{
      coderesult.forEach((value) {
        if(value['idx'] == idx) {
          title_code = value['cidx'];

        }
      });
    }

    return title_code;
  }

  Container getLivingCat(BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 28 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for(int m2=0; m2<coderesult.length; m2++)
              if(coderesult[m2]['pidx'] == 'C1')
                Container(
                  margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                  child: Row(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                          padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 0 * (MediaQuery.of(context).size.width / 360), 0),
                          height: 18 * (MediaQuery.of(context).size.height / 360),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(120),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x14545B5F),
                                blurRadius: 4,
                                offset: Offset(2, 2),
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(coderesult[m2]['idx'] == 'C101')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child:Icon(My_icons.apart, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE47421),),
                                ),
                              if(coderesult[m2]['idx'] == 'C102')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.school, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                                ),
                              if(coderesult[m2]['idx'] == 'C103')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child:Icon(My_icons.academy, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFC2C2),),
                                ),
                              if(coderesult[m2]['idx'] == 'C104')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.healty, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFBCD58),),
                                ),
                              if(coderesult[m2]['idx'] == 'C105')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.lifeshopping, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff925331),),
                                ),
                              if(coderesult[m2]['idx'] == 'C106')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.restaurant, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff729EF3),),
                                ),
                              if(coderesult[m2]['idx'] == 'C107')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.game, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                ),
                              if(coderesult[m2]['idx'] == 'C108')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.rantalcar, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff9B51E0),),
                                ),
                              if(coderesult[m2]['idx'] == 'C109')
                                Container(
                                  padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0,0, 0),
                                  // child: Image(image : AssetImage("assets/apart_icon.png"),width: 24 * (MediaQuery.of(context).size.width / 360),),
                                  child: Icon(My_icons.licensing, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                                ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  padding: EdgeInsets.all(1.1), // 여백 설정
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: '${coderesult[m2]['idx']}', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0,3 * (MediaQuery.of(context).size.width / 360), 0),
                                  child: Text(
                                    "${coderesult[m2]['name']}",
                                    style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff151515),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),

            /*        Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0 , 2), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 110 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child:
                              // Icon(Icons.apartment, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE47421),),
                              Image(image : AssetImage("assets/apart_icon.png"),width: 20 * (MediaQuery.of(context).size.width / 360),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Apartment",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff151515),
                                      //fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 100 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(Icons.book, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C102', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "School",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff151515),
                                      fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 110 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:Icon(Icons.school, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFC2C2),),

                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C103', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Academy",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 100 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(Icons.medical_services, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFBCD58),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C104', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Healthy",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(Icons.shopping_bag, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff925331),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C105', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Life/Shooping",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 110 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(Icons.restaurant, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff729EF3),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C106', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Restaurant",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff151515),
                                      fontFamily: 'NanumSquareR',
                                      //fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 100 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Icon(Icons.videogame_asset_rounded, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C107', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Leisure",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 110 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:  Icon(Icons.car_crash, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff9B51E0),),
                            ),

                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C108', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Rental Car",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        width: 100 * (MediaQuery.of(context).size.width / 360),
                        height: 21 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:  Icon(Icons.check_circle, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingList(title_catcode: 'C109', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                    },
                                  ));
                                },
                                child: Container(
                                  child: Text(
                                    "Licensing",
                                    style: TextStyle(
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareR'
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),*/
          ],
        ),
      ),
    );
  }

  //수정
  Container getSection01_1(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360),
                0, 3 * (MediaQuery.of(context).size.height / 360)),
            child: MainPage_Subject_Button(subtitle: 'Recommendation for you',urlbutton:'TodayList'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Row(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 285 * (MediaQuery.of(context).size.width / 360),
                  height: 145 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 260 * (MediaQuery.of(context).size.width / 360),
                                    height: 100 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_01.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                0 , 0 ),
                                            decoration: BoxDecoration(
                                              // color: Color(0xff27AE60),
                                              color: Color(0xffEB5757),
                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text('Daily',
                                                    style: TextStyle(
                                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                        Container(
                                            margin : EdgeInsets.fromLTRB(0, 4 * (MediaQuery.of(context).size.height / 360),
                                                7 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                )
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 255 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                child: Text(
                                  "I offer private English tutoring",
                                  style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NanumSquareEB'
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(0,  7 * (MediaQuery.of(context).size.height / 360), 0,  5 * (MediaQuery.of(context).size.height / 360)),
                              width: 257 * (MediaQuery.of(context).size.width / 360),
                              // alignment: Alignment(-1.0, -1.0),
                              child:Row(
                                children: [
                                  Icon(Icons.favorite, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 4 * (MediaQuery.of(context).size.width / 360), 0),
                                    child: Text(
                                      "12k",
                                      style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR'
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10 * (MediaQuery.of(context).size.width / 360),
                                    child: DottedLine(
                                      lineThickness:1,
                                      dashLength: 1.5,
                                      dashColor: Color(0xffC4CCD0),
                                      direction: Axis.vertical,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                    child: Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                    child: Text(
                                      "35",
                                      style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR'
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    // alignment: Alignment(1.0, -1.0),
                                    padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                    width: 165 * (MediaQuery.of(context).size.width / 360),
                                    child: Text(
                                      "2023/06/20 00:00",
                                      style: TextStyle(
                                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xffC4CCD0),
                                        fontFamily: 'NanumSquareR',
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  )
                                ],
                              ) ,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 285 * (MediaQuery.of(context).size.width / 360),
                  height: 145 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 260 * (MediaQuery.of(context).size.width / 360),
                                    height: 100 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_01.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                0 , 0 ),
                                            decoration: BoxDecoration(
                                              // color: Color(0xff27AE60),
                                              color: Color(0xffEB5757),
                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text('Daily',
                                                    style: TextStyle(
                                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                        Container(
                                            margin : EdgeInsets.fromLTRB(0, 4 * (MediaQuery.of(context).size.height / 360),
                                                7 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                )
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 255 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                child: Text(
                                  "I offer private English tutoring",
                                  style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NanumSquareEB'
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(0,  7 * (MediaQuery.of(context).size.height / 360), 0,  5 * (MediaQuery.of(context).size.height / 360)),
                              width: 257 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child:Row(
                                children: [
                                  Icon(Icons.favorite, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 4 * (MediaQuery.of(context).size.width / 360), 0),
                                    child: Text(
                                      "12k",
                                      style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR'
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10 * (MediaQuery.of(context).size.width / 360),
                                    child: DottedLine(
                                      lineThickness:1,
                                      dashLength: 1,
                                      dashColor: Color(0xffC4CCD0),
                                      direction: Axis.vertical,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                    child: Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                    child: Text(
                                      "35",
                                      style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR'
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                    width: 165 * (MediaQuery.of(context).size.width / 360),
                                    child: Text(
                                      "2023/06/20 00:00",
                                      style: TextStyle(
                                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xffC4CCD0),
                                        fontFamily: 'NanumSquareR',
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  )
                                ],
                              ) ,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 285 * (MediaQuery.of(context).size.width / 360),
                  height: 145 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 260 * (MediaQuery.of(context).size.width / 360),
                                    height: 100 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_02.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 65 * (MediaQuery.of(context).size.width / 360),
                                            alignment: Alignment(0.0, -1.0),
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                10 * (MediaQuery.of(context).size.width / 360) , 3 * (MediaQuery.of(context).size.height / 360),),
                                              decoration: BoxDecoration(
                                                color: Color(0xffEB5757),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child: Text('Dailly',
                                                style: TextStyle(
                                                  fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                  color: Colors.white,
                                                  // fontFamily: 'NanumSquareB'
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                        ),
                                        Container(
                                            width: 195 * (MediaQuery.of(context).size.width / 360),
                                            alignment: Alignment(1.0, -1.0),
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                              2 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Container(
                                              child:
                                              Container(
                                                  width: 21 * (MediaQuery.of(context).size.width / 360),
                                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                      5 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 12 , ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 255 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                child: Text(
                                  "I offer private English tutoring",
                                  style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NanumSquareEB'
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(0,  7 * (MediaQuery.of(context).size.height / 360), 0,  5 * (MediaQuery.of(context).size.height / 360)),
                              width: 257 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child:Row(
                                children: [
                                  Icon(Icons.favorite, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 4 * (MediaQuery.of(context).size.width / 360), 0),
                                    child: Text(
                                      "12k",
                                      style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR'
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10 * (MediaQuery.of(context).size.width / 360),
                                    child: DottedLine(
                                      lineThickness:1,
                                      dashLength: 1,
                                      dashColor: Color(0xffC4CCD0),
                                      direction: Axis.vertical,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                    child: Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                    child: Text(
                                      "35",
                                      style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR'
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment(1.0, -1.0),
                                    padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                    width: 165 * (MediaQuery.of(context).size.width / 360),
                                    child: Text(
                                      "2023/06/20 00:00",
                                      style: TextStyle(
                                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xffC4CCD0),
                                        fontFamily: 'NanumSquareR',
                                        // fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  )
                                ],
                              ) ,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

  //기존section01 사용
  Container getSection01(BuildContext context) {
    return Container(
      height: 160 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 22 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  /*decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xffE47421),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),*/
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      children: [
                        Container(
                          height: 25 * (MediaQuery.of(context).size.width / 360),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                          child: Text("회원님을 위한 호티의 추천",
                            style: TextStyle(
                              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                              fontWeight: FontWeight.w800,
                              fontFamily: 'NanumSquareEB',
                            ),
                          ),
                        ),

                      ],
                    )
                ),
                /*   Container(
             *//*       margin : EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),*//*
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),color: Color(0xffC4CCD0),
                      iconSize: 12 * (MediaQuery.of(context).size.height / 360),
                      onPressed: () async {
                        final dataManager = DataManager();
                        final dataToSave = {'hoty_recommend': 'N'};
                        dataManager.saveData(dataToSave);
                        final loadedData = await dataManager.loadData();
                        hoty_recommend = loadedData;
                        Recommend = Container();
                        setState(() {
                          Recommend = Container();
                        });
                      },
                    ),
                  ),*/
                GestureDetector(
                    onTap: () async {
                      final dataManager = DataManager();
                      final dataToSave = {'hoty_recommend': 'N'};
                      dataManager.saveData(dataToSave);
                      final loadedData = await dataManager.loadData();
                      hoty_recommend = loadedData;
                      Recommend = Container();
                      setState(() {
                        Recommend = Container();
                      });
                    },
                    child : Icon(Icons.close_rounded, color: Color(0xffC4CCD0), size: 12 * (MediaQuery.of(context).size.height / 360),)
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Container(
              height: 130 * (MediaQuery.of(context).size.height / 360),
              child:MainPage_Type1(section01List: section01List , coderesult : coderesult),
            ),
          )
        ],
      ),
    );
  }

  Container getSection02(BuildContext context) {
    return Container(
      height: 110 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 6 * (MediaQuery.of(context).size.height / 360),
                0, 2 * (MediaQuery.of(context).size.height / 360)),
            child: MainPage_Subject_Button(subtitle: '인기카테고리',urlbutton:''),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 75 * (MediaQuery.of(context).size.height / 360),
              child: MainPage_Type2(popular_categoryList,coderesult,context),
            ),
            /*child:
            Row(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 140 * (MediaQuery.of(context).size.width / 360),
                  height: 95 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 120 * (MediaQuery.of(context).size.width / 360),
                                    height: 65 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_cat01.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360),
                                    0, 2 * (MediaQuery.of(context).size.height / 360)),
                                child: Text(
                                  "Living Q&A",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    color: Color(0xff151515),
                                    // fontFamily: 'NanumSquareB',
                                    overflow: TextOverflow.ellipsis,
                                    //fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 2

                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 140 * (MediaQuery.of(context).size.width / 360),
                  height: 95 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 120 * (MediaQuery.of(context).size.width / 360),
                                    height: 65 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_cat02.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360),
                                    0, 2 * (MediaQuery.of(context).size.height / 360)),
                                child: Text(
                                  "Apartment Amenitles",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    color: Color(0xff151515),
                                    // fontFamily: 'NanumSquareB',
                                    overflow: TextOverflow.ellipsis,
                                    //fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.center,
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
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 140 * (MediaQuery.of(context).size.width / 360),
                  height: 95 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 120 * (MediaQuery.of(context).size.width / 360),
                                    height: 65 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_cat03.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360),
                                    0, 2 * (MediaQuery.of(context).size.height / 360)),
                                child: Text(
                                  "Golf Course",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    color: Color(0xff151515),
                                    // fontFamily: 'NanumSquareB',
                                    overflow: TextOverflow.ellipsis,
                                    //fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.center,
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
            ),*/
          )
        ],
      ),
    );
  }

  Container getSection03(BuildContext context) {
    var table_nm = 'KIN';


    List<dynamic> getsection03List = [];
    if(section03List.length > 0) {
      getsection03List.addAll(section03List[_selecter]);
    }


    return Container(
      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 6 * (MediaQuery.of(context).size.height / 360),
                0, 2 * (MediaQuery.of(context).size.height / 360)),
            child: MainPage_Subject_Button(subtitle: '지식 in HOTY',urlbutton:'KinList'),
          ),
          Container(
            height: 20 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                0, 0 * (MediaQuery.of(context).size.height / 360)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if(coderesult.length > 0)
                    for(var m=0; m<coderesult.length; m++)
                      if(coderesult[m]['pidx'] == table_nm && coderesult[m]['idx'] != 'B06')
                        Container(
                          // margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: GestureDetector(
                            onTap: (){
                              _selecter = coderesult[m]['idx'];
                              getsection03List.clear();
                              getsection03List.addAll(section03List[_selecter]);
                              setState(() {
                                print(_selecter);

                              });
                            },
                            child: Column(
                              children: [
                                if(coderesult[m]['idx'] == _selecter)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0xffE47421),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 2 * (MediaQuery.of(context).size.height / 360)),
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 5),
                                      child: Text(
                                        "${coderesult[m]['name']}",
                                        style: TextStyle(
                                          color: Color(0xffE47421),
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                if(coderesult[m]['idx'] != _selecter)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 2 * (MediaQuery.of(context).size.height / 360)),
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 5),
                                      child: Text(
                                        "${coderesult[m]['name']}",
                                        style: TextStyle(
                                          color: Color(0xff151515),
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.w700,
                                        ),
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
          ),
          MainPage_Type3( getsection03List,coderesult, context),
        ],
      ),
    );
  }

  Container getSection04(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 6 * (MediaQuery.of(context).size.height / 360),
                0, 2 * (MediaQuery.of(context).size.height / 360)),
            child: MainPage_Subject_Button(subtitle: '지식 in 최신글',urlbutton:'KinList2'),
          ),
          MainPage_Type4( section04List, context),
        ],
      ),
    );
  }


  // 기존 section05 사용
  Container getSection05(context) {
    return Container(
      child: Column(
          children: [
            Container(
              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                  10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
              child: MainPage_Subject_Button(subtitle: '중고거래',urlbutton:'TradeList'),
            ),
            Container(
              margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
              child: Column(
                children: [
                  Container(
                    child: Wrap(
                      children: [
                        // 1cow
                        if(section05List.length > 0)
                          for(var i=0; i<section05List.length; i++)
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return TradeView(article_seq : section05List[i]['article_seq'], table_nm : section05List[i]['table_nm'], params: {},checkList: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 125 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                // padding: EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                          topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                          bottomLeft: Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                          bottomRight: Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1.0,
                                            blurRadius: 2,
                                            offset: Offset(0, 1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                                      // color: Colors.white,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 165 * (MediaQuery.of(context).size.width / 360),
                                            height: 80 * (MediaQuery.of(context).size.height / 360),
                                            decoration:
                                            BoxDecoration(
                                              image: section05List[i]['main_img'] != '' &&  section05List[i]['main_img']!= null ? DecorationImage(
                                                  colorFilter: ColorFilter.mode(
                                                    Color(0xFF151515).withOpacity(0.7),
                                                    section05List[i]['cat02'] == 'D202' || section05List[i]['cat02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                                  ),
                                                  image: CachedNetworkImageProvider('$urlpath${section05List[i]['main_img_path']}${section05List[i]['main_img']}'),
                                                  fit: BoxFit.cover
                                              ) : DecorationImage(
                                                  colorFilter: ColorFilter.mode(
                                                    Color(0xFF151515).withOpacity(0.7),
                                                    section05List[i]['cat02'] == 'D202' || section05List[i]['cat02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                                  ),
                                                  image: AssetImage('assets/noimage.png'),
                                                  fit: BoxFit.cover
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                                topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                            ),

                                            // color: Colors.amberAccent,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if(section05List[i]['cat02'] != 'D202' && section05List[i]['cat02'] != 'D204')
                                                  Container(
                                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                          0 , 0 ),

                                                      decoration: BoxDecoration(
                                                        color :
                                                        section05List[i]['cat02'] == 'D201' ? Color(0xff53B5BB) :
                                                        section05List[i]['cat02'] == 'D202' ? Color(0xff925331) :
                                                        section05List[i]['cat02'] == 'D203' ? Color(0xffA6BB53) :
                                                        Color(0xffCA3625) ,
                                                        borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                                                      ),
                                                      child:Row(
                                                        children: [
                                                          Container(
                                                            padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                              8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                            child: Text(
                                                              getSubcodename(section05List[i]['cat02']),
                                                              style: TextStyle(
                                                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                                color: Colors.white,
                                                                fontFamily: 'NanumSquareB',
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                if(section05List[i]['cat02'] != 'D202' && section05List[i]['cat02'] != 'D204')
                                                  if(section05List[i]['like_yn'] != null && section05List[i]['like_yn'] > 0)
                                                    GestureDetector(
                                                      onTap : () {
                                                        _isLiked_05(true, section05List[i]["article_seq"], "USED_TRNSC", section05List[i]["title"], i);
                                                      },
                                                      child : Container(
                                                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                              3 * (MediaQuery.of(context).size.height / 360), 0 ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:Row(
                                                            children: [
                                                              Container(
                                                                padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                                  4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                                child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                if(section05List[i]['cat02'] != 'D202' && section05List[i]['cat02'] != 'D204')
                                                  if(section05List[i]['like_yn'] == null || section05List[i]['like_yn'] == 0)
                                                    GestureDetector(
                                                      onTap : () {
                                                        _isLiked_05(false, section05List[i]["article_seq"], "USED_TRNSC", section05List[i]["title"], i);
                                                      },
                                                      child : Container(
                                                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                              3 * (MediaQuery.of(context).size.height / 360), 0 ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:Row(
                                                            children: [
                                                              Container(
                                                                padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                                  4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                                child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                if(section05List[i]['cat02'] == 'D202' || section05List[i]['cat02'] == 'D204')
                                                  Center(
                                                      child : Container(
                                                        margin : EdgeInsets.fromLTRB(55 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                        padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 12 * (MediaQuery.of(context).size.height / 360),
                                                            10 * (MediaQuery.of(context).size.width / 360), 12 * (MediaQuery.of(context).size.height / 360)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            border: Border.all(width : 1 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                        ),
                                                        child: Text(getSubcodename(section05List[i]['cat02']), style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w800, fontSize: 11 * (MediaQuery.of(context).size.width / 360)),),
                                                      )
                                                  ),
                                              ],
                                            ),
                                          ),
                                          // 하단 정보
                                          Container(
                                            width: 155 * (MediaQuery.of(context).size.width / 360),
                                            // height: 30 * (MediaQuery.of(context).size.height / 360),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360),  2 * (MediaQuery.of(context).size.height / 360), 0, 2 * (MediaQuery.of(context).size.height / 360)),
                                                  alignment: Alignment.bottomLeft,
                                                  width: 170 * (MediaQuery.of(context).size.width / 360),
                                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                                  child: Text(
                                                    getVND("${section05List[i]['etc01']}"),
                                                    style: TextStyle(
                                                        fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                                        color: Color(0xff151515),
                                                        fontFamily: 'NanumSquareEB',
                                                        fontWeight: FontWeight.w800
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Container(
                                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                  width: 160 * (MediaQuery.of(context).size.width / 360),
                                                  child: Text(
                                                    "${section05List[i]['title']}",
                                                    style: TextStyle(
                                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                      color: Color(0xff4E4E4E),
                                                      fontFamily: 'NanumSquareR',
                                                      fontWeight: FontWeight.w400,
                                                      overflow: TextOverflow.ellipsis,
                                                      height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
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
                              ),
                            ),





                      ],
                    ),
                  ),
                  Container(
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    // height: 30 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 8 * (MediaQuery.of(context).size.height / 360)),
                    child: Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                              side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TradeList(checkList: [],);
                              },
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360)),
                                // alignment: Alignment.center,
                                // width: 50 * (MediaQuery.of(context).size.width / 360),
                                child: Text('더보기', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3),fontWeight: FontWeight.bold,),
                                ),
                              ),
                              Icon(My_icons.rightarrow, size: 12 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // more
                ],
              ),

            )
          ]
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
  // 수정 section06
  Container getSection06_1(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360),
                0, 7 * (MediaQuery.of(context).size.height / 360)),
            child: MainPage_Subject_Button(subtitle: '개인 과외',urlbutton:'LessonList'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:
            Row(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 260 * (MediaQuery.of(context).size.width / 360),
                  height: 145 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 0.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 240 * (MediaQuery.of(context).size.width / 360),
                                    height: 100 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_private01.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 130 * (MediaQuery.of(context).size.width / 360),
                                            alignment: Alignment(0.0, -1.0),
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                              decoration: BoxDecoration(
                                                color: Color(0xff27AE60),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child: Text('Language Tutoring',
                                                style: TextStyle(
                                                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                  color: Colors.white,
                                                  fontFamily: 'NanumSquareB',
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                        ),
                                        Container(
                                            width: 110 * (MediaQuery.of(context).size.width / 360),
                                            alignment: Alignment(1.0, -1.0),
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                              2 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Container(
                                              child:
                                              Container(
                                                  width: 21 * (MediaQuery.of(context).size.width / 360),
                                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                      5 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 , ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 240 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                child: Text(
                                  "I offer private English tutoring",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    color: Color(0xff151515),
                                    fontFamily: 'NanumSquareEB',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(0,  7 * (MediaQuery.of(context).size.height / 360), 0,  5 * (MediaQuery.of(context).size.height / 360)),
                              width: 240 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Text(
                                "50,000 VND",
                                style: TextStyle(
                                  fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                  // color: Colors.white,
                                  color: Color(0xff151515),
                                  // fontFamily: 'NanumSquareB',
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                ), textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                  width: 260 * (MediaQuery.of(context).size.width / 360),
                  height: 145 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0,
                            5 * (MediaQuery.of(context).size.height / 360), 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 240 * (MediaQuery.of(context).size.width / 360),
                                    height: 100 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                        0,  5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/main_private02.png'),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 130 * (MediaQuery.of(context).size.width / 360),
                                            alignment: Alignment(0.0, -1.0),
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                              decoration: BoxDecoration(
                                                color: Color(0xff27AE60),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child: Text('Exercise Lesson',
                                                style: TextStyle(
                                                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                  color: Colors.white,
                                                  // fontFamily: 'NanumSquareB',
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                        ),
                                        Container(
                                            width: 110 * (MediaQuery.of(context).size.width / 360),
                                            alignment: Alignment(1.0, -1.0),
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                              2 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Container(
                                              child:
                                              Container(
                                                  width: 21 * (MediaQuery.of(context).size.width / 360),
                                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                      5 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 , ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 240 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Container(
                                child: Text(
                                  "Tennis lessons",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    color: Color(0xff151515),
                                    // fontFamily: 'NanumSquareB',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ), textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(0,  7 * (MediaQuery.of(context).size.height / 360), 0,  5 * (MediaQuery.of(context).size.height / 360)),
                              width: 240 * (MediaQuery.of(context).size.width / 360),
                              alignment: Alignment(-1.0, -1.0),
                              child: Text(
                                "1 Person",
                                style: TextStyle(
                                  fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                  // color: Colors.white,
                                  color: Color(0xff151515),
                                  // fontFamily: 'NanumSquareB',
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                ), textAlign: TextAlign.left,
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
          ),
        ],
      ),
    );
  }

  // 기존 section06 사용
  Container getSection06(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                10, 0 * (MediaQuery.of(context).size.height / 360)),
            child: MainPage_Subject_Button(subtitle: '개인과외',urlbutton:'LessonList'),
          ),
          Container(
            height: 140 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(section06List.length, (index) =>
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return LessonView(article_seq : section06List[index]['article_seq'], table_nm : section06List[index]['table_nm'], params: {},checkList: [],);
                            },
                          ));
                        },
                        child: Container(
                          width: 290 * (MediaQuery.of(context).size.width / 360),
                          height: 125 * (MediaQuery.of(context).size.height / 360),
                          margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          // padding: EdgeInsets.fromLTRB(20,30,10,15),
                          // color: Colors.black,
                          child: Column(
                            children: [
                              Container(
                                width: 270 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                decoration:
                                BoxDecoration(
                                  image: section06List[index]['main_img'] != '' &&  section06List[index]['main_img']!= null ? DecorationImage(
                                      image: CachedNetworkImageProvider('$urlpath${section06List[index]['main_img_path']}${section06List[index]['main_img']}'),
                                      fit: BoxFit.cover
                                  ) : DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                                // color: Colors.amberAccent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            0 , 0 ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff27AE60),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child:Row(
                                          children: [
                                            for(var c=0; c<coderesult.length; c++)
                                              if(coderesult[c]['idx'] == section06List[index]['main_category'])
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text('${coderesult[c]['name']}',
                                                    style: TextStyle(
                                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      fontFamily: 'NanumSquareB',
                                                      // fontWeight: FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                          ],
                                        )
                                    ),
                                    if(section06List[index]['like_yn'] != null && section06List[index]['like_yn'] > 0)
                                      GestureDetector(
                                        onTap : () {
                                          _isLiked_06(true, section06List[index]["article_seq"], "PERSONAL_LESSON", section06List[index]["title"], index);
                                        },
                                        child : Container(
                                            margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                5 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                )
                                              ],
                                            )
                                        ),
                                      ),
                                    if(section06List[index]['like_yn'] == null || section06List[index]['like_yn'] == 0)
                                      GestureDetector(
                                        onTap : () {
                                          _isLiked_06(false, section06List[index]["article_seq"], "PERSONAL_LESSON", section06List[index]["title"], index);
                                        },
                                        child : Container(
                                            margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                5 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                )
                                              ],
                                            )
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // 하단 정보
                              Container(
                                width: 280 * (MediaQuery.of(context).size.width / 360),
                                // height: 30 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.height / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 280 * (MediaQuery.of(context).size.width / 360),
                                      // height: 20 * (MediaQuery.of(context).size.height / 360),
                                      child: Text(
                                        "${section06List[index]['title']}",
                                        style: TextStyle(
                                          fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                          // color: Colors.white,
                                          fontFamily: 'NanumSquareEB',
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w800,
                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: 280 * (MediaQuery.of(context).size.width / 360),
                                      // height: 10 * (MediaQuery.of(context).size.height / 360),
                                      margin : EdgeInsets.fromLTRB( 0, 5  * (MediaQuery.of(context).size.height / 360),
                                          0, 0),
                                      child: Text(
                                        getVND("${section06List[index]['etc01']}"),
                                        style: TextStyle(
                                          fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                          // color: Colors.white,
                                          fontFamily: 'NanumSquareEB',
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w800,
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
                      )
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  Container aboutus(BuildContext context) {
    return Container(
        width: 350 * (MediaQuery.of(context).size.width / 360),
        height: 120 * (MediaQuery.of(context).size.height / 360),
        child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : [
              Container(
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 0),
                height: 30 * (MediaQuery.of(context).size.height / 360),
                child :
                Text ("Follow us", style : TextStyle(
                  fontSize : 20 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.bold,
                ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  height: 30 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0),
                  child : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children : [
                        Container(
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                          child : Image(image: AssetImage('assets/Instagram.png'), width: (40 * (MediaQuery.of(context).size.width / 360))),
                        ),
                        Container(
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                          child :  Image(image: AssetImage('assets/youtube.png'), width: (40 * (MediaQuery.of(context).size.width / 360))),
                        ),
                        Container(
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                          child : Image(image: AssetImage('assets/kakaotalk.png'), width: (40 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ]
                  )
              ),
              Container(
                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 0),
                height: 20 * (MediaQuery.of(context).size.height / 360),
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                child :
                Text ("About HOTY", style : TextStyle(
                  fontSize : 15 * (MediaQuery.of(context).size.width / 360),
                ),
                ),
              ),
              Container(
                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 0),
                height: 20 * (MediaQuery.of(context).size.height / 360),
                child :
                Text ("© 2024 HOTY All rights reserved.", style : TextStyle(
                  fontSize : 15 * (MediaQuery.of(context).size.width / 360),
                ),
                ),
              ),
            ]
        )
    );
  }

  String getVND(pay) {
    String payment = "";

    if(pay != null && pay != ''){
      var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
      getpay.format(int.parse(pay));
      payment = getpay.format(int.parse(pay)) + " VND";
    }

    return payment;
  }

  void _isLiked_05(like_yn, article_seq, table_nm, apptitle, index) {

    setState(() {
      like_yn = !like_yn;
      if(like_yn) {
        likes_yn = 'Y';
        updatelike( article_seq, table_nm, apptitle);
        section05List[index]['like_yn'] = 1;
        setState(() {

        });
      } else{
        likes_yn = 'N';
        updatelike( article_seq, table_nm, apptitle);
        section05List[index]['like_yn'] = 0;
        setState(() {

        });
      }

    });
  }

  void _isLiked_06(like_yn, article_seq, table_nm, apptitle, index) {

    setState(() {
      like_yn = !like_yn;
      if(like_yn) {
        likes_yn = 'Y';
        updatelike( article_seq, table_nm, apptitle);
        section06List[index]['like_yn'] = 1;
        setState(() {

        });
      } else{
        likes_yn = 'N';
        updatelike( article_seq, table_nm, apptitle);
        section06List[index]['like_yn'] = 0;
        setState(() {

        });
      }

    });
  }

  // 공지모달
  void _noticeModal(context, getresult, index){

    showDialog(
      context: context,
      barrierColor: _show_cnt == 1 ? Color(0xffE47421).withOpacity(0.4) : Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding: EdgeInsets.fromLTRB(10, 20,
                10  , 20 ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            elevation: 0,
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Container(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close_rounded , size: 30,),
                  ),
                ),
              ],
            ),
            titlePadding: EdgeInsets.fromLTRB(
              0 * (MediaQuery.of(context).size.width / 360),
              10,
              10,
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            content: Container(
              // width: 330 * (MediaQuery.of(context).size.width / 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child : Text(
                      "${getresult["title"]}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 300,
                    // height: 30 * (MediaQuery.of(context).size.height / 360),
                    child : Text(
                      "${getresult["alt"]}",
                      style: TextStyle(
                        fontSize: 13 ,
                        height: 1.6,
                      ),
                      maxLines: 3,
                      // textAlign: TextAlign.start,
                    ),
                  ),

                  Container(
                    width: 300,
                    height: 240,
                    margin: EdgeInsets.fromLTRB(
                      0 ,
                      0,
                      0,
                      0,
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider('http://www.hoty.company${getresult["file_path"]}'),
                            fit: BoxFit.contain
                        )
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: (){
                          Navigator.of(context).pop(true);
                        },
                        child: Center(
                          child: Text(
                            "이벤트 참여111",
                            style: TextStyle(
                              fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(20 , 0,
                      20, 20 ),
                  child : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xffFFFFFF),
                            // padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)
                            ),
                            side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                            elevation: 0
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          padding: EdgeInsets.symmetric(horizontal: 0 , vertical: 10 ),
                          child : Text("다시보지 않기",
                            style: TextStyle(
                                color: Color(0xffE47421),
                                fontFamily: "NanumSquareR",
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                        onPressed: () {
                          isShow = false;
                          Navigator.pop(context, false);

                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xffE47421),
                            // padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)
                            ),
                            side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                            elevation: 0
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: 130,
                          padding: EdgeInsets.symmetric(horizontal: 0 , vertical: 10 ),
                          child : Text("이벤트 참여하기",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontFamily: "NanumSquareR",
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                        onPressed: () {
                          isShow = false;
                          Navigator.pop(context, true);
                          // Navigator.of(context, rootNavigator: true).pop();
                        },
                      )
                    ],
                  )
              )
            ],
          ),
        );
      },
    ).then((value) {
      if(value == true) {
        /*Navigator.pop(context, true);*/
        if(getresult["link_yn"] == "Y") {
          if(getresult["type"] == "list") {
            if(getresult["table_nm"] == 'TODAY_INFO') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TodayList(main_catcode: '', table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'HOTY_PICK') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TodayAdvicelist();
                },
              ));
            } else if (getresult["table_nm"] == 'KIN') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return KinList(success: false, failed: false,main_catcode: '',);
                },
              ));
            } else if (getresult["table_nm"] == 'LIVING_INFO') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LivingList(title_catcode: 'C1',check_sub_catlist: [],check_detail_catlist: [],check_detail_arealist: []);
                },
              ));
            } else if (getresult["table_nm"] == 'ON_SITE') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Service(table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'INTRP_SRVC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Service(table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'REAL_ESTATE_INTRP_SRVC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Service(table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'AGENCY_SRVC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Service(table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'PERSONAL_LESSON') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LessonList(checkList: []);
                },
              ));
            } else if (getresult["table_nm"] == 'USED_TRNSC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TradeList(checkList: []);
                },
              ));
            } else if (getresult["table_nm"] == 'DAILY_TALK') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CommunityDailyTalk(main_catcode: 'F101');
                },
              ));
            }

          } else if(getresult["type"] == "view") {
            if(getresult["table_nm"] == 'TODAY_INFO') {
              String cat_name = '';
              if(getresult["main_category"] == 'TD_001') {
                cat_name = '공지사항';
              } else if (getresult["main_category"] == 'TD_002') {
                cat_name = '뉴스';
              } else if (getresult["main_category"] == 'TD_003') {
                cat_name = '환율';
              } else if (getresult["main_category"] == 'TD_004') {
                cat_name = '영화';
              }
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return todayView(article_seq: getresult["article_seq"],title_catcode: getresult["main_category"],cat_name: cat_name,table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'HOTY_PICK') {
              String cat_name = '';
              if(getresult["main_category"] == 'HP_001') {
                cat_name = '오늘뭐먹지?';
              } else if (getresult["main_category"] == 'HP_002') {
                cat_name = '오늘뭐하지?';
              } else if (getresult["main_category"] == 'HP_003') {
                cat_name = '호치민 정착가이드';
              }
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return todayView(article_seq: getresult["article_seq"],title_catcode: getresult["main_category"],cat_name: cat_name,table_nm: getresult["table_nm"]);
                },
              ));
            } else if (getresult["table_nm"] == 'KIN') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return KinView(article_seq: getresult["article_seq"],table_nm: getresult["table_nm"],adopt_chk: '');
                },
              ));
            } else if (getresult["table_nm"] == 'LIVING_INFO') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LivingView(article_seq: getresult["article_seq"],table_nm: getresult["table_nm"],title_catcode: getresult["main_category"], params: {},);
                },
              ));
            } else if (getresult["table_nm"] == 'ON_SITE') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfileServiceHistoryDetail(idx: getresult["article_seq"]);
                },
              ));
            } else if (getresult["table_nm"] == 'INTRP_SRVC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfileServiceHistoryDetail(idx: getresult["article_seq"]);
                },
              ));
            } else if (getresult["table_nm"] == 'REAL_ESTATE_INTRP_SRVC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfileServiceHistoryDetail(idx: getresult["article_seq"]);
                },
              ));
            } else if (getresult["table_nm"] == 'AGENCY_SRVC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfileServiceHistoryDetail(idx: getresult["article_seq"]);
                },
              ));
            } else if (getresult["table_nm"] == 'PERSONAL_LESSON') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LessonView(article_seq: getresult["article_seq"], table_nm: getresult["table_nm"], params: {},checkList: [],);
                },
              ));
            } else if (getresult["table_nm"] == 'USED_TRNSC') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TradeView(article_seq: getresult["article_seq"], table_nm: getresult["table_nm"], params: {}, checkList: [],);
                },
              ));
            } else if (getresult["table_nm"] == 'DAILY_TALK') {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CommunityDailyTalkView(article_seq: getresult["article_seq"],table_nm: getresult["table_nm"],main_catcode: getresult["main_category"], params: {},);
                },
              ));
            }
          }
        }
      }
      if(value == false){
        _noticeCancle(getresult["popupzone_seq"]);
      }
    });
  }


/* 공지 다시보지 않기 여부 */
  void _noticeCancle(seq) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("notice_yn_${seq}", 'N');
  }
}