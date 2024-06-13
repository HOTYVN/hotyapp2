import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoty/common/dialog/showDialog_modal.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/icons/my_icons.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_exchangerate.dart';
import 'package:hoty/today/today_movie.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;

import '../categorymenu/providers/living_provider.dart';
import '../common/Nodata.dart';
import '../common/menu_banner.dart';
import '../community/device_id.dart';


class TodayList extends StatefulWidget {
  final String main_catcode;
  final String table_nm;

  const TodayList({super.key, required this.main_catcode, required this.table_nm});

  @override
  _TodayList createState() => _TodayList();

}

class _TodayList extends State<TodayList> {

  String likes_yn = '';
  var menu_title = '오늘의 정보';
  var base_Imgurl = 'http://www.hoty.company';

  Widget getBanner = Container(); //공통배너
  // 고유정보
  var table_nm = "TODAY_INFO"; // 오늘의정보 테이블네임
  // 메뉴카테고리 selectkey
  final GlobalKey titlecat_key = GlobalKey();
  List<dynamic> getresult = []; // get리스트
  List<dynamic> result = []; // 전체 리스트
  List<dynamic> coderesult = []; // 공통코드 리스트

  List<dynamic> cattitle = []; // 카테고리타이틀
  List<dynamic> catname = []; // 세부카테고리
  var main_catcode = '';

  var _sortvalue = ""; // sort
  var keyword = ""; // search
  var condition = "TITLE";

  var totalpage = 1;
  var cpage = 1;
  var rows = 10;
  var board_seq = 9;
  var reg_id = "admin";
  var subtitle = "TODAY_INFO";
  var urlpath = 'http://www.hoty.company';

  var todayinfo_totalcount = 0;
  var hotypick_totalcount = 0;

  List<String> todayinfoList = [];
  List<String> hotypickList = [];

  var todayinfo_check = false;
  var hotypick_check = false;

  void saveStorageData(List<String> items, String item) {
    final box = GetStorage();
    box.write(item, items);
  }

  List<String> getStorageData(String item) {
    final box = GetStorage();
    //notificationList = List<String>.from(box.read(item) ?? []);
    return List<String>.from(box.read(item) ?? []);
  }

  void removeStorageData(String item) {
    final box = GetStorage();
    box.remove(item);
  }

