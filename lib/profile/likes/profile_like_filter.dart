import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../categorymenu/providers/living_provider.dart';
import '../profile_like.dart';



class ProfileLikeFilter extends StatefulWidget {
  final List<String> getcheck_detail_catlist;
  final List<dynamic> getcheck_detail_table_nm;
  const ProfileLikeFilter({Key? key,
    required this.getcheck_detail_catlist,
    required this.getcheck_detail_table_nm,
  }) : super(key:key);
  @override
  _ProfileLikeFilter createState() => _ProfileLikeFilter();
}



class _ProfileLikeFilter extends State<ProfileLikeFilter>{

  //보여줄 필터 리스트
  List<String> viewcode = ['C1','D2','E1'];
  List<String> viewtitlecode = ['Living Information','Community'];

  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> sub_catlist = []; // 서브 카테고리 리스트

  // 검색을 위해 담긴 체크리스트
  List<String> allcheck_sub_catlist = []; // 서브카테고리 all
  List<String> check_sub_catlist = []; // 서브카테고리 체크
  List<String> allcheck_detail_catlist = []; // 세부카테고리 all
  List<String> check_detail_catlist = []; // 세부카테고리 체크

  List<dynamic> check_detail_table_nm = []; //선택된 테이블nm

  var title_catcode = ''; // 신규 좋아요 필터 타이틀코드

  String sub_cattitle = '';

  var is_checked = false;


  // 공통코드 호출
  Future<dynamic> setcode() async {

    //코드 전체리스트 가져오기
    sub_catlist = await livingProvider().getcodedata();

    sub_catlist.forEach((value) {
      if(value['pidx'] == 'LIKE_PAGE'){
        coderesult.add(value);
      }
    });

  }


  @override
  void initState() {
    super.initState();
    check_sub_catlist.addAll(widget.getcheck_detail_catlist);
    check_detail_table_nm.addAll(widget.getcheck_detail_table_nm);
    if(check_sub_catlist.length > 0) {
      check_sub_catlist.forEach((element) {
        title_catcode = element;
      });
    }
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
          IconButton(icon: Icon(Icons.close_rounded),color: Colors.black,alignment: Alignment.centerRight,iconSize: 26,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: makefilter('',context),
      ),
      bottomNavigationBar:
      Container(
        width: 340 * (MediaQuery.of(context).size.width / 360),
        height: 60 * (MediaQuery.of(context).size.height / 360),
        margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
    /*                  if(check_sub_catlist.length > 0) {
                        check_detail_table_nm.add("LIVING_INFO");
                      }*/
                      return Profile_like(check_detail_catlist : [], /*check_detail_table_nm: check_detail_table_nm,*/ title_catcode: title_catcode, check_sub_catlist: [], check_detail_arealist: [],);
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
                  check_detail_table_nm.clear();
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
                  subcatinfo(subtitle,context), // 공통
                  // subcatinfo2(subtitle,context), // 커뮤니티
                  // filterinfo(subtitle,context), // 세부카테고리
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  ),

                ],
              ),
            ),


          ]
      );
  }

  Column subcatinfo(String subtitle,context){

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
                  title: Text("좋아요",
                    style: TextStyle(
                      // color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      fontFamily: 'NanumSquareR',
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
                        /*  Container(
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
                                    value: allcheck_sub_catlist.contains("C1"),
                                    // value: true,
                                    activeColor: Color(0xffE47421),
                                    checkColor: Colors.white,
                                    onChanged: (val) {
                                      _allSubSelected(val!,"C1");
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
                          ),*/
                          for(int m2=0; m2<coderesult.length; m2++)
                            if(check_detail_table_nm.contains(coderesult[m2]['cidx']))
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
                                          value: check_sub_catlist.contains(coderesult[m2]['cidx']),
                                          // value: true,
                                          activeColor: Color(0xffE47421),
                                          checkColor: Colors.white,
                                          onChanged: (val) {
                                            if(title_catcode != '') {
                                              is_checked = true;
                                            } else {
                                              is_checked = false;
                                            }
                                            _onSubSelected(val!, coderesult[m2]['cidx']);
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

  Column subcatinfo2(String subtitle,context){

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
                    title: Text("커뮤니티",
                      style: TextStyle(
                        // color: Colors.black87,
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
                          /*  Container(
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
                                        "All",
                                        style: TextStyle(

                                        ),
                                      ),
                                    ),
                                  ]
                                  ,)
                            ),*/
                            for(int m2=0; m2<coderesult.length; m2++)
                              if(coderesult[m2]['idx'] == 'USED_TRNSC')...[
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
                                              value: check_detail_table_nm.contains(coderesult[m2]['idx']),
                                              // value: true,
                                              activeColor: Color(0xffE47421),
                                              checkColor: Colors.white,

                                              onChanged: (val) {
                                                _onSubSelected2(val!, coderesult[m2]['idx']);
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text(
                                            "${coderesult[m2]['name']}",
                                            style: TextStyle(
                                                overflow: TextOverflow.clip
                                            ),
                                          ),
                                        ),
                                      ]
                                      ,)
                                ),
                              ]
                              else if(coderesult[m2]['idx'] == 'PERSONAL_LESSON')...[
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
                                              value: check_detail_table_nm.contains(coderesult[m2]['idx']),
                                              // value: true,
                                              activeColor: Color(0xffE47421),
                                              checkColor: Colors.white,

                                              onChanged: (val) {
                                                _onSubSelected2(val!, coderesult[m2]['idx']);
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text(
                                            "${coderesult[m2]['name']}",
                                            style: TextStyle(
                                                overflow: TextOverflow.clip
                                            ),
                                          ),
                                        ),
                                      ]
                                      ,)
                                ),
                              ]
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
    if (selected == true) {
      allcheck_sub_catlist.add(dataName);
      for(var m2=0; m2<coderesult.length; m2++) {
        if(coderesult[m2]['pidx'] == dataName) {
          check_sub_catlist.add(coderesult[m2]['idx']);
        }
      }
      setState(() {
      });
    } else {
      allcheck_sub_catlist.remove(dataName);
      check_sub_catlist.clear();
      setState(() {
      });
    }
  }
  // 서브카테고리
  void _onSubSelected(bool selected, String dataName) {
    check_sub_catlist.clear();
    title_catcode = '';
    if (selected == true) {
      check_sub_catlist.add(dataName);
      title_catcode = dataName;
      setState(() {
        print(check_sub_catlist);
      });
    } /*else {
      check_sub_catlist.remove(dataName);
      setState(() {
        print(check_sub_catlist);
      });
    }*/
  }
  // 서브 테이블n_m
  void _allSubSelected2(bool selected, String dataName) {
    if (selected == true) {
      allcheck_sub_catlist.add(dataName);
      for(var m2=0; m2<sub_catlist.length; m2++) {
        check_sub_catlist.add(sub_catlist[m2]['idx']);
      }
      setState(() {
      });
    } else {
      allcheck_sub_catlist.remove(dataName);
      check_sub_catlist.clear();
      setState(() {
      });
    }
  }
  // 서브 테이블n_m
  void _onSubSelected2(bool selected, String dataName) {
    if (selected == true) {
      check_detail_table_nm.add(dataName);
      setState(() {
        print(check_sub_catlist);
      });
    } else {
      check_detail_table_nm.remove(dataName);
      setState(() {
        print(check_sub_catlist);
      });
    }
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
      check_detail_catlist.clear();
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

}