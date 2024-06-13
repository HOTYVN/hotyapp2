import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/common/list_filter.dart';
import 'package:hoty/categorymenu/common/view_on_map.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/categorymenu/providers/living_provider.dart';
import 'package:hoty/common/Nodata.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/icons/my_icons.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/device_id.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/landing/landing.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/search/search_result.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hoty/main/main_page.dart';

import '../categorymenu/living_list.dart';
import '../common/dialog/showDialog_modal.dart';
import '../common/menu_banner.dart';
import 'likes/like_provider.dart';
import 'likes/profile_like_filter.dart';

class Profile_like extends StatefulWidget {
  final String title_catcode;
  // 검색을 위해 담긴 체크리스트
  // final List<String> allcheck_sub_catlist = []; // 서브카테고리 all
  final List<String> check_sub_catlist; // 서브카테고리 체크
  // final List<String> allcheck_detail_catlist = []; // 세부카테고리 all
  final List<String> check_detail_catlist;
  final List<String> check_detail_arealist; // 지역리스트
  // 세부카테고리 체크
  const Profile_like({Key? key,
    required this.title_catcode,
    required this.check_sub_catlist,
    required this.check_detail_catlist,
    required this.check_detail_arealist,
  }) : super(key:key);

  @override
  _Profile_likeState createState() => _Profile_likeState();

}


class _Profile_likeState extends State<Profile_like> {
  //뷰타입
  var view_type = "S";
  Map params = {};
  //검색지역카테고리
  List<String> check_detail_arealist = [];
  //검색서브카테고리
  List<String> checklist = [];
  Widget getBanner = Container(); //공통배너
  var base_Imgurl = 'http://www.hoty.company';
  String likes_yn = '';
  // 메뉴카테고리 selectkey
  final GlobalKey titlecat_key = GlobalKey();
  // 생활정보 카테고리
  List<dynamic> coderesult = []; // 공통코드 리스트
  // List<dynamic> cattitle = []; // 카테고리타이틀 리스트
  List<dynamic> main_catname = []; // 메인카테고리 리스트
  List<dynamic> title_catname = []; // 메뉴타이틀테고리 리스트
  List<dynamic> areaname = []; // 지역카테고리 리스트

  var title_cat_name = '';

  var title_living = ['C1','C2','C3','C4','C5']; // 생활정보

  // 카테고리 검색조건
  List<String> sub_checkList = []; // 서브 카테고리 체크리스트
  List<String> sub_allcheckList = []; // 서브 카테고리 전체체크

  //아파트,병원,학교,학원 분류
  // List<String> gubun = ['C101','C102','C103','C104','C105','C106','C107','C108','C109'];
  List<String> gubun = ['C101','C102','C103','C104'];
  List<dynamic> result = []; // 리스트데이터
  Map pagination = {}; // 페이징데이터
  var totalpage = 0; // 총 리스트페이지

  // 고유정보
  var table_nm = ""; // 생활정보 테이블네임
  var title_catcode = ''; // 메뉴카테고리 코드값 //추후 링크연동시 code값 필요.
  var main_category_list = ['C1'];
  //params 정보
  var cpage = 1;
  var rows = 10;
  var reg_id = ""; //임시 ID값
  var condition = "TITLE"; // 검색구분
  var keyword = ''; // serch
  var _sortvalue = ""; // sort
  var appmenu = [];

  List<dynamic> Categorycoderesult = [];

  List<dynamic> _resultcatlist = [];



  // 노데이터
  Widget _noData = Container();

  var getmenu_idx = ['USED_TRNSC','PERSONAL_LESSON','HOTY_PICK'];
  var getmenu_pidx = ['F1','PERSONAL_LESSON'];

  // 공통코드 호출
  Future<dynamic> setcode() async {
    //코드 전체리스트 가져오기
    coderesult = await likeProvider().getcodedata();

    // 생활정보 코드 리스트
 /*   for(int i=0; i<coderesult.length; i++){
      if(coderesult[i]['pidx'] == table_nm){
        cattitle.add(coderesult[i]);
      }
    }*/

    // 타이틀코드,지역코드
    coderesult.forEach((value) {
      if(value['pidx'] == 'LIKE_PAGE'){
        title_catname.add(value);
      }
      if(value['pidx'] == 'AREA'){
        areaname.add(value);
      }
    });

    // 첫번째 카테고리
 /*   for(var i=0; i<title_catname.length; i++){
      if(i == 5){
        title_catcode = title_catname[i]['idx'];
      }
    }*/

  }

  var table_code = ['USED_TRNSC','PERSONAL_LESSON','HOTY_PICK'];

