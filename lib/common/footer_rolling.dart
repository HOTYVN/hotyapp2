import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:hoty/categorymenu/common/view_on_map.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../categorymenu/living_list.dart';
import '../community/dailytalk/community_dailyTalk.dart';
import '../community/usedtrade/trade_list.dart';
import 'dialog/commonAlert.dart';
import 'icons/my_icons.dart';


class FotterRolling extends StatefulWidget {
  /*final List<String> getmenulist;
  const FotterRolling({Key? key,
    required this.getmenulist,
  }) : super(key:key);*/

  @override
  _CircularWidgetsSliderState createState() => _CircularWidgetsSliderState();
}

class _CircularWidgetsSliderState extends State<FotterRolling> {
  final int numberOfWidgets = 7;
  final double radius = 150;
  double _rotateAngle = 0.0;
  int selectIndex = 0;
  // var strList = [];
  var strIList = [];

  List<String> strList = [];
  List<String> c_strList = [];
  Map rst_menu = {};

  Widget setrolling= GestureDetector();

  var view_yn = 'N';





  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> cattitle = []; // 타이틀 리스트
  List<dynamic> subcat = [];
  var title_menu_cat = ""; // 타이틀메뉴 코드 idx
  var title_menu_cidx = ""; // 타이틀메뉴 cidx(기존메뉴IDX)
  var title_living = ['M01','M02','M03','M04','M05'];

