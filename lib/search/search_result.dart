import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/search/morelist/more_community_dailyTalk.dart';
import 'package:hoty/search/morelist/more_kinlist.dart';
import 'package:hoty/search/morelist/more_lesson_list.dart';
import 'package:hoty/search/morelist/more_today_list.dart';
import 'package:hoty/today/today_list.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../categorymenu/living_list.dart';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../categorymenu/living_view.dart';
import '../categorymenu/providers/living_provider.dart';
import '../common/icons/my_icons.dart';
import '../community/dailytalk/community_dailyTalk_view.dart';
import '../today/today_view.dart';
import 'morelist/more_living_list.dart';
import 'morelist/more_trade_list.dart';

class SearchResult extends StatefulWidget {
  String keyword;

  SearchResult({Key? key, required this.keyword}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class customStyleArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xff53B5BB)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    final double triangleH = 5;
    final double triangleW = 20.0;
    final double width = size.width;
    final double height = size.height;
    double nipSize = 7;
    double offset = 10;
    double radius = 5;

    final Path trianglePath = Path();
    var path = Path();
    path.addRRect(RRect.fromLTRBR(
        nipSize, 0, width, height, Radius.circular(radius)));

    var path2 = Path();
    path2.lineTo(0, 2 * nipSize);
    path2.lineTo(-nipSize, nipSize);
    path2.lineTo(0, 0);

    path.addPath(path2, Offset(nipSize, size.height - offset - 1.5 * nipSize));


    canvas.drawPath(path, paint);
    /* final BorderRadius borderRadius = BorderRadius.circular(15);
    final Rect rect = Rect.fromLTRB(width, height, width, height);
    final RRect outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _SearchResultState extends State<SearchResult> {
  List<dynamic> coderesult = []; // 공통코드 리스트
  late String keyword;

  bool _touch_check = false;

  // 공통코드 호출
  Future<dynamic> setcode() async {
    //코드 전체리스트 가져오기
    coderesult = await livingProvider().getcodedata();

    // 생활정보 코드 리스트
    /*   for(int i=0; i<coderesult.length; i++){
      if(coderesult[i]['pidx'] == table_nm){
        cattitle.add(coderesult[i]);
      }
    }*/

    // 타이틀코드,지역코드
  /*  coderesult.forEach((value) {
      if(value['pidx'] == 'C1'){
        title_catname.add(value);
      }
      if(value['pidx'] == 'C2'){
        areaname.add(value);
      }
    });*/

