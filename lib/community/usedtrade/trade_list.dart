import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/common/Nodata.dart';
import 'package:hoty/common/dialog/showDialog_modal.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/common/list_filter.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/device_id.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_modify.dart';
import 'package:hoty/community/usedtrade/trade_write.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/landing/landing.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../categorymenu/providers/living_provider.dart';
import '../../common/dialog/loginAlert.dart';
import '../../common/icons/my_icons.dart';
import '../../login/login.dart';
import 'trade_view.dart';


class TradeList extends StatefulWidget {
  final List<String> checkList;

  const TradeList({Key? key,
    required this.checkList,
  }) : super(key:key);


  @override
  _TradeList createState() => _TradeList();

}

class _TradeList extends State<TradeList> {
  var view_type = "L";
  Map params = {};

  final GlobalKey titlecat_key = GlobalKey();

  Widget getBanner = Container(); //공통배너
  var base_Imgurl = 'http://www.hoty.company';

  var title_catcode = 'D1'; // 메뉴카테고리 코드값 //추후 링크연동시 code값 필요.

  List<dynamic> getresult = [];
  List<dynamic> result = [];

  List<dynamic> cattitle = []; // 카테고리타이틀
  List<dynamic> catname = []; // 세부카테고리
  List<dynamic> coderesult = []; // 공통코드 리스트

  // 카테고리 검색조건
  List<String> sub_checkList = []; // 서브 카테고리 체크리스트
  List<String> sub_allcheckList = []; // 서브 카테고리 전체체크

  String likes_yn = '';

  var totalpage = 1;
  var cpage = 1;
  var rows = 10;
  var board_seq = 15;
  var reg_id = "";

  var urlpath = 'http://www.hoty.company';

  var _sortvalue = ""; // sort
  var keyword = ""; // search
  var condition = "TITLE";

  var subtitle = "DAILY_TALK";

  var _isChecked = false;

  Widget _Nodata = Container();

