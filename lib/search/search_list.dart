import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/search/search_result.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../common/icons/my_icons.dart';
import '../community/dailytalk/community_dailyTalk.dart';
import '../community/privatelesson/lesson_list.dart';
import '../community/usedtrade/trade_list.dart';
import '../kin/kinlist.dart';
import '../service/service_guide.dart';
import '../today/today_list.dart';

class SearchList extends StatefulWidget {

  SearchList({Key? key}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {


  var Baseurl = "http://www.hoty.company/mf";
  var Base_Imgurl = "http://www.hoty.company";
  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> popular_categoryList = [];
  List<dynamic> serch_catList = []; // 추천 타이틀 카테고리
  var title_living = ['M01','M02','M03','M04','M05'];



  Future<dynamic> getpopularCategoryListdata() async {

    var popular_result = [];

    var url = Uri.parse(
      /*'http://www.hoty.company/mf/common/popular_category.do',*/
      'http://www.hoty.company/mf/common/popular_category.do',
      /*'http://www.hoty.company/mf/main/list.do',*/
      // 'http://192.168.0.109/mf/main/list.do',
    );

    try {
      Map data = {

      };

      var body = json.encode(data);
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

        popular_result = json.decode(response.body)['result'];


      }

      popular_result.forEach((element) {
        if(element['gubun'] == 'S') {
          serch_catList.add(element);
        }
      });

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

/*        cattitle.forEach((element) {
          coderesult.forEach((value) {
            if(value['pidx'] == element['idx']){
              catname.add(value);
            }
          });
          // print(element['idx']);
        });*/

        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getcodedata().then((value) {
      getpopularCategoryListdata().then((value) {
        setState(() {
        });
      });
    });
    _asyncMethod();
    _getSearchHistory().then((value) {
      setState(() {

      });
    });
    _getLink().then((value) {
      setState(() {

      });
    });
  }

  String regist_id = "";


  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId')) ?? "";
  }


  String link_url = '';

  bool _touch_check = false;

  final TextEditingController _keywordController = TextEditingController();

  List<dynamic> _search_history = [];

  Map<String, dynamic> _linkInfo = {};

  Future<void> _getSearchHistory() async {
    _search_history.clear();
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

  /* 검색어 저장 api */
  Future<void> _searchInsert(String search_word) async {
    final url = Uri.parse('http://www.hoty.company/mf/search/search_insert.do');

    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    regist_id = reg_id!;

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
        print(response.body);
      } else {
        print('요청 실패: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('오류: $error');
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
        print(response.body);
      } else {
        print('요청 실패: ${response.statusCode}');
        print(response.body);
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
        print(response.body);
      } else {
        print('요청 실패: ${response.statusCode}');
        print(response.body);
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

  @override
  Widget build(BuildContext context) {
    int hexToInteger(String hex) => int.parse(hex, radix: 16);

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
        appBar: AppBar(
          titleSpacing: 0,
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
              if(_touch_check == true) {
                _touch_check = false;
                setState(() {
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: TextField(
            controller: _keywordController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '검색 키워드를 입력해 주세요',
              hintStyle: TextStyle(
                color:Color(0xffC4CCD0),
                fontSize: 16 * (MediaQuery.of(context).size.width / 360),
              ),
            ),
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            onTap: () {
              _touch_check = true;
              setState(() {
              });
            },
            onSubmitted: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    _searchInsert(value).then((_){
                      setState(() {

                      });
                    });
                    return SearchResult(keyword: value);
                  },
                ),
              );
            },
            style: TextStyle(decorationThickness: 0 , fontSize: 16 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
          ),
          // centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.search_rounded),color: Color.fromRGBO(15, 19, 22, 1),
              iconSize: 26,
              onPressed: (){
                String keyword = _keywordController.text;
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    _searchInsert(keyword).then((_){
                      setState(() {

                      });
                    });
                    return SearchResult(keyword: keyword);
                  },
                ));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              children: [
                if(_touch_check == false)...[
                  Container(
                      child:Column(
                          children: [
                            Container( // 메뉴타이틀
                                alignment: Alignment.center,
                                margin : EdgeInsets.fromLTRB(0, 15 * (MediaQuery.of(context).size.height / 360),
                                    0 , 10 * (MediaQuery.of(context).size.height / 360)),
                                width: 340 * (MediaQuery.of(context).size.width / 360),
                                child: Text(
                                  "호티를 통해 다양한 정보\n를 찾아보세요!",
                                  style: TextStyle(
                                    fontSize: 22 * (MediaQuery.of(context).size.width / 360),
                                    // color: Color(0xff151515),
                                    // overflow: TextOverflow.ellipsis,
                                    // fontFamily: 'NanumSquareEB',
                                    height: 1.4,
                                    fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ]
                      )
                  ),
                  getdata(),
                /*Container(
                  margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 *(MediaQuery.of(context).size.height / 360),),
                  child: Wrap(
                    children: [
                      for(var i=0; i<serch_catList.length; i++)
                        Container(
                          margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2.5 * c_height,
                              5 * (MediaQuery.of(context).size.width / 360), 2.5 *c_height,),
                          child: GestureDetector(
                            onTap: (){
                              // Navigator.pop(context);
                              if(title_living.contains(serch_catList[i]['table_nm'])){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: getTitlecode('${serch_catList[i]['table_nm']}'), check_sub_catlist: [getTitlecode('${serch_catList[i]['main_category']}')], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              }
                              if(serch_catList[i]['table_nm'] == 'M06'){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Service_guide(table_nm : "${serch_catList[i]['main_category']}");
                                  },
                                ));
                              }
                              if(serch_catList[i]['table_nm'] == 'M07'){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    if(serch_catList[i]['main_category'] == 'M0701') {
                                      return TradeList(checkList: [],);
                                    } else if(serch_catList[i]['main_category'] == 'M0702'){
                                      return LessonList(checkList: [],);
                                    } else {
                                      return CommunityDailyTalk(main_catcode: getTitlecode('${serch_catList[i]['main_category']}'));
                                    }
                                  },
                                ));
                              }
                              if(serch_catList[i]['table_nm'] == 'M08'){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return TodayList(main_catcode: '',table_nm : getTitlecode('${serch_catList[i]['main_category']}'));
                                  },
                                ));
                              }
                            },
                            child: Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * c_height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15 * c_height),
                                // color: Color(0xff+int.parse(serch_catList[i]['bak_colr'], radix: 16)),
                                color: serch_catList[i]['bak_colr'] != null ? Color(hexToInteger('FF${serch_catList[i]['bak_colr']}')) : Color(0xffF3F6F8),

                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0 * c_height, 0, 0),
                                    child: getSubIcons('${serch_catList[i]['main_category']}', context),
                                    // color: Colors.amberAccent,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5 * c_height, 0, 0),
                                    child: Text(
                                      getCodename("${serch_catList[i]['main_category']}"),
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),*/




         /*       Container(
                  child: Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){

                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C101", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_01.png'),
                                          // fit: BoxFit.cover
                                        ),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C106", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_02.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 1cow
                      Container(
                        margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C105", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_03.png'),
                                          // fit: BoxFit.cover
                                        ),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C107", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_04.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 2col
                      Container(
                        margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C104", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_05.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C108", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_06.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 3col
                      Container(
                        margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C102", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_07.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C103", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_08.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 4col
                      Container(
                        margin : EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LivingList(title_catcode: "C109", check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_09.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return TradeList(checkList: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_10.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 5col
                      Container(
                        margin : EdgeInsets.fromLTRB(12 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // padding: EdgeInsets.all(5),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return LessonList(checkList: [],);
                                  },
                                ));
                              },
                              child: Container(
                                width: 170 * (MediaQuery.of(context).size.width / 360),
                                height: 80 * (MediaQuery.of(context).size.height / 360),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 160 * (MediaQuery.of(context).size.width / 360),
                                      height: 80 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/search_bg_11.png'),
                                          // fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      // color: Colors.amberAccent,
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
                ),*/
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
                ),
            ]
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'Search_page'),
      )
    );
  }

  Container getdata() {
    int hexToInteger(String hex) => int.parse(hex, radix: 16);

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
    return Container(
      margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
        10 * (MediaQuery.of(context).size.width / 360), 0 *(MediaQuery.of(context).size.height / 360),),
      child: Wrap(
        children: [
          for(var i=0; i<serch_catList.length; i++)
            Container(
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2.5 * c_height,
                5 * (MediaQuery.of(context).size.width / 360), 2.5 *c_height,),
              child: GestureDetector(
                onTap: (){
                  // Navigator.pop(context);
                  if(title_living.contains(serch_catList[i]['table_nm'])){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LivingList(title_catcode: getTitlecode('${serch_catList[i]['table_nm']}'), check_sub_catlist: [getTitlecode('${serch_catList[i]['main_category']}')], check_detail_catlist: [], check_detail_arealist: [],);
                      },
                    ));
                  }
                  if(serch_catList[i]['table_nm'] == 'M06'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service_guide(table_nm : "${serch_catList[i]['main_category']}");
                      },
                    ));
                  }
                  if(serch_catList[i]['table_nm'] == 'M07'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        if(serch_catList[i]['main_category'] == 'M0701') {
                          return TradeList(checkList: [],);
                        } else if(serch_catList[i]['main_category'] == 'M0702'){
                          return LessonList(checkList: [],);
                        } else {
                          return CommunityDailyTalk(main_catcode: getTitlecode('${serch_catList[i]['main_category']}'));
                        }
                      },
                    ));
                  }
                  if(serch_catList[i]['table_nm'] == 'M08'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TodayList(main_catcode: '',table_nm : getTitlecode('${serch_catList[i]['main_category']}'));
                      },
                    ));
                  }
                  if(serch_catList[i]['table_nm'] == 'M10'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinList(success: false, failed: false,main_catcode: '',);
                      },
                    ));
                  }
                },
                child: Container(
                  width: 160 * (MediaQuery.of(context).size.width / 360),
                  height: 80 * c_height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15 * c_height),
                    // color: Color(0xff+int.parse(serch_catList[i]['bak_colr'], radix: 16)),
                    color: serch_catList[i]['bak_colr'] != null ? Color(hexToInteger('FF${serch_catList[i]['bak_colr']}')) : Color(0xffF3F6F8),

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0 * c_height, 0, 0),
                        child: getSubIcons('${serch_catList[i]['main_category']}', context),
                        // color: Colors.amberAccent,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5 * c_height, 0, 0),
                        child: Text(
                          getCodename("${serch_catList[i]['main_category']}"),
                          style: TextStyle(
                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                            // color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
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
  String getTitlecode(idx) {
    var title_code = '';

    coderesult.forEach((value) {
      if(value['idx'] == idx) {
        title_code = value['cidx'];
      }
    });


    return title_code;
  }
}

Container getSubIcons(idx, BuildContext context) {
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
  Icon subicon = Icon(caticon, size: 80 * (MediaQuery.of(context).size.width / 360),  color: catcolor,);
  Image subimage = Image(image: AssetImage('assets/today_menu01_1.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);

  var gubun = ['M0801','M0802','M0203'];
  // 아이콘미사용
  if(idx != null) {
    if(idx == 'M0203') {
      subimage = Image(image: AssetImage('assets/M0203.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);
    }
    if(idx == 'M0801') {
      subimage = Image(image: AssetImage('assets/M0801.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);
    }
    if(idx == 'M0802') {
      subimage = Image(image: AssetImage('assets/M0802.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);
    }
  }

  return Container(
    child: subicon,
  );
}