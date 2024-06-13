import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hoty/categorymenu/common/view_on_map.dart';
import 'package:hoty/common/footer.dart';

import '../../common/container/cmcontainer.dart';
import '../living_list.dart';
import '../providers/living_provider.dart';

class Catmenu_Filter_Map extends StatefulWidget {
  final String title_catcode;
  final List<String> getcheck_sublist;
  final List<String> getcheck_detiallist;
  final List<String> getcheck_areadetiallist;
  const Catmenu_Filter_Map({Key? key,
    required this.title_catcode,
    required this.getcheck_sublist,
    required this.getcheck_detiallist, required this.getcheck_areadetiallist,
  }) : super(key:key);

  @override
  _Catmenu_Filter_Map createState() => _Catmenu_Filter_Map();
}


class _Catmenu_Filter_Map extends State<Catmenu_Filter_Map> {
  // 생활정보 카테고리
  List<dynamic> coderesult = []; // 공통코드 리스트
  // List<dynamic> cattitle = []; // 카테고리타이틀 리스트
  List<dynamic> sub_catname = []; // 서브카테고리 리스트
  List<dynamic> title_catname = []; // 메뉴타이틀테고리 리스트
  List<dynamic> areaname = []; // 지역카테고리 리스트

  String sub_cattitle = '';
  List<dynamic> sub_catlist = []; // 서브 카테고리 리스트
  List<dynamic> sub_arealist = []; // 지역 카테고리 리스트
  List<dynamic> sub_detail_catlist = []; // 서브 카테고리 리스트
  var main_title_catcode = 'C101'; // 메뉴카테고리 코드값 //추후 링크연동시 code값 필요.


  // 검색을 위해 담긴 체크리스트
  List<String> allcheck_sub_catlist = []; // 서브카테고리 all
  List<String> check_sub_catlist = []; // 서브카테고리 체크
  List<String> allcheck_detail_catlist = []; // 세부카테고리 all
  List<String> check_detail_catlist = []; // 세부카테고리 체크

  List<String> allcheck_detail_arealist = []; // 지역카테고리 all
  List<String> check_detail_arealist = []; // 지역카테고리 체크


  Map params = {}; // 카테고리 맵
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


  //아파트,학교,학원 분류
  List<String> gubun = ['C101','C102','C103'];
  // 선택형_카테고리 리스트
  List<String> selsubcat = [];

  // 공통코드 호출
  Future<dynamic> setcode() async {
    if(widget.title_catcode != null) {
      main_title_catcode = widget.title_catcode;
    }
    //코드 전체리스트 가져오기
    coderesult = await livingProvider().getcodedata();


    // 타이틀코드,지역코드
    coderesult.forEach((value) {
      if(value['pidx'] == 'RIVING_INFO'){
        title_catname.add(value);
      }
      if(value['pidx'] == 'AREA'){
        areaname.add(value);
        sub_arealist.add(value);
      }
    });

    // 서브카테고리 지역사용여부 구분
    if(gubun.contains(main_title_catcode)){
      // sub_catlist = areaname;
      coderesult.forEach((element) {
        if(element['pidx'] == main_title_catcode) {
          coderesult.forEach((val) {
            if(val['pidx'] == element['idx']){
              sub_detail_catlist.add(val);
            }
          });
        }
      });
    }else{
      getfiltercode();
      coderesult.forEach((element) {
        if(element['idx'] == main_title_catcode) {
          sub_cattitle = element['name'];
        }
        if(element['pidx'] == main_title_catcode) {
          sub_catlist.add(element);
        }
      });
    }
    // sub_arealist = areaname;


    // 첫번째 카테고리
    /*   for(var i=0; i<title_catname.length; i++){
      if(i == 5){
        title_catcode = title_catname[i]['idx'];
      }
    }*/

  }

  void getfiltercode() {
    // main_title_catcode = 'C10401';
    sub_detail_catlist.clear();
    print(main_title_catcode);

    if(check_sub_catlist.length > 0) {
      check_sub_catlist.forEach((selcode) {
        coderesult.forEach((element) {
          if(element['idx'] == selcode) {
            coderesult.forEach((val) {
              if(val['pidx'] == element['idx']){
                sub_detail_catlist.add(val);
              }
            });
          }
        });
      });
    }

/*    coderesult.forEach((element) {
      if(element['pidx'] == main_title_catcode) {
        coderesult.forEach((val) {
          if(val['pidx'] == element['idx']){
            sub_detail_catlist.add(val);
          }
        });
      }
    });*/

  }