  // list 호출
  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/community/list.do',
      //'http://192.168.0.110/mf/community/list.do',
    );

    sub_checkList = widget.checkList;
    List<String> main_checklist = [];
    List<String> listcat02 = [];


    for(var i = 0; i < sub_checkList.length; i++) {
      if(sub_checkList[i].contains("D1")) {
        main_checklist.add(sub_checkList[i]);
      }
      if(sub_checkList[i].contains("D2")) {
        listcat02.add(sub_checkList[i]);
      }
    }

    print(main_checklist);
    print(listcat02);

    print("데이터체크");

    
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "main_checklist": main_checklist.toList(),
        "listcat02" : listcat02.toList(),
        "table_nm" : "USED_TRNSC",
        "reg_id" : (await storage.read(key:'memberId')) ?? await getMobileId(),
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
      };
      var body = json.encode(data);
      params.addAll(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];

        for(int i=0; i<getresult.length; i++){
          result.add(getresult[i]);
        }

        Map paging = json.decode(response.body)['pagination'];

        print("#####paging####");
        print(paging);
        totalpage = paging['totalpage']; // totalpage
        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

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
    print(like_status);
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    print("#############################################");
    print(reg_id);
  }

  var Baseurl = "http://www.hoty.company/mf";
  // var Baseurl = "http://192.168.0.109/mf";
  var Base_Imgurl = "http://www.hoty.company";
  // var Base_Imgurl = "http://192.168.0.109";
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<dynamic> getbresult = [];
  Future<dynamic> getlistdata2() async {

    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
        Baseurl + "/popup/list.do"
    );
    try {
      Map data = {
        "table_nm" : "USED_TRNSC"
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

        getbresult = json.decode(response.body)['result'];
        // print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        // print(getbresult);
        getBanner = bannerbuild(context); // 카테고리별 배너 셋팅
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
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
          if(coderesult[i]['pidx'] == subtitle){
            cattitle.add(coderesult[i]);
          }
        }

        cattitle.forEach((element) {
          coderesult.forEach((value) {
            if(value['pidx'] == element['idx']){
              catname.add(value);
            }
          });
          print(element['idx']);
        });



        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }


  Container bannerbuild(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: 55 * (MediaQuery.of(context).size.height / 360), // 이미지 사이즈
      /* margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
      child: bannerlist2(context),
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
                  if(getbresult.length > 0)
                    for(var i=0; i<getbresult.length; i++)
                      buildBanner('${getbresult[i]['title']}', i,'${getbresult[i]['file_path']}', '${getbresult[i]['type']}', '${getbresult[i]['table_nm']}', int.parse('${getbresult[i]['article_seq'] ?? 0}') , '${getbresult[i]['main_category']}'),
                ],
              ),
              /*Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(getbresult.length > 0)
                        for(var i=0; i<getbresult.length; i++)
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

          if(getbresult[index]["landing_target"] == "N") {
            if(getbresult[index]["link_yn"] == "Y") {
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
                    return LivingView(article_seq: article_seq, table_nm: table_nm, title_catcode: title_catcode, params: params);
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
                        return TradeView(article_seq: article_seq, table_nm: table_nm, params: params, checkList: []);
                      } else if(category == 'PERSONAL_LESSON'){
                        return LessonView(article_seq: article_seq, table_nm: table_nm, params: params, checkList: []);
                      } else {
                        return CommunityDailyTalkView(article_seq: article_seq, table_nm: table_nm, main_catcode: category, params: params);
                      }
                    },
                  ));
                }
                if(table_nm == 'M08'){

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return todayView(article_seq: article_seq, title_catcode: title_catcode, cat_name: '', table_nm: table_nm);
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
        },
        child : Container(
          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정합니다.
            // color: Colors.blueGrey,
            image: DecorationImage(
                image: NetworkImage('$base_Imgurl$file_path'),
                // image: NetworkImage(''),
                fit: BoxFit.cover
            ),
          ),
          // child: Center(child: Text(text)), // 타이틀글 사용시 주석해제
        )
    );
  }

  Row Dailycat(BuildContext context) {

    return Row(  // 카테고리
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
          // width: 30 * (MediaQuery.of(context).size.width / 360),
            child: Wrap(
              children: [
                Container(
                    child : Row(
                      children: [
                        Container(
                          key: titlecat_key,
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
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
                              "중고거래",
                              style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                    child : Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
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
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return LessonList(checkList: []);
                                },
                              ));
                            },
                            child: Text(
                              "개인과외",
                              style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w400,
                                color: Color(0xff151515),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                for(int m2=0; m2<catname.length; m2++)
                  Container(
                    child: Row(
                      children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
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
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return CommunityDailyTalk(main_catcode: catname[m2]['idx']);
                                  },
                                ));
                              },
                              child: Text(
                                "${catname[m2]['name']}",
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
    );
  }

  void _allSelected(bool selected, main_catlist) {
    if (selected == true) {
      _isChecked = true;
      for(var m2=0; m2<main_catlist.length; m2++) {
          sub_checkList.add(main_catlist[m2]['idx']);
      }
      result.clear();
      getlistdata().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    } else {
      _isChecked = false;
      sub_checkList.clear();
      result.clear();
      getlistdata().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    }
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      result.clear();
      sub_checkList.add(dataName);
      getlistdata().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    } else {
      result.clear();
      sub_checkList.remove(dataName);
      getlistdata().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    }
  }

  @override
  void initState() {

    super.initState();
    _asyncMethod();
    getcodedata().then((_) {
      getlistdata2().then((_) {
        getlistdata().then((_) {
          _Nodata = Nodata();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Scrollable.ensureVisible(
              titlecat_key.currentContext!,
            );
          });
          setState(() {
            Timer.periodic(Duration(seconds: 3), (Timer timer) {
              if (_currentPage < getbresult.length) {
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
                              result.clear();
                              getlistdata().then((_) {
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
                      style: TextStyle(decorationThickness: 0 ,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        fontFamily: '',
                      ),
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
                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                  /*margin: EdgeInsets.all(5 * (MediaQuery.of(context).size.width / 360)),*/
                  padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                  /*alignment: Alignment.center,*/
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Dailycat(context),
                  ),

                ),
                ListTitle(context),// title
                Maincategory(context),
                if(getbresult.length > 0)
                  Container(
                    width: 340 * (MediaQuery.of(context).size.width / 360),
                    height: 55 * c_height, // 이미지 사이즈
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                        5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: getBanner,
                  ),
                if(result.length > 0 && view_type == 'L')
                  getList(context),
                // S타입
                if(result.length > 0 && view_type == 'S')
                  Container(
                    margin : EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    child: s_resultList(context, c_height),
                  ),
                if(result.length == 0)
                  _Nodata,
                if(result.length > 0 && cpage < totalpage)
                  Morelist(context),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    40 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                ),//show more
              ]
          ),
        ),

        floatingActionButton: SizedBox(
          width: 70 * (MediaQuery.of(context).size.width / 360),
          height: 40 * (MediaQuery.of(context).size.height / 360),
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 0,
              onPressed: (){
                if(reg_id != null && reg_id != "") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Tradewrite();
                      // return TradeModify();
                    },
                  ));
                }

                if(reg_id == null || reg_id == "") {
                  showModal(context, 'loginalert', '');
                 /* showDialog(context: context,
                      barrierColor: Color(0xffE47421).withOpacity(0.4),
                      builder: (BuildContext context) {
                        return loginalert(context,'');
                      }
                  );*/
                }
              },
              tooltip: 'Increment',
              backgroundColor: Colors.transparent,
              child : Column(
                children: [
                      Image(image: AssetImage("assets/write_icon2.png"),
                      width: 70 * (MediaQuery.of(context).size.width / 360),
                      height: 35 * (MediaQuery.of(context).size.height / 360)
                  ),
                ],
              ),
            ),
          ),
        ),

        extendBody: true,
        bottomNavigationBar: Footer(nowPage: 'Main_menu'),
      ),
    );
  }

  Widget Maincategory(context) {
    List<String> allcheckList = [];

    List<dynamic> main_catlist = [];
    coderesult.forEach((element) {
      if(element['pidx'] == title_catcode) {
          main_catlist.add(element);
      }
    });

    return
      Container(
          width: 360 * (MediaQuery.of(context).size.width / 360),
          // height: 17 * (MediaQuery.of(context).size.height / 360),
          margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.width / 360),
            0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.width / 360),),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 9 * (MediaQuery.of(context).size.height / 360),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Checkbox(
                                side: BorderSide(
                                  color: Color(0xffC4CCD0),
                                  width: 2,
                                ),
                                splashRadius: 12,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                // materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _isChecked,
                                checkColor: Colors.white,
                                activeColor: Color(0xffE47421),
                                onChanged: (val) {
                                  _allSelected(val!,main_catlist);
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              // padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Text(
                                "전체",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  // fontWeight: FontWeight.bold,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DottedLine(
                        lineThickness:1,
                        dashLength: 2.0,
                        dashColor: Color(0xffC4CCD0),
                        direction: Axis.vertical,
                      ),
                    ],
                  ),
                ),
                for(var i=0; i<main_catlist.length; i++)
                  Container(
                    height: 9 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Container(
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    splashRadius: 12,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    // materialTapTargetSize: MaterialTapTargetSize.padded,
                                    value: sub_checkList.contains(main_catlist[i]['idx']),
                                    checkColor: Colors.white,
                                    activeColor: Color(0xffE47421),
                                    onChanged: (val) {
                                      _onSelected(val!, main_catlist[i]['idx']);
                                    },
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                // padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                  "${main_catlist[i]['name']}",
                                  style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    // fontWeight: FontWeight.bold,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(i+1 < main_catlist.length)
                          DottedLine(
                            lineThickness:1,
                            dashLength: 2.0,
                            dashColor: Color(0xffC4CCD0),
                            direction: Axis.vertical,
                          ),
                      ],
                    ),
                  )
              ],
            ),
          )
      )
    ;
  }

  // S 타입 리스트
  Widget s_resultList(context, c_height) {

    return
      Column(
        children: [
          for(int i=0; i<result.length; i++)
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
                                return TradeView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], params: params, checkList: sub_checkList,);
                              },
                            ));
                          },
                          child: Container(
                            width: 150 * (MediaQuery.of(context).size.width / 360),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: result[i]['main_img'] != null &&  result[i]['main_img'] != '' ?
                                  DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                        Color(0xFF151515).withOpacity(0.7),
                                        result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                      ),
                                      image: CachedNetworkImageProvider('$base_Imgurl${result[i]['main_img_path']}${result[i]['main_img']}'),
                                      fit: BoxFit.cover
                                  ) : DecorationImage(
                                      colorFilter: ColorFilter.mode(
                                        Color(0xFF151515).withOpacity(0.7),
                                        result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
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
                                    if(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
                                      Container(
                                          margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                              0 , 0 ),
                                          decoration: BoxDecoration(
                                            color:
                                            result[i]['cat02'] == 'D201' ? Color(0xff53B5BB) :
                                            result[i]['cat02'] == 'D202' ? Color(0xff925331) :
                                            result[i]['cat02'] == 'D203' ? Color(0xffA6BB53) :
                                            Color(0xffCA3625) ,
                                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child:Row(
                                            children: [
                                              Container(
                                                padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3,
                                                    6 * (MediaQuery.of(context).size.width / 360) , 3 ),
                                                child: Text(getSubcodename(result[i]['cat02']),
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
                                    if(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
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
                                              if(result[i]['like_yn'] != null && result[i]['like_yn'] > 0)
                                                GestureDetector(
                                                  onTap: () {
                                                    _isLiked(true, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
                                                  },
                                                  child : Container(
                                                    padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                      4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                    child: Icon(Icons.favorite, color: Color(0xffE47421), size: 15 , ),
                                                  ),
                                                ),
                                              if(result[i]['like_yn'] == null || result[i]['like_yn'] == 0)
                                                GestureDetector(
                                                  onTap: () {
                                                    _isLiked(false, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
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
                                    if(result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204')
                                      Center(
                                          child : Container(
                                            margin : EdgeInsets.fromLTRB(50 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                8 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                            padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 9 * (MediaQuery.of(context).size.height / 360),
                                                8 * (MediaQuery.of(context).size.width / 360), 9 * (MediaQuery.of(context).size.height / 360)),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50),
                                                border: Border.all(width : 2 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                            ),
                                            child: Text(getSubcodename(result[i]['cat02']), style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w800, fontSize: 8 * (MediaQuery.of(context).size.width / 360)),),
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
                                return TradeView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], params: params, checkList: sub_checkList,);
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
                                    '${getVND(result[i]['etc01'])}',
                                    style: TextStyle(
                                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff151515),
                                      fontFamily: 'NanumSquareEB',
                                      fontWeight: FontWeight.w800
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                    //height: 25 * (MediaQuery.of(context).size.height / 360),
                                  padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    child: Text(
                                      '${result[i]['title']}',
                                      style: TextStyle(
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff4E4E4E),
                                        fontFamily: 'NanumSquareR',
                                        fontWeight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
                                        height: 0.7 * (MediaQuery.of(context).size.height / 360),
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
                  if(result.length != i+1)
                    Divider(thickness: 5, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                ],
              ),

            ),
        ],
      )
    ;
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

  Widget getList(context) {

    return  Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Wrap(
        children: [
          for(var i=0; i<result.length; i++)
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return TradeView(article_seq : result[i]['article_seq'], table_nm : result[i]['table_nm'], params: params, checkList: sub_checkList,);
                  },
                ));
              },
              child: Container(
                color: Color(0xffFCFCFC),
                width: 180 * (MediaQuery.of(context).size.width / 360),
                height: 150 * (MediaQuery.of(context).size.height / 360),
                child: Column(
                  children: [
                    Container(
                      width: 180 * (MediaQuery.of(context).size.width / 360),
                      padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child: Column(
                        children: [
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            height: 80 * (MediaQuery.of(context).size.height / 360),
                            decoration:
                            BoxDecoration(
                              image: result[i]['main_img'] != '' &&  result[i]['main_img']!= null ?
                              DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFF151515).withOpacity(0.7),
                                    result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                  ),
                                  image: CachedNetworkImageProvider('$base_Imgurl${result[i]['main_img_path']}${result[i]['main_img']}'),
                                  fit: BoxFit.cover
                              ) : DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFF151515).withOpacity(0.7),
                                    result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204' ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                  ),
                                  image: AssetImage('assets/noimage.png'),
                                  fit: BoxFit.cover
                              ),
                              borderRadius : BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)
                              ),
                            ),
                            // color: Colors.amberAccent,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color:
                                        result[i]['cat02'] == 'D201' ? Color(0xff53B5BB) :
                                        result[i]['cat02'] == 'D202' ? Color(0xff925331) :
                                        result[i]['cat02'] == 'D203' ? Color(0xffA6BB53) :
                                        Color(0xffCA3625) ,
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text(
                                              getSubcodename(result[i]['cat02']),
                                              style: TextStyle(
                                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                if(result[i]['like_yn'] != null && result[i]['like_yn'] > 0 && result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
                                  GestureDetector(
                                    onTap : () {
                                      _isLiked(true, result[i]["article_seq"], "USED_TRNSC", result[i]["title"], i);
                                    },
                                    child : Container(
                                        margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            3 * (MediaQuery.of(context).size.height / 360), 0 ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child:Row(
                                          children: [
                                            Container(
                                              padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                              child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 * (MediaQuery.of(context).size.width / 360), ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                if((result[i]['like_yn'] == null || result[i]['like_yn'] == 0) && result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
                                  GestureDetector(
                                    onTap : () {
                                      _isLiked(false, result[i]["article_seq"], "USED_TRNSC", result[i]["title"], i);
                                    },
                                    child : Container(
                                        margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            3 * (MediaQuery.of(context).size.height / 360), 0 ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child:Row(
                                          children: [
                                            Container(
                                              padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                              child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 * (MediaQuery.of(context).size.width / 360), ),
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                if(result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204')
                                  Center(
                                    child : Container(
                                      margin : EdgeInsets.fromLTRB(45 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                          8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                      padding : EdgeInsets.fromLTRB(12 * (MediaQuery.of(context).size.width / 360), 13 * (MediaQuery.of(context).size.height / 360),
                                          12 * (MediaQuery.of(context).size.width / 360), 13 * (MediaQuery.of(context).size.height / 360)),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(width : 2 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                      ),
                                      child: Text(getSubcodename(result[i]['cat02']),
                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    )
                                  ),
                              ],
                            ),
                          ),
                          // 하단 정보
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            //height: 50 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              color:Color(0xffFFFFFF),
                              borderRadius : BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10.0,
                                  offset: Offset(0,10),
                                )
                              ]
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 165 * (MediaQuery.of(context).size.width / 360),
                                  child: Text(
                                    getVND('${result[i]['etc01']}'),
                                    style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        color: Color(0xff151515),
                                        fontFamily: 'NanumSquareEB',
                                        fontWeight: FontWeight.w800
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360), 0, 5  * (MediaQuery.of(context).size.height / 360)),
                                  width: 165 * (MediaQuery.of(context).size.width / 360),
                                  child: Text(
                                    '${result[i]['title']}',
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff4E4E4E),
                                      fontFamily: 'NanumSquareR',
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                      height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(result.length%2 == 0)
                      if(result.length != i+1 && result.length != i+2)
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration : BoxDecoration (
                                border : Border(
                                    bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                                )
                            )
                        ),
                    if(result.length%2 == 1)
                      if(result.length != i+1)
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration : BoxDecoration (
                                border : Border(
                                    bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                                )
                            )
                        ),
                  ],
                ),
              ),
            ),
        ],
      ),

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


  Widget ListTitle(context) {
    return Container(
      // height: 20 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
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
                  child:Text('중고거래',
                    style: TextStyle(
                      fontSize: 20 * (MediaQuery.of(context).size.width / 360),
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
                        fullscreenDialog: true,
                        builder: (context) {
                          /*return AlertDialog(
                            content: Cm_Filter(subtitle: 'USED_TRNSC',),
                          );*/
                          return Cm_Filter(subtitle: 'USED_TRNSC',getcheckList : widget.checkList);
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
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        1 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                    child:Row(
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
                              )

                            ],
                          ),
                        )
                        ,
                      ],
                    ),
                  ),
                  // 뷰타입 설정
                  GestureDetector(
                      onTap: (){
                        if(view_type == "L") {
                          view_type = "S";
                        } else{
                          view_type = "L";
                        }
                        setState(() {

                        });

                      },
                      child : Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),),
                        child: Icon(
                          view_type == 'S' ? Icons.grid_view_rounded : Icons.format_list_bulleted_rounded,
                          size: 10 * (MediaQuery.of(context).size.height / 360),
                          color: Color(0xffC4CCD0),
                        ),
                      )
                  )
                ],
              )
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

  Widget sortby() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 135 * (MediaQuery.of(context).size.height / 360),
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
            height: 25 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  alignment: Alignment.center,
                  width: 280 * (MediaQuery.of(context).size.width / 360),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                    child: Text("정렬 기준",style: TextStyle(
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
            ),

          ),
          Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              decoration : BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
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
                  '작성일',
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
                    ),
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
                        '댓글수',
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
              value: 'answerup',
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
                        '댓글수',
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
              value: 'answerdown',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),
        ],
      ),
    );

  }


  void changesort(val) {
    print(val);
    setState(() {
      _sortvalue = val;
      result.clear();
      Navigator.pop(context);
      getlistdata().then((_) {
        setState(() {
        });
      });
    });
  }


  void _isLiked(like_yn, article_seq, table_nm, apptitle, index) {

    setState(() {
      like_yn = !like_yn;
      if(like_yn) {
        likes_yn = 'Y';
        updatelike( article_seq, table_nm, apptitle);
        result[index]['like_yn'] = 1;
        result[index]['like_cnt'] = result[index]['like_cnt'] + 1;

        setState(() {

        });
      } else{
        likes_yn = 'N';
        updatelike( article_seq, table_nm, apptitle);
        result[index]['like_yn'] = 0;
        result[index]['like_cnt'] = result[index]['like_cnt'] - 1;

        setState(() {

        });
      }

    });
  }

}


