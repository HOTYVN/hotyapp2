import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/likes/profile_like_filter.dart';
import 'package:hoty/profile/profile_mypost_filter.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../categorymenu/providers/living_provider.dart';
import '../common/Nodata.dart';
import '../common/dialog/commonAlert.dart';
import '../common/icons/my_icons.dart';
import '../community/dailytalk/community_dailyTalk_view.dart';
import '../community/privatelesson/lesson_view.dart';
import '../community/usedtrade/trade_view.dart';
import '../kin/kin_view.dart';
import '../main/layout/page_type5.dart';
import 'customer/profile_customer_service_detail.dart';

class Profile_my_post extends StatefulWidget {
  final String table_nm;
  final String category;

  const Profile_my_post({Key? key,
    required this.table_nm,
    required this.category,
  }) : super(key:key);

  @override
  State<Profile_my_post> createState() => _Profile_my_postState();
}

class _Profile_my_postState extends State<Profile_my_post> {
  final storage = FlutterSecureStorage();
  var urlpath = 'http://www.hoty.company';

  String? reg_id;
  var keyword = "";
  List<String> viewtitlecode = ['Living Information','Community'];

  var _sortvalue = "";
  List<dynamic> list = [];
  List<dynamic> coderesult = []; // 공통코드 리스트

  List<dynamic> coderesult1 = []; // 공통코드 리스트
  List<dynamic> Categorycoderesult = [];
  List<dynamic> lessoncoderesult = [];

  List<dynamic> codeOrgResult = [];

  var _selectCate = 'KIN';
  var mainCategory = 'KIN';

  final TextEditingController _keyword = TextEditingController();

  Widget _Nodata = Container();