  var _smode = false;

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
          if(coderesult[i]['idx'] != "M09") {
            cattitle.add(coderesult[i]);
          }
        }
      }
    }
    catch(e){
      print(e);
    }
  }

  // 메뉴호출
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




  // 설정한 메뉴 데이터 셋팅

  late SharedPreferences _prefs;
  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();


  }

  // 데이터를 저장하는 함수
  Future<void> _saveData() async {
    _prefs.setStringList('myMenu', strList);  // 'myData' 키에 데이터 저장
    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('저장완료')),  // 저장 완료 메시지 출력
    );*/
  }

  // 데이터를 로드하는 함수
  Future<void> _loadData() async {
    final myMenu = _prefs.getStringList('myMenu');
    if(myMenu != null) {
      strList = myMenu;
      c_strList = myMenu;
    }
    print(c_strList);
    print(myMenu);
    print(strList);
    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로드완료: $myMenu')), // 로드 완료 메시지와 함께 데이터 출력
    );*/
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    title_menu_cat = "M01";
    getcodedata().then((value) {
      // strList = widget.getmenulist;
      // c_strList = widget.getmenulist;
      _loadData().then((value) {
        getsubmenu().then((value) {
          // setrolling = getmenulist();
          setState(() {
            view_yn = 'Y';
          });
        });
      });
    });
  }


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
        c_height = m_height * (1.5 * aspectRatio);
        // c_height = m_height * ( aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }


    return Dialog(
      // insetPadding: EdgeInsets.all(20),
        insetPadding: EdgeInsets.fromLTRB(5, 5 * (MediaQuery.of(context).size.height / 360), 5, 20),
      alignment: Alignment.bottomCenter,
      elevation: 0,
      backgroundColor: Colors.transparent
        ,
        clipBehavior:  Clip.hardEdge,

      child: GestureDetector(
        onTap: (){
          if(_smode == false) {
            Navigator.pop(context);
          } else {
            showDialog(
              context: context,
                barrierDismissible: false,
              // barrierColor: Color(0xffE47421).withOpacity(0.2),
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: deletechecktext2(context,'편집하던 내용은 저장되지 않습니다. \n그래도 나가시겠습니까?', '아니요', '네'),
                  );
                },
            ).then((value) {
              if(value == true) {
                Navigator.pop(context);
              }
            });
          }
        },
        child: Container(
          width: 360 * (MediaQuery.of(context).size.height / 360),
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {

              // Navigator.pop(context);
              /*Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MainPage();
            },
          ));*/
            },
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(_smode == true)
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Column(
                      children: [
                        Container(
                          width: 330 ,
                          // height: 100 * c_height ,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(color: Colors.white, width: 2.0),
                          ),
                          child: Column(
                            children: [
                              // 메뉴타이틀
                              Container(
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2,
                                    0 * (MediaQuery.of(context).size.width / 360), 2 ),
                                child: category(context),
                              ),
                              // 메뉴아이콘
                              Container(
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 ,
                                    0 * (MediaQuery.of(context).size.width / 360), 7 ),
                                child: submenulist(context),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60 ,
                          height: 10 ,
                          // color: Colors.black,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/Polygon_2.png'), // 배경 이미지
                            ),
                            // color: Colors.white,
                          ),
                          // child: Icon(Icons.arrow_drop_down_outlined, color: Colors.white, size: 40 * (MediaQuery.of(context).size.width / 360) ,),

                        ),
                      ],
                    ),
                  ),

                Container(
                  width: 300 ,
                  height: 300 ,
                  // clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: Stack(
                    /* decoration: BoxDecoration(
                  color: Color(0xffF9FBFB),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/footer_rolling.png'), // 배경 이미지
                  ),
                ),*/
                    children: [
                      // setrolling,
                      // getmenulist(),

                      // 구분선
                      GestureDetector(
                          onPanUpdate: (details) {
                            double dx = details.localPosition.dx - (360) / 2;
                            double dy = details.localPosition.dy - (360) / 2;
                            setState(() {
                              _rotateAngle = atan2(dy, dx);
                            });
                          },
                          child: Transform.rotate(
                            angle : _rotateAngle,
                            child: Stack(
                              alignment: Alignment.center,

                              children: [
                                CustomPaint(
                                  size: Size(300, 300),
                                  painter: CircularContainerPainter(),

                                ),
                              ],
                            ),
                          )

                      ),

                      if(view_yn == 'Y')
                        GestureDetector(
                          onPanUpdate: (details) {
                            double dx = details.localPosition.dx - (360) / 2;
                            double dy = details.localPosition.dy - (360) / 2;
                            setState(() {
                              _rotateAngle = atan2(dy, dx);
                            });
                          },
                          child: Container(
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children:
                                List.generate(numberOfWidgets, (index) {
                                  double centerX = 150;
                                  double centerY = 150;
                                  double widgetAngle = (index * 2 * pi / numberOfWidgets) + _rotateAngle - pi / 2;
                                  // widgetAngle = index * 2 * pi / 7;
                                  double widgetX = radius * cos(widgetAngle) * 0.7 ;
                                  double widgetY = radius * sin(widgetAngle) * 0.7 ;

                                  int iconNumber = index+1;
                                  // print(index);
                                  return Positioned(
                                    left: widgetX + (radius * 0.8),
                                    top:  widgetY + (radius * 0.76),
                                    // left: widgetX,
                                    // top: widgetY /2,
                                    // left: MediaQuery.of(context).size.width / 360 + widgetX,
                                    // top: MediaQuery.of(context).size.height / 360 + widgetY,
                                    child: GestureDetector(
                                      onTap: () {
                                        selectIndex = index;
                                      },
                                      child: Row(
                                        children: [
                                          if(index < strList.length)
                                            GestureDetector(
                                              onTap: (){
                                                if(_smode == true) {
                                                  strList.remove(strList[index]);
                                                } else {
                                                  Map params = {};
                                                  var pidx = getTitlecode(strList[index]!);
                                                  var cidx = getCidxcode(strList[index]!);
                                                  var title_code = getTitlecode(cidx);
                                                  params = {
                                                    "pidx" : pidx,
                                                    "idx" : strList[index]!,
                                                    "cidx" : cidx,
                                                    "title_code" : title_code,
                                                  };
                                                  Navigator.pop(context, params);
                                                  // params.clear();
                                                }
                                                setState(() {

                                                });
                                              },
                                              child: Container(
                                                // width: 350 * (MediaQuery.of(context).size.width / 360),
                                                // height: 14 * c_height,
                                                width: 60 ,
                                                height: 60,
                                                margin : EdgeInsets.fromLTRB(0,5,
                                                    5, 0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF9FBFB),
                                                  shape: BoxShape.circle,
                                                  // border: Border.all(color: Colors.white, width: 2.0),
                                                ),
                                                // color: Colors.transparent,
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getSubIcons('${strList[index]}'),

                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),4,
                                                          0, 0),
                                                      child: Text(
                                                        getCodename( '${strList[index]}'),
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Color(0xff151515),
                                                          fontWeight: FontWeight.w500,
                                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,

                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if(index >= strList.length)
                                            GestureDetector(
                                              onTap: (){
                                                _smode = true;
                                                // print('######################################');
                                                setState(() {
                                                });
                                              },
                                              child: Container(
                                                width: 60 ,
                                                height: 60 ,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF9FBFB),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.white, width: 2.0),
                                                ),
                                                child: Icon(
                                                  Icons.add_circle_rounded,
                                                  color:
                                                  (index == strList.length && _smode == true) ? Color(0xffE47421) :
                                                  (index != strList.length && _smode == true) ? Color(0xff4E4E4E) :
                                                  (_smode == false) ? Color(0xffE47421) :
                                                  Color(0xff4E4E4E),
                                                  // alignment: Alignment.centerRight,
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                              ),
                            ),
                          ),
                        ),
                      Container(
                        width: 300,
                        height: 300  ,
                        child: Center(
                            child: GestureDetector(
                              onTap: (){
                                if(_smode == true) {
                                  _smode = false;
                                  _saveData().then((value) {
                                    setState(() {
                                    });
                                  });
                                } else {
                                  _smode = true;
                                  setState(() {
                                  });
                                }
                              },
                              child: Container(
                                  width: 60 ,
                                  height: 60 ,
                                  decoration: BoxDecoration(
                                    color: Color(0xffF9FBFB),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2.0),
                                  ),
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if(_smode == true)
                                        Container(
                                          child: Text(
                                            '완료',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'NanumSquareR',
                                              color: Color(0xffE47421),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      else
                                        Container(
                                          child: Text(
                                            '편집',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: 'NanumSquareR',
                                              color: Color(0xffE47421),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ],
                                  )
                              ),
                            )
                        ),
                      ),
                    ],

                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  // 미사용, 원형메뉴
  /*GestureDetector getmenulist() {
    return GestureDetector(
      onPanUpdate: (details) {
        double dx = details.localPosition.dx - (360) / 2;
        double dy = details.localPosition.dy - (180) / 2;
        setState(() {
          _rotateAngle = atan2(dy, dx);
        });
      },
      child: Container(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children:
            List.generate(numberOfWidgets, (index) {
              double centerX = 150;
              double centerY = 150;
              double widgetAngle = (index * 2 * pi / numberOfWidgets) + _rotateAngle - pi / 2;
              double widgetX = radius * cos(widgetAngle) * 0.7 ;
              double widgetY = radius * sin(widgetAngle) * 0.7 ;

              int iconNumber = index+1;
              // print(index);
              return Positioned(
                left: widgetX + (radius * 0.8),
                top:  widgetY + (radius * 0.76),
                // left: widgetX,
                // top: widgetY /2,
                // left: MediaQuery.of(context).size.width / 360 + widgetX,
                // top: MediaQuery.of(context).size.height / 360 + widgetY,
                child: GestureDetector(
                  onTap: () {
                    selectIndex = index;
                  },
                  child: Row(
                    children: [
                      if(index < strList.length)
                        GestureDetector(
                          onTap: (){
                            if(_smode == true) {
                              strList.remove(strList[index]);
                            }
                            setState(() {

                            });
                          },
                          child: Container(
                            // width: 350 * (MediaQuery.of(context).size.width / 360),
                            // height: 14 * c_height,
                            width: 60 ,
                            height: 60,
                            margin : EdgeInsets.fromLTRB(0,5,
                                5, 0),
                            decoration: BoxDecoration(
                              color: Color(0xffF9FBFB),
                              shape: BoxShape.circle,
                              // border: Border.all(color: Colors.white, width: 2.0),
                            ),
                            // color: Colors.transparent,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getSubIcons('${strList[index]}'),

                                Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),4,
                                      0, 0),
                                  child: Text(
                                    getCodename( '${strList[index]}'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xff151515),
                                      fontWeight: FontWeight.w500,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,

                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if(index >= strList.length)
                        Container(
                          width: 60 ,
                          height: 60 ,
                          decoration: BoxDecoration(
                            color: Color(0xffF9FBFB),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.0),
                          ),
                          child:
                          IconButton(icon: Icon(Icons.add_circle_rounded),
                            color:
                            (index == strList.length && _smode == true) ? Color(0xffE47421) :
                            (index != strList.length && _smode == true) ? Color(0xff4E4E4E) :
                            (_smode == false) ? Color(0xffE47421) :
                            Color(0xff4E4E4E),
                            // alignment: Alignment.centerRight,
                            iconSize: 30,
                            onPressed: (){
                              // Navigator.pop(context);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }*/

  // 카테고리 타이틀 메뉴
  Container category(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5 * (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 ,
                  0 * (MediaQuery.of(context).size.width / 360), 3),
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
                  8 ,
                  0 * (MediaQuery.of(context).size.height / 360),
                  8 ,
                  8 ,
                ),
                child: Text(
                  "",
                  style: TextStyle(
                    // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),

              ),
            ),
            Container(
              // width: 360 *  (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 ,
                  0 * (MediaQuery.of(context).size.width / 360), 0),
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
                                8 ,
                                0 * (MediaQuery.of(context).size.height / 360),
                                8 ,
                                8 ,
                              ),
                              child: Text(
                                cattitle[i]['name'],
                                style: TextStyle(
                                  // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                  color: cattitle[i]['idx'] == title_menu_cat ? Color(0xffE47421) : Color(0xff151515),
                                  fontSize: 14 ,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                            )
                        ),
                      ),
                    /*GestureDetector(
                      onTap: (){
                        title_menu_cat = 'KIN';
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
                                color: title_menu_cat == 'KIN' ? Color(0xffE47421) : Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              8 ,
                              0 * (MediaQuery.of(context).size.height / 360),
                              8 ,
                              8 ,
                            ),
                            child: Text(
                              '지식인',
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                color: title_menu_cat == 'KIN' ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 ,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          )
                      ),
                    )*/
                  ],
                ),
              ),
            ),
            Container(
              width: 5 *  (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 ,
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
                  8 ,
                  0 * (MediaQuery.of(context).size.height / 360),
                  8 ,
                  8 ,
                ),
                child: Text(
                  "",
                  style: TextStyle(
                    // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                    fontSize: 14,
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
  Wrap submenulist(BuildContext context) {
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
    return Wrap(
      children: [
        if(title_menu_cat != "KIN")
        for(var i=0; i<subcat.length; i++)
          GestureDetector(
            onTap: (){
              // setmenulist('${subcat[i]['idx']}');
              if(strList.contains('${subcat[i]['idx']}')) {
                c_strList.remove('${subcat[i]['idx']}');
                strList.remove('${subcat[i]['idx']}');
              } else {
                setmenulist('${subcat[i]['idx']}');
              }
              // rst_menu.putIfAbsent("data", () => subcat[i]);
              setState(() {
              });
            },
            child: Container(
              // width: 350 * (MediaQuery.of(context).size.width / 360),
              // height: 14 * c_height,
              width: 70 ,
              height: 60,
              margin : EdgeInsets.fromLTRB(0,5,
                  5, 0),
              decoration: BoxDecoration(
                color: strList.contains(subcat[i]['idx']) ? Color(0xffFDF4EE) : Color(0xffF9FBFB),
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.white, width: 2.0),
              ),
              // color: Colors.transparent,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getSubIcons('${subcat[i]['idx']}'),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),4,
                        0, 0),
                    child: Text(
                      "${subcat[i]['name']}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xff151515),
                        fontWeight: FontWeight.w500,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                    ),
                  ),
                ],
              ),
            ),
          ),
        if(title_menu_cat == "KIN")
        GestureDetector(
          onTap: (){

            if(strList.contains('KIN')) {
              c_strList.remove('KIN');
              strList.remove('KIN');
            } else {
              setmenulist('KIN');
            }

            // rst_menu.putIfAbsent("data", () => subcat[i]);
            setState(() {
            });
          },
          child: Container(
            // width: 350 * (MediaQuery.of(context).size.width / 360),
            // height: 14 * c_height,
            width: 70 ,
            height: 60,
            margin : EdgeInsets.fromLTRB(0,5,
                5, 0),
            decoration: BoxDecoration(
              color: strList.contains('KIN') ? Color(0xffFDF4EE) : Color(0xffF9FBFB),
              shape: BoxShape.circle,
              // border: Border.all(color: Colors.white, width: 2.0),
            ),
            // color: Colors.transparent,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getSubIcons('KIN'),
                Container(
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),4,
                      0, 0),
                  child: Text(
                    "지식IN",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff151515),
                      fontWeight: FontWeight.w500,
                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void setmenulist(idx) {
    var val_cnt = 0;
    if(idx != null) {
      if(c_strList.length < 7) {
        c_strList.forEach((element) {
          if(element == idx) {
            val_cnt ++;
          }
        });
        if(val_cnt == 0) {
          c_strList.add(idx);
        }
      }
    /*  c_strList.forEach((element) {
        if(element != idx) {
        } else {
          c_strList.removeWhere((item) => item == element);
        }
      });*/
      // strList.clear();
      strList = c_strList;
    }
    setState(() {

    });
  }

  String getCodename(getcode) {
    var Codename = '';

    coderesult.forEach((element) {
      if(element['idx'] == getcode) {
        Codename = element['name'];
      }
    });

    return Codename;
  }

  // 타이틀코드
  String getTitlecode(idx) {
    var title_code = '';

    coderesult.forEach((value) {
      if(value['idx'] == idx) {
        title_code = value['pidx'];
      }
    });

    return title_code;
  }
  // CIDX 코드
  String getCidxcode(idx) {
    var title_code = '';

    coderesult.forEach((value) {
      if(value['idx'] == idx) {
        if(value['cidx'] != null) {
          title_code = value['cidx'];
        }
      }
    });

    return title_code;
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
    Icon subicon = Icon(caticon, size: 20 ,  color: catcolor,);
    Image subimage = Image(image: AssetImage('assets/today_menu01_1.png'), width: 20,);

    var gubun = ['KIN'];
    // 아이콘미사용
    if(idx != null) {
      if(idx == 'M0203') {
        subimage = Image(image: AssetImage('assets/M0203.png'), width: 20 ,);
      }
      if(idx == 'M0801') {
        subimage = Image(image: AssetImage('assets/M0801.png'), width: 20 ,);
      }
      if(idx == 'M0802') {
        subimage = Image(image: AssetImage('assets/M0802.png'), width: 20 ,);
      }
      if(idx == 'KIN') {
        subimage = Image(image: AssetImage('assets/footer_rollicon4.png'), width: 20 ,);
      }
    }

    return Container(
      child: gubun.contains(idx) ? subimage : subicon,
    );
  }

}

class CircularContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // var strList = ['1', '2', '3', '4', '5', '6', '7'];
    var strlength = 7;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height /2;

    final Paint sectionPaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 10;
    final Paint linePaint = Paint()
      ..color = Color(0xffE6E8E9)
      ..strokeWidth = 0.5;

    final double angleStep = 2 * pi / strlength;

    // Draw sections
    for (int i = 0; i < strlength; i++) {
      final double startAngle = i * angleStep - pi / 2;
      final double endAngle = (i + 1) * angleStep - pi / 2;
      final Rect arcRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
      // canvas.drawArc(arcRect, startAngle, angleStep, true, sectionPaint);

      // Draw lines
      final double startX = centerX + radius * cos(startAngle + angleStep / 2);
      final double startY = centerY + radius * sin(startAngle + angleStep / 2);
      final double endX = centerX + radius * cos(endAngle + angleStep / 2);
      final double endY = centerY + radius * sin(endAngle + angleStep / 2);
      canvas.drawLine(Offset(centerX, centerY), Offset(startX, startY), linePaint);
      // canvas.drawLine(Offset(centerX, centerY), Offset(endX, endY), linePaint);

      // Draw text
     /* final textPainter = TextPainter(
        text: TextSpan(
          text: '${strList[i]}',
          style: TextStyle(color: Colors.black12, fontSize: 16),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );*/

      // textPainter.layout();
      final textCenterX = centerX + radius * 0.7 * cos(startAngle + angleStep / 2);
      final textCenterY = centerY + radius * 0.7 * sin(startAngle + angleStep / 2);
      // textPainter.paint(canvas, Offset(textCenterX - textPainter.width / 2, textCenterY - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}