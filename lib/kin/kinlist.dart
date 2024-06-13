import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/Nodata.dart';
import 'package:hoty/common/menu_banner.dart';
import 'package:hoty/kin/kin_adopt_write.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:hoty/kin/kin_view2.dart';
import 'package:hoty/kin/kin_write.dart';
import 'package:hoty/login/login.dart';
import 'package:hoty/main/main_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:speech_balloon/speech_balloon.dart';

import 'package:intl/intl.dart';

import '../common/dialog/commonAlert.dart';
import '../common/dialog/loginAlert.dart';
import '../common/dialog/showDialog_modal.dart';
import '../common/icons/my_icons.dart';

class KinList extends StatefulWidget {
  final bool success;
  final bool failed;
  final dynamic main_catcode;

  const KinList({Key? key,
    required this.success,
    required this.failed,
    required this.main_catcode,
  }) : super(key:key);

  @override
  State<KinList> createState() => _KinListState();
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

class _KinListState extends State<KinList> {

  bool isFold = false;
  double c_height = 0; // 기종별 height 값

  bool success = false;
  bool failed = false;

  Widget getBanner = Container(); //공통배너

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
  var rows = 20;
  var board_seq = 10;
  var reg_id = "";
  var subtitle = "KIN";

  var search_btn = 0;

  // var urlpath = 'http://www.hoty.company';
  var urlpath = 'http://www.hoty.company';

  Widget _Nodata = Container();

  TextEditingController _searchController = TextEditingController();