  @override
  void initState() {
    super.initState();

    print("AA : " + widget.table_nm);
    print("BB : " + widget.category);
    if(widget.table_nm != null && widget.table_nm != '') {
      mainCategory = widget.table_nm;
      _selectCate = widget.table_nm;
    }

    if(widget.category != null && widget.category != '') {
      _selectCate = widget.category;
    }

    //WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getMypostCategory().then((_) {
          getcodedata().then((_) {
            getBoardList().then((_) {
              _Nodata = Nodata();
              setState(() {
              });
            });
          });
        });
      });
    //});

  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }
  // 공통코드 호출
  Future<dynamic> getcodedata() async {
    print('code list');
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
    );
    try {
      Map data = {
         //"pidx": "MENU_CATEGORY",
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if(response.statusCode == 200) {
        // 전체코드
        codeOrgResult = json.decode(response.body)['result'];

        print("Categorycoderesult.length ${Categorycoderesult.length}");
        if(Categorycoderesult.length > 0) {
          for(int i = 0 ; i < Categorycoderesult.length - 1; i++) {
            if (Categorycoderesult[i]["TABLE_NM"] != null && Categorycoderesult[i]["TABLE_NM"] != '') {
              if (Categorycoderesult[i]["TABLE_NM"] == "ON_SITE") {
                Categorycoderesult.removeAt(i);
              }
              if (Categorycoderesult[i]["TABLE_NM"] == "INTRP_SRVC") {
                Categorycoderesult.removeAt(i);
              }
              if (Categorycoderesult[i]["TABLE_NM"] == "AGENCY_SRVC") {
                Categorycoderesult.removeAt(i);
              }
              if (Categorycoderesult[i]["TABLE_NM"] == "REAL_ESTATE") {
                Categorycoderesult.removeAt(i);
              }
              if (Categorycoderesult[i]["TABLE_NM"] == "REAL_ESTATE_INTRP_SRVC") {
                Categorycoderesult.removeAt(i);
              }
            }
          }
        }

        int KIN_CHK = 0;
        for(int i = 0 ; i < Categorycoderesult.length; i++) {
          for(int j = 0; j <codeOrgResult.length; j++) {
            if(Categorycoderesult[i]["TABLE_NM"] == "KIN") {
              if (Categorycoderesult[i]["TABLE_NM"] == codeOrgResult[j]["idx"]) {
                if(KIN_CHK == 0) {
                  coderesult1.add(codeOrgResult[j]);
                  KIN_CHK = 1;
                  setState(() {

                  });
                }
              }
            }
          }
        }

        for(int i = 0 ; i < Categorycoderesult.length; i++) {
          for(int j = 0; j <codeOrgResult.length; j++) {
            if(Categorycoderesult[i]["TABLE_NM"] == "DAILY_TALK") {
              if(Categorycoderesult[i]["MAIN_CATEGORY"] == codeOrgResult[j]["idx"]) {
                coderesult1.add(codeOrgResult[j]);
              }
            }
          }
        }

        int USED_TRNSC_CHK = 0;
        for(int i = 0 ; i < Categorycoderesult.length; i++) {
          for(int j = 0; j <codeOrgResult.length; j++) {
            if(Categorycoderesult[i]["TABLE_NM"] == "USED_TRNSC") {
              if (Categorycoderesult[i]["TABLE_NM"] == codeOrgResult[j]["idx"]) {
                if(USED_TRNSC_CHK == 0) {
                  coderesult1.add(codeOrgResult[j]);
                  USED_TRNSC_CHK = 1;
                  setState(() {

                  });
                }
              }
            }
          }
        }

        int PERSONAL_LESSON_CHK = 0;
        for(int i = 0 ; i < Categorycoderesult.length; i++) {
          for(int j = 0; j <codeOrgResult.length; j++) {
            if(Categorycoderesult[i]["TABLE_NM"] == "PERSONAL_LESSON") {
              if (Categorycoderesult[i]["TABLE_NM"] == codeOrgResult[j]["idx"]) {
                if(PERSONAL_LESSON_CHK == 0) {
                  coderesult1.add(codeOrgResult[j]);
                  PERSONAL_LESSON_CHK = 1;
                  setState(() {

                  });
                }
              }
            }
          }
        }

        if(coderesult1.length > 0) {
          if(widget.category == null || widget.category == '') {
            _selectCate = coderesult1[0]["idx"];
          }
        }


        print(">>");
        for(int i = 0; i < codeOrgResult.length; i++) {
          if(codeOrgResult[i]['pidx'] == 'MENU_CATEGORY') {
            coderesult.add(codeOrgResult[i]);
          }
        }
        for(int i = 0; i < codeOrgResult.length; i++) {
          if(codeOrgResult[i]['pidx'] == 'F1') {
            coderesult.add(codeOrgResult[i]);
          }
        }

        for(int i = 0; i < codeOrgResult.length; i++) {
          if(codeOrgResult[i]['pidx'] == 'E1') {

            lessoncoderesult.add(codeOrgResult[i]);
          }
        }




        print(codeOrgResult);
        print('##');
        print(Categorycoderesult);
        print(coderesult1);
        /*_selectCate = coderesult[0]['idx'];*/
        print(_selectCate);
        setState(() {
          getBoardList();
        });
      }


    }
    catch(e){
      print(e);
    }
    return coderesult;

  }


  Future<dynamic> getBoardList() async {
    print('board list $_selectCate');
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberHotyBoard.do',
      //'http://192.168.100.31:8080/mf/member/getMemberHotyBoard.do',
    );
    print('mainCategory');
    print(mainCategory);

    try {
      var selectCateVal;
      if(_selectCate == 'F101' || _selectCate == 'F102' || _selectCate == 'F103' || _selectCate == 'F104') {
        selectCateVal = 'DAILY_TALK';
        mainCategory = _selectCate;
      } else {
        selectCateVal = _selectCate;
        mainCategory = '';
      }

      Map data = {
        "memberId": reg_id,
        "keyword": _keyword.text,
        "sort_nm": _sortvalue,
        "tableNm": selectCateVal,
        "mainCategory": mainCategory
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if(json.decode(response.body)['state'] == 200) {
        setState(() {
          list = json.decode(response.body)['result']['boardList'];
        });
      }

    }catch(e) {
      print(e);
    }

  }

  Future<dynamic> getMypostCategory() async {
    print('board list $_selectCate');
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMypostCategory.do',
      //'http://192.168.100.31:8080/mf/member/getMemberHotyBoard.do',
    );
    print('mainCategory');
    print(mainCategory);

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
          Categorycoderesult = json.decode(response.body)['result']["getMypostCategory"];
        });
      }

    }catch(e) {
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
        child : Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(28 * (MediaQuery.of(context).size.height / 360),),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppBar(
                    titleSpacing: 0,
                    leadingWidth: 40,
                    toolbarHeight: 28 * (MediaQuery.of(context).size.height / 360),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    // titleSpacing: 10 * (MediaQuery.of(context).size.width / 360),
                    automaticallyImplyLeading: true,
                    /*iconTheme: IconThemeData(
            color: Colors.black,
          ),*/
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_rounded),
                      iconSize: 12 * (MediaQuery.of(context).size.height / 360),
                      color: Color(0xff151515),
                      alignment: Alignment.centerLeft,
                      // padding: EdgeInsets.zero,
                      // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
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
                    title:Container(
                      height: 18 * (MediaQuery.of(context).size.height / 360),
                      margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                        color: Color(0xffF3F6F8),
                      ),
                      child: TextField(
                        controller: _keyword,
                        decoration: InputDecoration(
                          isDense: true,
                            contentPadding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                            border: InputBorder.none,
                            hintText: '검색 할 키워드를 입력 해주세요',
                            hintStyle: TextStyle(
                              color:Color(0xffC4CCD0),
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            ),
                            suffixIcon: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 1 * (MediaQuery.of(context).size.width / 360), 0),
                              child: IconButton(
                                icon: Icon(Icons.search_rounded,
                                  color: Colors.black, size: 11 * (MediaQuery.of(context).size.height / 360),
                                ),
                                onPressed: () {
                                  list.clear();
                                  getBoardList().then((_) {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                    });
                                  });
                                },
                              ),
                            )
                        ),
                        textInputAction: TextInputAction.go,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (text) {
                          setState(() {
                            keyword = text;
                            // print(keyword);
                          });
                        },
                        style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                      ),
                    ),
                    // centerTitle: false,
                  ),
                ],
              )
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              // height: 16 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
              padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              //alignment: Alignment.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: cat(context),
              ),

            ),
            if(list.length > 0)
            Listtitle(context), // 타이틀
            makeList(context),
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
      bottomNavigationBar: Footer(nowPage: 'My_page'),
      )
    );
  }
  Container makeList(context){
    print('makeList');
    return Container(
      child: Column(
        children: [
          if(list.length == 0)
            _Nodata,
          if(_selectCate == 'USED_TRNSC')
            makeTrnsc(),
          if(_selectCate != 'USED_TRNSC')
          for(var i = 0; i < list.length; i++)
            makeItem(list[i])
        ],
      ),
    );
  }
  Widget makeItem(dynamic item){
    if(item['TABLE_NM'] == 'KIN') {
      return Column(
        children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return KinView(
                      article_seq: item['ARTICLE_SEQ'],
                      table_nm: item['TABLE_NM'],
                      adopt_chk: item["ADOPT_CHK"],);
                  },
                ));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Image(
                              image: AssetImage("assets/question.png"),
                              color: Color(0xffE47421),
                              width: 25 * (MediaQuery.of(context).size.width / 360),),
                          ),
                          Container(
                            width: 300 * (MediaQuery.of(context).size.width / 360),
                            margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            child: Wrap(
                              children: [
                                Text("${item["TITLE"]}",
                                  style: TextStyle(
                                    fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'NanumSquareR',
                                    height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                    if(item["ADOPT_COMMENT_CONTS"] != null && item["ADOPT_COMMENT_CONTS"] != '')
                      Container(
                          width: 360 * (MediaQuery.of(context).size.width / 360),
                          margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360)),
                          padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffE6E8E9)
                            ),
                            borderRadius: BorderRadius.circular(
                                3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(
                                    "${item["ADOPT_COMMENT_CONTS"]}"
                                    , style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${item["ADOPT_COMMENT_REG_NM"]} ",
                                        style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff151515),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                      Icon(My_icons.rate,
                                        color: item['ADOPT_COMMENT_GROUP_SEQ'] == '4' ? Color(0xff27AE60):
                                        item['ADOPT_COMMENT_GROUP_SEQ'] == '5' ? Color(0xff27AE60) :
                                        item['ADOPT_COMMENT_GROUP_SEQ'] == '6' ? Color(0xffFBCD58) :
                                        item['ADOPT_COMMENT_GROUP_SEQ'] == '7' ? Color(0xffE47421) :
                                        item['ADOPT_COMMENT_GROUP_SEQ'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
                                        size: 12 * (MediaQuery.of(context).size.width / 360),),
                                      Container(
                                          width: 5 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(
                                              5 * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text("•", style: TextStyle(
                                            color: Color(0xff4E4E4E),
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          ),)
                                      ),
                                      Text("${item["ADOPT_COMMENT_REG_DT"]}",
                                        style: TextStyle(
                                          fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                      Container(
                                          width: 5 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(
                                              5 * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text("•", style: TextStyle(
                                            color: Color(0xff4E4E4E),
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          ),)
                                      ),
                                      Text("${getSubcodename(item["MAIN_CATEGORY"])}",
                                        style: TextStyle(
                                          fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                      )
                    else if(item["COMMENT_CONTS"] != null && item["COMMENT_CONTS"] != '')
                      Container(
                          width: 360 * (MediaQuery.of(context).size.width / 360),
                          margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360)),
                          padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffE6E8E9)
                            ),
                            borderRadius: BorderRadius.circular(
                                3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(
                                    "${item["COMMENT_CONTS"]}"
                                    , style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${item["COMMENT_REG_NM"]} ",
                                        style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff151515),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                      Icon(My_icons.rate,
                                        color: item['COMMENT_GROUP_SEQ'] == '4' ? Color(0xff27AE60):
                                        item['COMMENT_GROUP_SEQ'] == '5' ? Color(0xff27AE60) :
                                        item['COMMENT_GROUP_SEQ'] == '6' ? Color(0xffFBCD58) :
                                        item['COMMENT_GROUP_SEQ'] == '7' ? Color(0xffE47421) :
                                        item['COMMENT_GROUP_SEQ'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
                                        size: 12 * (MediaQuery.of(context).size.width / 360),),
                                      Container(
                                          width: 5 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(
                                              5 * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text("•", style: TextStyle(
                                            color: Color(0xff4E4E4E),
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          ),)
                                      ),
                                      Text("${item["COMMENT_REG_DT"]}",
                                        style: TextStyle(
                                          fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                      Container(
                                          width: 5 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(
                                              5 * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text("•", style: TextStyle(
                                            color: Color(0xff4E4E4E),
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          ),)
                                      ),
                                      Text("${getSubcodename(item["MAIN_CATEGORY"])}",
                                        style: TextStyle(
                                          fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                      )
                    else
                      Container(
                          width: 360 * (MediaQuery.of(context).size.width / 360),
                          margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360)),
                          padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffE6E8E9)
                            ),
                            borderRadius: BorderRadius.circular(
                                3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(
                                    "${item["CONTS"]}"
                                    , style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${item["REG_NM"]} ",
                                        style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff151515),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                      Icon(My_icons.rate,
                                        color: item['GROUP_SEQ'] == '4' ? Color(0xff27AE60):
                                        item['GROUP_SEQ'] == '5' ? Color(0xff27AE60) :
                                        item['GROUP_SEQ'] == '6' ? Color(0xffFBCD58) :
                                        item['GROUP_SEQ'] == '7' ? Color(0xffE47421) :
                                        item['GROUP_SEQ'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
                                        size: 12 * (MediaQuery.of(context).size.width / 360),),
                                      Container(
                                          width: 5 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(
                                              5 * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text("•", style: TextStyle(
                                            color: Color(0xff4E4E4E),
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          ),)
                                      ),
                                      Text("${item["REG_DT"]}",
                                        style: TextStyle(
                                          fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                      Container(
                                          width: 5 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(
                                              5 * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text("•", style: TextStyle(
                                            color: Color(0xff4E4E4E),
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          ),)
                                      ),
                                      Text("${getSubcodename(item["MAIN_CATEGORY"])}",
                                        style: TextStyle(
                                          fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0),
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                    Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                  ],
                ),
              ),
            )
        ],
      );
    } else if(item['TABLE_NM'] == 'ON_SITE' || item['TABLE_NM'] == 'INTRP_SRVC' || item['TABLE_NM'] == 'AGENCY_SRVC' || item['TABLE_NM'] == 'REAL_ESTATE_INTRP_SRVC')  {
      return Container(
        child: Column(
            children: [GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileServiceHistoryDetail(idx: item['ARTICLE_SEQ']);
                  },
                ));
              },
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 50 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      child: Image(image: AssetImage("assets/repair.png")),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      width: 260 * (MediaQuery.of(context).size.width / 360),
                      height: 40 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            child: Row(
                              children: [
                                Container(
                                  width: 230 * (MediaQuery.of(context).size.width / 360),
                                  child: Text(item['TABLE_NM'] == 'ON_SITE' ? '출장 서비스' : item['TABLE_NM'] == 'INTRP_SRVC' ? "24시 긴급 출장통역서비스" : item['TABLE_NM'] == 'AGENCY_SRVC' ? "비자서비스": "부동산통역서비스",
                                    style: TextStyle(
                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 30 * (MediaQuery.of(context).size.width / 360),
                                  child:Image(image: AssetImage(
                                      item['CAT01'] == 'SRVE_001' ? 'assets/complete_color.png' : item['CAT01'] == 'SRVE_002' ? 'assets/progress_color.png' : item['CAT01'] == 'SRVE_003' ? 'assets/soldout_color.png' : 'assets/canceled_color.png'
                                  ),width: 30 * (MediaQuery.of(context).size.width / 360),height: 30 * (MediaQuery.of(context).size.height / 360),),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10 * (MediaQuery.of(context).size.height / 360),
                            child: Text(item['CONTS'],
                              style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  color: Color(0xff0F1316),
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                          Container(
                            height: 10 * (MediaQuery.of(context).size.height / 360),
                            child: Text(
                              item['ETC02'] + " VND",
                              style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.bold,
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
              Container(
                height: 20 * (MediaQuery.of(context).size.height / 360),
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Row(
                  children: [
                    Container(
                      width: 200 * (MediaQuery.of(context).size.width / 360),
                      child: Text("ID: " + item['ETC09'],
                        style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff0F1316)
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                        textAlign: TextAlign.left,),
                    ),
                    Container(
                      width: 120 * (MediaQuery.of(context).size.width / 360),
                      child: Text(item['REG_DT'],
                        style: TextStyle(
                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(196, 204, 208, 1)
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                        textAlign: TextAlign.right,),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 5, height: 7 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
          ],
        ),
      );
    } else if(item['TABLE_NM'] == 'USED_TRNSC') {
      return Container(
      );
    } else if(item['TABLE_NM'] == 'PERSONAL_LESSON') {
      return Container(
        padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360),
            10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                if(item['CAT02'] == 'E201') {
                  showDialog(context: context,
                      barrierColor: Color(0xffE47421).withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                          child: textalert(context,'검토중인 게시물입니다.'),
                        );
                      }
                  );
                } else if(item['CAT02'] == 'E203') {
                  showDialog(context: context,
                      barrierColor: Color(0xffE47421).withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                          child: deletechecktext2(context,'블라인드 처리 된 게시물입니다.', '1:1문의하기', '확인'),
                        );
                      }
                  ).then((value) {
                    if(value == false) {
                      _launchURL("http://pf.kakao.com/_gYrxnG");

                    }
                  });
                } else {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return LessonView(article_seq: item['ARTICLE_SEQ'], table_nm : item['TABLE_NM'], params: {}, checkList: [],);
                    },
                  ));
                }
              },
              child: Container(
                width: 150 * (MediaQuery.of(context).size.width / 360),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: item['MAIN_IMG'] != null &&  item['MAIN_IMG'] != '' ? DecorationImage(
                          image: CachedNetworkImageProvider('$urlpath${item['MAIN_IMG_PATH']}${item['MAIN_IMG']}'),
                          fit: BoxFit.cover
                      ) : DecorationImage(
                          image: AssetImage('assets/noimage.png'),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                0 , 0 ),
                            decoration: BoxDecoration(
                              color: Color(0xff27AE60),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            child:Row(
                              children: [
                                Container(
                                  padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3,
                                      6 * (MediaQuery.of(context).size.width / 360) , 3 ),
                                  child: Text(getSubcodename(item['MAIN_CATEGORY']),
                                    style: TextStyle(
                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                            margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360), 6 * (MediaQuery.of(context).size.width / 360), 0),
                            // width: 40 * (MediaQuery.of(context).size.width / 360),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                              shape: BoxShape.circle,
                            ),
                            child:Row(
                              children: [
                                if(item['LIKE_YN'] != null && item['LIKE_YN'] > 0)
                                  GestureDetector(
                                    onTap: () {
                                      //_isLiked(true, item["ARTICLE_SEQ"], item["TABLE_NM"], item["TITLE"], i);
                                    },
                                    child : Container(
                                      padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                        4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                      child: Icon(Icons.favorite, color: Color(0xffE47421), size: 15 , ),
                                    ),
                                  ),
                                if(item['LIKE_YN'] == null || item['LIKE_YN'] == 0)
                                  GestureDetector(
                                    onTap: () {
                                      //_isLiked(false, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
                                    },
                                    child : Container(
                                      padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                        4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                      child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 15 , ),
                                    ),
                                  ),
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 190 * (MediaQuery.of(context).size.width / 360),
              // height: 50 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      if(item['CAT02'] == 'E201') {
                        showDialog(context: context,
                            barrierColor: Color(0xffE47421).withOpacity(0.4),
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                child: textalert(context,'검토중인 게시물입니다.'),
                              );
                            }
                        );
                      } else if(item['CAT02'] == 'E203') {
                        showDialog(context: context,
                            barrierColor: Color(0xffE47421).withOpacity(0.4),
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                child: deletechecktext2(context,'블라인드 처리 된 게시물입니다.', '1:1문의하기', '확인'),
                              );
                            }
                        ).then((value) {
                          if(value == false) {
                            _launchURL("http://pf.kakao.com/_gYrxnG");
                          }
                        });
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LessonView(article_seq: item['ARTICLE_SEQ'], table_nm : item['TABLE_NM'], params: {}, checkList: [],);
                          },
                        ));
                      }

                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      // height: 25 * (MediaQuery.of(context).size.height / 360),
                      child: Text(
                        '${item['TITLE']}',
                        style: TextStyle(
                          fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth : 190 * (MediaQuery.of(context).size.width / 360)),
                    margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360),
                        0, 0 * (MediaQuery.of(context).size.height / 360)),
                    /*width: 340 * (MediaQuery.of(context).size.width / 360),*/
                    // height: 10 * (MediaQuery.of(context).size.height / 360),
                    child:Row(
                      children: [
                        Container(
                          child: Text(
                            "후기",
                            style: TextStyle(
                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                              // color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NanumSquareR',
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                          child: Text(
                            "${item['RATING_CNT']}",
                            style: TextStyle(
                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black54,
                              overflow: TextOverflow.ellipsis,
                              // fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                          child: Row(
                            children: [
                              RatingBarIndicator(
                                unratedColor: Color(0xffC4CCD0),
                                rating: item['RATING_CNT'] ?? 0,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                direction: Axis.horizontal,
                              ),
                              Container(
                                margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0.5 * (MediaQuery.of(context).size.height / 360)),
                                child: Text(
                                  "(${item['RATING_COUNT']})",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    color: Colors.black54,
                                    overflow: TextOverflow.ellipsis,
                                    // fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360),
                        0, 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text(
                      getVND(item['ETC01']),
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                  ),
                  Container(
                    // width: 340 * (MediaQuery.of(context).size.width / 360),
                    // height: 15 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360),
                        3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                    // color: Colors.purpleAccent,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 10 * (MediaQuery.of(context).size.height / 360),
                            // width: 340 * (MediaQuery.of(context).size.width / 360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  // width: 70 * (MediaQuery.of(context).size.width / 360),
                                    child: Row(
                                      children: [
                                        Icon(Icons.favorite, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                        Container(
                                          constraints: BoxConstraints(maxWidth : 70 * (MediaQuery.of(context).size.width / 360)),
                                          margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                          padding: EdgeInsets.fromLTRB(0, 0, 8 * (MediaQuery.of(context).size.width / 360), 0),
                                          child: Text(
                                            '${item['LIKE_CNT']}',
                                            style: TextStyle(
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              color: Color(0xff151515),
                                              overflow: TextOverflow.ellipsis,
                                              // fontWeight: FontWeight.bold,
                                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                DottedLine(
                                  lineThickness:1,
                                  dashLength: 2.0,
                                  dashColor: Color(0xffC4CCD0),
                                  direction: Axis.vertical,
                                ),
                                Container(
                                  // width: 70 * (MediaQuery.of(context).size.width / 360),
                                  padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                      Container(
                                        constraints: BoxConstraints(maxWidth : 70 * (MediaQuery.of(context).size.width / 360)),
                                        margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 8 * (MediaQuery.of(context).size.width / 360), 0),
                                        child: Text(
                                          '${item['VIEW_CNT']}',
                                          style: TextStyle(
                                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                            color: Color(0xff151515),
                                            overflow: TextOverflow.ellipsis,
                                            // fontWeight: FontWeight.bold,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                          textAlign: TextAlign.center,
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
          ],
        ),
      );
    } else if(item['TABLE_NM'] == 'DAILY_TALK') {
      return Container(
        child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CommunityDailyTalkView(article_seq : item['ARTICLE_SEQ'], table_nm : item['TABLE_NM'], main_catcode: '', params: {},);
                },
              ));
            },
            child: Container(
                width : 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                ),
                child : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width : 260 * (MediaQuery.of(context).size.width / 360),
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 18 * (MediaQuery.of(context).size.height / 360),
                              child : Text(
                                "${item["TITLE"] ?? ''}",
                                style: TextStyle(
                                  color: Color(0xff151515),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                  height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child : Row(
                                  children: [
                                    Container(
                                        width: 185 * (MediaQuery.of(context).size.width / 360),
                                        child : Row(
                                          children: [
                                            Text("${item["REG_DT"] ?? ''}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                            Text("  ·  ", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                            Text("${getSubcodename(item["MAIN_CATEGORY"])}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                          ],
                                        )
                                    ),
                                    Container(
                                        child : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 * (MediaQuery.of(context).size.width / 360) , ),
                                            Text(" ${item["LIKE_CNT"]}"),
                                            Container(
                                              width: 1 * (MediaQuery.of(context).size.width / 360),
                                              height : 8 * (MediaQuery.of(context).size.height / 360) ,
                                              margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                  4 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffF3F6F8)
                                                ),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                color: Color(0xffF3F6F8),
                                              ),
                                            ),
                                            Image(image: AssetImage("assets/comment_icon.png"),width: 14 * (MediaQuery.of(context).size.width / 360),color: Color(0xff5990E3),),
                                            Text(" ${item["COMMENT_CNT"]}"),
                                          ],
                                        )
                                    ),
                                  ],
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                      width : 60 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration(
                        image: item["MAIN_IMG"] != null ? DecorationImage(
                            image:  CachedNetworkImageProvider(urlpath+'${item["MAIN_IMG_PATH"]}${item["MAIN_IMG"]}'),
                            fit: BoxFit.cover
                        ) : DecorationImage(
                            image: AssetImage('assets/noimage.png'),
                            fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      ),
                    )
                  ],
                )
            )
        ),
      );
    } else {
      return Container(
        child: Container(
            child: Text('test')
        ),
      );
    }

  }

  Widget makeTrnsc() {
    return Column(
      children: [
        for(int i=0; i<list.length; i++)
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            // height: 65 * (MediaQuery.of(context).size.height / 360),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TradeView(article_seq: list[i]['ARTICLE_SEQ'], table_nm : list[i]['TABLE_NM'], params: {"history_dart" : "myPost"}, checkList: [],);
                            },
                          ));
                        },
                        child: Container(
                          width: 150 * (MediaQuery.of(context).size.width / 360),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                image: list[i]['MAIN_IMG'] != null &&  list[i]['MAIN_IMG'] != '' ?
                                DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFF151515).withOpacity(0.7),
                                      list[i]['CAT02'] == 'D202' || list[i]['CAT02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                    ),
                                    image: CachedNetworkImageProvider('$urlpath${list[i]['MAIN_IMG_PATH']}${list[i]['MAIN_IMG']}'),
                                    fit: BoxFit.cover
                                ) : DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFF151515).withOpacity(0.7),
                                      list[i]['CAT02'] == 'D202' || list[i]['CAT02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                    ),
                                    image: AssetImage('assets/noimage.png'),
                                    fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(list[i]['CAT02'] != 'D202' && list[i]['CAT02'] != 'D204')
                                    Container(
                                        margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            0 , 0 ),
                                        decoration: BoxDecoration(
                                          color:
                                          list[i]['CAT02'] == 'D201' ? Color(0xff53B5BB) :
                                          list[i]['CAT02'] == 'D202' ? Color(0xff925331) :
                                          list[i]['CAT02'] == 'D203' ? Color(0xffA6BB53) :
                                          Color(0xffCA3625) ,
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child:Row(
                                          children: [
                                            Container(
                                              padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3,
                                                  6 * (MediaQuery.of(context).size.width / 360) , 3 ),
                                              child: Text(getSubcodename(list[i]['CAT02']),
                                                style: TextStyle(
                                                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                  color: Colors.white,
                                                  // fontWeight: FontWeight.bold,
                                                  // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  if(list[i]['CAT02'] != 'D202' && list[i]['CAT02'] != 'D204')
                                    Container(
                                        margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360), 6 * (MediaQuery.of(context).size.width / 360), 0),
                                        // width: 40 * (MediaQuery.of(context).size.width / 360),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                          shape: BoxShape.circle,
                                        ),
                                        child:Row(
                                          children: [
                                            if(list[i]['LIKE_YN'] != null && list[i]['LIKE_YN'] > 0)
                                              GestureDetector(
                                                onTap: () {
                                                 // _isLiked(true, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
                                                },
                                                child : Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffE47421), size: 15 , ),
                                                ),
                                              ),
                                            if(list[i]['LIKE_YN'] == null || list[i]['LIKE_YN'] == 0)
                                              GestureDetector(
                                                onTap: () {
                                                  //_isLiked(false, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
                                                },
                                                child : Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 15 , ),
                                                ),
                                              ),
                                          ],
                                        )
                                    ),
                                  if(list[i]['CAT02'] == 'D202' || list[i]['CAT02'] == 'D204')
                                    Center(
                                        child : Container(
                                          margin : EdgeInsets.fromLTRB(44 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 9 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360), 9 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              border: Border.all(width : 2 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                          ),
                                          child: Text(getSubcodename(list[i]['CAT02']), style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w800, fontSize: 8 * (MediaQuery.of(context).size.width / 360)),),
                                        )
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TradeView(article_seq: list[i]['ARTICLE_SEQ'], table_nm : list[i]['TABLE_NM'], params: {}, checkList: [],);
                            },
                          ));
                        },
                        child : Container(
                          width: 190 * (MediaQuery.of(context).size.width / 360),
                          //height: 10 * (MediaQuery.of(context).size.height / 360),
                          padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                //height: 25 * (MediaQuery.of(context).size.height / 360),
                                child: Text(
                                  '${getVND(list[i]['ETC01'])}',
                                  style: TextStyle(
                                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff151515),
                                      fontFamily: 'NanumSquareEB',
                                      fontWeight: FontWeight.w800
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                //height: 25 * (MediaQuery.of(context).size.height / 360),
                                padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                child: Text(
                                  '${list[i]['TITLE']}',
                                  style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff4E4E4E),
                                    fontFamily: 'NanumSquareR',
                                    fontWeight: FontWeight.w400,
                                    overflow: TextOverflow.ellipsis,
                                    height: 1.4 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                        ),
                      )
                    ],
                  ),
                ),
                if(list.length != i+1)
                  Divider(thickness: 5, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
              ],
            ),

          ),
      ],
    );
  }


  Widget sortby() {
    return Container(
        height: 90 * (MediaQuery.of(context).size.height / 360),
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
                height: 22 * (MediaQuery.of(context).size.height / 360),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      alignment: Alignment.center,
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                        child:
                        Text("정렬 기준",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 3 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              // width: 120 * (MediaQuery.of(context).size.width / 360),
              height: 20 * (MediaQuery.of(context).size.height / 360),
              // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
              child: RadioListTile<String>(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                controlAffinity: ListTileControlAffinity.leading,
                title: Transform.translate(
                  offset: const Offset(-20, 0),
                  child: Text(
                    '최근 등록일',
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                value: '',
                // checkColor: Colors.white,
                activeColor: Color(0xffE47421),
                onChanged: (String? value) {
                  changesort(value);
                },
                groupValue: _sortvalue,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

              // width: 120 * (MediaQuery.of(context).size.width / 360),
              height: 20 * (MediaQuery.of(context).size.height / 360),
              // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
              child: RadioListTile<String>(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                controlAffinity: ListTileControlAffinity.leading,
                title: Transform.translate(
                  offset: const Offset(-20, 0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          '조회수',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child: Text(
                          '↑',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                value: 'viewup',
                // checkColor: Colors.white,
                activeColor: Color(0xffE47421),
                onChanged: (String? value) {
                  changesort(value);
                },
                groupValue: _sortvalue,
              ),
            ),
            Container(
              // width: 120 * (MediaQuery.of(context).size.width / 360),
              height: 20 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

              // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
              child: RadioListTile<String>(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                controlAffinity: ListTileControlAffinity.leading,
                title: Transform.translate(
                  offset: const Offset(-20, 0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          '조회수',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child: Text(
                          '↓',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                value: 'viewdown',
                // checkColor: Colors.white,
                activeColor: Color(0xffE47421),
                onChanged: (String? value) {
                  changesort(value);
                },
                groupValue: _sortvalue,
              ),
            ),
          ],
        )
    );
  }

  void changesort(val) {
    setState(() {
      _sortvalue = val;
      list.clear();
      getBoardList();
      Navigator.pop(context);
    });
  }

  String getSubcodename(getcode) {
    var Codename = '';
    List<dynamic> main_catlist = [];

    codeOrgResult.forEach((element) {
      if(element['idx'] == getcode) {
        Codename = element['name'];
      }
      // print(getcode);
    });

    return Codename;
  }

  Row cat(BuildContext context) {

    return Row(  // 카테고리
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            // width: 30 * (MediaQuery.of(context).size.width / 360),
            child: Wrap(
              children: [
                Container(
                  child: Row(
                    children: [
                    for(int m2=0; m2<coderesult1.length; m2++)
                      if(coderesult1[m2]['idx'] != 'B06')
                        Container(
                          child: Row(
                            children: [
                              if(coderesult1[m2]['idx'] == _selectCate)
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                                  padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                  // height: 18 * (MediaQuery.of(context).size.height / 360),
                                  decoration: BoxDecoration(
                                    color: Color(0xffE47421),
                                    borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      // primary: Color(0xffF3F6F8),
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {  },
                                    child: Text(
                                      "${coderesult1[m2]['name']}",
                                      style: TextStyle(
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              if(coderesult1[m2]['idx'] != _selectCate)
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                                  padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                  // height: 18 * (MediaQuery.of(context).size.height / 360),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF3F6F8),
                                    borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Color(0xffF3F6F8),
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      _selectCate = coderesult1[m2]['idx'];
                                      getBoardList().then((_) {
                                        setState(() {
                                        });
                                      });
                                    },
                                    child: Text(
                                      "${coderesult1[m2]['name']}",
                                      style: TextStyle(
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff151515),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                    ],
                  )
               ),
              ],
            )
        )
      ]
    );
  }

  // 타이틀
  Container Listtitle(BuildContext context) {
    return Container(
      // height: 20 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          5 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.width / 360)),
      decoration: BoxDecoration(
        border: Border(
          // left: BorderSide(color: Color(0xffE47421),  width: 5 * (MediaQuery.of(context).size.width / 360),),
            bottom: BorderSide(color: Color(0xffE47421), )
        ),
      ),
      // width: 100 * (MediaQuery.of(context).size.width / 360),
      // height: 100 * (MediaQuery.of(context).size.width / 360),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // height: 15 * (MediaQuery.of(context).size.height / 360),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
              ),
            ),
            margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.width / 360)),
            child:Row(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                  child:Text(getSubcodename(_selectCate),
                    style: TextStyle(
                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              child:Row(
                children: [
                  GestureDetector(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfilemyPostFilter(getcheck_detail_catlist: [_selectCate], catlist: coderesult1,);
                        },
                      ));
                    },
                    child:Row(
                      children: [
                        Icon(Icons.filter_list_outlined, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                        Container(
                          padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                          child: Text('필터',
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  ,
                  Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          1 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                      child : Row(
                        children: [
                          GestureDetector(
                            onTap:() {
                              showModalBottomSheet(
                                context: context,
                                clipBehavior: Clip.hardEdge,
                                barrierColor: Color(0xffE47421).withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (BuildContext context) {
                                  return sortby();
                                },
                              );
                            },
                            child:Row(
                              children: [
                                Icon(Icons.sort, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                                Container(
                                  padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                                  child:  Text('정렬 기준',
                                    style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}