  @override
  void initState() {
    super.initState();
    check_sub_catlist = widget.getcheck_sublist;
    check_detail_catlist = widget.getcheck_detiallist;
    check_detail_arealist = widget.getcheck_areadetiallist;
    setcode().then((_) {
      setState(() {
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 27,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: true,

        title: Text("필터",
          style: TextStyle(
            fontSize: 20 * (MediaQuery.of(context).size.width / 360),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xffF3F6F8),
            width: 1 * (MediaQuery.of(context).size.width / 360),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
            child: IconButton(icon: Icon(Icons.close_rounded),color: Colors.black,alignment: Alignment.centerRight,iconSize: 26,
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: makefilter('${main_title_catcode}',context),
      ),
      bottomNavigationBar:
      Container(
        width: 340 * (MediaQuery.of(context).size.width / 360),
        height: 60 * (MediaQuery.of(context).size.height / 360),
        margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)) ,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ViewOnMap(title_catcode: main_title_catcode, check_sub_catlist: check_sub_catlist, check_detail_catlist: check_detail_catlist, check_detail_arealist: check_detail_arealist, rolling: '', params: {},);
                    },
                  ));
                },
                child: Text('적용하기', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                    color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumSquareR',
                ),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 3  * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360)) ,
              padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      side : BorderSide(color: Color(0xffE47421), width: 2 * (MediaQuery.of(context).size.width / 360)),

                    )
                ),
                onPressed: (){
                  check_sub_catlist.clear();
                  check_detail_catlist.clear();
                  allcheck_detail_catlist.clear();
                  allcheck_sub_catlist.clear();
                  allcheck_detail_arealist.clear();
                  check_detail_arealist.clear();
                  setState(() {
                  });
                },
                child: Text('모든 필터 지우기', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360),fontWeight: FontWeight.bold, color: Color(0xffE47421), fontFamily: 'NanumSquareR',),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makefilter(subtitle,context){

    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  areacatinfo(subtitle,context), // 지역
                  if(gubun.contains(main_title_catcode))
                    filterinfo(subtitle,context),
                  if(!gubun.contains(main_title_catcode))
                    subcatinfo(subtitle,context), // 메인카테고리
                  //세부카테고리
                  if(check_sub_catlist.length < 2 && check_sub_catlist.length > 0)
                    filterinfo2(subtitle,context),

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  ),
                  filtertip(context),

                ],
              ),
            ),


          ]
      );
  }

  Column areacatinfo(String subtitle,context){

    return
      Column(
        children: [
          Container(
            // height: 60 * (MediaQuery.of(context).size.height / 360),
            child: Column(
              children: [
                ExpansionTile(
                  // backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      // top: Radius.circular(25),
                    ),
                  ),
                  iconColor: Color(0xff0F1316),
                  textColor: Color(0xff0F1316),
                  collapsedIconColor: Color(0xff0F1316),
                  title: Text('지역',
                    style: TextStyle(
                      // color: Color(0xff151515),
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                    ),
                  ),
                  initiallyExpanded: true,
                  children: [
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      // height: 50 * (MediaQuery.of(context).size.height / 360),
                      child: Wrap(
                        children: [
                          Container(
                              width: 175 * (MediaQuery.of(context).size.width / 360),
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container( child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    value: allcheck_detail_arealist.contains('C2'),
                                    // value: true,
                                    activeColor: Color(0xffE47421),
                                    checkColor: Colors.white,
                                    onChanged: (val) {
                                      _allAreaSelected(val!,'C2');
                                    },
                                  ),),
                                  Container(
                                    child: Text(
                                      "전체",
                                      style: TextStyle(
                                        fontFamily: 'NanumSquareR',
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                ]
                                ,)
                          ),
                          for(int m2=0; m2<sub_arealist.length; m2++)
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Transform.scale(
                                        scale: 1,
                                        child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          side: BorderSide(
                                            color: Color(0xffC4CCD0),
                                            width: 2,
                                          ),
                                          value: check_detail_arealist.contains(sub_arealist[m2]['idx']),
                                          // value: true,
                                          activeColor: Color(0xffE47421),
                                          checkColor: Colors.white,

                                          onChanged: (val) {
                                            _onAreaSelected(val!, sub_arealist[m2]['idx']);
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                      child: Text(
                                        "${sub_arealist[m2]['name']}",
                                        style: TextStyle(
                                            overflow: TextOverflow.clip,
                                          fontFamily: 'NanumSquareR',
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    ;
  }
  // 지역카테고리
  void _allAreaSelected(bool selected, String dataName) {
    if (selected == true) {
      allcheck_detail_arealist.add(dataName);
      for(var m2=0; m2<sub_arealist.length; m2++) {
        check_detail_arealist.add(sub_arealist[m2]['idx']);
      }
      setState(() {
      });
    } else {
      allcheck_detail_arealist.remove(dataName);
      check_detail_arealist.clear();
      setState(() {
      });
    }
  }
  // 지역카테고리
  void _onAreaSelected(bool selected, String dataName) {
    if (selected == true) {
      check_detail_arealist.add(dataName);
      setState(() {
      });
    } else {
      check_detail_arealist.remove(dataName);
      setState(() {
      });
    }
  }



  Column subcatinfo(String subtitle,context){

    return
      Column(
        children: [
          if(sub_catlist.length > 0)
            Container(
              // height: 60 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  ExpansionTile(
                    // backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        // top: Radius.circular(25),
                      ),
                    ),
                    iconColor: Color(0xff0F1316),
                    textColor: Color(0xff0F1316),
                    collapsedIconColor: Color(0xff0F1316),
                    title: Text(sub_cattitle,
                      style: TextStyle(
                        // color: Color(0xff151515),
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        // height: 50 * (MediaQuery.of(context).size.height / 360),
                        child: Wrap(
                          children: [
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container( child: Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      side: BorderSide(
                                        color: Color(0xffC4CCD0),
                                        width: 2,
                                      ),
                                      value: allcheck_sub_catlist.contains(sub_cattitle),
                                      // value: true,
                                      activeColor: Color(0xffE47421),
                                      checkColor: Colors.white,
                                      onChanged: (val) {
                                        _allSubSelected(val!,sub_cattitle);
                                      },
                                    ),),
                                    Container(
                                      child: Text(
                                        "전체",
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),
                            for(int m2=0; m2<sub_catlist.length; m2++)
                              Container(
                                  width: 175 * (MediaQuery.of(context).size.width / 360),
                                  height: 15 * (MediaQuery.of(context).size.height / 360),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Transform.scale(
                                          scale: 1,
                                          child: Checkbox(
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: BorderSide(
                                              color: Color(0xffC4CCD0),
                                              width: 2,
                                            ),
                                            value: check_sub_catlist.contains(sub_catlist[m2]['idx']),
                                            // value: true,
                                            activeColor: Color(0xffE47421),
                                            checkColor: Colors.white,

                                            onChanged: (val) {
                                              _onSubSelected(val!, sub_catlist[m2]['idx']);
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                        child: Text(
                                          "${sub_catlist[m2]['name']}",
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                        ),
                                      ),
                                    ]
                                    ,)
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      )
    ;
  }


  // 서브카테고리
  void _allSubSelected(bool selected, String dataName) {
    check_detail_catlist.clear();
    allcheck_detail_catlist.clear();
    if (selected == true) {
      allcheck_sub_catlist.add(dataName);
      for(var m2=0; m2<sub_catlist.length; m2++) {
        check_sub_catlist.add(sub_catlist[m2]['idx']);
      }
      getfiltercode();
      setState(() {
      });
    } else {
      // allcheck_sub_catlist.remove(dataName);
      allcheck_sub_catlist.clear();
      print(allcheck_sub_catlist);
      check_sub_catlist.clear();
      coderesult.forEach((element) {
        if(element['pidx'] == dataName){
          // check_detail_catlist.remove(element['idx']);
          check_detail_catlist.removeWhere((item) => item == element['idx']);
        }
      });
      // check_sub_catlist.clear();
      getfiltercode();
      setState(() {
      });
    }
  }
  // 서브카테고리
  void _onSubSelected(bool selected, String dataName) {
    if(check_sub_catlist.length  > 1) {
      // check_sub_catlist.clear();
    }
    check_detail_catlist.clear();
    allcheck_detail_catlist.clear();
    if (selected == true) {
      check_sub_catlist.add(dataName);
      getfiltercode();
      setState(() {
        print(check_sub_catlist);
      });
    } else {
      check_sub_catlist.remove(dataName);
      getfiltercode();
      setState(() {
        print(check_sub_catlist);
      });
    }
  }


  
  // 세부 카테고리
  Column filterinfo(String subtitle,context){
  
    return
      Column(
        children: [
/*          if(main_title_catcode == 'C101')
            Container(
            // height: 60 * (MediaQuery.of(context).size.height / 360),
            child: Column(
              children: [
                ExpansionTile(
                  // backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      // top: Radius.circular(25),
                    ),
                  ),
                  iconColor: Color(0xff0F1316),
                  textColor: Color(0xff0F1316),
                  collapsedIconColor: Color(0xff0F1316),
                  title: Text('아파트 내 편의시설',
                    style: TextStyle(
                      // color: Color(0xff151515),
                      fontWeight: FontWeight.bold,
                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                    ),
                  ),
                  initiallyExpanded: true,
                  children: [
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      // height: 50 * (MediaQuery.of(context).size.height / 360),
                      child: Wrap(
                        children: [
                          Container(
                              width: 175 * (MediaQuery.of(context).size.width / 360),
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container( child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    value: allcheck_detail_catlist.contains('C101'),
                                    // value: true,
                                    activeColor: Color(0xffE47421),
                                    checkColor: Colors.white,
                                    onChanged: (val) {
                                      _allDetailSelected(val!,'C101');
                                    },
                                  ),),
                                  Container(
                                    child: Text(
                                      "전체",
                                      style: TextStyle(

                                      ),
                                    ),
                                  ),
                                ]
                                ,)
                          ),
                          for(int m2=0; m2<sub_detail_catlist.length; m2++)
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Transform.scale(
                                        scale: 1,
                                        child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          side: BorderSide(
                                            color: Color(0xffC4CCD0),
                                            width: 2,
                                          ),
                                          value: check_detail_catlist.contains(sub_detail_catlist[m2]['idx']),
                                          // value: true,
                                          activeColor: Color(0xffE47421),
                                          checkColor: Colors.white,
                                          onChanged: (val) {
                                            _onDetailSelected(val!, sub_detail_catlist[m2]['idx']);
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                      child: Text(
                                        "${sub_detail_catlist[m2]['name']}",
                                        style: TextStyle(
                                            overflow: TextOverflow.clip
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),*/
          // if(gubun.contains(main_title_catcode) && main_title_catcode != 'C101')
            for(int i=0; i<sub_detail_catlist.length; i++)
            Container(
              // height: 60 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  ExpansionTile(
                    // backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        // top: Radius.circular(25),
                      ),
                    ),
                    iconColor: Color(0xff0F1316),
                    textColor: Color(0xff0F1316),
                    collapsedIconColor: Color(0xff0F1316),
                    title: Text('${sub_detail_catlist[i]['name']}',
                      style: TextStyle(
                        // color: Color(0xff151515),
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        // height: 50 * (MediaQuery.of(context).size.height / 360),
                        child: Wrap(
                          children: [
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container( child: Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      side: BorderSide(
                                        color: Color(0xffC4CCD0),
                                        width: 2,
                                      ),
                                      value: allcheck_detail_catlist.contains(sub_detail_catlist[i]['idx']),
                                      // value: true,
                                      activeColor: Color(0xffE47421),
                                      checkColor: Colors.white,
                                      onChanged: (val) {
                                        _allDetailSelected(val!,sub_detail_catlist[i]['idx']);
                                      },
                                    ),),
                                    Container(
                                      child: Text(
                                        "전체",
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),
                            for(int m2=0; m2<coderesult.length; m2++)
                              if(coderesult[m2]['pidx'] == sub_detail_catlist[i]['idx'])
                              Container(
                                  width: 175 * (MediaQuery.of(context).size.width / 360),
                                  height: 15 * (MediaQuery.of(context).size.height / 360),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Transform.scale(
                                          scale: 1,
                                          child: Checkbox(
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: BorderSide(
                                              color: Color(0xffC4CCD0),
                                              width: 2,
                                            ),
                                            value: check_detail_catlist.contains(coderesult[m2]['idx']),
                                            // value: true,
                                            activeColor: Color(0xffE47421),
                                            checkColor: Colors.white,
                                            onChanged: (val) {
                                              _onDetailSelected(val!, coderesult[m2]['idx']);
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                        child: Text(
                                          "${coderesult[m2]['name']}",
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                        ),
                                      ),
                                    ]
                                    ,)
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      )
    ;
  }


  // 세부카테고리
  void _allDetailSelected(bool selected, String dataName) {
    if (selected == true) {
      allcheck_detail_catlist.add(dataName);
      print(allcheck_detail_catlist);
      for(var m2=0; m2<coderesult.length; m2++) {
        if(coderesult[m2]['pidx'] == dataName) {
          check_detail_catlist.add(coderesult[m2]['idx']);
        }
      }
      setState(() {
      });
    } else {
      allcheck_detail_catlist.remove(dataName);
      coderesult.forEach((element) {
        if(element['pidx'] == dataName){
          // check_detail_catlist.remove(element['idx']);
          check_detail_catlist.removeWhere((item) => item == element['idx']);
        }
      });
      // check_detail_catlist.clear();
      setState(() {
      });
    }
  }
  // 세부카테고리
  void _onDetailSelected(bool selected, String dataName) {
    if (selected == true) {
      check_detail_catlist.add(dataName);
      setState(() {
        print(check_detail_catlist);
      });
    } else {
      check_detail_catlist.remove(dataName);
      setState(() {
        print(check_detail_catlist);
      });
    }
  }

  Column filterinfo2(String subtitle,context){

    return
      Column(
        children: [
/*          if(main_title_catcode == 'C101')
            Container(
            // height: 60 * (MediaQuery.of(context).size.height / 360),
            child: Column(
              children: [
                ExpansionTile(
                  // backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      // top: Radius.circular(25),
                    ),
                  ),
                  iconColor: Color(0xff0F1316),
                  textColor: Color(0xff0F1316),
                  collapsedIconColor: Color(0xff0F1316),
                  title: Text('아파트 내 편의시설',
                    style: TextStyle(
                      // color: Color(0xff151515),
                      fontWeight: FontWeight.bold,
                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                    ),
                  ),
                  initiallyExpanded: true,
                  children: [
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      // height: 50 * (MediaQuery.of(context).size.height / 360),
                      child: Wrap(
                        children: [
                          Container(
                              width: 175 * (MediaQuery.of(context).size.width / 360),
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container( child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    value: allcheck_detail_catlist.contains('C101'),
                                    // value: true,
                                    activeColor: Color(0xffE47421),
                                    checkColor: Colors.white,
                                    onChanged: (val) {
                                      _allDetailSelected(val!,'C101');
                                    },
                                  ),),
                                  Container(
                                    child: Text(
                                      "전체",
                                      style: TextStyle(

                                      ),
                                    ),
                                  ),
                                ]
                                ,)
                          ),
                          for(int m2=0; m2<sub_detail_catlist.length; m2++)
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Transform.scale(
                                        scale: 1,
                                        child: Checkbox(
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          side: BorderSide(
                                            color: Color(0xffC4CCD0),
                                            width: 2,
                                          ),
                                          value: check_detail_catlist.contains(sub_detail_catlist[m2]['idx']),
                                          // value: true,
                                          activeColor: Color(0xffE47421),
                                          checkColor: Colors.white,
                                          onChanged: (val) {
                                            _onDetailSelected(val!, sub_detail_catlist[m2]['idx']);
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                      child: Text(
                                        "${sub_detail_catlist[m2]['name']}",
                                        style: TextStyle(
                                            overflow: TextOverflow.clip
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),*/
          // if(gubun.contains(main_title_catcode) && main_title_catcode != 'C101')
          for(int i=0; i<sub_detail_catlist.length; i++)
            Container(
              // height: 60 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  ExpansionTile(
                    // backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        // top: Radius.circular(25),
                      ),
                    ),
                    iconColor: Color(0xff0F1316),
                    textColor: Color(0xff0F1316),
                    collapsedIconColor: Color(0xff0F1316),
                    title: Text('${sub_detail_catlist[i]['name']}',
                      style: TextStyle(
                        // color: Color(0xff151515),
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        // height: 50 * (MediaQuery.of(context).size.height / 360),
                        child: Wrap(
                          children: [
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container( child: Checkbox(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      side: BorderSide(
                                        color: Color(0xffC4CCD0),
                                        width: 2,
                                      ),
                                      value: allcheck_detail_catlist.contains(sub_detail_catlist[i]['idx']),
                                      // value: true,
                                      activeColor: Color(0xffE47421),
                                      checkColor: Colors.white,
                                      onChanged: (val) {
                                        _allDetailSelected(val!,sub_detail_catlist[i]['idx']);
                                      },
                                    ),),
                                    Container(
                                      child: Text(
                                        "전체",
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),
                            for(int m2=0; m2<coderesult.length; m2++)
                              if(coderesult[m2]['pidx'] == sub_detail_catlist[i]['idx'])
                                Container(
                                    width: 175 * (MediaQuery.of(context).size.width / 360),
                                    height: 15 * (MediaQuery.of(context).size.height / 360),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Transform.scale(
                                            scale: 1,
                                            child: Checkbox(
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              side: BorderSide(
                                                color: Color(0xffC4CCD0),
                                                width: 2,
                                              ),
                                              value: check_detail_catlist.contains(coderesult[m2]['idx']),
                                              // value: true,
                                              activeColor: Color(0xffE47421),
                                              checkColor: Colors.white,
                                              onChanged: (val) {
                                                _onDetailSelected(val!, coderesult[m2]['idx']);
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text(
                                            "${coderesult[m2]['name']}",
                                            style: TextStyle(
                                                overflow: TextOverflow.clip,
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                            ),
                                          ),
                                        ),
                                      ]
                                      ,)
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      )
    ;
  }


}