import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/guide/guide.dart';
import 'package:hoty/intro/intro_two.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroOne extends StatefulWidget {

  @override
  State<IntroOne> createState() => _IntroOneState();
}

class _IntroOneState extends State<IntroOne> {
  void skipTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', false);
  }
  @override
  void initState() {
    /*initDynamicLinks();*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( 45 * (MediaQuery.of(context).size.height / 360)),
        child: Column(
          children: [
            Container(
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0, 15 * (MediaQuery.of(context).size.height / 360),0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 120 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.centerLeft,
                    // color: Colors.red,
                  ),
                  Container(
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    //height: 110 * (MediaQuery.of(context).size.height / 360),
                    // margin: EdgeInsets.fromLTRB(0, 0, 30 * (MediaQuery.of(context).size.height / 360), 0),
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                  Container(
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        skipTutorial();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Guide();
                            /*return MainPage();*/
                          },
                        ));
                      },
                      child: Text('건너뛰기', style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff2F67D3),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('assets/intro1.png'),
                    fit: BoxFit.cover
                )
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(0, 190 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("호치민의 모든 정보 \n HOTY에서 확인하세요", style: TextStyle(
                        fontSize: 28 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NanumSquareEB',
                      ), textAlign: TextAlign.center),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      ),
                      Text("생활에 필요한 정보 찾기", style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Color.fromRGBO(228, 116, 33, 1),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NanumSquareEB',
                      ), textAlign: TextAlign.center)
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 9 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        width: 70 * (MediaQuery.of(context).size.width / 360),
                        height: 4 * (MediaQuery.of(context).size.height / 360),
                        child: Image(image: AssetImage('assets/intro_page.png')),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: (MediaQuery.of(context).size.width / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 8 * (MediaQuery.of(context).size.height / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return IntroTwo();
                          },
                        ));
                      },
                      child:  Row(
                        children: [
                          Text('다음', style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), fontFamily: 'NanumSquareR', fontWeight: FontWeight.w700, color: Colors.white),),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 3 * (MediaQuery.of(context).size.height / 360), 0),
                            child: Text(""),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18 * (MediaQuery.of(context).size.width / 360),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      print("#################### flutter firebase link ####################");
      print(deepLink.path);
      Get.toNamed(deepLink.path, arguments: deepLink.path);
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
                return TodayList(main_catcode: '', table_nm: table_nm);
              },
              ));
            });
          } else if (table_nm == 'HOTY_PICK') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TodayAdvicelist();
              },
              ));
            });
          } else if (table_nm == 'KIN') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return KinList(success: false, failed: false,main_catcode: '',);
              },
              ));
            });
          } else if (table_nm == 'LIVING_INFO') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LivingList(title_catcode: 'C1',
                    check_sub_catlist: [],
                    check_detail_catlist: [],
                    check_detail_arealist: []);
              },
              ));
            });
          } else if (table_nm == 'ON_SITE') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Service(table_nm: table_nm);
              },
              ));
            });
          } else if (table_nm == 'INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Service(table_nm: table_nm);
              },
              ));
            });
          } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Service(table_nm: table_nm);
              },
              ));
            });
          } else if (table_nm == 'AGENCY_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Service(table_nm: table_nm);
              },
              ));
            });
          } else if (table_nm == 'PERSONAL_LESSON') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LessonList(checkList: []);
              },
              ));
            });
          } else if (table_nm == 'USED_TRNSC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TradeList(checkList: []);
              },
              ));
            });
          } else if (table_nm == 'DAILY_TALK') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CommunityDailyTalk(main_catcode: 'F101');
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
                return todayView(article_seq: article_seq,
                    title_catcode: category,
                    cat_name: cat_name,
                    table_nm: table_nm);
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
                return todayView(article_seq: article_seq,
                    title_catcode: category,
                    cat_name: cat_name,
                    table_nm: table_nm);
              },
              ));
            });
          } else if (table_nm == 'KIN') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return KinView(article_seq: article_seq,
                    table_nm: table_nm,
                    adopt_chk: '');
              },
              ));
            });
          } else if (table_nm == 'LIVING_INFO') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LivingView(article_seq: article_seq,
                    table_nm: table_nm,
                    title_catcode: category, params: {},);
              },
              ));
            });
          } else if (table_nm == 'ON_SITE') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileServiceHistoryDetail(idx: article_seq);
              },
              ));
            });
          } else if (table_nm == 'INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileServiceHistoryDetail(idx: article_seq);
              },
              ));
            });
          } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileServiceHistoryDetail(idx: article_seq);
              },
              ));
            });
          } else if (table_nm == 'AGENCY_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileServiceHistoryDetail(idx: article_seq);
              },
              ));
            });
          } else if (table_nm == 'PERSONAL_LESSON') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LessonView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],);
              },
              ));
            });
          } else if (table_nm == 'USED_TRNSC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TradeView(article_seq: article_seq, table_nm: table_nm, params: {}, checkList: [],);
              },
              ));
            });
          } else if (table_nm == 'DAILY_TALK') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CommunityDailyTalkView(article_seq: article_seq,
                    table_nm: table_nm,
                    main_catcode: category, params: {},);
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
}