  // 좋아요리스트 있는 카테고리 세팅
  Future<dynamic> setresultcat() async {

    // if(title_catcode == '') {
      for(var i=0; i<Categorycoderesult.length; i++) {

        if(table_code.contains(Categorycoderesult[i]['TABLE_NM'])){
          _resultcatlist.add(Categorycoderesult[i]['TABLE_NM']);
        } else {
          _resultcatlist.add(Categorycoderesult[i]['MAIN_CATEGORY']);
        }
      }

      for(var i=0; i<title_catname.length; i++) {
        if(_resultcatlist.contains(title_catname[i]['cidx']) && widget.title_catcode == '') {
          if(title_catcode == '') {
            title_catcode = title_catname[i]['cidx'];
          }
        }
      }

    // }

    print("aa : ${_resultcatlist}");
    print("bb : ${title_catcode}");

    /*if(title_catcode == null || title_catcode == '') {
       title_catcode = _resultcatlist[0]['cidx'];
       setlist();
       setState(() {

       });
    }*/

  }

  // 리스트 호출
  Future<dynamic> setlist() async {

    main_category_list.add(title_catcode);
    // _resultcatlist.clear();

    Map data = {
      "cpage": cpage.toString(),
      "rows": rows.toString(),
      "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
      "sort_nm" : _sortvalue,
      "keyword" : keyword,
      "condition" : condition,
      "main_category" : main_category_list.toList(),
      "like_cat_title" : title_catcode,
      "sub_category" : sub_checkList.toList(),
      "checklist" : checklist.toList(),
      "area_category" : check_detail_arealist.toList(),
      "listcat01" : listcat01.toList(),
      "listcat02" : listcat02.toList(),
      "listcat03" : listcat03.toList(),
      "listcat04" : listcat04.toList(),
      "listcat05" : listcat05.toList(),
      "listcat06" : listcat06.toList(),
      "listcat07" : listcat07.toList(),
      "listcat08" : listcat08.toList(),
      "listcat09" : listcat09.toList(),
      "listcat10" : listcat10.toList(),
      "listcat11" : listcat11.toList(),
      "stay_yn" : stay_yn,
    };

    params.addAll(data);

    print('params>>>');
    print(params);
    main_category_list.clear();
    Map<String, dynamic> rst = {};
    List<dynamic> getresult = [];

    rst = await likeProvider().getlistdata(data);
    //리스트 데이터
    getresult = rst['list'] ?? [];
    getresult.forEach((element) {
      result.add(element);
    });
    // Categorycoderesult = rst['likecat'];
    // print(Categorycoderesult);


  /*  for(int i = 0; i < result.length; i++) {
      if(title_catcode == "C106" || title_catcode == "C107"  || title_catcode == "C104") {
        if(result[i]["etc10"] != null && result[i]["etc10"] != "") {
          dynamic Map = await fetchPlaceRating(result[i]["etc10"]);
          print("지도값 체크입니다.");
          print(Map);
          if(Map["result"] != null) {
            result[i]["place_rating"] = Map["result"]["rating"];
            result[i]["place_rating_cnt"] = Map["result"]["user_ratings_total"];
          }
        }
      }
    }*/
/*    setState(() {

    });*/

    //페이징처리
    pagination = rst['pagination'] ?? {};
    totalpage = pagination['totalpage'] ?? 0;

    // print('############################');
    // print(result);
/*    print(result[0]["place_rating"]);
    print(result[1]["place_rating"]);
    print(result[1]["place_rating_cnt"]);*/
    // print(totalpage);
    getRating().then((_) {
      setState(() {

      });
    });

  }

  Future<dynamic> getmenucat() async {

    main_category_list.add(title_catcode);
    // _resultcatlist.clear();

    Map data = {
      "cpage": cpage.toString(),
      "rows": rows.toString(),
      "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
      "sort_nm" : _sortvalue,
      "keyword" : keyword,
      "condition" : condition,
      "main_category" : main_category_list.toList(),
      "like_cat_title" : title_catcode,
      "sub_category" : sub_checkList.toList(),
      "checklist" : checklist.toList(),
      "area_category" : check_detail_arealist.toList(),
      "listcat01" : listcat01.toList(),
      "listcat02" : listcat02.toList(),
      "listcat03" : listcat03.toList(),
      "listcat04" : listcat04.toList(),
      "listcat05" : listcat05.toList(),
      "listcat06" : listcat06.toList(),
      "listcat07" : listcat07.toList(),
      "listcat08" : listcat08.toList(),
      "listcat09" : listcat09.toList(),
      "listcat10" : listcat10.toList(),
      "listcat11" : listcat11.toList(),
      "stay_yn" : stay_yn,
    };

    params.addAll(data);

    print('params>>>');
    print(params);
    main_category_list.clear();
    Map<String, dynamic> rst = {};
    List<dynamic> getresult = [];

    rst = await likeProvider().getlistdata(data);
    //리스트 데이터
    // getresult = rst['list'];
    // getresult.forEach((element) {
    //   result.add(element);
    // });
    Categorycoderesult = rst['likecat'];
    print(Categorycoderesult);


    /*  for(int i = 0; i < result.length; i++) {
      if(title_catcode == "C106" || title_catcode == "C107"  || title_catcode == "C104") {
        if(result[i]["etc10"] != null && result[i]["etc10"] != "") {
          dynamic Map = await fetchPlaceRating(result[i]["etc10"]);
          print("지도값 체크입니다.");
          print(Map);
          if(Map["result"] != null) {
            result[i]["place_rating"] = Map["result"]["rating"];
            result[i]["place_rating_cnt"] = Map["result"]["user_ratings_total"];
          }
        }
      }
    }*/
/*    setState(() {

    });*/

    //페이징처리
    pagination = rst['pagination'];
    totalpage = pagination['totalpage'];

    // print('############################');
    // print(result);
/*    print(result[0]["place_rating"]);
    print(result[1]["place_rating"]);
    print(result[1]["place_rating_cnt"]);*/
    // print(totalpage);
    getRating().then((_) {
      setState(() {

      });
    });

  }