    // 첫번째 카테고리
    /*   for(var i=0; i<title_catname.length; i++){
      if(i == 5){
        title_catcode = title_catname[i]['idx'];
      }
    }*/

  }

  var _isloading = false; // 노데이터 노출

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.keyword;
    _asyncMethod();
    setcode();
    _getSearchHistory();
    keyword = widget.keyword;
    _getSearch().then((_){
      setState(() {
        _getLink().then((_){
          setState(() {
            _isloading = true;
          });
        });
      });
    });
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId')) ?? "";
  }

  String regist_id = "";

  var urlpath = 'http://www.hoty.company';

  Map<String, dynamic> _linkInfo = {};
  String link_url = '';
  var Base_Imgurl = "http://www.hoty.company";

  List<dynamic> _search_history = [];

  List<dynamic> _living_list = [];
  List<dynamic> _today_list = [];
  List<dynamic> _kin_list = [];
  List<dynamic> _cmmu_list = [];


  List<dynamic> _living_list_info = [];
  Map _today_list_info = {};
  Map _kin_list_info = {};
  Map _cmmu_list_info = {};

  List<dynamic> _c1List = [];
  List<dynamic> _c2List = [];
  List<dynamic> _c3List = [];
  List<dynamic> _c4List = [];
  List<dynamic> _c5List = [];
  List<dynamic> _c6List = [];
  List<dynamic> _c7List = [];
  List<dynamic> _c8List = [];
  List<dynamic> _c9List = [];

  List<dynamic> _used_trnsc_list = [];
  Map _used_trnsc_list_info = {};

  List<dynamic> _personal_lesson_list = [];
  Map _personal_lesson_list_info = {};

  TextEditingController _searchController = TextEditingController();

  Future<void> _getSearch() async {
    _living_list.clear();
    _today_list.clear();
    _kin_list.clear();
    _living_list_info.clear();
    _today_list_info.clear();
    _kin_list_info.clear();
    _c1List.clear();
    _c2List.clear();
    _c3List.clear();
    _c4List.clear();
    _c5List.clear();
    _c6List.clear();
    _c7List.clear();
    _c8List.clear();
    _c9List.clear();
    _used_trnsc_list.clear();
    _used_trnsc_list_info.clear();
    _personal_lesson_list.clear();
    _personal_lesson_list_info.clear();
    _cmmu_list.clear();
    _cmmu_list_info.clear();

    final url = Uri.parse('http://www.hoty.company/mf/search/list.do');
    // final url = Uri.parse('http://192.168.0.109/mf/search/list.do');
    try {
      Map data = {
        "keyword" : keyword,
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        _living_list = responseData['result']['living_list'];
        _today_list = responseData['result']['today_list'];
        _kin_list = responseData['result']['kin_list'];


        _living_list_info = responseData['result']['living_list_info'];
        _today_list_info = responseData['result']['today_list_info'];
        _kin_list_info = responseData['result']['kin_list_info'];


        for (var item in _living_list) {
          if (item['main_category'] == 'C1') {
            _c1List.add(item);
          } else if (item['main_category'] == 'C2') {
            _c2List.add(item);
          }else if (item['main_category'] == 'C3') {
            _c3List.add(item);
          }else if (item['main_category'] == 'C4') {
            _c4List.add(item);
          }else if (item['main_category'] == 'C5') {
            _c5List.add(item);
          }
        }


        if(responseData['result']['daily_talk_list'].length > 0) {
          _cmmu_list = responseData['result']['daily_talk_list'];
          _cmmu_list_info = responseData['result']['daily_talk_list_list_info'];
        }


        if(responseData['result']['used_trnsc_list'].length > 0) {
          _used_trnsc_list = responseData['result']['used_trnsc_list'];
          _used_trnsc_list_info = responseData['result']['used_trnsc_list_info'];
        }
        if(responseData['result']['personal_lesson_list'].length > 0) {
          _personal_lesson_list = responseData['result']['personal_lesson_list'];
          _personal_lesson_list_info = responseData['result']['personal_lesson_list_info'];
        }

      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  /* 검색어 저장 api */
  Future<void> _searchInsert(String search_word) async {
    final url = Uri.parse('http://www.hoty.company/mf/search/search_insert.do');
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");

    Map<String, dynamic> data = {
      "reg_id": reg_id,
      "search_word" : search_word,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {

      } else {
        print('요청 실패: ${response.statusCode}');

      }
    } catch (error) {
      print('오류: $error');
    }
  }

  Future<void> _getSearchHistory() async {
    final url = Uri.parse('http://www.hoty.company/mf/search/search_history.do');
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    try {
      Map data = {
        "reg_id" : reg_id,
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        _search_history = responseData['result']['search_history'];
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _searchDelete(int search_seq) async {
    final url = Uri.parse('http://www.hoty.company/mf/search/search_delete.do');

    Map<String, dynamic> data = {
      "search_seq": search_seq,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          _getSearchHistory();
        });

      } else {
        print('요청 실패: ${response.statusCode}');

      }
    } catch (error) {
      print('오류: $error');
    }
  }

  Future<void> _searchAllDelete() async {
    final url = Uri.parse('http://www.hoty.company/mf/search/search_all_delete.do');

    Map<String, dynamic> data = {
      "reg_id": regist_id,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          _getSearchHistory();
        });

      } else {
        print('요청 실패: ${response.statusCode}');

      }
    } catch (error) {
      print('오류: $error');
    }
  }

  Future<void> _getLink() async{
    _linkInfo.clear();
    final url = Uri.parse('http://www.hoty.company/mf/link/view.do');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        _linkInfo = responseData['result']['view'];
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _launchURL() async{
    link_url = _linkInfo['link_url'];
    if (await canLaunch(link_url)) {
      await launch(link_url);
    } else {
      throw 'Could not launch $link_url';
    }
  }

  Future<void> _kakaoURL() async{
    link_url = 'http://pf.kakao.com/_gYrxnG';
    if (await canLaunch(link_url)) {
      await launch(link_url);
    } else {
      throw 'Could not launch $link_url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        titleSpacing: 5,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
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
          child: searchbar(context),
          /*decoration: InputDecoration(
            filled : true,
            border: InputBorder.none,
            hintText: '$keyword',
            hintStyle: TextStyle(color:Color(0xff0F1316),fontFamily: 'NanumSquareEB'),
          ),*/
        ),

        // centerTitle: true,
        /*actions: [
          IconButton(icon: Icon(Icons.search),color: Color.fromRGBO(15, 19, 22, 1),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResult(keyword: '$keyword')));
            },
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container( // 메뉴타이틀
                            alignment: Alignment.center,
                            margin : EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360),
                                0 , 0 * (MediaQuery.of(context).size.height / 360)),
                            width: 360 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child:  Text(
                                    "\"${keyword ?? ""}\"",
                                    style: TextStyle(
                                      fontSize: 22 * (MediaQuery.of(context).size.width / 360),
                                      // color: Color(0xff151515),
                                      // overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(5  * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                  child:  Text(
                                    "검색 결과는 다음",
                                    style: TextStyle(
                                      fontSize: 22 * (MediaQuery.of(context).size.width / 360),
                                      // color: Color(0xff151515),
                                      // overflow: TextOverflow.ellipsis,
                                      // fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ],
                            )

                        ),
                        Container( // 메뉴타이틀
                            alignment: Alignment.center,
                            margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360),
                                0 , 5 * (MediaQuery.of(context).size.height / 360)),
                            width: 360 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            child: Text(
                              "과 같습니다.",
                              style: TextStyle(
                                fontSize: 22 * (MediaQuery.of(context).size.width / 360),
                                // color: Color(0xff151515),
                                // overflow: TextOverflow.ellipsis,
                                // fontWeight: FontWeight.bold,
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                              ),
                            )
                        ),
                      ]
                  )
              ),
              if(_touch_check == false)...[
                if (_living_list.isNotEmpty || _today_list.isNotEmpty || _kin_list.isNotEmpty || _used_trnsc_list.isNotEmpty || _personal_lesson_list.isNotEmpty || _cmmu_list.isNotEmpty)...[
                  Container(
                    child: Column(
                      children: [
                        // 지식인
                        if(_kin_list.isNotEmpty)...[
                          // 지식인
                          kinList(context),
                          if(int.parse('${_kin_list_info['count'] ?? '0'}') > 4)
                            Container(
                              width: 100 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
                              child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                                        side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return M_KinList(success: false, failed: false, main_catcode: '', serchtext: keyword);
                                        },
                                      ));
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
                            ),
                          Container(
                            child: Column(
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
                            ),
                          ),
                        ],


                        // 생활정보
                        for(var i=0; i<_living_list_info.length; i++)
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                      0, 5 * (MediaQuery.of(context).size.height / 360)),
                                    child: subtitle(context,'${_living_list_info[i]['name']}','(${_living_list_info[i]['count']})',),
                                ),
                                if(_c1List.isNotEmpty && _living_list_info[i]['main_category'] == 'C1')...[
                                  apartList(context),
                                ],
                                if(_c2List.isNotEmpty && _living_list_info[i]['main_category'] == 'C2')...[
                                  schoolList(context),
                                ],
                                if(_c3List.isNotEmpty && _living_list_info[i]['main_category'] == 'C3')...[
                                  academyList(context),
                                ],
                                if(_c4List.isNotEmpty && _living_list_info[i]['main_category'] == 'C4')...[
                                  healthyList(context),
                                ],
                                if(_c5List.isNotEmpty && _living_list_info[i]['main_category'] == 'C5')...[
                                  lifeShoppingList(context),
                                ],

                                if(int.parse('${_living_list_info[i]['count'] ?? '0'}') > 4) ...[
                                  Container(
                                    width: 100 * (MediaQuery.of(context).size.width / 360),
                                    margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
                                    child: Column(
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                                              side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                                            ),
                                          ),
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) {
                                                return M_LivingList(title_catcode: _living_list_info[i]['main_category'],
                                                  check_sub_catlist: [],
                                                  check_detail_catlist: [], check_detail_arealist: [], serchtext: keyword,);
                                              },
                                            ));
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
                                  ),
                                  Container(
                                    child: Column(
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
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),


                        //커뮤니티
                        if(_cmmu_list.isNotEmpty)...[
                          dailytalkList(context),
                          if(int.parse('${_cmmu_list_info['count'] ?? '0'}') > 4)
                            Container(
                              width: 100 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
                              child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                                        side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return M_CommunityDailyTalk(main_catcode: '', serchtext: keyword,);
                                        },
                                      ));
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
                            ),
                          Container(
                            child: Column(
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
                            ),
                          ),
                        ],


                        //오늘의정보
                        if(_today_list.isNotEmpty)...[
                          // 오늘의정보
                          todayList(context),
                          if(int.parse('${_today_list_info['count'] ?? '0'}') > 4)
                            Container(
                              width: 100 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
                              child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                                        side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return M_TodayList(main_catcode: '',
                                              table_nm: 'TODAY_INFO', serchtext: keyword,);
                                        },
                                      ));
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
                            ),
                          Container(
                            child: Column(
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
                            ),
                          ),
                        ],

                        //호치민 정착가이드

                        //중고거래
                        if(_used_trnsc_list.isNotEmpty && _used_trnsc_list.length > 0)...[
                          usedTrnscList(context),
                          if(int.parse('${_used_trnsc_list_info['count'] ?? '0'}') > 4)
                            Container(
                              width: 100 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
                              child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                                        side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return M_TradeList(checkList: [], serchtext: keyword,);
                                        },
                                      ));
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
                            ),
                          Container(
                            child: Column(
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
                            ),
                          ),
                        ],

                        //개인과외
                        if(_personal_lesson_list.isNotEmpty && _personal_lesson_list.length > 0)...[
                          personalLessonList(context),
                          if(int.parse('${_personal_lesson_list_info['count'] ?? '0'}') > 4)
                            Container(
                              width: 100 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
                              child: Column(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                                        side : BorderSide(color: Color(0xff2F67D3),width: 2 ),
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return M_LessonList(checkList: [], serchtext: keyword,);
                                        },
                                      ));
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
                            ),
                          Container(
                            child: Column(
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
                            ),
                          ),
                        ],


                      ],
                    ),

                  ),
                ],
                if(_cmmu_list.isEmpty && _living_list.isEmpty && _today_list.isEmpty && _kin_list.isEmpty && _used_trnsc_list.isEmpty && _used_trnsc_list.length == 0 && _personal_lesson_list.isEmpty && _personal_lesson_list.length == 0
                && _isloading == true)...[
                  Container(
                    width: 200 * (MediaQuery.of(context).size.width / 360),
                    height: 110 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('$Base_Imgurl${_linkInfo['img_url']}'),
                        // fit: BoxFit.cover
                      ),
                    ),
                    // color: Colors.amberAccent,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360)),
                    child: Text(
                      "${_linkInfo['title'] ?? ""}",
                      style: TextStyle(
                        fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 9 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                        child: Container(
                          width: 335 * (MediaQuery.of(context).size.width / 360),
                          height: 30 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffE47421),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return KinList(success: false, failed: false,main_catcode: '',);
                                  },
                                ));
                              },
                              child: Center(
                                child: Text(
                                  "지식인",
                                  style: TextStyle(
                                    fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                    color: Colors.white,
                                    fontFamily: 'NanumSquareEB',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                        child: Container(
                          width: 335 * (MediaQuery.of(context).size.width / 360),
                          height: 30 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xff2F67D3),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                _kakaoURL();
                              },
                              child: Center(
                                child: Text(
                                  "카카오톡 1:1 문의",
                                  style: TextStyle(
                                    fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                    fontFamily: 'NanumSquareEB',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      4 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    width: 335 * (MediaQuery.of(context).size.width / 360),
                    child: Text(
                      "${_linkInfo['conts'] ?? ""}",
                      style: TextStyle(
                        fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
              if(_touch_check == true)...[
                Container(
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Center(
                    child: Container(
                      width: 340 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(0xffE47421),
                          width: 1.0,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return KinList(success: false, failed: false, main_catcode: '');
                            },
                          ));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Center(
                          child: Text(
                            "지식 iN에 물어보기",
                            style: TextStyle(
                              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xffE47421),
                              fontFamily: 'NanumSquareEB',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),

                  /*   padding: EdgeInsets.fromLTRB(
                    20 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),*/
                  margin : EdgeInsets.fromLTRB(0  * (MediaQuery.of(context).size.width / 360),
                      10 * (MediaQuery.of(context).size.height / 360),
                      0  * (MediaQuery.of(context).size.width / 360),
                      8  * (MediaQuery.of(context).size.height / 360)),
                  // height: 10 * (MediaQuery.of(context).size.height / 360),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "최근 검색",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff0F1316),
                            // fontFamily: 'NanumSquareB',
                            fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            /*  GestureDetector(
                                onTap: () {
                                  _searchAllDelete().then((_) {
                                    setState(() {
                                    });
                                  });
                                },
                                child: Image(
                                  image: AssetImage('assets/search_del.png'),
                                  width: 15 * (MediaQuery.of(context).size.width / 360),
                                ),
                              ),*/
                            GestureDetector(
                              onTap: () {
                                _searchAllDelete().then((_) {
                                  _getSearchHistory().then((value) {
                                    setState(() {

                                    });
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  5 * (MediaQuery.of(context).size.width / 360),
                                  0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360),
                                  0 * (MediaQuery.of(context).size.height / 360),
                                ),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "모두 삭제",
                                  style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff2F67D3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
                if(_search_history.isNotEmpty)...[
                  for(var i=0; i<_search_history.length; i++)
                    Container(
                      width: 340 * (MediaQuery.of(context).size.width / 360),
                      margin: EdgeInsets.fromLTRB(
                        0 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360),
                        1 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(
                            width: 300 * (MediaQuery.of(context).size.width / 360),
                            child :  GestureDetector(
                              onTap: (){
                                // print('#####################################');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResult(keyword: _search_history[i]['search_word']),
                                  ),
                                );
                              },
                              child: Container(
                                  width: 300 * (MediaQuery.of(context).size.width / 360),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 180 * (MediaQuery.of(context).size.width / 360),
                                      alignment: Alignment.centerLeft,
                                      color: Colors.transparent,
                                      child: Text(
                                        '${_search_history[i]['search_word']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          color: Colors.black,
                                        ),

                                      ),
                                    ),
                                    Container(
                                      // alignment: Alignment.centerRight,
                                      child: Text(
                                        '${_search_history[i]['search_dt']}',
                                        style: TextStyle(
                                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                            color: Color(0xffC4CCD0)
                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                      10 * (MediaQuery.of(context).size.width / 360),
                                      0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360),
                                      0 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          _searchDelete(_search_history[i]['search_seq']).then((_) {
                                            _getSearchHistory().then((value) {
                                              setState(() {

                                              });
                                            });
                                          });
                                        },
                                        child : Icon(Icons.close_rounded, color: Color(0xff151515), size: 13 * (MediaQuery.of(context).size.height / 360),)                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),


                    ),
                ],
              ],
              Container(
                margin: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  40 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
              )
            ]
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'Search_page'),
    );
  }

  Widget apartList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c1List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c1List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c1List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c1List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c1List[0]['img_path'] != '' &&  _c1List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c1List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c1List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c1List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c1List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c1List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c1List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c1List[1]['img_path'] != '' &&  _c1List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c1List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c1List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c1List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c1List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c1List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c1List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c1List[2]['img_path'] != '' &&  _c1List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c1List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c1List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c1List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c1List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c1List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c1List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c1List[3]['img_path'] != '' &&  _c1List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c1List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c1List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c1List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget schoolList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c2List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c2List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c2List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c2List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c2List[0]['img_path'] != '' &&  _c2List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c2List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c2List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c2List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c2List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c2List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c2List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c2List[1]['img_path'] != '' &&  _c2List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c2List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c2List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c2List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c2List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c2List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c2List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c2List[2]['img_path'] != '' &&  _c2List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c2List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c2List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c2List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c2List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c2List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c2List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c2List[3]['img_path'] != '' &&  _c2List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c2List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c2List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c2List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget academyList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c3List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c3List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c3List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c3List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c3List[0]['img_path'] != '' &&  _c3List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c3List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c3List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c3List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c3List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c3List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c3List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c3List[1]['img_path'] != '' &&  _c3List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c3List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c3List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c3List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c3List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c3List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c3List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c3List[2]['img_path'] != '' &&  _c3List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c3List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c3List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c3List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c3List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c3List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c3List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c3List[3]['img_path'] != '' &&  _c3List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c3List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c3List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c3List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget healthyList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c4List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c4List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c4List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c4List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c4List[0]['img_path'] != '' &&  _c4List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c4List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c4List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c4List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c4List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c4List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c4List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c4List[1]['img_path'] != '' &&  _c4List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c4List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c4List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c4List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c4List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c4List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c4List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c4List[2]['img_path'] != '' &&  _c4List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c4List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c4List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c4List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c4List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c4List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c4List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c4List[3]['img_path'] != '' &&  _c4List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c4List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c4List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                          child: Row(
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                child: Text(
                                                  '${_c4List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget lifeShoppingList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c5List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c5List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c5List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c5List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c5List[0]['img_path'] != '' &&  _c5List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c5List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c5List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c5List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c5List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c5List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c5List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c5List[1]['img_path'] != '' &&  _c5List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c5List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c5List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c5List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c5List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c5List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c5List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c5List[2]['img_path'] != '' &&  _c5List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c5List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c5List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c5List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c5List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c5List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c5List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c5List[3]['img_path'] != '' &&  _c5List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c5List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c5List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c5List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget restaurantList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c6List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c6List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c6List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c6List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c6List[0]['img_path'] != '' &&  _c6List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c6List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c6List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c6List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c6List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c6List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c6List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c6List[1]['img_path'] != '' &&  _c6List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c6List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c6List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c6List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c6List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c6List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c6List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c6List[2]['img_path'] != '' &&  _c6List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c6List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c6List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c6List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c6List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c6List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c6List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c6List[3]['img_path'] != '' &&  _c6List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c6List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c6List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c6List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leisureList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c7List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c7List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c7List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c7List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c7List[0]['img_path'] != '' &&  _c7List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c7List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c7List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c7List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c7List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c7List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c7List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c7List[1]['img_path'] != '' &&  _c7List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c7List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c7List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c7List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c7List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c7List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c7List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c7List[2]['img_path'] != '' &&  _c7List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c7List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c7List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c7List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c7List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c7List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c7List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c7List[3]['img_path'] != '' &&  _c7List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c7List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c7List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c7List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rentcarList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c8List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c8List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c8List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c8List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c8List[0]['img_path'] != '' &&  _c8List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c8List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c8List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c8List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c8List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c8List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c8List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c8List[1]['img_path'] != '' &&  _c8List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c8List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c8List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c8List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c8List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c8List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c8List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c8List[2]['img_path'] != '' &&  _c8List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c8List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c8List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c8List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c8List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c8List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c8List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c8List[3]['img_path'] != '' &&  _c8List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c8List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c8List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c8List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget licensingList(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: _c9List.length > 2 ? 190 * (MediaQuery.of(context).size.height / 360) : 100 * (MediaQuery.of(context).size.height / 360),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c9List.isNotEmpty)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c9List[0]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c9List[0]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c9List[0]['img_path'] != '' &&  _c9List[0]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c9List[0]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c8List[0]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c9List[0]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c9List.length >= 2)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c9List[1]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c9List[1]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c9List[1]['img_path'] != '' &&  _c9List[1]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c9List[1]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c9List[1]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c9List[1]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            // padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_c9List.length >= 3)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c9List[2]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c9List[2]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c9List[2]['img_path'] != '' &&  _c9List[2]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c9List[2]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c9List[2]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c9List[2]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
                if(_c9List.length >= 4)...[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return LivingView(article_seq: _c9List[3]['article_seq'], table_nm: 'LIVING_INFO', title_catcode: _c9List[3]['main_category'], params: {},);
                        },
                      ));
                    },
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.black,
                      width: 175 * (MediaQuery.of(context).size.width / 360),
                      height: 90 * (MediaQuery.of(context).size.height / 360),
                      child: Column(
                        children: [
                          Container(
                            width: 170 * (MediaQuery.of(context).size.width / 360),
                            height: 70 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: _c9List[3]['img_path'] != '' &&  _c9List[3]['img_path']!= null ? DecorationImage(
                                  image: CachedNetworkImageProvider('$urlpath${_c9List[3]['img_path']}'),
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
                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2F67D3),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5,
                                              7 * (MediaQuery.of(context).size.width / 360) , 5 ),
                                          child: Text(getSubcodename(_c9List[3]['area_category']),
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
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                          // 하단 정보
                          Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            // color: Colors.purpleAccent,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 150 * (MediaQuery.of(context).size.width / 360),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                constraints: BoxConstraints(maxWidth : 140 * (MediaQuery.of(context).size.width / 360)),
                                                child: Text(
                                                  '${_c9List[3]['title']}',
                                                  style: TextStyle(
                                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'NanumSquareEB',
                                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget subtitle(context,text,count) {
    return Container(
        // constraints: BoxConstraints(maxWidth : 350 * (MediaQuery.of(context).size.width / 360)),
        // width: 350 * (MediaQuery.of(context).size.width / 360),
        // height: 12 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(
          10 * (MediaQuery.of(context).size.width / 360),
          0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360),
          0 * (MediaQuery.of(context).size.height / 360),
        ),
        child: Row(
            // mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin : EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          count,
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xffE47421),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child : Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
              fit : FlexFit.tight,
            ),
            Container(
              margin : EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
            )


          ],
        )
    );
  }

  Widget kinList(context) {
    return
      Container(
          padding: EdgeInsets.fromLTRB(
            0 * (MediaQuery.of(context).size.width / 360),
            0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360),
            0 * (MediaQuery.of(context).size.height / 360),
          ),
          width: 360 * (MediaQuery.of(context).size.width / 360),
          child: Column (
              children : [
                subtitle(context,'지식in','(${_kin_list_info['count']})',),
                  Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Column(
                          children: [
                            for(var i=0; i < _kin_list.length; i++)
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return KinView(article_seq : _kin_list[i]['list']['article_seq'], table_nm : _kin_list[i]['list']['table_nm'], adopt_chk: _kin_list[i]["list"]["adopt_chk"],);
                                    },
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 360 * (MediaQuery.of(context).size.width / 360),
                                        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
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
                                                  Text("${_kin_list[i]["list"]["title"]}",
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
                                      if(_kin_list[i]["list"]["comment_conts"] != null && _kin_list[i]["list"]["comment_conts"] != '')
                                        Container(
                                            width: 360 * (MediaQuery.of(context).size.width / 360),
                                            margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                10 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360)),
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
                                                      "${_kin_list[i]["list"]["comment_conts"]}"
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
                                                          "${_kin_list[i]["list"]["comment_reg_nm"]} ",
                                                          style: TextStyle(
                                                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                            fontWeight: FontWeight.w700,
                                                            color: Color(0xff151515),
                                                            fontFamily: 'NanumSquareR',
                                                          ),
                                                        ),
                                                        Icon(My_icons.rate,
                                                          color: _kin_list[i]['comment_group_seq'] == '4' ? Color(0xff27AE60):
                                                          _kin_list[i]['comment_group_seq'] == '5' ? Color(0xff27AE60) :
                                                          _kin_list[i]['comment_group_seq'] == '6' ? Color(0xffFBCD58) :
                                                          _kin_list[i]['comment_group_seq'] == '7' ? Color(0xffE47421) :
                                                          _kin_list[i]['comment_group_seq'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
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
                                                        Text("${_kin_list[i]["list"]["comment_reg_dt"]}",
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
                                                        Text("${getSubcodename(_kin_list[i]["list"]["main_category"])}",
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
                                            margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                10 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360)),
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
                                                      "${_kin_list[i]["list"]["conts"]}"
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
                                                          "${_kin_list[i]["list"]["reg_nm"]} ",
                                                          style: TextStyle(
                                                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                            fontWeight: FontWeight.w700,
                                                            color: Color(0xff151515),
                                                            fontFamily: 'NanumSquareR',
                                                          ),
                                                        ),
                                                        Icon(My_icons.rate,
                                                          color: _kin_list[i]['group_seq'] == '4' ? Color(0xff27AE60):
                                                          _kin_list[i]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                          _kin_list[i]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                          _kin_list[i]['group_seq'] == '7' ? Color(0xffE47421) :
                                                          _kin_list[i]['group_seq'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
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
                                                        Text("${_kin_list[i]["list"]["reg_dt"]}",
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
                                                        Text("${getSubcodename(_kin_list[i]["list"]["main_category"])}",
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
                                      if(_kin_list.length-1 != i)
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
                                      //Divider(thickness: 7, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8), ),
                                      /*Container(
                              width: 360 * (MediaQuery.of(context).size.width / 360),
                              height : 5 * (MediaQuery.of(context).size.height / 360) ,
                              *//*margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  4 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*//*
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffF3F6F8)
                                ),
                                //borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                color: Color(0xffF3F6F8),
                              ),
                            ),*/
                                    ],
                                  ),
                                ),
                              )


                          ]
                      )
                  ),
              ]
        )
    );
  }

  Widget dailytalkList(context) {
    return
      Container( // 게시판
        width: 360 * (MediaQuery.of(context).size.width / 360),
        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
        // height: 200 * (MediaQuery.of(context).size.height / 360),
        child: Column(
          children: [
            subtitle(context,'커뮤니티','(${_cmmu_list_info['count']})',),

            for(var i=0; i<_cmmu_list.length; i++)
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CommunityDailyTalkView(article_seq : _cmmu_list[i]['article_seq'], table_nm : _cmmu_list[i]['table_nm'],
                              main_catcode : _cmmu_list[i]['main_category'], params: {},);
                          },
                        ));
                      },
                      child: Container(
                          width : 360 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                                          "${_cmmu_list[i]["title"] ?? ''}",
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
                                                      Text("${_cmmu_list[i]["reg_dt"] ?? ''}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                      Text("  ·  ", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                      Text("${getSubcodename(_cmmu_list[i]["main_category"])}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                    ],
                                                  )
                                              ),
                                              Container(
                                                  child : Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 * (MediaQuery.of(context).size.width / 360) , ),
                                                      Text(" ${_cmmu_list[i]["like_cnt"]}"),
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
                                                      Text(" ${_cmmu_list[i]["comment_cnt"]}"),
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
                                  image: _cmmu_list[i]["main_img"] != null ? DecorationImage(
                                      image:  CachedNetworkImageProvider(urlpath+'${_cmmu_list[i]["main_img_path"]}${_cmmu_list[i]["main_img"]}'),
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
                      ),

                    ),

                  ],
                ),
              ),
          ],
        ),
      );
  }

  Widget todayList(context) {
    return
      Container( // 게시판
        width: 360 * (MediaQuery.of(context).size.width / 360),
        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
        // height: 200 * (MediaQuery.of(context).size.height / 360),
        child: Column(
          children: [
            subtitle(context,'오늘의 정보','(${_today_list_info['count']})',),

            for(var i=0; i<_today_list.length; i++)
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return todayView(article_seq: _today_list[i]['article_seq'], title_catcode: _today_list[i]['main_category'],cat_name: getSubcodename(_today_list[i]['main_category']), table_nm: _today_list[i]['table_nm'],);
                          },
                        ));
                      },
                      child: Container(
                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        // height: 60 * (MediaQuery.of(context).size.height / 360),
                        // color: Colors.black87,
                        child: Column(
                          children: [
                            Container(
                              // height: 30 * (MediaQuery.of(context).size.height / 360),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0 * (MediaQuery.of(context).size.height / 360)),
                              child: Row(
                                children: [
                                  if(_today_list[i]['main_category'] == 'TD_001')
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60 * (MediaQuery.of(context).size.width / 360),
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: 55 * (MediaQuery.of(context).size.width / 360),
                                            height: 25 * (MediaQuery.of(context).size.height / 360),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color : Color(0xffE47421)
                                            ),
                                            child:
                                            Icon(Icons.notifications_active, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                                          )
                                        ],
                                      ),
                                    ),
                                  if(_today_list[i]['main_category'] == 'TD_002')
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60 * (MediaQuery.of(context).size.width / 360),
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: 55 * (MediaQuery.of(context).size.width / 360),
                                            height: 25 * (MediaQuery.of(context).size.height / 360),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color : Color(0xffE47421)
                                            ),
                                            child:
                                            Icon(Icons.description_outlined, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                                          )
                                        ],
                                      ),
                                    ),
                                  if(_today_list[i]['main_category'] == 'TD_003')
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60 * (MediaQuery.of(context).size.width / 360),
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: 55 * (MediaQuery.of(context).size.width / 360),
                                            height: 25 * (MediaQuery.of(context).size.height / 360),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color : Color(0xffE47421)
                                            ),
                                            child:
                                            Icon(Icons.attach_money, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                                          )
                                        ],
                                      ),
                                    ),
                                  if(_today_list[i]['main_category'] == 'TD_004')
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60 * (MediaQuery.of(context).size.width / 360),
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: 55 * (MediaQuery.of(context).size.width / 360),
                                            height: 25 * (MediaQuery.of(context).size.height / 360),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color : Color(0xffE47421)
                                            ),
                                            child:
                                            Icon(Icons.movie_outlined, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
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
                                          // height: 10 * (MediaQuery.of(context).size.height / 360),
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),
                                              0, 5 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text(
                                            getSubcodename("${_today_list[i]['main_category']}"),
                                            style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                        ),
                                        Container(
                                          // height: 15 * (MediaQuery.of(context).size.height / 360),
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360),
                                              0, 0 * (MediaQuery.of(context).size.height / 360)),
                                          child: Text(
                                            "${_today_list[i]['title']}",
                                            style: TextStyle(
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              // fontWeight: FontWeight.bold,
                                              // overflow: TextOverflow.visible,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                            Container(
                              // height: 20 * (MediaQuery.of(context).size.height / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(0, 0, 0, 5 * (MediaQuery.of(context).size.height / 360)),
                                    // width: 150 * (MediaQuery.of(context).size.width / 360),
                                    child: Text(
                                      "${_today_list[i]['reg_dt']}",
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
                    if(i != _today_list.length - 1)
                      Divider(thickness: 4, height: 3 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),

                  ],
                ),
              ),
          ],
        ),
      );
  }

  Widget usedTrnscList(context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          subtitle(context,'중고거래','(${_used_trnsc_list_info['count']})',),
          Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Wrap(
                children: [
                  for(int i = 0; i < (_used_trnsc_list.length < 4 ? _used_trnsc_list.length : 4); i++)
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TradeView(article_seq : _used_trnsc_list[i]['article_seq'], table_nm : _used_trnsc_list[i]['table_nm'], params: {}, checkList: [],);
                            },
                          ));
                        },
                        child: Container(
                            width: 180 * (MediaQuery.of(context).size.width / 360),
                            // height: 120 * (MediaQuery.of(context).size.height / 360),
                            child: Column(
                              children: [
                                Container(
                                    width: 180 * (MediaQuery.of(context).size.width / 360),
                                    padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 165 * (MediaQuery.of(context).size.width / 360),
                                          height: 80 * (MediaQuery.of(context).size.height / 360),
                                          decoration: BoxDecoration(
                                            image: _used_trnsc_list[i]['main_img'] != '' &&  _used_trnsc_list[i]['main_img']!= null ? DecorationImage(
                                                image: CachedNetworkImageProvider('$urlpath${_used_trnsc_list[i]['main_img_path']}${_used_trnsc_list[i]['main_img']}'),
                                                fit: BoxFit.cover
                                            ) : DecorationImage(
                                                image: AssetImage('assets/noimage.png'),
                                                fit: BoxFit.fill
                                            ),
                                            borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              if(_used_trnsc_list[i]['cat02'] == 'D201')
                                                Container(
                                                    margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                        0 , 0 ),

                                                    decoration: BoxDecoration(
                                                      color: Color(0xff53B5BB),
                                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                    ),
                                                    child:Row(
                                                      children: [
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Text(
                                                            '판매 중',
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
                                              if(_used_trnsc_list[i]['cat02'] == 'D202')
                                                Container(
                                                    margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                        0 , 0 ),

                                                    decoration: BoxDecoration(
                                                      color: Color(0xff925331),
                                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                    ),
                                                    child:Row(
                                                      children: [
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Text(
                                                            '판매완료',
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
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                  width: 165 * (MediaQuery.of(context).size.width / 360),
                                  // height: 45 * (MediaQuery.of(context).size.height / 360),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin : EdgeInsets.fromLTRB(0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                            0  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              /*width: 75 * (MediaQuery.of(context).size.width / 360),*/
                                              constraints: BoxConstraints(maxWidth : 75 * (MediaQuery.of(context).size.width / 360)),
                                              child: Text(
                                                _used_trnsc_list[i]['reg_nm'],
                                                style: TextStyle(
                                                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                  color: Colors.blueAccent,
                                                  overflow: TextOverflow.ellipsis,
                                                  // fontWeight: FontWeight.bold,
                                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Container(
                                              height : 8 * (MediaQuery.of(context).size.height / 360) ,
                                              margin : EdgeInsets.fromLTRB(6  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                                  3  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                                              child :  DottedLine(
                                                lineThickness:1,
                                                dashLength: 2.0,
                                                dashColor: Color(0xffC4CCD0),
                                                direction: Axis.vertical,
                                              ),
                                            ),
                                            Container(
                                                width: 75 * (MediaQuery.of(context).size.width / 360),
                                                padding : EdgeInsets.fromLTRB(0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                                    0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                                                child: Row(
                                                  children: [
                                                    Icon(My_icons.rate,
                                                      color: _used_trnsc_list[i]['group_seq'] == '4' ? Color(0xff27AE60) :
                                                      _used_trnsc_list[i]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                      _used_trnsc_list[i]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                      _used_trnsc_list[i]['group_seq'] == '7' ? Color(0xffE47421) :
                                                      _used_trnsc_list[i]['group_seq'] == '10' ? Color(0xffE47421)
                                                          : Color(0xff27AE60),
                                                      size: 8 * (MediaQuery.of(context).size.height / 360),),
                                                    // Image(image: AssetImage('assets/rate01.png')),
                                                    Text(
                                                      "${_used_trnsc_list[i]['user_group_nm'] ?? ""}",
                                                      style: TextStyle(
                                                        fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                        // color: Colors.white,
                                                        overflow: TextOverflow.ellipsis,
                                                        // fontWeight: FontWeight.bold,
                                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),

                                      ),
                                      Container(
                                        margin : EdgeInsets.fromLTRB(0, 0.5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 10 * (MediaQuery.of(context).size.height / 360),
                                        child: Text(
                                          getVND(_used_trnsc_list[i]['etc01']),
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
                                      Container(
                                        margin : EdgeInsets.fromLTRB(0, 2  * (MediaQuery.of(context).size.height / 360), 0,  10  * (MediaQuery.of(context).size.height / 360)),
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        // height: 15 * (MediaQuery.of(context).size.height / 360),
                                        child: Text(
                                          _used_trnsc_list[i]['title'],
                                          style: TextStyle(
                                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                            // color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            // fontWeight: FontWeight.bold,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          /*      Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration : BoxDecoration (
                                        border : Border(
                                            bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                                        )
                                    )
                                ),*/
                              ],
                            )
                        )
                    ),
                ],
              )
          )
        ],
      )
    );
  }

  Widget personalLessonList(context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          subtitle(context,'개인과외','(${_personal_lesson_list_info['count']})',),

          if(_personal_lesson_list.length >0)
            for(var i=0; i<_personal_lesson_list.length; i++)
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return LessonView(article_seq : _personal_lesson_list[i]['article_seq'], table_nm : _personal_lesson_list[i]['table_nm'], params: {},checkList: [],);
                    },
                  ));
                },
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
                          // padding: EdgeInsets.fromLTRB(20,30,10,15),
                          // color: Colors.black,
                          width: 340 * (MediaQuery.of(context).size.width / 360),
                          // height: 185 * (MediaQuery.of(context).size.height / 360),
                          child: Column(
                            children: [
                              Container(
                                width: 340 * (MediaQuery.of(context).size.width / 360),
                                height: 110 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: _personal_lesson_list[i]['main_img'] != '' &&  _personal_lesson_list[i]['main_img']!= null ? DecorationImage(
                                      image: CachedNetworkImageProvider('http://www.hoty.company/${_personal_lesson_list[i]['main_img_path']}${_personal_lesson_list[i]['main_img']}'),
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
                                    for(int m2=0; m2<coderesult.length; m2++)
                                      if(coderesult[m2]['idx'] == _personal_lesson_list[i]['main_category'])
                                        Container(
                                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 , 0 ),
                                          // height: 12 * (MediaQuery.of(context).size.height / 360),
                                          decoration: BoxDecoration(
                                            color: Color(0xff27AE60),
                                            borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child:Container(
                                              padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 4,
                                                  5 * (MediaQuery.of(context).size.width / 360), 4),
                                              child: Text('${coderesult[m2]['name']}',
                                                style: TextStyle(
                                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                  color: Colors.white,
                                                  // fontWeight: FontWeight.bold,
                                                  // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              // 하단 정보
                              Container(
                                width: 340 * (MediaQuery.of(context).size.width / 360),
                                // height: 65 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.width / 360),
                                                0 * (MediaQuery.of(context).size.width / 360), 0),
                                            width: 200 * (MediaQuery.of(context).size.width / 360),
                                            height: 10 * (MediaQuery.of(context).size.height / 360),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),0,
                                                              6 * (MediaQuery.of(context).size.width / 360), 0),
                                                          child: Text(
                                                            "${_personal_lesson_list[i]['reg_nm']}",
                                                            style: TextStyle(
                                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                              color: Colors.blue,
                                                              // overflow: TextOverflow.ellipsis,
                                                              fontWeight: FontWeight.w500,
                                                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                Container(
                                                  height: 7 * (MediaQuery.of(context).size.height / 360),
                                                  child : DottedLine(
                                                    lineThickness:1,
                                                    dashLength: 2.0,
                                                    dashColor: Color(0xffC4CCD0),
                                                    direction: Axis.vertical,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Icon(My_icons.rate,
                                                        color: _personal_lesson_list[i]['group_seq'] == '4' ? Color(0xff27AE60) :
                                                        _personal_lesson_list[i]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                        _personal_lesson_list[i]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                        _personal_lesson_list[i]['group_seq'] == '7' ? Color(0xffE47421) :
                                                        _personal_lesson_list[i]['group_seq'] == '10' ? Color(0xffE47421)
                                                            : Color(0xff27AE60),
                                                        size: 8 * (MediaQuery.of(context).size.height / 360),),
                                                      // Image(image: AssetImage('assets/rate01.png')),
                                                      Container(
                                                        margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                        child: Text(
                                                          "${_personal_lesson_list[i]['group_nm']}",
                                                          style: TextStyle(
                                                            fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                            color: Color(0xff0F1316),
                                                            overflow: TextOverflow.ellipsis,
                                                            fontWeight: FontWeight.w500,
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
                                    Container(
                                      margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.width / 360), 4  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      width: 340 * (MediaQuery.of(context).size.width / 360),
                                      child: Text(
                                        "${_personal_lesson_list[i]['title']}",
                                        style: TextStyle(
                                          fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                          // color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'NanumSquareEB',
                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.width / 360),
                                          2  * (MediaQuery.of(context).size.height / 360), 0, 1  * (MediaQuery.of(context).size.height / 360)),
                                      width: 340 * (MediaQuery.of(context).size.width / 360),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "후기",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                // color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'NanumSquareR',
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                            child: Text(
                                              "${_personal_lesson_list[i]['rating_cnt']}",
                                              style: TextStyle(
                                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.black54,
                                                overflow: TextOverflow.ellipsis,
                                                // fontWeight: FontWeight.bold,
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                          if( _personal_lesson_list[i]['rating_cnt'] != null &&  _personal_lesson_list[i]['rating_cnt'] != '')
                                          Container(
                                            margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                            child: Row(
                                              children: [
                                                RatingBarIndicator(
                                                  unratedColor: Color(0xffC4CCD0),
                                                  rating: _personal_lesson_list[i]['rating_cnt'].toDouble(),
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
                                                    "(${_personal_lesson_list[i]['comment_cnt']})",
                                                    style: TextStyle(
                                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
                                      margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                          0, 0),
                                      width: 340 * (MediaQuery.of(context).size.width / 360),
                                      // height: 10 * (MediaQuery.of(context).size.height / 360),
                                      child: Text(
                                        getVND(_personal_lesson_list[i]['etc01']),
                                        style: TextStyle(
                                          fontSize: 18 * (MediaQuery.of(context).size.width / 360),
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
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                // color: Colors.purpleAccent,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            // height: 10 * (MediaQuery.of(context).size.height / 360),
                                            width: 100 * (MediaQuery.of(context).size.width / 360),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin : EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360),0, 0 * (MediaQuery.of(context).size.width / 360), 0),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.favorite, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                                        Container(
                                                          constraints: BoxConstraints(maxWidth : 60 * (MediaQuery.of(context).size.width / 360)),
                                                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360),0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                                                          child: Text(
                                                            "${_personal_lesson_list[i]['like_cnt']}",
                                                            style: TextStyle(
                                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                              color: Colors.black87,
                                                              // fontWeight: FontWeight.bold,
                                                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                            ),
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ),
                                                Container(
                                                  height: 8 * (MediaQuery.of(context).size.height / 360),
                                                  child : DottedLine(
                                                    lineThickness:1,
                                                    dashLength: 2.0,
                                                    dashColor: Color(0xffC4CCD0),
                                                    direction: Axis.vertical,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                                      Container(
                                                        constraints: BoxConstraints(maxWidth : 80 * (MediaQuery.of(context).size.width / 360)),
                                                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                        child: Text(
                                                          "${_personal_lesson_list[i]['view_cnt']}",
                                                          style: TextStyle(
                                                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                            color: Colors.black87,
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
                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                            child: Text(
                                              "${_personal_lesson_list[i]['reg_dt']}",
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Color(0xffC4CCD0),
                                                // fontWeight: FontWeight.bold,
                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                              ),
                                            ),
                                          ),
                                          /*Container(
                                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                          width: 110 * (MediaQuery.of(context).size.width / 360),
                                          child: Text(
                                            "2023/06/20 00:00",
                                            style: TextStyle(
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              color: Color(0xffC4CCD0),
                                              // fontWeight: FontWeight.bold,
                                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                            ),
                                          ),
                                        ),*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(i != _personal_lesson_list.length - 1)
                          Container(
                            child: Column(
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
                            ),
                          ),
                      ]
                  ),
                ),
              ),
        ],
      ),
    );
  }

  // S 타입 리스트
  /*Widget s_resultList(context, c_height) {

    return
      Column(
        children: [
          for(int i=0; i<result.length; i++)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              // height: 60 * (MediaQuery.of(context).size.height / 360),
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
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LessonView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], params: params, checkList: sub_checkList,);
                              },
                            ));
                          },
                          child: Container(
                            width: 150 * (MediaQuery.of(context).size.width / 360),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: result[i]['main_img'] != null &&  result[i]['main_img'] != '' ? DecorationImage(
                                      image: CachedNetworkImageProvider('$base_Imgurl${result[i]['main_img_path']}${result[i]['main_img']}'),
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
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LessonView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], params: params, checkList: sub_checkList,);
                                    },
                                  ));
                                },
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    '${result[i]['title']}',
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
                                *//*width: 340 * (MediaQuery.of(context).size.width / 360),*//*
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
                                            itemSize: 15.0,
                                            direction: Axis.horizontal,
                                          ),
                                          Container(
                                            margin : EdgeInsets.fromLTRB( 2  * (MediaQuery.of(context).size.height / 360), 0, 0, 0.5 * (MediaQuery.of(context).size.height / 360)),
                                            child: Text(
                                              "(${result[i]['rating_count']})",
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
                                  getVND(result[i]['etc01']),
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
  }*/

  Container searchbar(BuildContext context) {
    return Container(
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            color:Color(0xffC4CCD0),
            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
          ),
          // hintText: '$keyword',
          suffixIcon: IconButton(
            icon: Icon(Icons.search_rounded, color: Color.fromRGBO(15, 19, 22, 1)),
            onPressed: () {
              _onSearchIconClick(_searchController.text);
            },
          ),
        ),

        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        onTap: () {
          setState(() {
            _touch_check = true;
            _getSearchHistory().then((_){
              setState(() {

              });
            });
          });
        },
        onSubmitted: (value) async {
          keyword = value;
          _searchInsert(keyword);
          _getSearch().then((_){
            setState(() {
              _touch_check = false;
            });
          });
        },
        style: TextStyle(decorationThickness: 0 , fontSize: 16 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
      ),
    );
  }

  void _onSearchIconClick(String searchText) {
    setState(() {
      keyword = searchText;
      _searchInsert(searchText);
      _getSearch().then((_){
        setState(() {
          _touch_check = false;
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

  String getVND(pay) {
    String payment = "";

    if(pay != null && pay != ''){
      var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
      getpay.format(int.parse(pay));
      payment = getpay.format(int.parse(pay)) + " VND";
    }

    return payment;
  }

}

String getPoint(pay) {
  String payment = "";

  if(pay != null && pay != ''){
    var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
    getpay.format(int.parse(pay));
    payment = getpay.format(int.parse(pay)) + " P";
  }

  return payment;
}

String parseHtmlString(String htmlString) {
  try{
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }catch(e){
    return htmlString;
  }


}