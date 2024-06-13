import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/common/NoNotification.dart';
import 'package:hoty/common/Nodata.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_app_push.dart';
import 'package:hoty/profile/profile_main.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/search/search_list.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../common/dialog/loginAlert.dart';
import '../common/dialog/showDialog_modal.dart';
import '../login/login.dart';


class MainNotification extends StatefulWidget {
  @override
  State<MainNotification> createState() => _MainNotificationState();
}

class _MainNotificationState extends State<MainNotification> {

  List<dynamic> result = []; // 전체 리스트
  List<String> notificationList = [];
  var reg_id = "";
  Widget _Nodata = Container();

  var title_menu_cat = '';

  void saveStorageData(List<String> items, String item) {
    final box = GetStorage();
    box.write(item, items);
  }

  List<String> getStorageData(String item) {
    final box = GetStorage();
    notificationList = List<String>.from(box.read(item) ?? []);
    return List<String>.from(box.read(item) ?? []);
  }

  void removeStorageData(String item) {
    final box = GetStorage();
    box.remove(item);
  }

  Future<dynamic> getlistdata() async {

    var main_category = '';

    if(title_menu_cat == '') {
      if(title_menu_cat == 'TODAY_INFO_TD_001') {
        main_category = 'TD_001';
      }
    }

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/notification.do',
    );

