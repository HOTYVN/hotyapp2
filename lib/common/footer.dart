import 'package:flutter/material.dart';
import 'package:hoty/categorymenu/common/view_on_map.dart';
//import 'package:hoty/common/rolling.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_menu_login.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_main.dart';
import 'package:hoty/search/search_list.dart';
import 'package:hoty/today/today_list.dart';
import 'dart:math';

import '../categorymenu/living_list.dart';
import '../community/privatelesson/lesson_list.dart';
import '../service/service_guide.dart';
import 'footer_rolling.dart';

class Footer extends StatefulWidget {
  final String nowPage;
  const Footer({Key? key, required this.nowPage}) : super(key: key);

  @override
  _Footer createState() => _Footer();
}
class _Footer extends State<Footer> {
  final Offset rootOffset = const Offset(0, 0);
  final int numberOfWidgets = 6;
  final double radius = 100;
  double _rotateAngle = 0.0;

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double c_height = m_height;
    double m_width = (MediaQuery.of(context).size.width/360);

    bool isFold = pageWidth > 480 ? true : false;

    if(pageWidth > 480) {
      c_height = m_height * ((m_height * 3)/10);
    }

    if(aspectRatio > 0.55) {
      if(isFold == true) {
        // c_height = m_height * (m_width * aspectRatio);
        c_height = m_height * ( aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }


    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 32 * c_height,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[ // 그림자효과
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(-2, 1 ),
            spreadRadius: 1,
          ),
        ],
        color: Colors.transparent,
        // 배경 이미지 설정
        image: DecorationImage(
          image: AssetImage('assets/Footer.png'), // 이미지 파일 경로
          fit: BoxFit.fill, // 이미지를 꽉 채우도록 설정
        ),
      ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      if(widget.nowPage != 'Main_page') {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MainPage();
                          },
                        ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360),10 * c_height,
                          20 * (MediaQuery.of(context).size.width / 360),10 * c_height),
                      // padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
                      width: 25 * (MediaQuery.of(context).size.width / 360),
                      height: 15 * c_height,
                      child: Image(
                          image: AssetImage('assets/home.png'),
                        color: widget.nowPage == 'Main_page' ? Color(0xffE47421) : Color(0xff151515),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      // if(widget.nowPage != 'Today_page') {
                      //if(widget.nowPage != 'Main_menu') {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            //return TodayList(main_catcode: '', table_nm: 'TODAY_INFO',);
                              return MainMenuLogin();
                          },
                        ));
                      //}
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),
                          10 * c_height,35 * (MediaQuery.of(context).size.width / 360),10 * c_height),
                      // padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
                      width: 25 * (MediaQuery.of(context).size.width / 360),
                      height: 15 * c_height,
                      child: Image(image: AssetImage('assets/reader.png'),
                        color: widget.nowPage == 'Main_menu' ? Color(0xffE47421) : Color(0xff151515),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
               /* showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                        alignment: Alignment.bottomCenter,
                        elevation: 0,
                        backgroundColor: Color.fromRGBO(243, 246, 248, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200)
                          ),
                          clipBehavior: Clip.hardEdge,
                          width: 265 * (MediaQuery.of(context).size.width / 360),
                          height: 265 * (MediaQuery.of(context).size.width / 360),
                          child: Container(
                            child: FotterRolling(),
                          ),
                        )
                    ));*/

                showDialog(context: context,
                    barrierDismissible: false,
                    // barrierColor: Color(0xffE47421).withOpacity(0.4),
                    barrierColor: Color(0xff000000).withOpacity(0.7),
                    builder: (BuildContext context) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                        child: FotterRolling(),
                        // child: GetRolling(),
                      );
                      // return FotterRolling();
                    }
                ).then((value) {
                  var title_living = ['M01','M02','M03','M04','M05'];
                  print(value);
                  if(title_living.contains(value['pidx'])){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: value['title_code'], check_sub_catlist: ['${value['cidx']}'], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  }
                  if(value['pidx'] == 'M06'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service_guide(table_nm : "${value['cidx']}");
                      },
                    ));
                  }
                  if(value['pidx'] == 'M07'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        if(value['cidx'] == 'USED_TRNSC') {
                          return TradeList(checkList: [],);
                        } else if(value['cidx'] == 'PERSONAL_LESSON'){
                          return LessonList(checkList: [],);
                        } else {
                          return CommunityDailyTalk(main_catcode: '${value['cidx']}');
                        }
                      },
                    ));
                  }
                  if(value['pidx'] == 'M08'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TodayList(main_catcode: '',table_nm : '${value['cidx']}');
                      },
                    ));
                  }
                  if(value['idx'] == 'KIN'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinList(success: false, failed: false,main_catcode: '',);
                      },
                    ));
                  }
                  if(value['pidx'] == 'M10'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinList(success: false, failed: false,main_catcode: '',);
                      },
                    ));
                  }
                  /*if(value == 0){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TradeList(checkList: [],);
                      },
                    )),
                  } else if(value == 1){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F101');
                      },
                    )),
                  } else if(value == 2){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F102');
                      },
                    )),
                  } else if(value == 3){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinList(success: false, failed: false,main_catcode: '',);
                      },
                    )),
                  } else if(value == 4){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F103');
                      },
                    )),
                  } else if(value == 5){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F104');
                      },
                    )),
                  } else if (value == 6) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ViewOnMap(title_catcode: 'C101', rolling: '', params: {}, check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    )),
                  }*/
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360),0 * c_height,
                    0 * (MediaQuery.of(context).size.width / 360),3 * c_height),
                padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0),
                width: 55 * (MediaQuery.of(context).size.width / 360),
                // height: 30 * c_height,
                child: Image(image: AssetImage('assets/wltlrin.png')),
              ),
            ),
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      if(widget.nowPage != 'Search_page') {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return SearchList();
                          },
                        ));
                      }
                    },

                    child: Container(
                      margin: EdgeInsets.fromLTRB(35 * (MediaQuery.of(context).size.width / 360),10 * c_height,
                          10 * (MediaQuery.of(context).size.width / 360),10 * c_height),
                      // padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
                      width: 25 * (MediaQuery.of(context).size.width / 360),
                      height: 15 * c_height,
                      child: Image(image: AssetImage('assets/search.png'),
                        color: widget.nowPage == 'Search_page' ? Color(0xffE47421) : Color(0xff151515),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(widget.nowPage != 'My_page') {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_main();
                          },
                        ));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360),10 * c_height,
                          20 * (MediaQuery.of(context).size.width / 360),10 * c_height),
                      // padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
                      width: 25 * (MediaQuery.of(context).size.width / 360),
                      height: 15 * c_height,
                      child: Image(image: AssetImage('assets/person.png'),
                        color: widget.nowPage == 'My_page' ? Color(0xffE47421) : Color(0xff151515),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

}
