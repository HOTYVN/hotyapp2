import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/categorymenu/common/photo_view.dart';
import 'package:hoty/common/footer.dart';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoty/common/photo/photo_album_user.dart';
import 'package:hoty/community/Report/report_write.dart';
import 'package:hoty/kin/kin_adopt_modify.dart';
import 'package:hoty/kin/kin_adopt_write.dart';
import 'package:hoty/kin/kin_comment_list.dart';
import 'package:hoty/kin/kin_modify.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import "package:back_button_interceptor/back_button_interceptor.dart";
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../common/dialog/commonAlert.dart';
import '../common/dialog/loginAlert.dart';
import '../common/dialog/showDialog_modal.dart';
import '../common/icons/my_icons.dart';
import '../login/login.dart';
import '../main/main_page.dart';

class KinView extends StatefulWidget {
  final int article_seq;
  final dynamic table_nm;
  final dynamic adopt_chk;


  const KinView({Key? key,
    required this.article_seq,
    required this.table_nm,
    required this.adopt_chk
  }) : super(key:key);
  @override
  State<KinView> createState() => _KinViewState();
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

class _KinViewState extends State<KinView> {

  // 메뉴카테고리 selectkey
  final GlobalKey titlecat_key = GlobalKey();

  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> cattitle = []; // 카테고리타이틀
  Map<String, dynamic> getresult = {};
  Map result = {};
  List<dynamic> filelist = [];
  List<dynamic> catname = []; // 세부카테고리
  List<dynamic> commentlist = [];
  List<dynamic> commentfilelist = [];

  var longurl = "";
  var url1 = "https://hotyapp.page.link/?link=https://hotyapp.page.link?";
  var url2 = "type=view@@table_nm=KIN@@article_seq=";
  var url3 = "&apn=com.hotyvn.hoty";
  var shorturl = "";
  var _sortvalue = ""; // sort
  var keyword = ""; // search
  var condition = "TITLE";

  var totalpage = 0;
  var totalcount = 0;
  var cpage = 1;
  var rows = 10;
  var board_seq = 10;
  var cms_menu_seq = 22;
  var reg_id = "";
  var reg_nm = "";
  var comment_seq = "";
  var subtitle = "KIN";
  String apptitle = "";
  var adoptmessage = "";
  var commentlikemessage = "";

  var _adoptCheck = 0;
  var adminChk = "";

  bool isLiked = false; // 좋아요상태
  String likes_yn = '';


  int _current = 0;

