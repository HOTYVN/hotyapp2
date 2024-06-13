import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_precautions.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/landing/landing.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_precautions.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;


class Menu_Banner extends StatefulWidget {
  final String table_nm;


  const Menu_Banner({Key? key,
    required this.table_nm,
  }) : super(key:key);


  @override
  _Menu_banner createState() => _Menu_banner();

}

class _Menu_banner extends State<Menu_Banner> {

  bool isFold = false;
  double c_height = 0; // 기종별 height 값

  var Baseurl = "http://www.hoty.company/mf";
  // var Baseurl = "http://192.168.0.109/mf";
  var Base_Imgurl = "http://www.hoty.company";
  // var Base_Imgurl = "http://192.168.0.109";

  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<dynamic> getresult = [];

  Future<dynamic> getlistdata() async {

    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
        Baseurl + "/popup/list.do"
    );
    try {
      Map data = {
        "table_nm" : widget.table_nm
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

  @override
  void initState() {
    super.initState();
    getlistdata().then((_){
      setState(() {
        Timer.periodic(Duration(seconds: 3), (Timer timer) {
          if (_currentPage < getresult.length) {
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
      });
    });

  }

  @override
  void didChangeDependencies() {
    getlistdata().then((_){
      setState(() {

      });
    });
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

    return Container(
      width: getresult.length <= 0 ? 0 : 350 * (MediaQuery.of(context).size.width / 360),
      height: getresult.length <= 0 ? 0 : widget.table_nm == "MENU_BOTTOM" ? 45 * (MediaQuery.of(context).size.height / 360) : 60 * c_height, // 이미지 사이즈
     /* margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
        child: bannerlist2(context),
    );

  }

  Container bannerlist(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: 60 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
      child: SingleChildScrollView (
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(getresult.length > 0)
              for(var i=0; i<getresult.length; i++)
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  // height: 100 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('$Base_Imgurl${getresult[i]['file_path']}'),
                        // image: NetworkImage(''),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 85 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          color: Color(0xff151515),
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        ),
                        child: Row(
                            children:[
                              Container(
                                padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                    4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                child: Text(
                                  (i+1).toString() + '/' + getresult.length.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white
                                  ),
                                ),
                              )
                            ]
                        ),
                      ),
                    ],
                  ),
                ),

          ],
        ),

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
                  if(getresult.length > 0)
                    for(var i=0; i<getresult.length; i++)
                  buildBanner('${getresult[i]['title']}', i,'${getresult[i]['file_path']}', '${getresult[i]['type']}', '${getresult[i]['table_nm']}', int.parse('${getresult[i]['article_seq'] ?? 0}') , '${getresult[i]['main_category']}'),
                ],
              ),
             /* Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(getresult.length > 0)
                        for(var i=0; i<getresult.length; i++)
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

  Widget buildBanner(String text, int index, file_path, type, table_nm, article_seq, category) {
    return GestureDetector(
        onTap : (){
          var title_living = ['M01','M02','M03','M04','M05'];
          print("링크확인");
          print(getresult[index]["link_yn"]);
          print(table_nm);
          print(category);
          if(getresult[index]["link_yn"] == "Y") {
            if(getresult[index]["landing_target"] == "N") {
              if(getresult[index]["link_yn"] == "Y") {
                if(type == "list") {

                  // 박정범
                  if(title_living.contains(table_nm)){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return LivingList(title_catcode: category,
                          check_sub_catlist: [],
                          check_detail_catlist: [],
                          check_detail_arealist: []);
                    },
                    ));
                  }
                  if(table_nm == 'M06'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service_guide(table_nm : category);
                      },
                    ));
                  }
                  if(table_nm == 'M07'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        if(category == 'USED_TRNSC') {
                          return TradeList(checkList: [],);
                        } else if(category == 'PERSONAL_LESSON'){
                          return LessonList(checkList: [],);
                        } else {
                          return CommunityDailyTalk(main_catcode: category);
                        }
                      },
                    ));
                  }
                  if(table_nm == 'M08'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TodayList(main_catcode: '',table_nm : category);
                      },
                    ));
                  }
                  // 지식인
                  if(table_nm == 'M09'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinList(success: false, failed: false,main_catcode: '',);
                      },
                    ));
                  }


                } else if(type == "view") {
                  if(title_living.contains(table_nm)){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return LivingView(article_seq: article_seq, table_nm: table_nm, title_catcode: category, params: {});
                    },
                    ));
                  }
                  if(table_nm == 'M06'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service_guide(table_nm : category);
                      },
                    ));
                  }
                  if(table_nm == 'M07'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        if(category == 'USED_TRNSC') {
                          return TradeView(article_seq: article_seq, table_nm: table_nm, params: {}, checkList: []);
                        } else if(category == 'PERSONAL_LESSON'){
                          return LessonView(article_seq: article_seq, table_nm: table_nm, params: {}, checkList: []);
                        } else {
                          return CommunityDailyTalkView(article_seq: article_seq, table_nm: table_nm, main_catcode: category, params: {});
                        }
                      },
                    ));
                  }
                  if(table_nm == 'M08'){

                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return todayView(article_seq: article_seq, title_catcode: category, cat_name: '', table_nm: table_nm);
                      },
                    ));
                  }
                  // 지식인
                  if(table_nm == 'M09'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinView(article_seq: article_seq, table_nm: table_nm, adopt_chk: '');
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
          } else {
            if(widget.table_nm == "TODAY_INFO") {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TodayPrecautions();
              },
              ));
            }
            if(widget.table_nm == "KIN") {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return KinPrecautions();
              },
              ));
            }
          }
        },
      child : Container(
        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정합니다.
          // color: Colors.blueGrey,
          image: DecorationImage(
              image: NetworkImage('$Base_Imgurl$file_path'),
              // image: NetworkImage(''),
              fit: BoxFit.cover
          ),
        ),
        // child: Center(child: Text(text)), // 타이틀글 사용시 주석해제
      )
    );
  }

}


/*
class Menu_banner extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Container(

    );

  }

}*/