  // list 호출
  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
      'http://www.hoty.company/mf/today/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : table_nm,
        "reg_id" : reg_id,
        "sort_nm" : _sortvalue,
        // "keyword" : keyword,
        // "condition" : condition,
        "main_category" : main_catcode,
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];

        for(int i=0; i<getresult.length; i++){
          result.add(getresult[i]);
        }

        Map paging = json.decode(response.body)['pagination'];

        totalpage = paging['totalpage']; // totalpage
        // print("asdasdasdasdasd");
        // print(result.length);
      }
      print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> getlistdata_todayinfo() async {

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
      'http://www.hoty.company/mf/today/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": "9",
        "cpage": "1",
        "rows": "99999",
        "table_nm" : "TODAY_INFO",
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(response.statusCode == 200) {

        Map paging = json.decode(response.body)['pagination'];
        todayinfo_totalcount = paging['totalcount']; // totalpage

        setState(() {
          todayinfoList = getStorageData("todayinfo");
        });

        var todayinfo = [];
        for(int i = 0;i < todayinfoList.length; i++) {
          if(todayinfo.length == 0) {
            todayinfo.add(todayinfoList[i]);
          }
          for(int j = 0; j < todayinfo.length; j++) {
            if(!todayinfo.contains(todayinfoList[i])) {
              todayinfo.add(todayinfoList[i]);
            }
          }
        }

        print("todayinfo : ${todayinfo}");
        print("todayinfo_totalcount : ${todayinfo_totalcount}");

        setState(() {
          if(todayinfo_totalcount == todayinfo.length) {
            todayinfo_check = true;
          } else if (todayinfo_totalcount > todayinfo.length) {
            todayinfo_check = false;
          }
        });

      }
      print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> getlistdata_hotypick() async {

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
      'http://www.hoty.company/mf/today/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": "26",
        "cpage": "1",
        "rows": "99999",
        "table_nm" : "HOTY_PICK",
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(response.statusCode == 200) {

        Map paging = json.decode(response.body)['pagination'];
        hotypick_totalcount = paging['totalcount']; // totalpage

        setState(() {
          hotypickList = getStorageData("hotypick");
        });

        var hotypick = [];
        for(int i = 0;i < hotypickList.length; i++) {
          if(hotypick.length == 0) {
            hotypick.add(hotypickList[i]);
          }
          for(int j = 0; j < hotypick.length; j++) {
            if(!hotypick.contains(hotypickList[i])) {
              hotypick.add(hotypickList[i]);
            }
          }
        }

        print("hotypick : ${hotypick}");
        print("hotypick_totalcount : ${hotypick_totalcount}");

        setState(() {
          if(hotypick_totalcount == hotypick.length) {
            hotypick_check = true;
          } else if (hotypick_totalcount > hotypick.length) {
            hotypick_check = false;
          }
        });

      }
      print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  // 좋아요
  Future<dynamic> updatelike(int aritcle_seq, String table_nm, apptitle) async {
    String like_status = "";

    Map params = {
      "article_seq" : aritcle_seq,
      "table_nm" : table_nm,
      "title" : apptitle,
      "likes_yn" : likes_yn,
      "reg_id" : reg_id != "" ? reg_id : await getMobileId(),
    };
    like_status = await livingProvider().updatelike(params);
  }

  // 공통배너 호출
  Future<dynamic> setBannerList() async {
    getBanner = await Menu_Banner(table_nm : 'TODAY_INFO');
  }

  // 공통코드 호출
  Future<dynamic> getcodedata() async {

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
        var catlist = json.decode(response.body)['result'];

        coderesult = json.decode(response.body)['result'];

        // print(result);


        for(int i=0; i<coderesult.length; i++){
          if(coderesult[i]['pidx'] == table_nm){
            cattitle.add(coderesult[i]);
          }
        }

       /* cattitle.forEach((element) {
          coderesult.forEach((value) {
            if(value['pidx'] == element['idx']){
              catname.add(value);
            }
          });
          print(element['idx']);
        });*/
        print('@@@@@@@@@@@@');
        print(cattitle);

        // 첫번째 카테고리
      /*  if(widget.main_catcode == null || widget.main_catcode == '') {
          for (var i = 0; i < catname.length; i++) {
            if (i == 0) {
              main_catcode = catname[i]['idx'];
            }
          }
        }*/



        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    print("#############################################");
    print(reg_id);
  }
  // 노데이터
  Widget _noData = Container();

  @override
  void initState() {
    if(widget.main_catcode != null && widget.main_catcode != '') {
      main_catcode = widget.main_catcode;
    }
    if(widget.table_nm != null && widget.table_nm != '') {
      table_nm = widget.table_nm;
      if(widget.table_nm == 'HOTY_PICK') {
        board_seq = 26;
      }
    }
    //removeStorageData("todayinfo");
    //removeStorageData("hotypick");

    super.initState();
    _asyncMethod();
    setBannerList().then((_){
      getcodedata().then((_) {
        getlistdata().then((_) {
          getlistdata_todayinfo().then((_) {
            getlistdata_hotypick().then((_) {
              _noData = Nodata();

              setState(() {
                /*     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Scrollable.ensureVisible(
                titlecat_key.currentContext!,
              );
            });*/
              });
            });
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
      appBar: AppBar(
        leadingWidth: 27 * (MediaQuery.of(context).size.width / 360),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 26 * (MediaQuery.of(context).size.width / 360),
          color: Colors.black,
          // alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
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
          // width: 240 * (MediaQuery.of(context).size.width / 360),
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          child: Text(
            "호티의 추천!",
            style: TextStyle(
              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xff0F1316),
              fontWeight: FontWeight.w800,
              overflow: TextOverflow.ellipsis,
              fontFamily: 'NanumSquareR',
            ),
          ),
        ),
        //centerTitle: true,
      ),

      body: SingleChildScrollView(

        child: Column(
            children: [
              if(getBanner != null)
              Container( //상단메뉴 ,카테고리
                width: 360 * (MediaQuery.of(context).size.width / 360),
                // height: 75 * c_height,
                //height: 70 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    Container( //배너 이미지
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      height: 70 * c_height,
                      /*decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/today01.png'),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),*/
                      child: getBanner,
                    )
                  ],
                ),
              ),
              todaystitle(context),
              maincatlist(context),
              // Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),

              if(table_nm == 'TODAY_INFO')
                getlist(context),
              if(table_nm == 'HOTY_PICK')
                getlist2(context),

              if(result.length > 0 && (cpage < totalpage) )
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Morelist(context),
                ),

              Container(
                margin: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  40 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
              ),
            ]
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'Main_menu'),
    );
  }

  Container Morelist(context) {
    return Container(
      width: 100 * (MediaQuery.of(context).size.width / 360),
      // height: 30 * (MediaQuery.of(context).size.height / 360),
      margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 15 * (MediaQuery.of(context).size.height / 360)),
      child: Wrap(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
              ),
            ),
            onPressed: (){
              setState(() {
                if(cpage < totalpage) {
                  cpage = cpage + 1;
                  getlistdata().then((_) {
                    setState(() {
                    });
                  });
                }
                else {
                  showModal(context, 'listalert','');
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360)),
                  // alignment: Alignment.center,
                  // width: 50 * (MediaQuery.of(context).size.width / 360),
                  child: Text('더보기', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3),fontWeight: FontWeight.bold,),
                  ),
                ),
                Icon(My_icons.rightarrow, size: 12 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container todaybanner(BuildContext context, c_height) {
    return Container( //배너 이미지
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    height: 70 * (MediaQuery.of(context).size.height / 360),
                    /*decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/today01.png'),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                    ),*/
      child: getBanner,
                  );
  }

  Container todaystitle(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 330 * (MediaQuery.of(context).size.width / 360),
            height: 25 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
            // color: Colors.redAccent,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    /* Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TodayAdvicelist();
                      },
                    ));*/
                    if(table_nm != "TODAY_INFO") {
                      board_seq = 9;
                      table_nm = 'TODAY_INFO';
                      cpage = 1;
                      result.clear();
                      cattitle.clear();
                      main_catcode = '';
                      getcodedata().then((_) => {
                        getlistdata().then((_) {
                          setState(() {});
                        })
                      });
                    }

                  },
                  child: Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          // color: Color(0xffE47421),
                          color : table_nm == 'TODAY_INFO' ? Color(0xffE47421) : Color(0xffF3F6F8),
                          width: 1 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                    width: 165 * (MediaQuery.of(context).size.width / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/today_menu01.png'), height: 8 * (MediaQuery.of(context).size.height / 360),),
                        Container(
                          padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          child: Text(
                            "오늘의 정보",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              // color: Color(0xff151515),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            2 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            9 * (MediaQuery.of(context).size.height / 360),
                          ),
                          width: 4 * (MediaQuery.of(context).size.width / 360),
                          height: 4 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(todayinfo_check == false ? 0xffEB5757 : 0xffFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                   /* Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TodayAdvicelist();
                      },
                    ));*/
                    if(table_nm != "HOTY_PICK") {
                      board_seq = 26;
                      table_nm = 'HOTY_PICK';
                      cpage = 1;
                      cattitle.clear();
                      result.clear();
                      main_catcode = '';
                      getcodedata().then((_) => {
                        getlistdata().then((_){
                          setState(() {
                          });
                        })
                      });
                    }

                  },
                  child: Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          // color: Color(0xffE47421),
                          color : table_nm == 'HOTY_PICK' ? Color(0xffE47421) : Color(0xffF3F6F8),
                          width: 1 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                    width: 165 * (MediaQuery.of(context).size.width / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: AssetImage('assets/today_menu02.png'), height: 8 * (MediaQuery.of(context).size.height / 360),),
                        Container(
                          padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          child: Text(
                            "호치민 정착가이드",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              // color: Color(0xff151515),
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            2 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            9 * (MediaQuery.of(context).size.height / 360),
                          ),
                          width: 4 * (MediaQuery.of(context).size.width / 360),
                          height: 4 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(hotypick_check == false ? 0xffEB5757 : 0xffFFFFFF),
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
  }

  Container maincatlist(BuildContext context) {
    return Container(
                    width: 340 * (MediaQuery.of(context).size.width / 360),
                    height: 25 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                      child:  Row(  // 카테고리
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: 20 * (MediaQuery.of(context).size.height / 360),
                              // margin: EdgeInsets.fromLTRB(0, 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                            // width: 30 * (MediaQuery.of(context).size.width / 360),
                              child: Wrap(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        if(main_catcode == '')
                                          Container(
                                            key: titlecat_key,
                                            alignment: Alignment.center,
                                            // width: 50 * (MediaQuery.of(context).size.width / 360),
                                            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                                            // padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                            height: 17 * (MediaQuery.of(context).size.height / 360),
                                            decoration: ShapeDecoration(
                                              color: Color(0xff482410),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(120),
                                              ),
                                              shadows: [
                                                BoxShadow(
                                                  color: Color(0x14545B5F),
                                                  blurRadius: 4,
                                                  offset: Offset(2, 2),
                                                  spreadRadius: 1,
                                                )
                                              ],
                                            ),
                                            child:
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1, 10 * (MediaQuery.of(context).size.width / 360), 1),
                                              child: GestureDetector(
                                                onTap: () {  },
                                                child: Container(
                                                 child : Text(
                                                    "전체",
                                                    style: TextStyle(
                                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ),
                                          ),
                                        if(main_catcode != '')
                                          Container(
                                            alignment: Alignment.center,
                                            // width: 50 * (MediaQuery.of(context).size.width / 360),
                                            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                                            // padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                            height: 17 * (MediaQuery.of(context).size.height / 360),
                                            decoration: ShapeDecoration(
                                              color: Color(0xffF3F6F8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(120),
                                              ),
                                              shadows: [
                                                BoxShadow(
                                                  color: Color(0x14545B5F),
                                                  blurRadius: 4,
                                                  offset: Offset(2, 2),
                                                  spreadRadius: 1,
                                                )
                                              ],
                                            ),
                                            child:
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1, 10 * (MediaQuery.of(context).size.width / 360), 1),
                                              child: GestureDetector(
                                                onTap: () {
                                                  main_catcode = '';
                                                  cpage=1;
                                                  result.clear();
                                                  getlistdata().then((_) {
                                                    setState(() {
                                                    });
                                                  });
                                                },
                                                child: Text(
                                                  "전체",
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff151515),
                                                  ),
                                                ),
                                              ),

                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  for(int m2=0; m2<cattitle.length; m2++)
                                    Container(
                                      child: Row(
                                        children: [
                                          if(cattitle[m2]['idx'] == main_catcode)
                                          GestureDetector(
                                            onTap: () {
                                              main_catcode = cattitle[m2]['idx'];
                                              cpage=1;
                                              result.clear();
                                              getlistdata().then((_) {
                                                setState(() {
                                                });
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                                              padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                              height: 17 * (MediaQuery.of(context).size.height / 360),
                                              decoration: BoxDecoration(
                                                color: Color(0xff482410),
                                                borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1, 10 * (MediaQuery.of(context).size.width / 360), 1),
                                                child: Text(
                                                  "${cattitle[m2]['name']}",
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),

                                            ),
                                          ),
                                          if(cattitle[m2]['idx'] != main_catcode)
                                            GestureDetector(
                                              onTap: () {
                                                main_catcode = cattitle[m2]['idx'];
                                                cpage=1;
                                                result.clear();
                                                getlistdata().then((_) {
                                                  setState(() {
                                                  });
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                                                padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                                height: 17 * (MediaQuery.of(context).size.height / 360),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF3F6F8),
                                                  borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                                                ),
                                                  child: Container(
                                                    padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1, 10 * (MediaQuery.of(context).size.width / 360), 1),
                                                    child: Text(
                                                      "${cattitle[m2]['name']}",
                                                      style: TextStyle(
                                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                        fontWeight: FontWeight.w400,
                                                        color: Color(0xff151515),
                                                      ),
                                                    ),
                                                  ),

                                              ),
                                            ),

                                        ],
                                      ),
                                    ),
                                ],
                              )
                          ),
                        ],
                      )
                    )
                  );
  }

  // 오늘의정보
  Container getlist(BuildContext context) {
    return Container( // 게시판
      width: 360 * (MediaQuery.of(context).size.width / 360),
      // height: 200 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          for(var i=0; i<result.length; i++)
          Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    todayinfoList = getStorageData("todayinfo");
                    todayinfoList.add("${result[i]["article_seq"]}");
                    saveStorageData(todayinfoList, "todayinfo");
                    getlistdata_todayinfo();
                    setState(() {

                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return todayView(article_seq: result[i]['article_seq'], title_catcode: result[i]['main_category'],cat_name: getsubtitlename(result[i]['main_category']), table_nm: result[i]['table_nm'],);
                      },
                    ));
                  },
                  child: Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                   // height: 60 * (MediaQuery.of(context).size.height / 360),
                    // color: Color(0xff151515),
                    child: Column(
                      children: [
                        Container(
                          //height: 30 * (MediaQuery.of(context).size.height / 360),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5 * (MediaQuery.of(context).size.height / 360)),
                          // color: Colors.green,
                        /*  decoration : BoxDecoration (
                              border : Border(
                                  bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                              )
                          ),*/
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(result[i]['main_category'] == 'TD_001')
                              Container(
                                alignment: Alignment.center,
                                width: 60 * (MediaQuery.of(context).size.width / 360),
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Wrap(
                                  children: [
                                    Container(
                                      width: 55 * (MediaQuery.of(context).size.width / 360),
                                      //height: 22 * (MediaQuery.of(context).size.height / 360),
                                      padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color : Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffF3F6F8 : 0xffE47421)
                                      ),
                                      child:
                                      Icon(Icons.notifications_active, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffC4CCD0 : 0xffFFFFFF),),
                                    )
                                  ],
                                ),
                              ),
                              if(result[i]['main_category'] == 'TD_002')
                                Container(
                                  alignment: Alignment.center,
                                  width: 60 * (MediaQuery.of(context).size.width / 360),
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        width: 55 * (MediaQuery.of(context).size.width / 360),
                                        //height: 22 * (MediaQuery.of(context).size.height / 360),
                                        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color : Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffF3F6F8 : 0xffE47421)
                                        ),
                                        child:
                                        Icon(Icons.description_outlined, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffC4CCD0 : 0xffFFFFFF),),
                                      )
                                    ],
                                  ),
                                ),
                              if(result[i]['main_category'] == 'TD_003')
                                Container(
                                  alignment: Alignment.center,
                                  width: 60 * (MediaQuery.of(context).size.width / 360),
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        width: 55 * (MediaQuery.of(context).size.width / 360),
                                        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        //height: 22 * (MediaQuery.of(context).size.height / 360),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color : Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffF3F6F8 : 0xffE47421)
                                        ),
                                        child:
                                        Icon(Icons.attach_money, size: 12 * (MediaQuery.of(context).size.height / 360), color: Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffC4CCD0 : 0xffFFFFFF),),
                                      )
                                    ],
                                  ),
                                ),
                              if(result[i]['main_category'] == 'TD_004')
                                Container(
                                  alignment: Alignment.center,
                                  width: 60 * (MediaQuery.of(context).size.width / 360),
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        width: 55 * (MediaQuery.of(context).size.width / 360),
                                        //height: 22 * (MediaQuery.of(context).size.height / 360),
                                        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color : Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffF3F6F8 : 0xffE47421)
                                        ),
                                        child:
                                        Icon(Icons.movie_outlined, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Color(getStorageData("todayinfo").contains(result[i]["article_seq"].toString()) == true ? 0xffC4CCD0 : 0xffFFFFFF),),
                                      )
                                    ],
                                  ),
                                ),
                              Container(
                                width: 260 * (MediaQuery.of(context).size.width / 360),
                                // color: Colors.green,
                                child: Column(
                                  children: [
                                    Container(
                                      //height: 10 * (MediaQuery.of(context).size.height / 360),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360) , 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      child: Text(
                                        getsubtitlename("${result[i]['main_category']}"),
                                        style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),

                                    ),
                                    Container(
                                      // height: 15 * (MediaQuery.of(context).size.height / 360),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360) , 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      child: Text(
                                        "${result[i]['title']}",
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          fontFamily: 'NanumSquareR',
                                          fontWeight: FontWeight.w400,
                                          height: 0.7 * (MediaQuery.of(context).size.height / 360)
                                          // overflow: TextOverflow.visible,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),

                        Container(
                          height: 20 * (MediaQuery.of(context).size.height / 360),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80 * (MediaQuery.of(context).size.width / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80 * (MediaQuery.of(context).size.width / 360),
                                      padding: EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                          Container(
                                            margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                            child: Text(
                                              "${result[i]['view_cnt']}",
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
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
                              Container(
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                width: 110 * (MediaQuery.of(context).size.width / 360),
                                child: Text(
                                  "${result[i]['reg_dt']}",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xffC4CCD0),
                                    // fontWeight: FontWeight.bold,
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
                if(i != result.length - 1)
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffDCE4EA),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xffF3F6F8),  width: 5 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      )
                    ],
                  )

              ],
            ),
          ),
          if(result.length == 0)
            _noData,
        ],
      ),
    );
  }


  // 호티의 추천
  Container getlist2(BuildContext context) {
    return Container( // 게시판
      width: 360 * (MediaQuery.of(context).size.width / 360),
      // height: 200 * (MediaQuery.of(context).size.height / 360),
      child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for(int i=0; i<result.length; i++)
              Container(
                margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                // padding: EdgeInsets.fromLTRB(20,30,10,15),
                // color: Colors.black,
                width: 360 * (MediaQuery.of(context).size.width / 360),
                // height: 170 * (MediaQuery.of(context).size.height / 360),
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: (){
                          hotypickList = getStorageData("hotypick");
                          hotypickList.add("${result[i]["article_seq"]}");
                          saveStorageData(hotypickList, "hotypick");
                          getlistdata_hotypick();
                          setState(() {

                          });

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return todayView(article_seq: result[i]['article_seq'], title_catcode: result[i]['main_category'],cat_name: getSubcodename(result[i]['main_category']), table_nm: result[i]['table_nm'],);
                            },
                          ));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 340 * (MediaQuery.of(context).size.width / 360),
                              height: 110 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: result[i]['main_img'] != '' &&  result[i]['main_img']!= null ? DecorationImage(
                                    image: CachedNetworkImageProvider('$base_Imgurl${result[i]['main_img_path']}${result[i]['main_img']}'),
                                    fit: BoxFit.cover
                                ) : DecorationImage(
                                    image: AssetImage('assets/noimage.png'),
                                    fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff2F67D3),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          if(result[i]['area_category'] != null && result[i]['area_category'] != '')
                                            Container(
                                            padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                                7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                            child: Text(getSubcodename(result[i]['area_category']),
                                              style: TextStyle(
                                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
                                      margin : EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360), 0),
                                      // width: 40 * (MediaQuery.of(context).size.width / 360),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                        shape: BoxShape.circle,
                                      ),
                                      child:Row(
                                        children: [
                                          if(result[i]['like_yn'] != null && result[i]['like_yn'] > 0)
                                            GestureDetector(
                                              onTap: () {
                                                _isLiked(true, result[i]["article_seq"], table_nm, result[i]["title"], i);
                                              },
                                              child : Container(
                                                padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                  4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                child: Icon(Icons.favorite, color: Color(0xffE47421), size: 14 , ),
                                              ),
                                            ),
                                          if(result[i]['like_yn'] == null || result[i]['like_yn'] == 0)
                                            GestureDetector(
                                              onTap: () {
                                                _isLiked(false, result[i]["article_seq"], table_nm, result[i]["title"], i);
                                              },
                                              child : Container(
                                                padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                  4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 14 , ),
                                              ),
                                            ),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 340 * (MediaQuery.of(context).size.width / 360),
                              // height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB( 1  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 340 * (MediaQuery.of(context).size.width / 360),
                                    child: Text(
                                      '${result[i]['title']}',
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontFamily: 'NanumSquareEB',
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if(result[i]['place_rating'] != null && result[i]["place_rating_cnt"] != null)
                                    Container(
                                        margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        width: 340 * (MediaQuery.of(context).size.width / 360),
                                        child:Row(
                                          children: [
                                            Text("구글평점 "),
                                            Text("${result[i]["place_rating"]}"),
                                            RatingBarIndicator(
                                              unratedColor: Color(0xffC4CCD0),
                                              rating: result[i]["place_rating"],
                                              itemBuilder: (context, index) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              direction: Axis.horizontal,
                                            ),
                                            Text("(${result[i]["place_rating_cnt"]})"),
                                          ],
                                        )

                                    ),
                                  // if(gubun.contains(result[i]['main_category']))
                                  if(result[i]['adres'] != null)
                                    Container(
                                        margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        width: 340 * (MediaQuery.of(context).size.width / 360),
                                        child:Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Icon(Icons.location_on_sharp, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                                            ),
                                            Container(
                                              margin : EdgeInsets.fromLTRB( 3  * (MediaQuery.of(context).size.width / 360),0, 0, 0),

                                              width: 300 * (MediaQuery.of(context).size.width / 360),
                                              child: Text(
                                                '${result[i]['adres']}',
                                                style: TextStyle(
                                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                  // color: Colors.white,
                                                  // fontWeight: FontWeight.bold,
                                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )

                                    ),
                                ],
                              ),
                            ),
                            Container(
                              width: 340 * (MediaQuery.of(context).size.width / 360),
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                              // color: Colors.purpleAccent,
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                          '${result[i]['like_cnt']}',
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
                                              Container(
                                                height : 8 * (MediaQuery.of(context).size.height / 360) ,
                                                child: DottedLine(
                                                  lineThickness:1,
                                                  dashLength: 2,
                                                  dashColor: Color(0xffC4CCD0),
                                                  direction: Axis.vertical,
                                                ),
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
                                                        '${result[i]['view_cnt']}',
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
                                        Container(
                                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                          // width: 110 * (MediaQuery.of(context).size.width / 360),
                                          child: Text(
                                            "${result[i]['reg_dt']}",
                                            style: TextStyle(
                                              fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                              color: Colors.black26,
                                              // fontWeight: FontWeight.bold,
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
                          ],
                        )

                    ),
                    if(result.length != i+1)
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffDCE4EA),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0xffF3F6F8),  width: 5 * (MediaQuery.of(context).size.width / 360),),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            if(result.length == 0)
              _noData,
          ]
      )
    );
  }

  String getsubtitlename(getcatcode) {
    String cat_code_name = '';

    for(var i=0; i<cattitle.length; i++ ){
      if(cattitle[i]['idx'] == getcatcode){
        cat_code_name = cattitle[i]['name'];
      }
    }

    return cat_code_name;
  }

  String getSubcodename(getcode) {
    var Codename = '';
    List<dynamic> main_catlist = [];

    coderesult.forEach((element) {
      if(element['idx'] == getcode) {
        Codename = element['name'];
      }
    });

    return Codename;
  }

  void _isLiked(like_yn, article_seq, table_nm, apptitle, index) {

    setState(() {
      like_yn = !like_yn;
      if(like_yn) {
        likes_yn = 'Y';
        updatelike( article_seq, table_nm, apptitle);
        setState(() {
          result[index]['like_yn'] = 1;
        });
      } else{
        likes_yn = 'N';
        updatelike( article_seq, table_nm, apptitle);
        setState(() {
          result[index]['like_yn'] = 0;
        });
      }

    });
  }

}