  Future<dynamic> getviewdata() async {

    var url = Uri.parse(
      /*'http://www.hoty.company/mf/community/view.do',*/
      'http://www.hoty.company/mf/community/view.do',
    );

    print('######');
    // print(widget.checkList);
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : widget.table_nm,
        "article_seq" : widget.article_seq,
        "reg_id" : reg_id,
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
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
        print("############################");
        print(json.decode(response.body)['result']['data']);
        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];
        getresult.forEach((key, value) {
          if(key == 'data'){
            result.addAll(value);
          }
          if(key == 'files'){
            filelist.addAll(value);
          }
        });
        if(result['title'] != null) {
          apptitle = result['title'];
        }
      }

    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> getviewdata2() async { //뷰 카운트 추가 안되는 버전

    var url = Uri.parse(
      /*'http://www.hoty.company/mf/community/view.do',*/
      'http://www.hoty.company/mf/community/view2.do',
    );

    print('######');
    // print(widget.checkList);
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : widget.table_nm,
        "article_seq" : widget.article_seq,
        "reg_id" : reg_id,
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
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
        print("############################view2");
        print(json.decode(response.body)['result']['data']);
        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];
        result.clear();
        filelist.clear();
        getresult.forEach((key, value) {
          if(key == 'data'){
            result.addAll(value);
          }
          if(key == 'files'){
            filelist.addAll(value);
          }
        });
        if(result['title'] != null) {
          apptitle = result['title'];
        }
        setState(() {

        });
      }

    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> getUrl() async {


    longurl = url1 + url2 + widget.article_seq.toString() + url3;

    print(longurl);

    var url = Uri.parse(
      //'http://www.hoty.company/mf/url/shorturl.do',
      'http://www.hoty.company/mf/url/shorturl.do',
    );

    Map params = {
      "url" : longurl
    };

    var body = json.encode(params);
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
      print("############################");
      print(json.decode(response.body)['url']);

      shorturl = json.decode(response.body)['url'];
    }
    setState(() {

    });
  }

  Future<dynamic> getcommentdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/comment/adopt_list.do',
      //'http://www.hoty.company/mf/comment/list.do',
    );

    print('######');
    // print(widget.checkList);
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : "KIN",
        "cms_menu_seq" : cms_menu_seq.toString(),
        "article_seq" : widget.article_seq,
        "reg_id" : reg_id,
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
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
        print("############################comment1");
        print(json.decode(response.body)['result']);
        print("############################comment2");
        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        commentlist.clear();
        for(int i=0; i<json.decode(response.body)['result'].length; i++){
          commentlist.add(json.decode(response.body)['result'][i]);
        }

        for(int i=0; i<commentlist.length; i++){
          commentlist[i]["list"]["visible1"] = false as bool;
          commentlist[i]["list"]["visible2"] = false as bool;

          if(commentlist[i]["list"]["adopt"] == "Y") {
            _adoptCheck = 1;
          }
        }

        Map paging = json.decode(response.body)['pagination'];
        print(json.decode(response.body)['pagination']);
        totalpage = paging['totalpage'].toInt(); // totalpage
        totalcount = paging['totalcount'].toInt(); // totalcount



        print("############################comment3");
      }

    }
    catch(e){
      print(e);
    }
  }
  // 공통코드 호출
  Future<dynamic> getcodedata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
      /*'http://www.hoty.company/mf/common/commonCode.do',*/
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
          // print(element['idx']);
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



  Future<dynamic> updateadopt(String adopt_id, String adopt_nm) async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/isAdopt.do',
      /*'http://www.hoty.company/mf/common/isAdopt.do',*/
    );

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic ipdata = await ipAddress.getIpAddress();

    try {
      Map data = {
        "comment_seq" : comment_seq,
        "reg_id" : reg_id,
        "reg_nm" : reg_nm,
        "ip" : ipdata["ip"].toString(),
        "etc01" : result["etc01"], // 채택 포인트
        "adopt_id" : adopt_id, // 채택된 사람의 아이디
        "adopt_nm" : adopt_nm,
        "article_seq" : widget.article_seq
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
        getcommentdata();
        setState(() {

        });
      }

      return json.decode(response.body)["message"].toString();

    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> updatecommentlike() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commentlike.do',
    );

    try {
      Map data = {
        "comment_seq" : comment_seq,
        "reg_id" : reg_id,
        "table_nm" : "KIN",
        "likes_yn" : "Y"
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

      }

      commentlikemessage = json.decode(response.body)['message'].toString();
      return commentlikemessage;

    }
    catch(e){
      print(e);
    }
  }


  Future<dynamic> deletekin() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/community/delete.do',
      //'http://www.hoty.company/mf/community/delete.do',
    );

    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "reg_id" : reg_id,
        "table_nm" : "KIN",
        "etc01" : result["etc01"],
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

      }

      return json.decode(response.body)['result'];

    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> deletecomment(int? comment_seq) async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/comment/delete.do',
    );

    try {
      Map data = {
        "comment_seq" : comment_seq,
        "reg_id" : reg_id,
        "table_nm" : "KIN"
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

      }

      return json.decode(response.body)['result'];

    }
    catch(e){
      print(e);
    }
  }

  Future<dynamic> updatelike() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/islike.do',
    );

    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : widget.table_nm,
        "title" : apptitle,
        "likes_yn" : likes_yn,
        "reg_id" : (await storage.read(key:'memberId')) ??  "",
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

      }

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
    adminChk = (await storage.read(key:'memberAdminChk')) ?? "";
    reg_nm = (await storage.read(key : 'memberNick')) ?? "";
    print("###########################################33##");
    print(reg_id);
  }

  Future<bool> _onBackKey() async {
    final value = await  Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return KinList(success: false, failed: false, main_catcode: '');
      },
    ));

    return value;
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    getcodedata().then((_) {
      getviewdata().then((_) {
        getcommentdata().then((_) {
          setState(() {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Scrollable.ensureVisible(
                titlecat_key.currentContext!,
              );
            });
          });
        });
      });
    });




  }

  @override
  Widget build(BuildContext context) {
    return /*WillPopScope(
        onWillPop: () {
          return _onBackKey();
        },
        child: */Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leadingWidth: 40,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: true,
            /*iconTheme: IconThemeData(
                color: Colors.black
            ),*/
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
            actions: [
              if(reg_id != null && reg_id != "" && reg_id != result["reg_id"])
              GestureDetector(
                onTap: (){
                  if(reg_id != null && reg_id != "") {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return KinAdoptWrite(article_seq: widget.article_seq,table_nm: widget.table_nm, title : result["title"]);
                      },
                    ));
                  }
                  if(reg_id == null || reg_id == "") {
                    showModal(context, 'loginalert', '');
                  }
                },
                child : Container(
                  //width: 70 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    /*margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),*/
                    child:Row(
                      children: [
                        /*Icon(Icons.listflutter, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),*/
                        Image(image: AssetImage("assets/ink_pen.png"), width : 15 * (MediaQuery.of(context).size.width / 360)),
                        Text('  답변하기',
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff151515),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'NanumSquareR',
                          ),
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  // height: 15 * (MediaQuery.of(context).size.height / 360),
                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: kincat(context),
                  ),

                ),// 카
                Container(
                    width : 360 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width : 360 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child : Image(image: AssetImage("assets/question.png"), color: Color(0xffE47421), width: 25 * (MediaQuery.of(context).size.width / 360),),
                              ),
                              Container(
                                width : 300 * (MediaQuery.of(context).size.width / 360),
                                margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                child : Wrap(
                                  children: [
                                    Text("${result["title"] ?? ''}",
                                      style: TextStyle(
                                          fontSize : 16 * (MediaQuery.of(context).size.width / 360),
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
                        Container(
                            child : Row(
                              children: [
                                Text("${result['reg_nm'] ?? ''} ", style: TextStyle(color: Color(0xff2F67D3), fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w700),),
                                Icon(My_icons.rate,
                                  color: result['group_seq'] == '4' ? Color(0xff27AE60) :
                                  result['group_seq'] == '5' ? Color(0xff27AE60) :
                                  result['group_seq'] == '6' ? Color(0xffFBCD58) :
                                  result['group_seq'] == '7' ? Color(0xffE47421) :
                                  result['group_seq'] == '10' ? Color(0xffE47421) :
                                  Color(0xff27AE60),
                                  size: 12 * (MediaQuery.of(context).size.width / 360),),
                              ],
                            )
                        ),
                        Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child : Text("${result['conts'] ?? ''}", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),)
                        ),
                        if(filelist.length > 0)
                          Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360) ),
                            child: SingleChildScrollView (
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if(filelist.length > 0)
                                    for(var f = 0; f < filelist.length; f++)
                                      GestureDetector(
                                        onTap: (){
                                          showDialog(context: context,
                                              barrierDismissible: false,
                                              barrierColor: Colors.black,
                                              builder: (BuildContext context) {
                                                return PhotoAlbum_User(apptitle: '${result['conts']}',fileresult: filelist, table_nm: widget.table_nm,);
                                              }
                                          );
                                        },
                                        child: Container(
                                          width: 330 * (MediaQuery.of(context).size.width / 360),
                                          margin : EdgeInsets.fromLTRB(f == 0 ? 0 : 5 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider('http://www.hoty.company/upload/'+widget.table_nm+'/${filelist[f]["yyyy"]}/${filelist[f]['mm']}/${filelist[f]['uuid']}'),
                                                // image: NetworkImage(''),
                                                fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 85 * (MediaQuery.of(context).size.height / 360),
                                                    10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff151515),
                                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                ),
                                                child: Row(
                                                    children:[
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                        child: Text(
                                                          (f+1).toString() + '/' + filelist.length.toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                      )
                                                    ]
                                                ),

                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ),
                        Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child : Text("${result['reg_dt'] ?? ''}", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xffC4CCD0), fontSize: 12 * (MediaQuery.of(context).size.width / 360)),)
                        ),
                        if(result["tag_names"] != null && result["tag_names"] != "")
                          Container(
                            width : 330 * (MediaQuery.of(context).size.width / 360),
                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for(var j = 1; j < result["tag_names"].toString().split("#").length; j++)
                                    Container(
                                        margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360) , 4 * (MediaQuery.of(context).size.height / 360) ),
                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360) ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                                          color: Color(0xffF3F6F8),
                                        ),
                                        child : Text("#${result["tag_names"].toString().split("#")[j]}", style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontFamily: 'NanumSquareR', color: Color(0xff2f67D3)),)
                                    ),
                                ],
                              ),
                            ),
                          ),
                        Container(
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Row(
                            children: [
                              Container(
                                width : 270 * (MediaQuery.of(context).size.width / 360),
                                child: Row(
                                  children: [
                                    // 좋아요
                                    GestureDetector(
                                      onTap : () {
                                        if(reg_id != null && reg_id != "") {
                                          /*_isLiked().then((_) {
                                            getviewdata2().then((_){
                                              setState(() {
                                              });
                                            });
                                          });*/
                                          likes_yn = 'Y';
                                          setState(() {
                                          });
                                          updatelike().then((_) {
                                            getviewdata2().then((_){
                                              setState(() {
                                              });
                                            });
                                          });
                                        }
                                        if(reg_id == null || reg_id == "") {
                                          showModal(context, 'loginalert', '');
                                        }
                                      },
                                      child :  Container(
                                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child : Row(
                                            children: [
                                              Image(image: AssetImage("assets/like.png"), width: 15 * (MediaQuery.of(context).size.width / 360), color: Color(0xffE47421),),
                                              Text(" ${result["like_cnt"] ?? "0"}", style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360), color: Color(0xff0F1316)),)
                                            ],
                                          )
                                      ),
                                    ),
                                    Container(
                                      height : 8 * (MediaQuery.of(context).size.height / 360) ,
                                      child :  DottedLine(
                                        lineThickness:1,
                                        dashLength: 1.0,
                                        dashColor: Color(0xffC4CCD0),
                                        direction: Axis.vertical,
                                      ),
                                    ),
                                    //조회수
                                    Container(
                                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                        child : Row(
                                          children: [
                                            Image(image: AssetImage("assets/view_icon.png"), width: 15 * (MediaQuery.of(context).size.width / 360), color: Color(0xff925331),),
                                            Text(" ${result["view_cnt"] ?? "0"}", style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360), color: Color(0xff0F1316)),)
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap : () async {
                                  final route = MaterialPageRoute(builder: (context) =>KinCommentList(article_seq: widget.article_seq, table_nm: widget.table_nm, adopt_chk: widget.adopt_chk, head_seq: result['comment_seq'] ?? 0, parent_seq: result['comment_seq'] ?? 0, state : "C"));
                                  final addResult = await Navigator.push(context, route);
                                  if(addResult != false)  {
                                    setState(() {
                                      getviewdata().then((value) {
                                        getcommentdata().then((value) {
                                          setState(() {
                                          });
                                        });
                                      });
                                    });
                                  }


                                },
                                child : Container(
                                  width : 60 * (MediaQuery.of(context).size.width / 360),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              10 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360) ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                            color: Color(0xffF3F6F8),
                                          ),
                                        child : Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image(image: AssetImage("assets/comment.png"), width: 14 * (MediaQuery.of(context).size.width / 360),),
                                              Text(" ${result['comment_cnt'] ?? 0}", style: TextStyle(fontSize: 13 * (MediaQuery.of(context).size.width / 360), color: Color(0xff0F1316)),)
                                            ],
                                        )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
                Divider(thickness: 1, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffE47421)),


                if(commentlist.length > 0)
                  for(var i = 0; i < commentlist.length; i++)
                    Container(
                        child: Column(
                            children : [
                              Container(
                                  width: 360 * (MediaQuery.of(context).size.width / 360),
                                  height: 30 * (MediaQuery.of(context).size.height / 360),
                                  margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  padding : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                      3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                    color : Color(0xffF3F6F8).withOpacity(0.4),
                                  ),
                                  child: Row(
                                      children : [
                                        Container(
                                          width: 280 * (MediaQuery.of(context).size.width / 360),
                                          child: Column(
                                              children : [
                                                Container(
                                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                                    child: Row(
                                                        children : [
                                                          Container(
                                                            padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                            //width: 80 * (MediaQuery.of(context).size.width / 360),
                                                            //color: Colors.red,
                                                            child : Text("${commentlist[i]["list"]["reg_nm"]}",style: TextStyle(
                                                              fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                              // fontWeight: FontWeight.bold,
                                                              fontFamily: 'NanumSquareB',
                                                              color: Colors.black,
                                                            ),
                                                            ),
                                                          ),
                                                          Container(
                                                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                              child: Row(
                                                                children: [
                                                                  Icon(My_icons.rate,
                                                                    color: commentlist[i]['group_seq'] == '4' ? Color(0xff27AE60) :
                                                                    commentlist[i]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                                    commentlist[i]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                                    commentlist[i]['group_seq'] == '7' ? Color(0xffE47421) :
                                                                    commentlist[i]['group_seq'] == '10' ? Color(0xffE47421)
                                                                        : Color(0xff27AE60),
                                                                    size: 12 * (MediaQuery.of(context).size.width / 360),),
                                                                  // Image(image: AssetImage('assets/rate01.png') , width: 20 * (MediaQuery.of(context).size.width / 360) ,),
                                                                  //Text(
                                                                  //  "${commentlist[i]["list"]["group_nm"]}",
                                                                  //  style: TextStyle(
                                                                  //    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                                  //    // color: Colors.white,
                                                                  //    overflow: TextOverflow.ellipsis,
                                                                  //    // fontWeight: FontWeight.bold,
                                                                  //    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                                  //  ),
                                                                  //  textAlign: TextAlign.left,
                                                                  //),
                                                                ],
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                ),
                                                Container(
                                                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                    //height: 15 * (MediaQuery.of(context).size.height / 360),
                                                    child: Row(
                                                        children : [
                                                          Container(
                                                            //width: 90 * (MediaQuery.of(context).size.width / 360),
                                                            child : Text(
                                                              "답변수 ${commentlist[i]["list"]["comment_cnt"]}",
                                                              style: TextStyle(
                                                                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                                                color: Color(0xff4E4E4E),
                                                                fontFamily: 'NanumSquareR',
                                                                overflow: TextOverflow.ellipsis,
                                                                fontWeight: FontWeight.w400,
                                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                              ),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ),
                                                          Container(
                                                              width: 5 * (MediaQuery.of(context).size.width / 360),
                                                              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                              child : Text("•", style: TextStyle(color:Color(0xff4E4E4E),fontSize: 11 * (MediaQuery.of(context).size.width / 360),),)
                                                          ),
                                                          Container(
                                                            child : Text(
                                                              "채택수 ${commentlist[i]["list"]["adopt_cnt"]}",
                                                              style: TextStyle(
                                                                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                                                color: Color(0xff4E4E4E),
                                                                fontFamily: 'NanumSquareR',
                                                                overflow: TextOverflow.ellipsis,
                                                                fontWeight: FontWeight.w400,
                                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                              ),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ),
                                                          Container(
                                                              width: 5 * (MediaQuery.of(context).size.width / 360),
                                                              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                              child : Text("•",style: TextStyle(color:Color(0xff4E4E4E),fontSize: 11 * (MediaQuery.of(context).size.width / 360),),)
                                                          ),
                                                          Container(
                                                            child : Text(
                                                              "도움되요 수 ${commentlist[i]["list"]["helpful_cnt"]}",
                                                              style: TextStyle(
                                                                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                                                color: Color(0xff4E4E4E),
                                                                fontFamily: 'NanumSquareR',
                                                                overflow: TextOverflow.ellipsis,
                                                                fontWeight: FontWeight.w400,
                                                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                              ),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          ),
                                                        ]
                                                    )
                                                ),
                                              ]
                                          ),
                                        ),
                                        Container(
                                        width: 35 * (MediaQuery.of(context).size.width / 360),
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        child : PopupMenuButton(
                                          icon: Image(
                                            image: AssetImage("assets/more_vert.png"),
                                            width: 35 * (MediaQuery.of(context).size.width / 360),
                                            color: Color(0xff151515),
                                          ),
                                          itemBuilder : (BuildContext context) => [
                                            if(commentlist[i]["list"]["adopt"] == "N" && (reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y"))
                                            PopupMenuItem(value : 'delete',
                                              child: Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),

                                            ),
                                            if(commentlist[i]["list"]["adopt"] == "N" && (reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y"))
                                           PopupMenuItem(value : 'Edit', child: Text("수정하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),), ),
                                           //PopupMenuItem(value : 'Report', child: Text("Report", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),)),
                                            PopupMenuItem(value : 'Share', child: Text("공유하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),))
                                          ],
                                          onSelected: (String? value) => setState(() {
                                            print(value);
                                            print("########################result######################");


                                            if(value == 'delete') {
                                              setState(() {
                                                //삭제
                                                deletecomment(commentlist[i]["list"]["comment_seq"]).then((value) =>
                                                    showDialog(
                                                      barrierColor: Color(0xffE47421).withOpacity(0.4),
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext context) {
                                                        return MediaQuery(
                                                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                          child: delalert(context),
                                                        );
                                                      },
                                                    ).then((value) => {
                                                      Navigator.pop(context),
                                                      getcommentdata().then((_) {
                                                        setState(() {
                                                        });
                                                      }),
                                                    }),
                                                );
                                              });
                                            }
                                            if(value == "Edit") {
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) {
                                                  return KinAdoptModify(article_seq: widget.article_seq, table_nm: widget.table_nm,comment_seq: commentlist[i]['list']['comment_seq'], state: "A",);
                                                },
                                              ));
                                            }
                                            if(value == "Share") {
                                              getUrl().then((_){
                                                setState(() {

                                                });
                                                _onShare(context, commentlist[i]["list"]["conts"], shorturl);
                                              });

                                            }
                                          }),
                                          //onSelected: ,`
                                        ),
                                      ),
                                      ]
                                  )
                              ),
                              Container(
                                width: 360 * (MediaQuery.of(context).size.width / 360),
                                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                /*height: 90 * (MediaQuery.of(context).size.height / 360),*/
                                child : Column (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children : [
                                      Container(
                                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                        /*height: 25 * (MediaQuery.of(context).size.height / 360),*/
                                        /*child : Html(data : "${commentlist[i]["list"]["conts"]}"),*/
                                        child : Text("${commentlist[i]["list"]["conts"]}", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                                      ),
                                      Container(
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                        child : SingleChildScrollView (
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              if(commentlist[i]["files"].length > 0)
                                                for(var f=0; f<commentlist[i]["files"].length; f++)
                                                  GestureDetector(
                                                    onTap : () {
                                                      showDialog(context: context,
                                                          barrierDismissible: false,
                                                          barrierColor: Colors.black,
                                                          builder: (BuildContext context) {
                                                            return photoView(apptitle: apptitle,fileresult: commentlist[i]["files"], table_nm: widget.table_nm,);
                                                          }
                                                      );
                                                    },
                                                    child : Container(
                                                      width: 330 * (MediaQuery.of(context).size.width / 360),
                                                      height: 100 * (MediaQuery.of(context).size.height / 360),
                                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff000000),
                                                        image: DecorationImage(
                                                          image: NetworkImage("http://www.hoty.company/upload/KIN/${commentlist[i]["files"][f]["yyyy"]}/${commentlist[i]["files"][f]["mm"]}/${commentlist[i]["files"][f]["uuid"]}"),
                                                          // image: NetworkImage(''),
                                                          fit: BoxFit.contain,
                                                        ),
                                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 85 * (MediaQuery.of(context).size.height / 360),
                                                                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xff151515),
                                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                            ),
                                                            child: Row(
                                                                children:[
                                                                  Container(
                                                                    padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                                        4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                                    child: Text(
                                                                      '${f+1}/${commentlist[i]["files"].length}',
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.white
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),

                                        ),

                                      ),
                                      Container(
                                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), commentlist[i]["files"].length > 0 ? 7 * (MediaQuery.of(context).size.height / 360) : 2,
                                            0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                        width: 360 * (MediaQuery.of(context).size.width / 360),
                                        //height: 10 * (MediaQuery.of(context).size.height / 360),
                                        //color : Colors.white70,
                                        child : Text("${commentlist[i]["list"]["reg_dt"]}" ,
                                          style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              color: Color.fromRGBO(196, 204, 208, 1),
                                              fontFamily: 'NanumSquareR'
                                            //overflow: TextOverflow.ellipsis,
                                            // fontWeight: FontWeight.bold,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Container(
                                          child : Row(
                                            children: [
                                              GestureDetector(
                                                onTap : () {
                                                  if(reg_id != null && reg_id != "") {
                                                    _iscommentlike(commentlist[i]["list"]["comment_seq"].toString() , i);
                                                    setState(() {

                                                    });
                                                  }
                                                  if(reg_id == null || reg_id == "") {
                                                    showModal(context, 'loginalert', '');
                                                  }
                                                },
                                                child : Container(
                                                  width: 270 * (MediaQuery.of(context).size.width / 360),
                                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                      0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                                  height: 15 * (MediaQuery.of(context).size.height / 360),
                                                  color : Colors.white24,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
                                                    children: [
                                                      Container(
                                                        child:
                                                        Image(image: AssetImage('assets/like_icon2.png'),width: 15 * (MediaQuery.of(context).size.width / 360),height: 15 * (MediaQuery.of(context).size.height / 360),),
                                                      ),
                                                      Container(
                                                        margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                            3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                                        child:
                                                        Text(
                                                          "${commentlist[i]["list"]["like_cnt"]}",
                                                          style: TextStyle(
                                                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                            color: Color(0xff151515),
                                                            //overflow: TextOverflow.ellipsis,
                                                            fontWeight: FontWeight.w400,
                                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                          ),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap : () {
                                                  Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) {
                                                      return KinCommentList(article_seq: widget.article_seq, table_nm: widget.table_nm, adopt_chk: widget.adopt_chk, head_seq: commentlist[i]["list"]['comment_seq'] ?? 0, parent_seq: commentlist[i]["list"]['comment_seq'] ?? 0, state : "A_C");
                                                    },
                                                  ));
                                                },
                                                child : Container(
                                                  width : 60 * (MediaQuery.of(context).size.width / 360),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                          padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                              10 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360) ),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                            color: Color(0xffF3F6F8),
                                                          ),
                                                          child : Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image(image: AssetImage("assets/comment.png"), width: 14 * (MediaQuery.of(context).size.width / 360),),
                                                              Text(" ${commentlist[i]["list"]['recomment_cnt']}", style: TextStyle(fontSize: 13 * (MediaQuery.of(context).size.width / 360), color: Color(0xff0F1316)),)
                                                            ],
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      if(_adoptCheck == 0 && result["reg_id"] != commentlist[i]["list"]["reg_id"] && (reg_id == result["reg_id"] || adminChk == "Y"))
                                        GestureDetector(
                                          onTap: (){
                                            _isAdopt(commentlist[i]["list"]["comment_seq"].toString(), commentlist[i]["list"]["reg_id"].toString(),  commentlist[i]["list"]["reg_nm"].toString());
                                          },
                                          child : Container(
                                              height: 25 * (MediaQuery.of(context).size.height / 360),
                                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                                color : Color(0xffF9FBFB),
                                              ),
                                              child : Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children : [
                                                    Container(
                                                      width: 240 * (MediaQuery.of(context).size.width / 360),
                                                      padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                      child : Text(
                                                        "이 답변을 채택 하시겠습니까?",
                                                        style: TextStyle(
                                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                          color: Color(0xff151515),
                                                          overflow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w700,
                                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                        ),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 60 * (MediaQuery.of(context).size.width / 360),
                                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                                        color: Color(0xffECFFF4),
                                                        border: Border.all(
                                                          color: Color(0xff27AE60),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child : Container(
                                                          child : Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Image(image: AssetImage("assets/check_icon.png",), width: 12 * (MediaQuery.of(context).size.width / 360) ,height: 15 * (MediaQuery.of(context).size.height / 360), color: Color(0xff27AE60),),
                                                              Text("  채택", style: TextStyle(color: Color(0xff27AE60),  fontWeight: FontWeight.w700,),),
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  ]
                                              )
                                          ),
                                        ),
                                      if(commentlist[i]["list"]["adopt"] == "Y")
                                        Container(
                                            height: 25 * (MediaQuery.of(context).size.height / 360),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                              color : Color.fromRGBO(243, 246, 248, 1),
                                            ),
                                            child : Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children : [
                                                  Image(image: AssetImage("assets/current_icon.png"), width : 20 * (MediaQuery.of(context).size.width / 360)),
                                                  Text(" 채택 된 답변 입니다.", style : TextStyle(fontSize : 14))
                                                ]
                                            )
                                        ),
                                    ]
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Color(0xffDCE4EA),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: Color(0xffF3F6F8),  width: 5 * (MediaQuery.of(context).size.width / 360),),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]
                        )
                    ),
                if(commentlist.length > 0 && cpage < totalpage)
                  seemore(context),
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
          extendBody: false,
          bottomNavigationBar: Footer(nowPage: 'Main_menu'),
        /*)*/
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
                getcommentdata().then((_) {
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

  String getPoint(pay) {
    String payment = "";

    if(pay != null && pay != ''){
      var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
      /*getpay.format(int.parse(pay));*/
      payment = "${getpay.format(int.parse(pay))} P";
    }

    return payment;
  }

  void _isAdopt(String seq, String adopt_id, String adopt_nm) {
      showDialog(
          barrierColor: Color(0xffE47421).withOpacity(0.4),
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Column(
                children: <Widget>[
                  Icon(Icons.warning, color: Color(0xffFBCD58), size: 50 * (MediaQuery.of(context).size.width / 360),)
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "채택하시면 취소 하실 수 없습니다.\n채택 하시겠습니까?", textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "NanumSquareEB", fontWeight: FontWeight.w500, fontSize: 16 * (MediaQuery.of(context).size.width / 360)),),
                ],
              ),
              actions: <Widget>[
                Container(
                    child : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xffFFFFFF),
                              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                              ),
                              side: BorderSide(width:2, color:Color(0xffE47421)), //border width and color
                              elevation: 0
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            child : Text("아니요", style: TextStyle(color: Color(0xffE47421)),),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                          },
                        ),
                        SizedBox(width: 7 * (MediaQuery.of(context).size.width / 360)),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xffE47421),
                              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                              ),
                              side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                              elevation: 0
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            child : Text("네", style: TextStyle(color: Color(0xffFFFFFF)),),
                          ),
                          onPressed: () {
                            comment_seq = seq;
                            updateadopt(adopt_id, adopt_nm).then((value) {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                barrierColor: Color(0xffE47421).withOpacity(0.4),
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                    child: textalert2(context, '채택 되었습니다.'),
                                  );
                                },
                              ).then((value) {
                                getcommentdata();
                                setState(() {

                                });
                              });
                            }


                            );
                          },
                        ),
                      ],
                    )
                )
              ],
            );
          }
      );

    setState(() {

      /*isLiked = !isLiked;
      if(isLiked) {
        likes_yn = 'Y';
        updatelike().then((value) =>
            showDialog(context: context,
                builder: (BuildContext context) {
                  return likealert(context);
                }
            )
        );
      } else{
        likes_yn = 'N';
        updatelike().then((value) =>
            showDialog(context: context,
                builder: (BuildContext context) {
                  return unlikealert(context);
                }
            )
        );
      }*/

    });
  }

  AlertDialog adoptalert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(adoptmessage == "채택 등록")
          Text(
            "채택 되었습니다.",
          ),
          if(adoptmessage == "채택 취소")
          Text(
            "채택이 취소되었습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            getcommentdata().then((_) {
              setState(() {
                if(adoptmessage == "채택 등록")
                _adoptCheck = 1;
                if(adoptmessage == "채택 취소")
                _adoptCheck = 0;
              });
            });
          },
        ),
      ],
    );
  }

  void _iscommentlike(String seq, int index) {
    comment_seq = seq;
    updatecommentlike().then((value) {
      setState(() {

        if(value == '댓글 좋아요 등록') {
          commentlist[index]["list"]["like_cnt"] = commentlist[index]["list"]["like_cnt"] + 1;
        } else if (value == '댓글 좋아요 취소') {
          commentlist[index]["list"]["like_cnt"] = commentlist[index]["list"]["like_cnt"] - 1;
        }

        /*getcommentdata().then((_) {
          setState(() {
          });
        });*/
      });
    });

    setState(() {

      /*updatecommentlike().then((value) =>
          showDialog(context: context,
              builder: (BuildContext context) {
                return commentlikealert(context);
              }
          )
      );*/
    });
  }

  AlertDialog commentlikealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(commentlikemessage == "댓글 좋아요 등록")
            Text(
              "댓글 좋아요가 등록되었습니다.",
            ),
          if(commentlikemessage == "댓글 좋아요 취소")
            Text(
              "댓글 좋아요가 취소되었습니다.",
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            getcommentdata().then((_) {
              setState(() {
              });
            });
          },
        ),
      ],
    );
  }

  void _onShare(BuildContext context, text, link) async {
    final box = context.findRenderObject() as RenderBox?;

    // subject is optional but it will be used
    // only when sharing content over email
    await Share.share(text,
        subject: link,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }


  Future<void> _isLiked() async {

    setState(() {
      isLiked = !isLiked;
      if(isLiked) {
        likes_yn = 'Y';
        updatelike();
        setState(() {

        });
      } else{
        likes_yn = 'N';
        updatelike();
        setState(() {

        });
      }

    });
  }

  AlertDialog likealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "게시글 좋아요가 등록되었습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            getviewdata().then((_){
              setState(() {
              });
            });
          },
        ),
      ],
    );
  }

  AlertDialog unlikealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "게시글 좋아요가 취소되었습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            getviewdata().then((_){
              setState(() {
              });
            });
          },
        ),
      ],
    );
  }

  Row kincat(BuildContext context) {

    print("catnamecatname");
    print(cattitle);

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
                      if("" == result["main_category"])
                        Container(
                          // width: 50 * (MediaQuery.of(context).size.width / 360),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                          padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                              "전체",
                              style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if("" != result["main_category"])
                        Container(
                          // width: 50 * (MediaQuery.of(context).size.width / 360),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                          padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return KinList(success: false, failed: false,main_catcode: '',);
                                },
                              ));
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
                          if(cattitle[m2]['idx'] == result["main_category"])
                            Container(
                              key: titlecat_key,
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                              padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                          if(cattitle[m2]['idx'] != result["main_category"])
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                              padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return KinList(success: false, failed: false,main_catcode: cattitle[m2]['idx'],);
                                    },
                                  ));
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
}