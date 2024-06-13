import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../common/Nodata.dart';

class Profile_service_history extends StatefulWidget {
  const Profile_service_history({super.key});

  @override
  State<Profile_service_history> createState() => _Profile_service_historyState();
}

class _Profile_service_historyState extends State<Profile_service_history> {
  final storage = FlutterSecureStorage();
  String? reg_id;
  var keyword = "";
  var selectServiceGubun = "";
  var cateGubun = "SRVE_001";

  var cateIndex = 0;
  var cateSize = 5;
  // var cateTitle = ['전체', '대행 서비스', '출장 서비스', '24시 긴급 출장 통역', '부동산통역서비스'];
  var cattitle = [];
  var title_menu_cat = '';
  List<dynamic> coderesult = []; // 공통코드 리스트


  List<dynamic> list = [];
  Widget _noData = Container();

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
        if(coderesult[i]['pidx'] == "M06"){
          cattitle.add(coderesult[i]);
        }
      }
    }
    catch(e){
      print(e);
    }

  }

  @override
  void initState() {
    super.initState();
    getcodedata().then((value) {
      _asyncMethod().then((value){
        getBoardList().then((_){
          _noData = Nodata();
          setState(() {
           /* WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
              });
            });*/
          });
        });
      });

    });


  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }

  Future<dynamic> getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberServiceBoard.do',
      //'http://192.168.100.31:8080/mf/member/getMemberServiceBoard.do',
    );

    try {

      Map data = {
        "memberId": reg_id,
        "boardGubun": "service",
        "serviceGubun" : selectServiceGubun,
        "cateGubun":cateGubun,
        "keyword" : keyword,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body));

        setState(() {
          list = json.decode(response.body)['result']['boardList'];
          for(int i = 0; i < list.length; i ++) {
            var id = "";
            int len = list[i]["article_seq"].toString().length;
            for(int a = 0; a < 6 - len; a++) {
              id = id + "0";
            }
            print(list[i]["ETC09"]);
            if(list[i]["ETC09"] != null && list[i]["ETC09"] != '') {
              id = id + list[i]["ARTICLE_SEQ"].toString() + list[i]["ETC09"].toString().substring(list[i]["ETC09"].toString().length - 4, list[i]["ETC09"].toString().length);
              print(id);
              list[i]["ID"] = id;
            }
          }
        });
      }

    }catch(e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  title: Container(
                    height: 18 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      color: Color(0xffF3F6F8),
                    ),
                    child: TextField(
                      style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                        border: InputBorder.none,
                        hintText: '검색 할 키워드를 입력 해주세요',
                        hintStyle: TextStyle(
                          color:Color(0xffC4CCD0),
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        ),
                        suffixIcon: Container(
                          // alignment: Alignment.centerr,
                          margin: EdgeInsets.fromLTRB(0, 0, 1 * (MediaQuery.of(context).size.width / 360), 0),
                          child: IconButton(
                            icon: Icon(Icons.search_rounded,
                              color: Colors.black, size: 11 * (MediaQuery.of(context).size.height / 360),
                            ),
                            onPressed: () {
                              list.clear();
                              getBoardList().then((_) {
                                setState(() {
                                  // FocusScope.of(context).unfocus();
                                });
                              });
                            },
                          ),
                        )
                        // fillColor : Color(0xffF3F6F8),
                        // filled : true,
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
                    ),
                  )
                // centerTitle: false,
              ),
            ],
          )
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // search(context),
              category(context),
              status(context),
              history_list(context),

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
        )
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }

  Column history_list(BuildContext context) {

    var category = ["assets/complete_color.png", "assets/progress_color.png","assets/soldout_color.png", "assets/canceled_color.png"];


    return
      Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(int i = 0 ; i < list.length; i++)
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfileServiceHistoryDetail(idx: list[i]['ARTICLE_SEQ']);
                },
              ));
            },
            child: Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              // height: 70 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  Container(
                    // height: 70 * (MediaQuery.of(context).size.height / 360),
                    padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50 * (MediaQuery.of(context).size.width / 360),
                          // height: 30 * (MediaQuery.of(context).size.height / 360),
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: Image(image: AssetImage("assets/repair.png")),
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          // width: 260 * (MediaQuery.of(context).size.width / 360),
                          // height: 40 * (MediaQuery.of(context).size.height / 360),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                /*height: 15 * (MediaQuery.of(context).size.height / 360),*/
                                child: Row(
                                  children: [
                                    Container(
                                      width: 250 * (MediaQuery.of(context).size.width / 360),
                                      child: Text(list[i]['SERVICE_NM'],
                                        style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      // alignment: Alignment.centerRight,
                                      width: 30 * (MediaQuery.of(context).size.width / 360),
                                      child:Image(image: AssetImage(
                                        list[i]['CAT01'] == 'SRVE_001' ? 'assets/complete_color.png' : list[i]['CAT01'] == 'SRVE_002' ? 'assets/progress_color.png' : list[i]['CAT01'] == 'SRVE_003' ? 'assets/soldout_color.png' : 'assets/canceled_color.png'
                                      ),
                                        // width: 25 * (MediaQuery.of(context).size.width / 360),
                                        /*height: 30 * (MediaQuery.of(context).size.height / 360),*/
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 250 * (MediaQuery.of(context).size.width / 360),
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Text('${list[i]['CONTS']}',
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w400
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Text(
                                  getVND(list[i]['ETC02']),
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
                  Container(
                    // height: 20 * (MediaQuery.of(context).size.height / 360),
                    padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      children: [
                        Container(
                          width: 210 * (MediaQuery.of(context).size.width / 360),
                          child: Text("신청 ID: ${list[i]['ID']}",
                            style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w500,
                                color: Color(0xff0F1316)
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                            textAlign: TextAlign.left,),
                        ),
                        Container(
                          width: 120 * (MediaQuery.of(context).size.width / 360),
                          child: Text(list[i]['REG_DT'],
                            style: TextStyle(
                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                // fontWeight: FontWeight.w600,
                                color: Color(0xffC4CCD0),
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                            textAlign: TextAlign.right,),
                        ),
                      ],
                    ),
                  ),
                  if(i != category.length - 1)
                    Divider(thickness: 5, height: 7 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                ],
              ),
            ),
          ),
          if(list.length == 0)
            _noData,
      ]
    );
  }

  SingleChildScrollView status(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            // height: 50 * (MediaQuery.of(context).size.height / 360),
            padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_001";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_01.png"), width: 80 * (MediaQuery.of(context).size.width / 360), fit: BoxFit.fill,),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_002";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_02.png"), width: 80 * (MediaQuery.of(context).size.width / 360)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_003";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_03.png"), width: 80 * (MediaQuery.of(context).size.width / 360)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_004";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_04.png"), width:  80 * (MediaQuery.of(context).size.width / 360)),
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
  }

  /*Container category(BuildContext context) {
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
                      *//*decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color(0xffF3F6F8),
                            color:Color(0xffF3F6F8),
                            width: 1 * (MediaQuery.of(context).size.width / 360),),
                        ),
                      ),*//*
                      child: GestureDetector(
                        child: Row(
                          children: [
                            for(var i = 0; i < cateSize; i++)
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    cateIndex = i;
                                    if(i == 1) {
                                      selectServiceGubun = "AGENCY_SRVC";
                                    } else if(i == 2) {
                                      selectServiceGubun = "ON_SITE";
                                    } else if(i == 3) {
                                      selectServiceGubun = "INTRP_SRVC";
                                    } else if(i == 4) {
                                      selectServiceGubun = "REAL_ESTATE_INTRP_SRVC";
                                    } else {
                                      selectServiceGubun = "";
                                    }
                                    getBoardList();
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
                                          color: cateIndex == i ? Color(0xffE47421) : Color(0xffF3F6F8),
                                          width: 1 * (MediaQuery.of(context).size.width / 360),),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                        7 * (MediaQuery.of(context).size.width / 360),
                                        0 * (MediaQuery.of(context).size.height / 360),
                                        7 * (MediaQuery.of(context).size.width / 360),
                                        5 * (MediaQuery.of(context).size.height / 360),
                                      ),
                                      child: Text(
                                        cateTitle[i],
                                        style: TextStyle(
                                          // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                          color: Color(0xff151515),
                                          fontSize: 16 * (MediaQuery.of(context).size.width / 360),
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
  }*/

  // 카테고리 타이틀 메뉴
  Container category(BuildContext context) {
    return Container(
      width: 360 *  (MediaQuery.of(context).size.width / 360),
      child : Row(
        children: [
          SingleChildScrollView(
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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
                            selectServiceGubun = '';
                            getBoardList().then((value) {
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
                                    color: title_menu_cat == '' ? Color(0xffE47421) : Color(0xffF3F6F8),
                                    width: 1 * (MediaQuery.of(context).size.width / 360),),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  7 * (MediaQuery.of(context).size.width / 360),
                                  0 * (MediaQuery.of(context).size.height / 360),
                                  7 * (MediaQuery.of(context).size.width / 360),
                                  5 * (MediaQuery.of(context).size.height / 360),
                                ),
                                child: Text(
                                  '전체',
                                  style: TextStyle(
                                    // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                    color: title_menu_cat == '' ? Color(0xffE47421) : Color(0xff151515),
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
                              selectServiceGubun = cattitle[i]['cidx'];
                              getBoardList().then((value) {
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
              ],
            ),
          ),
          Expanded(
            child: Container(
              // width: 25 *  (MediaQuery.of(context).size.width / 360),
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
                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                    fontWeight: FontWeight.w800,
                  ),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }

  String getVND(pay) {
    String payment = "";

    if(pay != null && pay != ''){
      var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
      getpay.format(int.parse(pay));
      payment = getpay.format(int.parse(pay)) + " VND";
    }

    return payment;
  }

  Container search(BuildContext context) {
    return Container(
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            // height: 20 * (MediaQuery.of(context).size.height / 360),
            // color : Color(0xffF3F6F8),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
              color: Color(0xffF3F6F8),
            ),
            child: TextField(
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                // labelText: 'Search',
                contentPadding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),  0, 0, 0),
                border: InputBorder.none,
                hintText: '검색 할 키워드를 입력 해주세요',
                hintStyle: TextStyle(
                  color:Color(0xffC4CCD0),
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                ),
                suffixIcon: IconButton(icon: Icon(Icons.search_rounded, color: Colors.black, size: 11 * (MediaQuery.of(context).size.height / 360),),
                  onPressed: () {
                    list.clear();
                    getBoardList().then((_) {
                      setState(() {
                        // FocusScope.of(context).unfocus();
                      });
                    });
                  },
                ),
              ),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center, // 텍스트필드 중앙정렬
              keyboardType: TextInputType.text,
              style: TextStyle(
                fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                fontFamily: ''
              ),
              onChanged: (text) {
                keyword = text;
                setState(() {
                  // print(keyword);
                });
              },
            ),
          );
  }
}