  var Baseurl = "http://www.hoty.company/mf";
  // var Baseurl = "http://192.168.0.110/mf";
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
        "table_nm" : title_catcode
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

  // 공통배너 호출
 /* Future<dynamic> setBannerList() async {
    // getBanner = await Menu_Banner(table_nm : table_nm);
    getBanner = await Menu_Banner(table_nm : title_catcode); // 카테고리별 배너 호출

  }*/

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
    like_status = await likeProvider().updatelike(params);
  }

  Future<dynamic> getRating() async {
    if(result.length > 0) {
      for (int i = 0; i < result.length; i++) {
          if (result[i]["etc10"] != null && result[i]["etc10"] != "" && result[i]["review_yn"] == 'Y') {
            dynamic Map = await fetchPlaceRating(result[i]["etc10"]);
            result[i]["place_rating"] = Map["result"]["rating"];
            result[i]["place_rating_cnt"] = Map["result"]["user_ratings_total"];
          }
      }
    }
    setState(() {

    });
  }

  Future<dynamic> fetchPlaceRating(String placeId) async {
    // print("place_id");
    // print(placeId);
    final apiKey = 'AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs';
    final apiUrl = 'https://maps.googleapis.com/maps/api/place/details/json?fields=rating,user_ratings_total';

    final response = await http.get(Uri.parse('$apiUrl&place_id=$placeId&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load place rating');
    }
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    // print(reg_id);
  }


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
  String stay_yn = 'N';
  Map<String, dynamic> catrst = {};

  void catckclear() {
    listcat01.clear();
    listcat02.clear();
    listcat03.clear();
    listcat04.clear();
    listcat05.clear();
    listcat06.clear();
    listcat07.clear();
    listcat08.clear();
    listcat09.clear();
    listcat10.clear();
    listcat11.clear();
    stay_yn = 'N';
  }

  Future<dynamic> checkcatlist() async {

    List<dynamic> pidxcode = [];


      // print(title_catcode);
    var pidx = '';
    for (var i = 0; i < checklist.length; i++) {
      coderesult.forEach((element) {
          if(element['idx'] == checklist[i]) {
            coderesult.forEach((subel) {
              if(subel['idx'] == element['pidx']){
                if(subel['seq'] == 1) {
                  listcat01.add(element['idx']);
                }
                if(subel['seq'] == 2) {
                  listcat02.add(element['idx']);
                }
                if(subel['seq'] == 3) {
                  listcat03.add(element['idx']);
                }
                if(subel['seq'] == 4) {
                  listcat04.add(element['idx']);
                }
                if(subel['seq'] == 5) {
                  listcat05.add(element['idx']);
                }
                if(subel['seq'] == 6) {
                  listcat06.add(element['idx']);
                }
                if(subel['seq'] == 7) {
                  listcat07.add(element['idx']);
                }
                if(subel['seq'] == 8) {
                  listcat08.add(element['idx']);
                }
                if(subel['seq'] == 9) {
                  listcat09.add(element['idx']);
                }
                if(subel['seq'] == 10) {
                  listcat10.add(element['idx']);
                }
                if(subel['seq'] == 11) {
                  listcat11.add(element['idx']);
                }
              }
            });
          }
        });
      }
    if(title_catcode == 'C101' || title_catcode == 'C302') {
      stay_yn = 'Y';
    }


  }


  @override
  void initState() {
    super.initState();
    if(widget.check_detail_arealist.length > 0) {
      check_detail_arealist.addAll(widget.check_detail_arealist);
    }
    if(widget.check_detail_catlist.length > 0){
      checklist.addAll(widget.check_detail_catlist);
    }
    _asyncMethod();
    if(widget.check_sub_catlist.length > 0) {
      sub_checkList.addAll(widget.check_sub_catlist);
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      // print(widget.check_sub_catlist);
    }
    title_catcode = widget.title_catcode; // 타이틀 코드 셋팅

    setcode().then((_){
      checkcatlist().then((_) {
        getmenucat().then((value) {
          setresultcat().then((value) {
            setState(() {
              setlist().then((_){
                setState(() {
                  getRating();
                  //getlistdata2().then((_){
                    _noData = Nodata();
                    setState(() {
                      /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scrollable.ensureVisible(
                    titlecat_key.currentContext!,
                  );
                });*/

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
                  //});
                });
              });
            });
          });
        });

      });
    });


  }

  var _isChecked = false;



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
                    title: Container(
                      height: 18 * (MediaQuery.of(context).size.height / 360),
                      margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                        color: Color(0xffF3F6F8),
                      ),
                      child: TextField(
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
                            // alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(0, 0, 1 * (MediaQuery.of(context).size.width / 360), 0),
                            // margin: EdgeInsets.all(1),
                            child: IconButton(
                              icon: Icon(Icons.search_rounded,
                                color: Colors.black, size: 11 * (MediaQuery.of(context).size.height / 360),
                              ),
                              onPressed: () {
                                result.clear();
                                pagination.clear();
                                setlist().then((_) {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
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
                        style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                      ),
                    )
                  // centerTitle: false,
                ),
              ],
            )
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                  height: 1 * (MediaQuery.of(context).size.height / 360),
                ),

                if(result.length > 0)
                Container( //상단메뉴 ,카테고리
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  // width: 340 * (MediaQuery.of(context).size.width / 360),
                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                  padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 3 * (MediaQuery.of(context).size.height / 360),),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Titlecat(context), // 상단카테고리
                  ),
                ),
                // if(result.length > 0)
                if(result.length > 0)
                Listtitle(context), // 타이틀
                // if(result.length > 0)
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                     /* GestureDetector(
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
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),),
                            child: Icon(
                              view_type == 'S' ? Icons.grid_view_rounded : Icons.format_list_bulleted_rounded,
                              size: 10 * (MediaQuery.of(context).size.height / 360),
                              color: Color(0xffC4CCD0),
                            ),
                          )
                      )*/
                    ],
                  ),
                ),

                // L타입
                if(result.length > 0 && view_type == 'L')
                Container(
                  margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child: resultList(context, c_height),
                ),
                // S타입
                if(result.length > 0 && view_type == 'S')
                  Container(
                    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    child: s_resultList(context, c_height),
                  ),

                if(result.length == 0)
                  _noData,

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
        bottomNavigationBar: Footer(nowPage: 'My_page'),
      ),
    );
  }


  // 배너관련

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
      onTap : () {
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
              image: CachedNetworkImageProvider('$Base_Imgurl$file_path'),
              // image: NetworkImage(''),
              fit: BoxFit.cover
          ),
        ),
        // child: Center(child: Text(text)), // 타이틀글 사용시 주석해제
      )
    );
  }

  // S 타입 리스트
  Widget s_resultList(context, c_height) {

    return
      Column(
        children: [
          for(int i=0; i<result.length; i++)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
             /* padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 33 * (MediaQuery.of(context).size.height / 360)),*/
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(title_living.contains(result[i]['main_category'])) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return LivingView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], title_catcode: title_catcode, params: params,);
                                },
                              ));
                            }
                            if(result[i]['table_nm'] == 'USED_TRNSC'){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return TradeView(article_seq: result[i]['article_seq'], table_nm: result[i]['table_nm'], params: {}, checkList: [],);
                                },
                              ));
                            }
                            if(result[i]['table_nm'] == 'PERSONAL_LESSON'){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return LessonView(article_seq: result[i]['article_seq'], table_nm: result[i]['table_nm'], params: {}, checkList: [],);
                                },
                              ));
                            }
                            if(result[i]['table_nm'] == 'HOTY_PICK'){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return todayView(article_seq: result[i]['article_seq'], title_catcode: result[i]['main_category'],cat_name: getSubcodename(result[i]['main_category']), table_nm: result[i]['table_nm'],);
                                },
                              ));
                            }
                            if(result[i]['table_nm'] == 'DAILY_TALK'){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CommunityDailyTalkView(article_seq: result[i]['article_seq'], table_nm: result[i]['table_nm'], main_catcode: result[i]['main_category'], params: {},);
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
                                  image: result[i]['main_img'] != null &&  result[i]['main_img'] != '' ? DecorationImage(
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
                                  mainAxisAlignment: (result[i]['table_nm'] == 'USED_TRNSC' && (result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204')) ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(result[i]['table_nm'] == 'LIVING_INFO' && result[i]['area_category'] != null && result[i]['area_category'] != '')
                                    Container(
                                        margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            0 , 0 ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff2F67D3),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child:Row(
                                          children: [
                                              Container(
                                                  padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3,
                                                      6 * (MediaQuery.of(context).size.width / 360) , 3 ),
                                                  child: Text(getSubcodename(result[i]['area_category']),
                                                    style: TextStyle(
                                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                      // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                              )
                                          ],
                                        )
                                    )
                                    else if(result[i]['table_nm'] == 'PERSONAL_LESSON')
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
                                                child: Text(getSubcodename(result[i]['main_category']),
                                                  style: TextStyle(
                                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.white,
                                                    // fontWeight: FontWeight.bold,
                                                    // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    else if(result[i]['table_nm'] == 'USED_TRNSC')
                                        Container(
                                            margin : EdgeInsets.fromLTRB(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204' ? 6 * (MediaQuery.of(context).size.width / 360) : 0, result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204' ? 3 * (MediaQuery.of(context).size.height / 360) : 0,
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
                                                if(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3,
                                                      6 * (MediaQuery.of(context).size.width / 360) , 3 ),
                                                  child: Text(getSubcodename(result[i]['cat02']),
                                                    style: TextStyle(
                                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                      // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                      else
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
                                                  child: Text(getSubcodename(result[i]['main_category']),
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
                                    if(result[i]['table_nm'] == 'USED_TRNSC' && (result[i]['cat02'] == 'D202' || result[i]['cat02'] == 'D204'))
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
                                      )
                                    else
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
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // 타이틀
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], title_catcode: title_catcode, params: {},);
                                    },
                                  ));
                                },
                                child: Container(
                                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    '${result[i]['title']}',
                                    style: TextStyle(
                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if(result[i]['place_rating'] == null || result[i]["place_rating_cnt"] == null)
                                Container(
                                  // height: 10 * (MediaQuery.of(context).size.height / 360),
                                ),
                              if(result[i]['place_rating'] != null && result[i]["place_rating_cnt"] != null)
                                Container(
                                    constraints: BoxConstraints(maxWidth : 190 * (MediaQuery.of(context).size.width / 360)),
                                    margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                        0  * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    /*width: 340 * (MediaQuery.of(context).size.width / 360),*/
                                    // height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child:Row(
                                      children: [

                                        Container(
                                          margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                              2  * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360)),
                                          child:   Text("구글평점", style: TextStyle(
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                            // color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),),
                                        ),
                                        Container(
                                          margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                              2  * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360)),
                                          child:  Text("${result[i]["place_rating"]}",style: TextStyle(
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                            color: Color(0xff4E4E4E),
                                            // fontWeight: FontWeight.bold,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                          ),
                                        ),

                                        RatingBarIndicator(
                                          unratedColor: Color(0xffC4CCD0),
                                          rating: result[i]["place_rating"].toDouble(),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 8.0 * (MediaQuery.of(context).size.height / 360),
                                          direction: Axis.horizontal,
                                        ),
                                        Container(
                                            margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                              0  * (MediaQuery.of(context).size.width / 360),0 * (MediaQuery.of(context).size.height / 360)),
                                          constraints: BoxConstraints(maxWidth : 40 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text("(${result[i]["place_rating_cnt"]})",style: TextStyle(
                                            fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                                                                         color: Color(0xff4E4E4E),
                                          ),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    )

                                ),
                              if(result[i]['table_nm'] == 'PERSONAL_LESSON')
                              Container(
                                constraints: BoxConstraints(maxWidth : 190 * (MediaQuery.of(context).size.width / 360)),
                                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                    0, 0 * (MediaQuery.of(context).size.height / 360)),
                                /*width: 340 * (MediaQuery.of(context).size.width / 360),*/
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child:Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "후기",
                                        style: TextStyle(
                                          fontSize: 10 * (MediaQuery.of(context).size.width / 360),
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
                                        "${result[i]['rating_cnt']}",
                                        style: TextStyle(
                                          fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff4E4E4E),
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
                                            rating: result[i]['rating_cnt'],
                                            itemBuilder: (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 8.0 * (MediaQuery.of(context).size.height / 360),
                                            direction: Axis.horizontal,
                                          ),
                                          Container(
                                            margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0.5 * (MediaQuery.of(context).size.height / 360)),
                                            child: Text(
                                              "(${result[i]['comment_cnt']})",
                                              style: TextStyle(
                                                fontSize: 10 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xff4E4E4E),
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
                              if(result[i]['table_nm'] == 'PERSONAL_LESSON' || result[i]['table_nm'] == 'USED_TRNSC')
                              Container(
                                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                    0, 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text(
                                  getVND(result[i]['etc01']),
                                  style: TextStyle(
                                    fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                              //좋아요
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
                                                        '${result[i]['like_cnt']}',
                                                        style: TextStyle(
                                                          fontSize: 10 * (MediaQuery.of(context).size.width / 360),
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
                                                height: 8 * (MediaQuery.of(context).size.height / 360),
                                              child:  DottedLine(
                                                  lineThickness:1,
                                                  dashLength: 2.0,
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
                                                        fontSize: 10 * (MediaQuery.of(context).size.width / 360),
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
                                            for(var a = 0; a < result[i]["icon_list"].length; a++)
                                              Container(
                                                  child : Row (
                                                    children: [
                                                      DottedLine(
                                                        lineThickness:1,
                                                        dashLength: 2.0,
                                                        dashColor: Color(0xffC4CCD0),
                                                        direction: Axis.vertical,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                                                        child: Row(
                                                          children: [
                                                            Image(image: CachedNetworkImageProvider("http://www.hoty.company/images/app_icon/${result[i]["icon_list"][a]["icon"]}.png"), height: 10 * (MediaQuery.of(context).size.height / 360),),
                                                            Container(
                                                              margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                              child: Text(
                                                                "${result[i]["icon_list"][a]["icon_nm"]}",
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
                                                  )
                                              )
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

  String getVND(pay) {
    String payment = "";

    if(pay != null && pay != ''){
      var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
      getpay.format(int.parse(pay));
      payment = getpay.format(int.parse(pay)) + " VND";
    }

    return payment;
  }

 // L 타입 리스트
  Widget resultList(context, c_height) {
    return
      Column(
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
                          if(title_living.contains(result[i]['main_category'])) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LivingView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], title_catcode: title_catcode, params: params,);
                              },
                            ));
                          }
                          if(result[i]['table_nm'] == 'USED_TRNSC'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TradeView(article_seq: result[i]['article_seq'], table_nm: result[i]['table_nm'], params: {}, checkList: [],);
                              },
                            ));
                          }
                          if(result[i]['table_nm'] == 'PERSONAL_LESSON'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LessonView(article_seq: result[i]['article_seq'], table_nm: result[i]['table_nm'], params: {}, checkList: [],);
                              },
                            ));
                          }
                          if(result[i]['table_nm'] == 'HOTY_PICK'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return todayView(article_seq: result[i]['article_seq'], title_catcode: result[i]['main_category'],cat_name: getSubcodename(result[i]['main_category']), table_nm: result[i]['table_nm'],);
                              },
                            ));
                          }
                          if(result[i]['table_nm'] == 'DAILY_TALK'){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return CommunityDailyTalkView(article_seq: result[i]['article_seq'], table_nm: result[i]['table_nm'], main_catcode: result[i]['main_category'], params: {},);
                              },
                            ));
                          }

                        },
                        child: Column(
                          children: [
                            Container(
                              width: 340 * (MediaQuery.of(context).size.width / 360),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
                                  decoration:
                                  BoxDecoration(
                                    image: result[i]['main_img'] != '' &&  result[i]['main_img']!= null ? DecorationImage(
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
                                  // color: Colors.amberAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(result[i]['table_nm'] == 'LIVING_INFO' && result[i]['area_category'] != null && result[i]['area_category'] != '')
                                        Container(
                                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 , 0 ),
                                          decoration: BoxDecoration(
                                            color: Color(0xff2F67D3),
                                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child:Row(
                                            children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    7 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text(getSubcodename(result[i]['area_category']),
                                                    style: TextStyle(
                                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                      // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                            ],
                                          )
                                      )
                                      else if(result[i]['table_nm'] == 'PERSONAL_LESSON')
                                        Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                0 , 0 ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff27AE60),
                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    7 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text(getSubcodename(result[i]['main_category']),
                                                    style: TextStyle(
                                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                      // fontWeight: FontWeight.bold,
                                                      // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                      else if(result[i]['table_nm'] == 'USED_TRNSC')
                                        Container(
                                            margin : EdgeInsets.fromLTRB(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204' ? 10 * (MediaQuery.of(context).size.width / 360) : 0,  result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204' ? 5 * (MediaQuery.of(context).size.height / 360) : 0,
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
                                                if(result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    7 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text(
                                                    getSubcodename(result[i]['cat02']),
                                                    style: TextStyle(
                                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )
                                        )
                                      else
                                        Container(
                                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                0 , 0 ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff27AE60),
                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    7 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text(getSubcodename(result[i]['main_category']),
                                                    style: TextStyle(
                                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
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
                                      if(result[i]['table_nm'] == 'USED_TRNSC' && result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204')
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
                                              margin : EdgeInsets.fromLTRB(45 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                  130 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
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
                                        if(result[i]['table_nm'] != 'USED_TRNSC' && (result[i]['cat02'] != 'D202' && result[i]['cat02'] != 'D204'))
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
                                                    _isLiked(true, result[i]["article_seq"],  result[i]["table_nm"], result[i]["title"], i);
                                                  },
                                                  child : Container(
                                                    padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                      4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                    child: Icon(Icons.favorite, color: Color(0xffE47421), size: 18 , ),
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
                                                    child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 18 , ),
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
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontFamily: 'NanumSquareEB',
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if(result[i]['place_rating'] != null && result[i]["place_rating_cnt"] != null  && result[i]["review_yn"] == 'Y')
                                    Container(
                                        margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360),
                                            2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        width: 340 * (MediaQuery.of(context).size.width / 360),
                                        child:Row(
                                          children: [
                                            Container(
                                              margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                              child:   Text("구글평점", style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                // color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),),
                                            ),
                                            Container(
                                              margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                              child:  Text("${result[i]["place_rating"]}",style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                // color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),),
                                            ),
                                            Container(
                                              margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  RatingBarIndicator(
                                                    unratedColor: Color(0xffC4CCD0),
                                                    rating: result[i]["place_rating"].toDouble(),
                                                    itemBuilder: (context, index) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 16.0,
                                                    direction: Axis.horizontal,
                                                  ),
                                                  Container(
                                                    margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0.5 * (MediaQuery.of(context).size.height / 360)),
                                                    child: Text(
                                                      "(${result[i]['place_rating_cnt']})",
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
                                        )

                                    ),
                                  // if(gubun.contains(result[i]['main_category']))
                                  if(result[i]['adres'] != null && result[i]['address_yn'] == 'Y')
                                  Container(
                                      margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360),
                                          2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      width: 340 * (MediaQuery.of(context).size.width / 360),
                                      child:Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                            child:Icon(Icons.location_on_sharp, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                                          ),
                                          Container(
                                            margin : EdgeInsets.fromLTRB( 3  * (MediaQuery.of(context).size.width / 360),0, 0, 0),

                                            width: 300 * (MediaQuery.of(context).size.width / 360),
                                            child: Text(
                                              '${result[i]['adres']}',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
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
                                  if(result[i]['table_nm'] == 'PERSONAL_LESSON')
                                    Container(
                                      margin : EdgeInsets.fromLTRB( 1  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360), 0, 1  * (MediaQuery.of(context).size.height / 360)),
                                      width: 340 * (MediaQuery.of(context).size.width / 360),
                                      child: Row(
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
                                              "${result[i]['rating_cnt']}",
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
                                                  rating: result[i]['rating_cnt'],
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                                Container(
                                                  margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0.5 * (MediaQuery.of(context).size.height / 360)),
                                                  child: Text(
                                                    "(${result[i]['comment_cnt']})",
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
                                  if(result[i]['table_nm'] == 'PERSONAL_LESSON' || result[i]['table_nm'] == 'USED_TRNSC')
                                    Container(
                                      margin : EdgeInsets.fromLTRB( 1  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      width: 340 * (MediaQuery.of(context).size.width / 360),
                                      // height: 10 * (MediaQuery.of(context).size.height / 360),
                                      child: Text(
                                        getVND(result[i]['etc01']),
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          // color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NanumSquareEB',
                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              width: 340 * (MediaQuery.of(context).size.width / 360),
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                              // color: Colors.purpleAccent,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      // height: 8 * (MediaQuery.of(context).size.height / 360),
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
                                                        fontSize: 10 * (MediaQuery.of(context).size.width / 360),
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
                                            height: 6 * (MediaQuery.of(context).size.height / 360),
                                              child: DottedLine(
                                                lineThickness:1,
                                                dashLength: 1.0,
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
                                                      fontSize: 10 * (MediaQuery.of(context).size.width / 360),
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
                                          for(var a = 0; a < result[i]["icon_list"].length; a++)
                                            Container(
                                                child : Row (
                                                  children: [
                                                    DottedLine(
                                                      lineThickness:1,
                                                      dashLength: 2.0,
                                                      dashColor: Color(0xffC4CCD0),
                                                      direction: Axis.vertical,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                                                      child: Row(
                                                        children: [
                                                          Image(image: CachedNetworkImageProvider("http://www.hoty.company/images/app_icon/${result[i]["icon_list"][a]["icon"]}.png"), height: 10 * (MediaQuery.of(context).size.height / 360),),
                                                          Container(
                                                            margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                            child: Text(
                                                              "${result[i]["icon_list"][a]["icon_nm"]}",
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
                                                )
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )

                    ),
                    if(result.length != i+1)
                    Divider(thickness: 5, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                  ],
                ),
              ),
          ]
      )
    ;
  }

  // 타이틀카테고리
  Row Titlecat(BuildContext context) {

    return Row(  // 카테고리
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0,
                0, 0),
          // width: 30 * (MediaQuery.of(context).size.width / 360),
            child: Wrap(
                children: [
                  for(int m2=0; m2<title_catname.length; m2++)
                    if(_resultcatlist.contains(title_catname[m2]['cidx']))
                    Container(
                      child: Row(
                        children: [
                          if(title_catname[m2]['cidx'] == title_catcode)
                            Container(
                              key: titlecat_key,
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
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
                                autofocus: true,
                                onPressed: () {  },
                                child: Text(
                                  "${title_catname[m2]['name']}",
                                  style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if(title_catname[m2]['cidx'] != title_catcode)
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
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
                                  cpage = 1;
                                  sub_checkList.clear();
                                  _isChecked = false;
                                  title_catcode = title_catname[m2]['cidx'];
              /*                    main_category_list.clear();
                                  main_category_list.add('${title_catname[m2]['cidx']}');*/
                                  catckclear(); // 검색cat~ 초기화
                                  result.clear();
                                  pagination.clear();
                                  getbresult.clear();
                                  check_detail_arealist.clear();
                                  checklist.clear();
                                  setlist().then((_) {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                    });
                                  });

                                  // result.clear();
                                  /*likeProvider().getlistdata().then((_) {
                                    setState(() {
                                    });
                                  });*/
                                },
                                child: Text(
                                  "${title_catname[m2]['name']}",
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
                  child:Text(getSubcodename(title_catcode),
                    style: TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
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
                          return ProfileLikeFilter(getcheck_detail_catlist: [title_catcode], getcheck_detail_table_nm: _resultcatlist,);
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
                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                              fontWeight: FontWeight.bold,
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
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      fontWeight: FontWeight.bold,
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

  // 타이틀별 메인카테고리
  Widget Maincategory(context) {
    List<String> allcheckList = [];

    List<dynamic> main_catlist = [];

    if(gubun.contains(title_catcode)){
      main_catlist = areaname;
    }else{
      coderesult.forEach((element) {
        if(element['pidx'] == title_catcode) {
          main_catlist.add(element);
        }
      });
    }

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
                for(var i=0; i<main_catlist.length; i++)
                  Container(
                    height: 9 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if(gubun.contains(title_catcode))
                                Container(
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    splashRadius: 12,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    // materialTapTargetSize: MaterialTapTargetSize.padded,
                                    value: check_detail_arealist.contains(main_catlist[i]['idx']),
                                    checkColor: Colors.white,
                                    activeColor: Color(0xffE47421),
                                    onChanged: (val) {
                                      _onSelected(val!, main_catlist[i]['idx']);
                                    },
                                  ),
                                ),
                              if(!gubun.contains(title_catcode))
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

  void _allSelected(bool selected, main_catlist) {
    if (selected == true) {
      _isChecked = true;
      for(var m2=0; m2<main_catlist.length; m2++) {
        if(gubun.contains(title_catcode)){
          check_detail_arealist.add(main_catlist[m2]['idx']);
        } else{
          sub_checkList.add(main_catlist[m2]['idx']);
        }
      }
      result.clear();
      pagination.clear();
      setlist().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    } else {
      _isChecked = false;
      sub_checkList.clear();
      check_detail_arealist.clear();
      result.clear();
      pagination.clear();
      setlist().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    }
  }
  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
    result.clear();
    pagination.clear();
    if(gubun.contains(title_catcode)){
      check_detail_arealist.add(dataName);
    } else{
      sub_checkList.add(dataName);
    }
    setlist().then((_) {
      setState(() {
        // sub_checkList.add(dataName);
      });
    });
    } else {
      result.clear();
      pagination.clear();
      if(gubun.contains(title_catcode)){
        check_detail_arealist.remove(dataName);
      } else{
        sub_checkList.remove(dataName);
      }
      setlist().then((_) {
        setState(() {
          // sub_checkList.remove(dataName);
        });
      });
    }
  }


  Widget sortby() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
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
            // height: 22 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      fontSize: 18  * (MediaQuery.of(context).size.width / 360),
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
            height: 18 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Text(
                  '최근등록일',
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
     /*     Container(
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
                        '좋아요',
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
              value: 'likeup',
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
                        '좋아요',
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
              value: 'likedown',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),*/
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 18 * (MediaQuery.of(context).size.height / 360),
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
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↑',
                        style: TextStyle(
                            color: Colors.black,
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
            height: 18 * (MediaQuery.of(context).size.height / 360),
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
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↓',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
      ),
    );

  }
  void changesort(val) {
    // print(val);
    setState(() {
      _noData = Container();
      _sortvalue = val;
      result.clear();
      pagination.clear();
      Navigator.pop(context);
      setlist().then((_) {
        _noData = Nodata();
        setState(() {
        });
      });
    });
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

  Container Morelist(context) {
    return Container(
      width: 100 * (MediaQuery.of(context).size.width / 360),
      // height: 20 * (MediaQuery.of(context).size.height / 360),
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
                  setlist().then((_) {
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


  // 타이틀 설정
  String gettitlename() {
    String titlename = '';

    for(var i=0; i<title_catname.length; i++) {
      if(title_catname[i]['idx'] == title_catcode) {
        titlename = title_catname[i]['name'];
      }
    }

    return titlename;
  }

  void _isLiked(like_yn, article_seq, table_nm, apptitle, index) {

    setState(() {
      like_yn = !like_yn;
      if(like_yn) {
        likes_yn = 'Y';
        updatelike( article_seq, table_nm, apptitle);
        setState(() {
          result[index]['like_yn'] = 1;
          result[index]['like_cnt'] = result[index]['like_cnt'] + 1;
        });
      } else{
        likes_yn = 'N';
        updatelike( article_seq, table_nm, apptitle);
        setState(() {
          result[index]['like_yn'] = 0;
          result[index]['like_cnt'] = result[index]['like_cnt'] - 1;
        });
      }

    });
  }

  AlertDialog likealert(BuildContext context, int index) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "관심등록 성공! 관심내역은 마이페이지에서 확인 가능합니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              result[index]['like_yn'] = 1;
            });
          },
        ),
      ],
    );
  }

  AlertDialog unlikealert(BuildContext context, int index) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "관심등록을 취소했습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            result[index]['like_yn'] = 0;
            setState(() {
            });
          },
        ),
      ],
    );
  }

}