    print('###### ${title_menu_cat}');
    try {
      Map data = {
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
        "table_nm" : title_menu_cat == '' ? '' : title_menu_cat == 'TODAY_INFO_TD_001' ? "TODAY_INFO" : title_menu_cat,
        "main_category" : main_category,
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
        var resultstatus = json.decode(response.body)['resultstatus'];

        result = json.decode(response.body)['result'];
      }
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

  @override
  void initState() {
    super.initState();
    _asyncMethod();
      getlistdata().then((_) {
        _Nodata = NoNotification();
        setState(() {
          if(reg_id == null || reg_id == "") {
            Future.delayed(Duration.zero, () {
              showModal(context, 'loginalert', '');
              showDialog(
                context: context,
                barrierColor: Color(0xffE47421).withOpacity(0.4),
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: loginalert(context, 'loginalert'),
                  );
                },
              ).then((value) {
                if(value == true) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Login(subtitle: '');
                    },
                  ));
                }
              });

            });
          }
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 27 * (MediaQuery.of(context).size.width / 360),

        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 25,
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
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
        title:  Text(
          "알림",
          style: TextStyle(
            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
            color: Color(0xff151515),
            fontFamily: 'NanumSquareEB',
            fontWeight: FontWeight.bold,
            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
          ),
        ),
        actions: [
          GestureDetector(
            onTap : () {
              showModalBottomSheet(
                context: context,
                clipBehavior: Clip.hardEdge,
                barrierColor: Color(0xffE47421).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25))),
                builder: (BuildContext context) {
                  return setting();
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage("assets/setting.png"),color: Color(0xffC4CCD0), width: 20 * (MediaQuery.of(context).size.width / 360),),
                Text("  설정",
                    style: TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      color: Color(0xff151515),
                      //fontFamily: 'NanumSquareEB',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                Container(
                  width: 15 * (MediaQuery.of(context).size.width / 360),
                )
              ],
            ),
          )
        ],
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container( //상단메뉴 ,카테고리
                width: 340 * (MediaQuery.of(context).size.width / 360),
                height: 85 * (MediaQuery.of(context).size.height / 360),
                margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                child: Column(
                  children: [
                    Container( //배너 이미지
                      width: 340 * (MediaQuery.of(context).size.width / 360),
                      height: 85 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/notification_banner_01.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 220 * (MediaQuery.of(context).size.width / 360),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: 210 * (MediaQuery.of(context).size.width / 360),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(0, 15 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      color: Colors.white,
                                      fontFamily: 'NanumSquareEB',
                                      // fontWeight: FontWeight.bold,
                                       height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 80 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/hotyphone01.png'),
                                fit: BoxFit.cover,
                              ),
                              // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              category(context),
              Container( // 게시판
                width: 340 * (MediaQuery.of(context).size.width / 360),
                // height: 200 * (MediaQuery.of(context).size.height / 360),
                child: Column(
                  children: [
                    // col1
                    if(result.length <= 0)
                      _Nodata,
                    if(result.length > 0)
                    list(context),


                    // col2

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  40 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
              ),
            ]
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: ''),
    );
  }

  Container list(BuildContext context) {
    return Container(
      child : Column(
        children: [
          for(int i = 0; i < result.length; i++)
          Container(
              child : Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      print("클릭!");
                      print(result);
                      getStorageData("notification");
                      notificationList.add("${result[i]["seq"]}");
                      saveStorageData(notificationList, "notification");
                      setState(() {
                      });

                      if(result[i]["del_yn"] == "N") {
                        if(result[i]["type"] == "list") {

                          if(result[i]["table_nm"] == 'TODAY_INFO') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TodayList(main_catcode: '', table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'HOTY_PICK') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TodayAdvicelist();
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'KIN') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return KinList(success: false, failed: false,main_catcode: '',);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'LIVING_INFO') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LivingList(title_catcode: 'C1',
                                  check_sub_catlist: [],
                                  check_detail_catlist: [],
                                  check_detail_arealist: []);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'ON_SITE') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Service(table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'INTRP_SRVC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Service(table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'REAL_ESTATE_INTRP_SRVC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Service(table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'AGENCY_SRVC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return Service(table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'PERSONAL_LESSON') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LessonList(checkList: []);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'USED_TRNSC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TradeList(checkList: []);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'DAILY_TALK') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CommunityDailyTalk(main_catcode: 'F101');
                            },
                            ));
                          }

                        } else if(result[i]["type"] == "view") {
                          if(result[i]["table_nm"] == 'TODAY_INFO') {
                            String cat_name = '';
                            if(result[i]["main_category"] == 'TD_001') {
                              cat_name = '공지사항';
                            } else if (result[i]["main_category"] == 'TD_002') {
                              cat_name = '뉴스';
                            } else if (result[i]["main_category"] == 'TD_003') {
                              cat_name = '환율';
                            } else if (result[i]["main_category"] == 'TD_004') {
                              cat_name = '영화';
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return todayView(article_seq: result[i]["article_seq"],
                                  title_catcode: result[i]["main_category"],
                                  cat_name: cat_name,
                                  table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'HOTY_PICK') {
                            String cat_name = '';
                            if(result[i]["main_category"] == 'HP_001') {
                              cat_name = '오늘뭐먹지?';
                            } else if (result[i]["main_category"] == 'HP_002') {
                              cat_name = '오늘뭐하지?';
                            } else if (result[i]["main_category"] == 'HP_003') {
                              cat_name = '호치민 정착가이드';
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return todayView(article_seq: result[i]["article_seq"],
                                  title_catcode: result[i]["main_category"],
                                  cat_name: cat_name,
                                  table_nm: result[i]["table_nm"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'KIN') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return KinView(article_seq: result[i]["article_seq"],
                                  table_nm: result[i]["table_nm"],
                                  adopt_chk: '');
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'LIVING_INFO') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LivingView(article_seq: result[i]["article_seq"],
                                table_nm: result[i]["table_nm"],
                                title_catcode: result[i]["main_category"], params: {},);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'ON_SITE') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProfileServiceHistoryDetail(idx: result[i]["article_seq"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'INTRP_SRVC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProfileServiceHistoryDetail(idx: result[i]["article_seq"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'REAL_ESTATE_INTRP_SRVC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProfileServiceHistoryDetail(idx: result[i]["article_seq"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'AGENCY_SRVC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ProfileServiceHistoryDetail(idx: result[i]["article_seq"]);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'PERSONAL_LESSON') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return LessonView(article_seq: result[i]["article_seq"], table_nm: result[i]["table_nm"], params: {},checkList: [],);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'USED_TRNSC') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return TradeView(article_seq: result[i]["article_seq"], table_nm: result[i]["table_nm"], params: {}, checkList: [],);
                            },
                            ));
                          } else if (result[i]["table_nm"] == 'DAILY_TALK') {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CommunityDailyTalkView(article_seq: result[i]["article_seq"],
                                table_nm: result[i]["table_nm"],
                                main_catcode: result[i]["main_category"], params: {},);
                            },
                            ));
                          }
                        }
                      } else {
                        showDialog(context: context,
                            barrierColor: Color(0xffE47421).withOpacity(0.4),
                            builder: (BuildContext context) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                child: textalert(context,'삭제된 게시글입니다.'),
                              );
                            }
                        );
                      }

                    },
                    child : Container(
                      /*height: 65 * (MediaQuery.of(context).size.height / 360),*/
                      margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0),
                      child: Column(
                        children: [
                          Container(
                            /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                            // color: Colors.green,
                            child: Row(
                              children: [
                                if(getStorageData("notification").contains(result[i]["seq"].toString()))
                                Container(
                                  /*alignment: Alignment.topCenter,*/
                                  width: 60 * (MediaQuery.of(context).size.width / 360),
                                  margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        width: 55 * (MediaQuery.of(context).size.width / 360),
                                        height: 25 * (MediaQuery.of(context).size.height / 360),
                                        padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360)),
                                        decoration: BoxDecoration(
                                          color: Color(0xffF3F6F8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image(image: AssetImage(result[i]["table_nm"] == 'TODAY_INFO' && result[i]["main_category"] == 'TD_001' ? "assets/notification_icon01.png" : result[i]["table_nm"] == 'TODAY_INFO' ? "assets/notification_icon02.png" :
                                        result[i]["table_nm"] == 'DAILY_TALK' || result[i]["table_nm"] == 'USED_TRNSC' || result[i]["table_nm"] == 'PERSONAL_LESSON' ? "assets/notification_icon03.png" :
                                        result[i]["table_nm"] == 'KIN' ? "assets/notification_icon04.png" :
                                        result[i]["table_nm"] == 'ON_SITE' || result[i]["table_nm"] == 'INTRP_SRVC' || result[i]["table_nm"] == 'AGENCY_SRVC' || result[i]["table_nm"] == 'REAL_ESTATE' || result[i]["table_nm"] == 'REAL_ESTATE_INTRP_SRVC' ? "assets/notification_icon05.png" : ""),
                                          width : 8 * (MediaQuery.of(context).size.width / 360), height: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                if(!getStorageData("notification").contains(result[i]["seq"].toString()))
                                Container(
                                  margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 60 * (MediaQuery.of(context).size.width / 360),
                                    child: Wrap(
                                      children: [
                                        Container(
                                          width: 55 * (MediaQuery.of(context).size.width / 360),
                                          height: 25 * (MediaQuery.of(context).size.height / 360),
                                          padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                            color: Color(0xffE47421),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image(image: AssetImage(result[i]["table_nm"] == 'TODAY_INFO' && result[i]["main_category"] == 'TD_001' ? "assets/notification_icon01.png" : result[i]["table_nm"] == 'TODAY_INFO' ? "assets/notification_icon02.png" :
                                          result[i]["table_nm"] == 'DAILY_TALK' || result[i]["table_nm"] == 'USED_TRNSC' || result[i]["table_nm"] == 'PERSONAL_LESSON' ? "assets/notification_icon03.png" :
                                          result[i]["table_nm"] == 'KIN' ? "assets/notification_icon04.png" :
                                          result[i]["table_nm"] == 'ON_SITE' || result[i]["table_nm"] == 'INTRP_SRVC' || result[i]["table_nm"] == 'AGENCY_SRVC' || result[i]["table_nm"] == 'REAL_ESTATE' || result[i]["table_nm"] == 'REAL_ESTATE_INTRP_SRVC' ? "assets/notification_icon05.png" : ""),
                                          width : 8 * (MediaQuery.of(context).size.width / 360), height: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFFFFF),
                                        )
                                        )
                                      ],
                                    ),
                                ),
                                Container(
                                  width: 260 * (MediaQuery.of(context).size.width / 360),
                                  // color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 260 * (MediaQuery.of(context).size.width / 360),
                                        /*height: 10 * (MediaQuery.of(context).size.height / 360),*/
                                        margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        child: Text(
                                          "${result[i]["title"]}",
                                          style: TextStyle(
                                            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'NanumSquareEB',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                        /*height: 30 * (MediaQuery.of(context).size.height / 360),*/
                                        width: 260 * (MediaQuery.of(context).size.width / 360),
                                        margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360) , 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        child: Text(
                                          "${result[i]["conts"]}",
                                          style: TextStyle(
                                            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                            // fontWeight: FontWeight.bold,
                                            // overflow: TextOverflow.visible,
                                          ),
                                          maxLines: 3,
                                          overflow : TextOverflow.visible,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 25 * (MediaQuery.of(context).size.height / 360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Text(
                                    "${result[i]["reg_dt"]}",
                                    style: TextStyle(
                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xffC4CCD0),
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
                  ),
                  Divider(thickness: 1.5, height: 1.5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                ],
              )
          )
        ],
      )
    );
  }

  // 카테고리 타이틀 메뉴
  Container category(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5 *  (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    // color: Color(0xffF3F6F8),
                    // color:Color(0xffF3F6F8),
                    color:Color(0xffF3F6F8),
                    width: 1 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  5 * (MediaQuery.of(context).size.height / 360),
                ),
                child: Text(
                  "",
                  style: TextStyle(
                    // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

              ),
            ),
            Container(
              // width: 360 *  (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              /*decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color(0xffF3F6F8),
                            color:Color(0xffF3F6F8),
                            width: 1 * (MediaQuery.of(context).size.width / 360),),
                        ),
                      ),*/
              child: GestureDetector(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        title_menu_cat = '';
                        getlistdata().then((value) {
                          setState(() {

                          });
                        });

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                color: '' == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "전체",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: '' == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        title_menu_cat = 'TODAY_INFO_TD_001';
                        getlistdata().then((value) {
                          setState(() {

                          });
                        });

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                color: 'TODAY_INFO_TD_001' == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "공지사항",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: 'TODAY_INFO_TD_001' == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        title_menu_cat = 'KIN';
                        getlistdata().then((value) {
                          setState(() {

                          });
                        });

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                color: 'KIN' == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "지식인",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: 'KIN' == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        title_menu_cat = 'DAILY_TALK';
                        getlistdata().then((value) {
                          setState(() {

                          });
                        });

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                color: 'DAILY_TALK' == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "커뮤니티",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: 'DAILY_TALK' == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        title_menu_cat = 'SERVICE';
                        getlistdata().then((value) {
                          setState(() {

                          });
                        });

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                color: 'SERVICE' == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "호티서비스",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: 'SERVICE' == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        title_menu_cat = 'TODAY_INFO';
                        getlistdata().then((value) {
                          setState(() {

                          });
                        });

                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                color: 'TODAY_INFO' == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "오늘의정보",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: 'TODAY_INFO' == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 5 *  (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    // color: Color(0xffF3F6F8),
                    // color:Color(0xffF3F6F8),
                    color:Color(0xffF3F6F8),
                    width: 1 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  5 * (MediaQuery.of(context).size.height / 360),
                ),
                child: Text(
                  "",
                  style: TextStyle(
                    // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setting() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 80 * (MediaQuery.of(context).size.height / 360),
      decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.only(
          /*topLeft: Radius.circular(20 * (MediaQuery.of(context).size.width / 360)),
          topRight: Radius.circular(20 * (MediaQuery.of(context).size.width / 360)),*/
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 25 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  alignment: Alignment.center,
                  width: 280 * (MediaQuery.of(context).size.width / 360),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                    child: Text("설정",style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'NanumSquareEB',
                      fontWeight: FontWeight.w800,
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
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              decoration : BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 3 * (MediaQuery.of(context).size.width / 360),)
                  )
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 15 * (MediaQuery.of(context).size.width / 360), 0),
            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 25 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                for(int i = 0; i < result.length; i++) {
                  notificationList.add("${result[i]["seq"]}");
                  saveStorageData(notificationList, "notification");
                  setState(() {

                  });
                }
              },
              child : Row(
                children: [
                  Icon(Icons.done_all_rounded, color: Color(0xffC4CCD0),),
                  Text(
                    '  모두읽기',
                    style: TextStyle(
                        color: Color(0xff151515),
                        fontWeight: FontWeight.w400,
                        fontSize: 7 * (MediaQuery.of(context).size.height / 360)
                    ),
                  ),
                ],
              )
            )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 15 * (MediaQuery.of(context).size.width / 360), 0),
              // width: 120 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileAppPush();
                    },
                  ));
                },
                child : Row(
                  children: [
                    Icon(Icons.toggle_on_outlined, color: Color(0xffC4CCD0),),
                    Text(
                      '  알림설정',
                      style: TextStyle(
                          color: Color(0xff151515),
                          fontWeight: FontWeight.w400,
                          fontSize: 7 * (MediaQuery.of(context).size.height / 360)
                      ),
                    ),
                  ],
                )
              )
          ),
        ],
      ),
    );

  }

}