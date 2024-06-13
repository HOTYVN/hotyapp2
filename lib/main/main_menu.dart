import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/icons/my_icons.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/counseling/counseling_guide.dart';
import 'package:hoty/login/login.dart';
import 'package:hoty/main/main_menu_login.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/search/search_list.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:hoty/kin/kinlist.dart';

import '../categorymenu/living_list.dart';
import '../today/today_advicelist.dart';


class MainMenu extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 27 * (MediaQuery.of(context).size.width / 360),

        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,

        title: Container(
          width: 80 * (MediaQuery.of(context).size.width / 360),
          height: 80 * (MediaQuery.of(context).size.height / 360),
          child: Image(image: AssetImage('assets/logo.png')),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.close_rounded),color: Colors.black,alignment: Alignment.centerRight,iconSize: 26,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Container( //상단메뉴 ,카테고리
              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width: 340 * (MediaQuery.of(context).size.width / 360),
              height: 70 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Login(subtitle: 'Main');
                          },
                        ));
                      },
                      child:Container( //배너 이미지
                        width: 340 * (MediaQuery.of(context).size.width / 360),
                        height: 70 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/menu_top01.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Color(0xffFF8A00), BlendMode.color),
                          ),
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 340 * (MediaQuery.of(context).size.width / 360),
                              height: 65 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  )

                ],
              ),
            ), // 카테고리

            // type01
            livinginfo(context),

            // type02
            service(context),

            // type03
            community(context),

            // type04
            hotyspick(context),

            // type05


            // type06

            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Divider(thickness: 5, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),

            // follow us
            Follow_us(),

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
      bottomNavigationBar: Footer(nowPage: ''),
    );
  }

  Container hotyspick(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 350 * (MediaQuery.of(context).size.width / 360),
            height: 12 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360)),
            // width: 100 * (MediaQuery.of(context).size.width / 360),
            // height: 100 * (MediaQuery.of(context).size.width / 360),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 10 * (MediaQuery.of(context).size.height / 360) ,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                    ),
                  ),
                ),
                Container(
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child:
                  Text("호티의 선택!",
                    style: TextStyle(
                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                      fontFamily: 'NanumSquareEB',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        height: 14 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child: Row(
                                children: [
                                  Image(image: AssetImage('assets/today_menu01.png'), height: 10 * (MediaQuery.of(context).size.height / 360),),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return TodayList(main_catcode: '',table_nm : 'TODAY_INFO');
                                        },
                                      ));
                                    },
                                    child: Container(
                                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                      child: Text(
                                        "오늘의 정보",
                                        style: TextStyle(
                                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child:Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return TradeList(checkList: [],);
                                        },
                                      ));
                                    },
                                    child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
          ),
          Container(
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        height: 14 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child: Row(
                                children: [
                                  Image(image: AssetImage('assets/today_menu02.png'), height: 10 * (MediaQuery.of(context).size.height / 360),),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return TodayList(main_catcode: '',table_nm : 'HOTY_PICK');
                                        },
                                      ));
                                    },
                                    child: Container(
                                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                      child: Text(
                                        "호치민 정착가이드",
                                        style: TextStyle(
                                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff151515),
                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child:Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return TodayAdvicelist();
                                        },
                                      ));
                                    },
                                    child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
          ),
        ],
      ),
    );
  }

  Container community(BuildContext context) {
    return Container(
            child: Column(
              children: [
                Container(
                  width: 350 * (MediaQuery.of(context).size.width / 360),
                  height: 18 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360)),

                  // width: 100 * (MediaQuery.of(context).size.width / 360),
                  // height: 100 * (MediaQuery.of(context).size.width / 360),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 10 * (MediaQuery.of(context).size.height / 360) ,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child:
                        Text('커뮤니티',
                          style: TextStyle(
                            fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                            fontFamily: 'NanumSquareEB',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.warehouse, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff53B5BB),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return TradeList(checkList: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "중고거래",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return TradeList(checkList: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.admin_panel_settings, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff27AE60),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LessonList(checkList: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "개인과외",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LessonList(checkList: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.restaurant, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F103');                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "맛집공유",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F103');
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.shopping_cart, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFBCD58),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F102');
                                                },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "핫딜공유",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F102');                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.nightlife, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F101');
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "일상공유",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F101');
                                                },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.business_center, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE47421),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return CommunityDailyTalk(main_catcode: 'F104');                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "사업수다방",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                ),
              ],
            ),
          );
  }

  Container service(BuildContext context) {
    return Container(
            child: Column(
              children: [
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  height: 18 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360)),

                  // width: 100 * (MediaQuery.of(context).size.width / 360),
                  // height: 100 * (MediaQuery.of(context).size.width / 360),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 10 * (MediaQuery.of(context).size.height / 360) ,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child:
                        Text('서비스',
                          style: TextStyle(
                            fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                            fontFamily: 'NanumSquareEB',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.language, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Service_guide(table_nm : "ON_SITE");
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "출장 서비스",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Service_guide(table_nm : "ON_SITE");
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.medical_services, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Service_guide(table_nm : "INTRP_SRVC");
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "24시 긴급 출장 통역 서비스",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Service_guide(table_nm : "INTRP_SRVC");
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.handshake, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFC2C2),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Service_guide(table_nm : "AGENCY_SRVC");
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "대행서비스",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Service_guide(table_nm : "AGENCY_SRVC");
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ), // 에이전트 서비스
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.real_estate_agent, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff925331),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Counseling_guide(table_nm: "REAL_ESTATE");
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "부동산 상담신청",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return Counseling_guide(table_nm: "REAL_ESTATE");
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                ),
              ],
            ),
          );
  }

  Container livinginfo(BuildContext context) {
    return Container(
            child: Column(
              children: [
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  height: 18 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),

                  // width: 100 * (MediaQuery.of(context).size.width / 360),
                  // height: 100 * (MediaQuery.of(context).size.width / 360),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 10 * (MediaQuery.of(context).size.height / 360) ,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                        child:
                        Text('생활정보',
                          style: TextStyle(
                            fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                            fontFamily: 'NanumSquareEB',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.apart, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE47421),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "아파트정보",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.restaurant, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff729EF3),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C106', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "음식점/BAR",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C106', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.school, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C102', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "학교",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C102', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.academy, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFC2C2),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C103', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "학원",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C103', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.healty, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFBCD58),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C104', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "병원/약국",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C104', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.lifeshopping, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff925331),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C105', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "생활/쇼핑",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C105', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.game, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C107', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "취미/여가",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C107', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.rantalcar, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff9B51E0),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C108', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "렌트카",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C108', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                      Container(
                        margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Column(
                          children: [
                            Container(
                              width: 350 * (MediaQuery.of(context).size.width / 360),
                              height: 14 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.licensing, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C109', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "인허가",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff151515),
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return LivingList(title_catcode: 'C109', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                              },
                                            ));
                                          },
                                          child: Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
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
                ),
              ],
            ),
          );
  }
}
