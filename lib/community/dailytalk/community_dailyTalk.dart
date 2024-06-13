import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/common/Nodata.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_modify.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/landing/landing.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../common/dialog/loginAlert.dart';
import '../../common/dialog/showDialog_modal.dart';
import '../../common/icons/my_icons.dart';
import '../../login/login.dart';
import '../../main/main_page.dart';
import 'community_dailyTalk_write.dart';

class CommunityDailyTalk extends StatefulWidget {
  final String main_catcode;

  const CommunityDailyTalk({super.key, required this.main_catcode});

  @override
  _CommunityDailyTalk createState() => _CommunityDailyTalk();

}


class _CommunityDailyTalk extends State<CommunityDailyTalk> {
  Map params = {};

  Widget getBanner = Container(); //공통배너
  var base_Imgurl = 'http://www.hoty.company';

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
  var board_seq = 23;
  var reg_id = "";
  var subtitle = "DAILY_TALK";
  var adminChk = "";

  var urlpath = 'http://www.hoty.company';

  // list 호출
  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
      'http://www.hoty.company/mf/community/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : "DAILY_TALK",
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
        "main_category" : main_catcode,
      };
      params.addAll(data);
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

        // 첫번째 카테고리
        if(widget.main_catcode == null || widget.main_catcode == '') {
          for (var i = 0; i < catname.length; i++) {
            if (i == 0) {
              main_catcode = catname[i]['idx'];
            }
          }
        }



        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
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
        "table_nm" : widget.main_catcode
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
                      buildBanner('${getbresult[i]['title']}', i,'${getbresult[i]['file_path']}'),
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

  Widget buildBanner(String text, int index, file_path) {
    return GestureDetector(
        onTap: () {
          var title_living = ['M01','M02','M03','M04','M05'];

          if(getbresult[index]["landing_target"] == "N") {
            if(getbresult[index]["link_yn"] == "Y") {
              if(getbresult[index]["type"] == "list") {

                // 박정범
                if(title_living.contains(getbresult[index]["table_nm"])){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LivingList(title_catcode: getbresult[index]["main_category"],
                        check_sub_catlist: [],
                        check_detail_catlist: [],
                        check_detail_arealist: []);
                  },
                  ));
                }
                if(getbresult[index]["table_nm"] == 'M06'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Service_guide(table_nm : getbresult[index]["main_category"]);
                    },
                  ));
                }
                if(getbresult[index]["table_nm"] == 'M07'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      if(getbresult[index]["main_category"] == 'USED_TRNSC') {
                        return TradeList(checkList: [],);
                      } else if(getbresult[index]["main_category"] == 'PERSONAL_LESSON'){
                        return LessonList(checkList: [],);
                      } else {
                        return CommunityDailyTalk(main_catcode: getbresult[index]["main_category"]);
                      }
                    },
                  ));
                }
                if(getbresult[index]["table_nm"] == 'M08'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TodayList(main_catcode: '',table_nm : getbresult[index]["main_category"]);
                    },
                  ));
                }
                // 지식인
                if(getbresult[index]["table_nm"] == 'M09'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return KinList(success: false, failed: false,main_catcode: '',);
                    },
                  ));
                }


              } else if(getbresult[index]["type"] == "view") {
                if(title_living.contains(getbresult[index]["table_nm"])){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LivingView(article_seq: getbresult[index]["article_seq"], table_nm: getbresult[index]["table_nm"], title_catcode: getbresult[index]["main_category"], params: {});
                  },
                  ));
                }
                if(getbresult[index]["table_nm"] == 'M06'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Service_guide(table_nm : getbresult[index]["main_category"]);
                    },
                  ));
                }
                if(getbresult[index]["table_nm"] == 'M07'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      if(getbresult[index]["main_category"] == 'USED_TRNSC') {
                        return TradeView(article_seq: getbresult[index]["article_seq"], table_nm: getbresult[index]["table_nm"], params: {}, checkList: []);
                      } else if(getbresult[index]["main_category"] == 'PERSONAL_LESSON'){
                        return LessonView(article_seq: getbresult[index]["article_seq"], table_nm: getbresult[index]["table_nm"], params: {}, checkList: []);
                      } else {
                        return CommunityDailyTalkView(article_seq: getbresult[index]["article_seq"], table_nm: getbresult[index]["table_nm"], main_catcode: getbresult[index]["main_category"], params: {});
                      }
                    },
                  ));
                }
                if(getbresult[index]["table_nm"] == 'M08'){

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return todayView(article_seq: getbresult[index]["article_seq"], title_catcode: getbresult[index]["main_category"], cat_name: '', table_nm: getbresult[index]["table_nm"]);
                    },
                  ));
                }
                // 지식인
                if(getbresult[index]["table_nm"] == 'M09'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return KinView(article_seq: getbresult[index]["article_seq"], table_nm: getbresult[index]["table_nm"], adopt_chk: '');
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
                image: CachedNetworkImageProvider('$Base_Imgurl$file_path'),
                // image: NetworkImage(''),
                fit: BoxFit.cover
            ),
          ),
          // child: Center(child: Text(text)), // 타이틀글 사용시 주석해제
        )
    );
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    adminChk = (await storage.read(key:'memberAdminChk')) ?? "";
    print(reg_id);
  }

  Widget _Nodata = Container();

  @override
  void initState() {
    _asyncMethod();
    if(widget.main_catcode != null && widget.main_catcode != '') {
      main_catcode = widget.main_catcode;
    }
    super.initState();
    getcodedata().then((_) {
      getlistdata().then((_) {
        _Nodata = Nodata();
        setState(() {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Scrollable.ensureVisible(
              titlecat_key.currentContext!,
            );
          });

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

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                        style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontFamily: ''),
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

              ListTitle(context),
              if(getbresult.length > 0)
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  height: 55 * (MediaQuery.of(context).size.height / 360), // 이미지 사이즈
                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child: getBanner,
                ),
              if(result.length > 0)
                getList(context), // list
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
              ),// more
            ],
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
                      return CommunityDailyTalkwrite(table_nm: 'DAILY_TALK', category: main_catcode,);
                      // return TradeModify();
                    },
                  ));
                }

                if(reg_id == null || reg_id == "") {
                  showModal(context, 'loginalert', '');
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
                                          return TradeList(checkList: [],);
                                        },
                                      ));
                                    },
                                    child: Text(
                                      "중고거래",
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
                                if(catname[m2]['idx'] == main_catcode)
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
                                        "${catname[m2]['name']}",
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                if(catname[m2]['idx'] != main_catcode)
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
                                          main_catcode = catname[m2]['idx'];
                                          result.clear();
                                          getlistdata().then((_) {
                                            setState(() {
                                            });
                                          });
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

  Widget getList(BuildContext context) {
    return
      Container(
        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Column(
              children: [
                for(var i=0; i<result.length; i++)
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalkView(article_seq : result[i]['article_seq'], table_nm : result[i]['table_nm'], main_catcode : main_catcode, params: params,);
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
                                      "${result[i]["title"] ?? ''}",
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
                                                  Text("${result[i]["reg_dt"] ?? ''}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                  Text("  ·  ", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                  Text("${getSubcodename(result[i]["main_category"])}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                ],
                                              )
                                          ),
                                          Container(
                                              child : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 * (MediaQuery.of(context).size.width / 360) , ),
                                                  Text(" ${result[i]["like_cnt"]}"),
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
                                                  Text(" ${result[i]["comment_cnt"]}"),
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
                              image: result[i]["main_img"] != null ? DecorationImage(
                                  image:  CachedNetworkImageProvider(urlpath+'${result[i]["main_img_path"]}${result[i]["main_img"]}'),
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
              ],
            ),
          );
  }

  Container Morelist(context) {
    return Container(
      width: 100 * (MediaQuery.of(context).size.width / 360),
      // height: 20 * (MediaQuery.of(context).size.height / 360),
      margin: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
      child: Wrap(
        children: [
          TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                  side : BorderSide(color: Color(0xff2F67D3), width: 2),
                )
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360),
                      8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360)),
                  alignment: Alignment.center,
                  // width: 50 * (MediaQuery.of(context).size.width / 360),
                  child: Text('더보기', style: TextStyle(fontSize: 16, color: Color(0xff2F67D3),fontWeight: FontWeight.bold,),
                  ),
                ),
                Icon(My_icons.rightarrow, size: 12, color: Color(0xff2F67D3),),
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
                  child:Text(gettitlename(),
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
                  Container(
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        1 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                    child:Row(
                      children: [
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
                                      )

                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget sortby() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 130 * (MediaQuery.of(context).size.height / 360),
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
                  '등록일',
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

  String gettitlename() {
    String titlename = '';

    for(var i=0; i<catname.length; i++) {
      if(catname[i]['idx'] == main_catcode) {
        titlename = catname[i]['name'];
      }
    }

    return titlename;
  }

  // 카테고리
  String getSubcodename(getcode) {
    var Codename = '';
    List<dynamic> main_catlist = [];

    coderesult.forEach((element) {
      if(element['idx'] == getcode) {
        Codename = element['name'];
      }
      // print(getcode);
    });

    return Codename;
  }

}