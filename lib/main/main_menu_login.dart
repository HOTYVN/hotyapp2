import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/menu_banner.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/counseling/counseling_guide.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/search/search_list.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_list.dart';
import 'package:http/http.dart' as http;

// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:hoty/kin/kinlist.dart';

import 'package:hoty/community/usedtrade/trade_list.dart';

import '../common/icons/my_icons.dart';
import '../login/login.dart';
import '../profile/profile_hoty_point.dart';
import '../today/today_advicelist.dart';

class MainMenuLogin extends StatefulWidget {

  @override
  _MainMenuLogin createState() => _MainMenuLogin();
}

class _MainMenuLogin extends State<MainMenuLogin> {
  var _isload = false;
  String? reg_id;
  var point_info;
  var point_limit;
  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> cattitle = []; // 타이틀 리스트
  List<dynamic> subcat = [];
  var title_menu_cat = ""; // 타이틀메뉴 코드 idx
  var title_menu_cidx = ""; // 타이틀메뉴 cidx(기존메뉴IDX)

  Widget getBanner = Container(); //공통배너

  var title_living = ['M01','M02','M03','M04','M05'];

  void getPointLimit() async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/point_limit.do',
      //'http://www.hoty.company/mf/common/point_limit.do',
    );

    try {
      Map data = {
        "member_id": reg_id,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(response.statusCode == 200) {
        setState(() {
          point_limit = json.decode(response.body)['result'];
        });

      }else {
        setState(() {
          point_limit = 0;
        });
      }

    } catch(e) {
      print(e);

      setState(() {
        point_limit = 0;
      });
    }

  }

  final storage = FlutterSecureStorage();


  // 공통코드 호출
  Future<dynamic> getcodedata() async {
    List<dynamic> result = []; // 공통코드 리스트

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
        // 전체코드
        coderesult = json.decode(response.body)['result'];
      }
      for(var i=0; i<coderesult.length; i++) {
        if(coderesult[i]['pidx'] == "APP_CATEGORY"){
          if(coderesult[i]['idx'] != "M09" && coderesult[i]['idx'] != "M10"){
            cattitle.add(coderesult[i]);
          }

        }
      }
    }
    catch(e){
      print(e);
    }

  }

  Future<dynamic> getsubmenu() async{
    subcat.clear();

    coderesult.forEach((element) {
      if(element['pidx'] == title_menu_cat) {
        subcat.add(element);
      }
      if(element['idx'] == title_menu_cat) {
        if(element['cidx'] != null) {
          title_menu_cidx = element['cidx'];
        }
      }
    });


  }



  @override
  void initState() {
    super.initState();
    title_menu_cat = "M01";
    getcodedata().then((value) {
      getsubmenu().then((value) {
        setState(() {

        });
      });
    });
    _asyncMethod().then((value){
      getPoint().then((_)  {
        getPointLimit();
        setState(() {
          _isload = true;
          setBannerList().then((value) {
            setState(() {

            });
          });
        });
      });
    });

  }

  Future<dynamic> _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = await storage.read(key:'memberId');
    return true;
  }

  Future<dynamic> getPoint() async{
    print('get point call');
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberPoint.do',
      //'http://192.168.100.31:8080/mf/member/getMemberPoint.do',
    );

    try {
      Map data = {
        "memberId": reg_id,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(json.decode(response.body)['state'] == 200) {
        setState(() {
          point_info = json.decode(response.body)['result']['pointInfo']['RTN_POINT'];
        });

      }else {
        setState(() {
          point_info = 0;
        });
      }

    } catch(e) {
      print(e);

      setState(() {
        point_info = 0;
      });
    }

  }

  Future<dynamic> setBannerList() async {
    // getBanner = await Menu_Banner(table_nm : table_nm);
    getBanner = await Menu_Banner(table_nm : 'MENU_BOTTOM'); // 카테고리별 배너 호출

  }

  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double c_height = m_height;
    double m_width = (MediaQuery.of(context).size.width/360);

    bool isFold = pageWidth > 480 ? true : false;

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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight( 30 * c_height),
          child: Column(
            children: [
              AppBar(
                toolbarHeight: 30 * c_height,
                leading: Container(),
                actions: [
                  IconButton(icon: Icon(Icons.close_rounded),color: Colors.black,alignment: Alignment.centerRight,iconSize: 13 * c_height,
                    onPressed: (){
                      Navigator.pop(context, true);

                      /*Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ));*/
                    },
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: true,
                title: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MainPage();
                      },
                    ));
                  },
                  child: Container(
                    width: 90 * (MediaQuery.of(context).size.width / 360),
                    height: 30 * c_height,
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                ),
                centerTitle: true,
              ),
            ],
          )
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container( //상단메뉴 ,카테고리
              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width: 340 * (MediaQuery.of(context).size.width / 360),
              // height: reg_id != null && reg_id != '' ? 45 * c_height : 70 * c_height,

              child: Column(
                children: [

                  if(reg_id != null && reg_id != '' && _isload == true)
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_hoty_point();
                          },
                        ));
                      },
                      child:  Container(
                          width: 340 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                            color: Color(0xffFFF3EA),
                          ),
                          child : Column(
                            children: [
                              Container(
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                  child : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image(image: AssetImage("assets/coin.png"), height: 10 * (MediaQuery.of(context).size.height / 360),),
                                      Container(
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1  * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                        child : Text(' ${point_info ?? 0} P', style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 20 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515))),
                                      )
                                    ],
                                  )
                              ),
                              Container(
                                  child : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("적립 가능  ",  style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 11 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515))),
                                      Container(
                                        //width: 42 * (MediaQuery.of(context).size.width / 360),
                                        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                                          color: Color(0xff925331),
                                        ),
                                        child : Text("${point_limit ?? 0}", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w700, fontSize: 8 * (MediaQuery.of(context).size.width / 360), ),textAlign: TextAlign.center,),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                  if((reg_id == null || reg_id == '') && _isload == true)
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
                        height: 70 * c_height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/menu_top01.png'),
                            fit: BoxFit.cover,
                            // colorFilter: ColorFilter.mode(Color(0xffFF8A00), BlendMode.color),
                          ),
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                        ),
                      ),
                    )


                ],
              ),
            ), // 카테고리


            // 지식인
            if(_isload == true)
            GestureDetector(
              onTap: (){
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return KinList(success: false, failed: false,main_catcode: '',);
                  },
                ));
              },
              child : Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                //height: 50 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                  color: Color(0xff0075FE),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container( //이미지
                        child : Image(image: AssetImage("assets/kin_icon.png"), width: 30 * (MediaQuery.of(context).size.width / 360),)
                    ),
                    Container( //글
                      width: 250 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("호치민 뭐든지 물어봐!",
                            style: TextStyle(
                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareEB',
                                color: Color(0xffFFFFFF)
                            ),
                          ),
                          Text(" 지식iN",
                            style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareEB',
                                color: Color(0xff03E166)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container( //화살표
                      child: Icon(Icons.keyboard_arrow_right, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                    ),
                  ],
                ),
              ),
            ),



            category(context),

            Container(
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: submenulist(context),
            ),

            // type01
            // livinginfo(context),

            // type02
            // service(context),

            // type03
            // community(context),

            // type04
            // hotyspick(context),

            // type05


            // type06

            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            ),
            Container(
              margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child : getBanner,
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
            )

          ],
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
        child: Footer(nowPage: 'Main_menu',),

      ),
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
                    for(var i = 0; i < cattitle.length; i++)
                      GestureDetector(
                        onTap: (){
                          title_menu_cat = cattitle[i]['idx'];
                          getsubmenu().then((value) {
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
                                  color: cattitle[i]['idx'] == title_menu_cat ? Color(0xffE47421) : Color(0xffF3F6F8),
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
                                cattitle[i]['name'],
                                style: TextStyle(
                                  // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                  color: cattitle[i]['idx'] == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                            )
                        ),
                      )
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
  // 카테고리 서브 메뉴
  Column submenulist(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double c_height = m_height;
    double m_width = (MediaQuery.of(context).size.width/360);

    bool isFold = pageWidth > 480 ? true : false;

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
    return Column(
      children: [
        for(var i=0; i<subcat.length; i++)
          GestureDetector(
            onTap: (){
              // Navigator.pop(context);
              if(title_living.contains(title_menu_cat)){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LivingList(title_catcode: title_menu_cidx, check_sub_catlist: ['${subcat[i]['cidx']}'], check_detail_catlist: [], check_detail_arealist: [],);
                  },
                ));
              }
              if(title_menu_cat == 'M06'){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Service_guide(table_nm : "${subcat[i]['cidx']}");
                  },
                ));
              }
              if(title_menu_cat == 'M07'){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    if(subcat[i]['cidx'] == 'USED_TRNSC') {
                      return TradeList(checkList: [],);
                    } else if(subcat[i]['cidx'] == 'PERSONAL_LESSON'){
                      return LessonList(checkList: [],);
                    } else {
                      return CommunityDailyTalk(main_catcode: '${subcat[i]['cidx']}');
                    }
                  },
                ));
              }
              if(title_menu_cat == 'M08'){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return TodayList(main_catcode: '',table_nm : '${subcat[i]['cidx']}');
                  },
                ));
              }
            },
            child: Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              // height: 15 * c_height,
              margin : EdgeInsets.fromLTRB(0,1 * (MediaQuery.of(context).size.height / 360), 0, 0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      children: [
                        getSubIcons('${subcat[i]['idx']}'),
                        Container(
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                          child: Text(
                            "${subcat[i]['name']}",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360) ),
                    // width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
          ),
      ],

    );
  }

  Container getSubIcons(idx) {
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
    Icon subicon = Icon(caticon, size: 20 * (MediaQuery.of(context).size.width / 360),  color: catcolor,);
    Image subimage = Image(image: AssetImage('assets/today_menu01_1.png'), width: 20 * (MediaQuery.of(context).size.width / 360),);

    var gubun = ['M0801','M0802','M0203'];
    // 아이콘미사용
    if(idx != null) {
      if(idx == 'M0203') {
        subimage = Image(image: AssetImage('assets/M0203.png'), width: 20 * (MediaQuery.of(context).size.width / 360),);
      }
      if(idx == 'M0801') {
        subimage = Image(image: AssetImage('assets/M0801.png'), width: 20 * (MediaQuery.of(context).size.width / 360),);
      }
      if(idx == 'M0802') {
        subimage = Image(image: AssetImage('assets/M0802.png'), width: 20 * (MediaQuery.of(context).size.width / 360),);
      }
    }

    return Container(
      child: subicon,
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
          GestureDetector(
            onTap: (){
              // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TodayList(main_catcode: '',table_nm : 'TODAY_INFO');
                },
              ));
            },
            child: Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 14 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/today_menu01.png'), height: 10 * (MediaQuery.of(context).size.height / 360),),
                        Container(
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
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  // return TodayAdvicelist();
                  return TodayList(main_catcode: '',table_nm : 'HOTY_PICK');
                },
              ));
            },
            child: Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 14 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/today_menu02.png'), height: 10 * (MediaQuery.of(context).size.height / 360),),
                        Container(
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
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                ],
              ),
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
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TradeList(checkList: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.warehouse, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff53B5BB),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LessonList(checkList: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.admin_panel_settings, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff27AE60),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F103');
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_cart, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFBCD58),),
                              Container(
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                child: Text(
                                  "업체추천",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff151515),
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F101');
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.nightlife, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode : "F104");
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.business_center, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE47421),),
                              Container(
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                child: Text(
                                  "구인구직",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff151515),
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk(main_catcode: 'F102');
                        },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.ads_click, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff9B51E0),),
                              Container(
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                child: Text(
                                  "자유광고방",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff151515),
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
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
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service_guide(table_nm : "ON_SITE");
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.language, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                //GestureDetector(
                //  onTap: (){
                //    Navigator.pop(context);
                //    Navigator.push(context, MaterialPageRoute(
                //      builder: (context) {
                //        return Service_guide(table_nm : "INTRP_SRVC");
                //      },
                //    ));
                //  },
                //  child: Container(
                //    width: 350 * (MediaQuery.of(context).size.width / 360),
                //    height: 14 * (MediaQuery.of(context).size.height / 360),
                //    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                //    color: Colors.transparent,
                //    child: Row(
                //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //      children: [
                //        Container(
                //          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                //              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                //          child: Row(
                //            children: [
                //              Icon(Icons.medical_services, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                //              Container(
                //                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                //                child: Text(
                //                  "24시 긴급 출장 통역 서비스",
                //                  style: TextStyle(
                //                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                //                    color: Color(0xff151515),
                //                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                //                  ),
                //                ),
                //              ),
                //            ],
                //          ),
                //        ),
                //        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                //      ],
                //    ),
                //  ),
                //),
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
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.handshake, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFC2C2),),
                              Container(
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                child: Text(
                                  "비자서비스",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff151515),
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                //GestureDetector(
                //  onTap: (){
                //    Navigator.pop(context);
                //    Navigator.push(context, MaterialPageRoute(
                //      builder: (context) {
                //        return Counseling_guide(table_nm: "REAL_ESTATE");
                //      },
                //    ));
                //  },
                //  child: Container(
                //    width: 350 * (MediaQuery.of(context).size.width / 360),
                //    height: 14 * (MediaQuery.of(context).size.height / 360),
                //    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                //    color: Colors.transparent,
                //    child: Row(
                //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //      children: [
                //        Container(
                //          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                //              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                //          child: Row(
                //            children: [
                //              Icon(Icons.real_estate_agent, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff925331),),
                //              Container(
                //                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                //                child: Text(
                //                  "부동산 상담신청",
                //                  style: TextStyle(
                //                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                //                    color: Color(0xff151515),
                //                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                //                  ),
                //                ),
                //              ),
                //            ],
                //          ),
                //        ),
                //        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                //      ],
                //    ),
                //  ),
                //),
                /*GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service_guide(table_nm : "REAL_ESTATE_INTRP_SRVC");
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.language, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                              Container(
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                child: Text(
                                  "부동산통역서비스",
                                  style: TextStyle(
                                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff151515),
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),*/
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
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.apart, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffE47421),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C106', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(Icons.restaurant, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff729EF3),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C102', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.school, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff2F67D3),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C103', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.academy, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFFC2C2),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C104', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.healty, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffFBCD58),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C105', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.lifeshopping, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff925331),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C107', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.game, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C108', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.rantalcar, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xff9B51E0),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: 'C109', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  },
                  child: Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 14 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0,5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Icon(My_icons.licensing, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                              Container(
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
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      ],
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