  Future<dynamic> getlistdata() async {

    keyword = _searchController.text;

    var url = Uri.parse(
      'http://www.hoty.company/mf/kin/list.do',
      //'http://www.hoty.company/mf/kin/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : "KIN",
        "reg_id" : reg_id,
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
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
         print(json.decode(response.body)['result']);
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
        });
        // 첫번째 카테고리
        for(var i=0; i<catname.length; i++){
          if(i == 0){
            main_catcode = catname[i]['idx'];
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

  Future<dynamic> setBannerList() async {
    getBanner = await Menu_Banner(table_nm : "KIN");
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    print("#############################################");
    print(reg_id);
  }

  @override
  void initState() {

    super.initState();

    main_catcode = widget.main_catcode;
    success = widget.success;
    failed = widget.failed;

    _asyncMethod();
    setBannerList().then((_){
      getlistdata().then((_) {
        _Nodata = Nodata();
        setState(() {
        });
      });
      getcodedata().then((_) {
        setState(() {
        });
      });
    });


  }

  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    isFold = pageWidth > 480 ? true : false;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double m_width = (MediaQuery.of(context).size.width/360);
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;


    if(aspectRatio > 0.55) {
      if(isFold == true) {
        // c_height = m_height * (m_width * aspectRatio);
        c_height = m_height * (m_width * aspectRatio);
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
                      controller: _searchController,

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
                                if(search_btn == 0) {
                                  search_btn = 1;
                                  setState(() {
                                    search_btn = 1;
                                  });
                                  result.clear();
                                  main_catcode = '';
                                  getlistdata().then((_) {
                                    setState(() {
                                      search_btn = 0;
                                      FocusScope.of(context).unfocus();
                                    });
                                  });
                                }
                              },
                            ),
                          )
                      ),
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      onSubmitted: (value) async {
                        setState(() {
                          keyword = value;
                          main_catcode = '';
                          result.clear();
                          getlistdata().then((_) {
                            setState(() {
                            });
                          });
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
              children: [ // 검색
                Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  // height: 15 * (MediaQuery.of(context).size.height / 360),
                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: kincat(context),
                  ),

                ),// 카테고리
                Question(context),
                getBanner,
                /*morebar(context),*/
                Visibility(
                    visible: success,
                    child: Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        height: 20 * (MediaQuery.of(context).size.height / 360),
                        padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        color: Color(0xff27AE60),
                        child : Row(
                          children: [
                            Image(image: AssetImage("assets/write_success.png"), width: 20 * (MediaQuery.of(context).size.width / 360),),
                            Container(
                              width: 290 * (MediaQuery.of(context).size.width / 360),
                              padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text("게시물이 등록되었습니다!", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF)),),
                            ),
                            GestureDetector(
                              onTap : () {
                                success = false;
                                setState(() {
                                  success = false;
                                });
                              },
                              child : Image(image: AssetImage("assets/delete.png"), width: 20 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF),),
                            )
                          ],
                        )
                    ),
                ),
                Visibility(
                    visible: failed,
                    child: Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        height: 20 * (MediaQuery.of(context).size.height / 360),
                        padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        color: Color(0xffEB5757),
                        child : Row(
                          children: [
                            Image(image: AssetImage("assets/write_failed.png"), width: 20 * (MediaQuery.of(context).size.width / 360),),
                            Container(
                              width: 290 * (MediaQuery.of(context).size.width / 360),
                              padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text("다시 시도해주세요", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF)),),
                            ),
                            GestureDetector(
                              onTap : () {
                                failed = false;
                                setState(() {
                                  failed = false;
                                });
                              },
                              child : Image(image: AssetImage("assets/delete.png"), width: 20 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF),),
                            )
                          ],
                        )
                    ),
                ),
                if(result.length > 0)
                  makekinList(context),
                if(result.length == 0)
                  _Nodata,
                if(result.length > 0 && cpage < totalpage)
                  seemore(context),
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
                ),
                Follow_us(),
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
      )
    );
  }

  Container seemore(BuildContext context) {
    return Container(
              width: 100 * (MediaQuery.of(context).size.width / 360),
              // height: 20 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(1  * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360),
                  1  * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360)),
              child : TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25 * (MediaQuery.of(context).size.height / 360)),
                    side : BorderSide(color: Color(0xff2F67D3),width: 2),
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
              )
          );
  }

  Container morebar(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: getBanner,
    );
  }

  Container Question(BuildContext context) {
    return Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 20 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width : 240 * (MediaQuery.of(context).size.width / 360),
                  child : Row(
                    children: [
                      Container(
                        width: 95 * (MediaQuery.of(context).size.width / 360),
                        height: 18 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 1, color: Color.fromRGBO(228, 116, 33, 1)),
                              backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                              padding: EdgeInsets.symmetric(horizontal: 7 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                              ),
                              elevation: 0
                          ),
                          onPressed: (){
                            print("로그인체크");
                            print(reg_id);
                            if(reg_id != null && reg_id != "") {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return KinWrite();
                                },
                              ));
                            }
                            if(reg_id == null || reg_id == "") {
                              showModal(context, 'loginalert', '');
                            }
                          },
                          child: Row(

                            children: [
                              Container(
                                width: 20 * (MediaQuery.of(context).size.width / 360),
                                child: Image(image: AssetImage('assets/question.png')),
                              ),
                              Container(
                                child: Text(' 질문하기', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.white, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 95 * (MediaQuery.of(context).size.width / 360),
                        height: 18 * (MediaQuery.of(context).size.height / 360),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2, color: Color.fromRGBO(228, 116, 33, 1)),
                              backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                              padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 4 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                              ),
                              elevation: 0
                          ),
                          onPressed: (){

                            main_catcode = 'B06';
                            result.clear();
                            getlistdata().then((_) {
                              setState(() {
                              });
                            });
                          },
                          child: Container(
                              child : Text('자주하는질문', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360) , fontWeight: FontWeight.w800 , color:Color.fromRGBO(228, 116, 33, 1)),)
                          ),
                        ),
                      ),
                    ],
                  )
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
                            Icon(Icons.sort, size: 24 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                            Container(
                              padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                              child:  Text(' 정렬 기준',
                                style: TextStyle(
                                  fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff151515),
                                  fontFamily: 'NanumSquareR',
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
              ],
            ),
          );
  }

  Row kincat(BuildContext context) {

    // print("catnamecatname");
    // print(cattitle);

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
                      if("" == main_catcode)
                        Container(
                          width: 50 * (MediaQuery.of(context).size.width / 360),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                          padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                          // height: 15 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: TextButton(
                            onPressed: () {  },
                            style: TextButton.styleFrom(
                              // primary: Color(0xffF3F6F8),
                              minimumSize: Size.zero,
                              padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                  7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "전체",
                              style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if("" != main_catcode)
                        Container(
                          width: 50 * (MediaQuery.of(context).size.width / 360),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                          padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                          // height: 15 * (MediaQuery.of(context).size.height / 360),
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
                              main_catcode = "";
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
                    ],
                  ),
                ),
                for(int m2=0; m2<cattitle.length; m2++)
                  if(cattitle[m2]['idx'] != 'B06')
                    Container(
                      child: Row(
                        children: [
                          if(cattitle[m2]['idx'] == main_catcode)
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                              padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                              // height: 15 * (MediaQuery.of(context).size.height / 360),
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
                                  "${cattitle[m2]['name']}",
                                  style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          if(cattitle[m2]['idx'] != main_catcode)
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                              padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                              // height: 15 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                color: Color(0xffF3F6F8),
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
                                onPressed: () {
                                  main_catcode = cattitle[m2]['idx'];
                                  result.clear();
                                  getlistdata().then((_) {
                                    setState(() {
                                    });
                                  });
                                },
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
                        ],
                      ),
                    )
              ],
            )
        ),
      ],
    );
  }

  Container searchbar(BuildContext context) {
    return Container(
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 25 * (MediaQuery.of(context).size.height / 360),
            child: Container(
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color(0xffF3F6F8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    //border: OutlineInputBorder(),
                    // labelText: 'Search',
                    hintText: '검색 할 키워드를 입력 해주세요.',
                    hintStyle: TextStyle(fontSize: 14, color: Color(0xffC4CCD0)),
                    suffixIcon: IconButton(icon: Icon(Icons.search_rounded, color: Colors.black, size: 25,),
                      onPressed: () {
                        if(search_btn == 0) {
                          search_btn = 1;
                          setState(() {
                            search_btn = 1;
                          });
                          result.clear();
                          main_catcode = '';
                          getlistdata().then((_) {
                            setState(() {
                              search_btn = 0;
                              FocusScope.of(context).unfocus();
                            });
                          });
                        }
                      },
                    ), border: InputBorder.none
                ),
                textInputAction: TextInputAction.go,
                onSubmitted: (value) async {
                  setState(() {
                    keyword = value;
                    main_catcode = '';
                    result.clear();
                    getlistdata().then((_) {
                      setState(() {
                      });
                    });
                  });
                },
                style: TextStyle(decorationThickness: 0, fontFamily: ''),
              ),
            ),
          );
  }

  Widget makekinList (context) {

      if(main_catcode == 'B06') {
        return Container(
          child : Column(
            children: [
              for(var i = 0 ; i < result.length; i++)
                GestureDetector(
                  onTap : () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinView2(
                          article_seq: result[i]['list']['article_seq'],
                          table_nm: result[i]['list']['table_nm'],
                          main_catcode: main_catcode,
                          params: {},
                        );
                      },
                    ));
                  },
                  child : Container(
                      width : 360 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                          15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
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
                                  Text(
                                    "${result[i]["list"]["title"] ?? ''}",
                                    style: TextStyle(
                                      color: Color(0xff151515),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      child : Row(
                                        children: [
                                          Container(
                                              width: 195 * (MediaQuery.of(context).size.width / 360),
                                              child : Row(
                                                children: [
                                                  Text("${result[i]["list"]["reg_dt"] ?? ''}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                  Text("  ·  ", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                  Text("자주하는질문", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                ],
                                              )
                                          ),
                                          Container(
                                              child : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 * (MediaQuery.of(context).size.width / 360) , ),
                                                  Text(" ${result[i]["list"]["like_cnt"]}"),
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
                                                  Text(" ${result[i]["list"]["comment_cnt"]}"),
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
                            decoration: BoxDecoration(
                              image: result[i]["list"]["main_img"] != null ? DecorationImage(
                                  image:  CachedNetworkImageProvider(urlpath+'${result[i]["list"]["main_img_path"]}${result[i]["list"]["main_img"]}'),
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
                )
            ],
          )
        );
      } else {
        return Container(
            child: Column(
              children: [
                for(var i = 0; i < result.length; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return KinView(
                            article_seq: result[i]['list']['article_seq'],
                            table_nm: result[i]['list']['table_nm'],
                            adopt_chk: result[i]["list"]["adopt_chk"],);
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
                                      Text("${result[i]["list"]["title"]}",
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
                          if(result[i]["list"]["adopt_comment_conts"] != null && result[i]["list"]["adopt_comment_conts"] != '')
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
                                          "${result[i]["list"]["adopt_comment_conts"]}"
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
                                              "${result[i]["list"]["adopt_comment_reg_nm"]} ",
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff151515),
                                                fontFamily: 'NanumSquareR',
                                              ),
                                            ),
                                            Icon(My_icons.rate,
                                              color: result[i]['adopt_comment_group_seq'] == '4' ? Color(0xff27AE60):
                                              result[i]['adopt_comment_group_seq'] == '5' ? Color(0xff27AE60) :
                                              result[i]['adopt_comment_group_seq'] == '6' ? Color(0xffFBCD58) :
                                              result[i]['adopt_comment_group_seq'] == '7' ? Color(0xffE47421) :
                                              result[i]['adopt_comment_group_seq'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
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
                                            Text("${result[i]["list"]["adopt_comment_reg_dt"]}",
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
                                            Text("${getSubcodename(result[i]["list"]["main_category"])}",
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
                          else if(result[i]["list"]["comment_conts"] != null && result[i]["list"]["comment_conts"] != '')
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
                                          "${result[i]["list"]["comment_conts"]}"
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
                                            "${result[i]["list"]["comment_reg_nm"]} ",
                                            style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff151515),
                                              fontFamily: 'NanumSquareR',
                                            ),
                                          ),
                                          Icon(My_icons.rate,
                                            color: result[i]['comment_group_seq'] == '4' ? Color(0xff27AE60):
                                            result[i]['comment_group_seq'] == '5' ? Color(0xff27AE60) :
                                            result[i]['comment_group_seq'] == '6' ? Color(0xffFBCD58) :
                                            result[i]['comment_group_seq'] == '7' ? Color(0xffE47421) :
                                            result[i]['comment_group_seq'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
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
                                          Text("${result[i]["list"]["comment_reg_dt"]}",
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
                                          Text("${getSubcodename(result[i]["list"]["main_category"])}",
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
                                          "${result[i]["list"]["conts"]}"
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
                                              "${result[i]["list"]["reg_nm"]} ",
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff151515),
                                                fontFamily: 'NanumSquareR',
                                              ),
                                            ),
                                            Icon(My_icons.rate,
                                              color: result[i]['group_seq'] == '4' ? Color(0xff27AE60):
                                              result[i]['group_seq'] == '5' ? Color(0xff27AE60) :
                                              result[i]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                              result[i]['group_seq'] == '7' ? Color(0xffE47421) :
                                              result[i]['group_seq'] == '10' ? Color(0xffE47421) : Color(0xff27AE60),
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
                                            Text("${result[i]["list"]["reg_dt"]}",
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
                                            Text("${getSubcodename(result[i]["list"]["main_category"])}",
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
                          if(result.length-1 != i)
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
              ],
            )
        );
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

  Widget sortby() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 85 * (MediaQuery.of(context).size.height / 360),
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
                  width: 290 * (MediaQuery.of(context).size.width / 360),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                    child: Text("정렬 기준",style: TextStyle(
                      fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                      fontFamily: 'NanumSquareEB',
                      fontWeight: FontWeight.w800,
                    ),
                    ),
                  ),

                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    icon: Icon(Icons.close,size: 24 * (MediaQuery.of(context).size.width / 360),),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),

                )
              ],
            ),

          ),
          Container(
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 0 * (MediaQuery.of(context).size.width / 360), 0),
              decoration : BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                  )
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 15 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Text(
                  '등록순',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 6 * (MediaQuery.of(context).size.height / 360)
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
            height: 15 * (MediaQuery.of(context).size.height / 360),
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
                        '답변↑',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 6 * (MediaQuery.of(context).size.height / 360)
                        ),
                      ),
                    ),
                    /*Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↑',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 7 * (MediaQuery.of(context).size.height / 360)
                        ),
                      ),
                    )*/
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
            height: 15 * (MediaQuery.of(context).size.height / 360),
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
                        '답변↓',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 6 * (MediaQuery.of(context).size.height / 360)
                        ),
                      ),
                    ),
                    /*Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↓',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 7 * (MediaQuery.of(context).size.height / 360)
                        ),
                      ),
                    )*/
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