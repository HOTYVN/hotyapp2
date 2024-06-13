import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
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
import 'package:hoty/community/Report/commentreport_write.dart';
import 'package:hoty/community/Report/report_write.dart';
import 'package:hoty/kin/kin_adopt_write.dart';
import 'package:hoty/kin/kin_coment_modify.dart';
import 'package:hoty/kin/kin_modify.dart';
import 'package:hoty/kin/kin_view.dart';
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

class KinCommentList extends StatefulWidget {
  final int article_seq;
  final int head_seq;
  final int parent_seq;
  final dynamic table_nm;
  final dynamic adopt_chk;
  final dynamic state;

  const KinCommentList({Key? key,
    required this.article_seq,
    required this.head_seq,
    required this.parent_seq,
    required this.table_nm,
    required this.adopt_chk,
    required this.state,
  }) : super(key:key);
  @override
  State<KinCommentList> createState() => _KinCommentListState();
}

class _KinCommentListState extends State<KinCommentList> {

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

  bool write_bar1 = true;
  bool write_bar2 = false;

  bool isLiked = false; // 좋아요상태
  String likes_yn = '';

  Widget _write_height = Container();
  
  int _current = 0;

  final _commentController = TextEditingController();
  final _recommentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickermodify = ImagePicker();
  List<XFile> _pickedImgs = [];

  Future _pickImg(ImageSource imageSource) async {

    if(imageSource == ImageSource.camera) {
      final XFile? images = await _picker.pickImage(source: imageSource);
      if(_pickedImgs.length >= 1) {
        if (images != null) {
          setState(() {
            _pickedImgs.removeLast();
          });
        }
      }
      if (images != null) {
        setState(() {
          _pickedImgs.add(images);
        });
      }
    }

    if(imageSource == ImageSource.gallery) {
      final XFile? images = await _picker.pickImage(source: imageSource);

      if(_pickedImgs.length >= 1) {
        if (images != null) {
          setState(() {
            _pickedImgs.removeLast();
          });
        }
      }
      if (images != null) {
        setState(() {
          _pickedImgs.add(images);
        });
      }

    }
  }

  Future _pickImg2(ImageSource imageSource, index) async {
    List<XFile> _pickedImgs2 = [];
    if(imageSource == ImageSource.camera) {
      final XFile? images = await _picker.pickImage(source: imageSource);
      if (images != null) {
        setState(() {
          _pickedImgs2.add(images);
          commentlist[index]["list"]["_pickedImgs"] = _pickedImgs2;
        });
      }
    }

    if(imageSource == ImageSource.gallery) {
      final XFile? images = await _picker.pickImage(source: imageSource);
      if (images != null) {
        setState(() {
          _pickedImgs2.add(images);
          commentlist[index]["list"]["_pickedImgs"] = _pickedImgs2;
        });
      }

    }
  }

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
      widget.state == 'C' ? 'http://www.hoty.company/mf/comment/list.do':
      'http://www.hoty.company/mf/comment/adopt_commentlist.do',
      //'http://www.hoty.company/mf/comment/list.do',
    );

    print('######');
    // print(widget.checkList);
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        /*"rows": rows.toString(),*/
        "rows": 99999,
        "table_nm" : "KIN",
        "cms_menu_seq" : cms_menu_seq.toString(),
        "article_seq" : widget.article_seq,
        "reg_id" : reg_id,
        "sort_nm" : _sortvalue,
        "keyword" : keyword,
        "condition" : condition,
        "head_seq" : widget.head_seq,
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
        //commentlist = json.decode(response.body)['result'];

        for(int i=0; i<json.decode(response.body)['result'].length; i++){
          commentlist.add(json.decode(response.body)['result'][i]);
        }


        for(int i=0; i<commentlist.length; i++){
          commentlist[i]["list"]["visible1"] = false as bool;
          commentlist[i]["list"]["visible2"] = false as bool;
          commentlist[i]["list"]["_pickedImgs"] = [];
          commentlist[i]["list"]["write"] = false;

          if(commentlist[i]["list"]["adopt"] == "Y") {
            _adoptCheck = 1;
          }
        }

        Map paging = json.decode(response.body)['pagination'];
        //print(json.decode(response.body)['pagination']);
        totalpage = paging['totalpage'].toInt(); // totalpage
        totalcount = paging['totalcount'].toInt(); // totalcount

        totalcount = commentlist.length;



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
        "adopt_nm" : adopt_nm
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
        return KinView(article_seq: widget.article_seq, table_nm: widget.table_nm, adopt_chk: '');
      },
    ));

    return value;
  }

  Future<bool> _isclose() async {
    bool isclose = false;

      for(var a = 0; a < commentlist.length; a++) {
        commentlist[a]["list"]["visible1"] = false;
        commentlist[a]["list"]["visible2"] = false;
      }

    isclose = true;

    setState(() {

    });

    return isclose;
  }

  Future<bool> _write_bar_close() async {
    bool write_bar_close = false;

    write_bar1 = false;
    write_bar2 = false;

    write_bar_close = true;

    setState(() {

    });


    return write_bar_close;


  }

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // GlobalKey를 저장할 리스트 선언
  final Map<String, GlobalKey<FormState>> _formKeys = {

  };
  // final List<GlobalKey> _keys = [];
  // List<GlobalKey> cm_key = [];
  final GlobalKey titlecat_key = GlobalKey();
/*  void _generateFormKeys(dynamic list) {

    cm_key = list.generate(list.length, (index) => GlobalKey());
    for (int i = 0; i < list.length; i++) {
      // _keys.add(list[i]["list"]["comment_seq"]);
      // cm_key.add(GlobalKey());
    }
  }*/
  // 폼 키를 생성하고 리스트에 추가하는 함수
  void _generateFormKeys(dynamic list) {
    for (int i = 0; i < list.length; i++) {
      _formKeys["key_${list[i]["list"]["comment_seq"]}"] = GlobalKey<FormState>();
    }
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    getcodedata().then((_) {
      setState(() {
      });
    });
    getviewdata().then((_) {
      setState(() {
      });
    });
    getcommentdata().then((_) {
      setState(() {
        _generateFormKeys(commentlist);
      });
    });


  }

  @override
  Widget build(BuildContext context) {
      return /*WillPopScope(
          onWillPop: () {
           return _onBackKey();
      },
        child : */GestureDetector(
          onTap : () {
            //FocusManager.instance.primaryFocus?.unfocus();
            //for(var i = 0; i <commentlist.length; i++) {
            //  commentlist[i]["list"]["visible1"] = false;
            //  commentlist[i]["list"]["visible2"] = false;
            //}
            //write_bar1 = true;
            //write_bar2 = false;
            //_recommentController.text = '';
            //_commentController.text = '';
            //setState(() {
            //  for(var i = 0; i <commentlist.length; i++) {
            //    commentlist[i]["list"]["visible1"] = false;
            //    commentlist[i]["list"]["visible2"] = false;
            //  }
            //  write_bar1 = true;
            //  write_bar2 = false;
            //  _commentController.text = "";
            //  _recommentController.text = '';
            //});
          },
        child : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: true,
            /*iconTheme: IconThemeData(
                color: Colors.black
            ),*/
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 25,
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
            title: Container(
                width: 80 * (MediaQuery.of(context).size.width / 350),
                height: 80 * (MediaQuery.of(context).size.height / 360),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("댓글", style: TextStyle(color: Color(0xff151515), fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800, fontFamily: 'NanumSquareR'),),
                    Text(" ${totalcount}", style: TextStyle(color: Color(0xffE47421), fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800, fontFamily: 'NanumSquareR'),)
                  ],
                )
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            // controller: _scrollController,
            child: Column(
              children: [
                for(var i = 0 ; i < commentlist.length; i++)
                // 1뎁스
                  if(commentlist[i]['list']['lv'] == '1')
                    Container(
                        child : Column(
                          children: <Widget> [
                            Container(
                                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                decoration : BoxDecoration (
                                    border : Border(
                                        bottom: BorderSide(color : Color(0xffF3F6F8), width: 1 * (MediaQuery.of(context).size.width / 360),)
                                    )
                                ),
                                child : Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 300 * (MediaQuery.of(context).size.width / 360),
                                            key: _formKeys["key_${commentlist[i]["list"]["comment_seq"]}"],
                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                            child: Row(
                                              children: [
                                                Text("${commentlist[i]["list"]["reg_nm"]} ", style: TextStyle(color: Color(0xff151515), fontSize : 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w700),),
                                                Icon(My_icons.rate,
                                                  color: commentlist[i]["list"]['group_seq'] == '4' ? Color(0xff27AE60) :
                                                  commentlist[i]["list"]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                  commentlist[i]["list"]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                  commentlist[i]["list"]['group_seq'] == '7' ? Color(0xffE47421) :
                                                  commentlist[i]["list"]['group_seq'] == '10' ? Color(0xffE47421) :
                                                  Color(0xff27AE60),
                                                  size: 12 * (MediaQuery.of(context).size.width / 360),),
                                              ],
                                            ),
                                          ),
                                          /*if(reg_id != null && reg_id != "")
                                            if(reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y")*/
                                              Container(
                                              width: 25 * (MediaQuery.of(context).size.width / 360),
                                              height: 8 * (MediaQuery.of(context).size.height / 360),
                                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                              child: PopupMenuButton(
                                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                    0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
                                                iconSize : 55 * (MediaQuery.of(context).size.width / 360),
                                                icon: Image(image: AssetImage("assets/more_vert.png"),color: Color(0xffC4CCD0), width : 60 * (MediaQuery.of(context).size.width / 360), height : 60 * (MediaQuery.of(context).size.height / 360)),
                                                itemBuilder : (BuildContext context) => [
                                                  if(reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y")
                                                    PopupMenuItem(value : 'delete',
                                                      child : GestureDetector(
                                                        onTap : () {
                                                          deleteDialog(context,commentlist[i]["list"]["comment_seq"]);
                                                        },
                                                        child: Container(

                                                          child : Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),
                                                        )
                                                      ),
                                                    ),
                                                  if(reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y")
                                                    PopupMenuItem(value : 'Edit',
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) {
                                                                return KinCommentModify(article_seq: widget.article_seq, comment_seq: commentlist[i]["list"]["comment_seq"], head_seq: widget.head_seq, parent_seq: widget.parent_seq, table_nm: widget.table_nm, state: widget.state);
                                                              },
                                                            ));
                                                          },
                                                          child: Text(
                                                            "수정하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                                          )
                                                      ),
                                                    ),
                                                  // if(reg_id != null && reg_id != "")
                                                    PopupMenuItem(value : 'Report',
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) {
                                                                return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${commentlist[i]["list"]["conts"]}",board_seq: board_seq, comment_seq: commentlist[i]["list"]["comment_seq"],);
                                                              },
                                                            ));
                                                          },
                                                          child: Text(
                                                            "신고하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                                          )
                                                      ),

                                                    )
                                                ],
                                                //onSelected: ,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if(commentlist[i]['files'].length > 0)
                                    Container(
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360) ),

                                      child: SingleChildScrollView (
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            if(commentlist[i]['files'].length > 0)
                                              for(var f = 0; f < commentlist[i]['files'].length; f++)
                                                GestureDetector(
                                                  onTap: (){
                                                    showDialog(context: context,
                                                        barrierDismissible: false,
                                                        barrierColor: Colors.black,
                                                        builder: (BuildContext context) {
                                                          return PhotoAlbum_User(apptitle: '${commentlist[i]['list']['conts']}',fileresult: commentlist[i]['files'], table_nm: widget.table_nm,);
                                                        }
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 325 * (MediaQuery.of(context).size.width / 360),
                                                    margin : EdgeInsets.fromLTRB(f == 0 ? 0 : 5 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider('http://www.hoty.company/upload/'+widget.table_nm+'/${commentlist[i]['files'][f]["yyyy"]}/${commentlist[i]['files'][f]['mm']}/${commentlist[i]['files'][f]['uuid']}'),
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
                                                                    (f+1).toString() + '/' + commentlist[i]['files'].length.toString(),
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
                                        width : 330 * (MediaQuery.of(context).size.width / 360),
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        child : RichText(
                                          text : TextSpan(
                                              children: [
                                                if(commentlist[i]["list"]["parent_nm"] != null)
                                                  TextSpan(text : "@${commentlist[i]["list"]["parent_nm"]} ", style: TextStyle(color: Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),),
                                                TextSpan(text : "${commentlist[i]["list"]["conts"]}",
                                                  style: TextStyle(color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),
                                                ),
                                              ]
                                          ),
                                        ),
                                      
                                    ),
                                    Container(
                                        child : Row(
                                          children: [
                                            Container(
                                                width : 165 * (MediaQuery.of(context).size.width / 360),
                                                child : Row(
                                                  children: [
                                                    Text("${commentlist[i]["list"]["reg_dt"]}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                  ],
                                                )
                                            ),
                                            Container(
                                              width : 165 * (MediaQuery.of(context).size.width / 360),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {

                                                      double top_alignment = 0;

                                                      if(reg_id == null || reg_id == "") {
                                                        showModal(context, 'loginalert', '');
                                                      }
                                                      if(reg_id != null && reg_id != "") {
                                                        /*for(var a = 0; a < commentlist.length; a++) {
                                                  commentlist[a]["list"]["visible1"] = false;
                                                  commentlist[a]["list"]["visible2"] = false;
                                                }*/
                                                        _write_bar_close().then((value) {
                                                          _isclose().then((value) {
                                                            if(write_bar1 == false && write_bar2 == false) {
                                                              top_alignment = 0.42;
                                                            } else {
                                                              top_alignment = 0.03;
                                                            }

                                                            if (commentlist[i]["list"]["visible2"] == false) {
                                                              // top_alignment = 0.3;
                                                              //commentlist[i]["list"]["visible2"] = true;
                                                              write_bar1 = false;
                                                              write_bar2 = false;

                                                            } else {
                                                              //commentlist[i]["list"]["visible2"] = false;
                                                              write_bar1 = true;
                                                              write_bar2 = false;
                                                            }

                                                            setState(() {

                                                            });

                                                            if (commentlist[i]["list"]["visible2"] == false) {
                                                              // top_alignment = 0.3;
                                                              commentlist[i]["list"]["visible2"] = true;
                                                              //write_bar1 = false;
                                                              //write_bar2 = false;

                                                            } else {
                                                              commentlist[i]["list"]["visible2"] = false;
                                                              //write_bar1 = true;
                                                              //write_bar2 = false;
                                                            }


                                                            _recommentController.text = "";
                                                            setState(() {

                                                            });
                                                            if(value == true) {
                                                              setState(() {
                                                                print('@@@@@@@@@@@@@@@@@@@@@@@@@@>>>');
                                                                print(top_alignment);
                                                                Scrollable.ensureVisible(
                                                                  // titlecat_key!.currentContext!,
                                                                    _formKeys["key_${commentlist[i]["list"]["comment_seq"]}"]!.currentContext!,
                                                                    alignment : top_alignment
                                                                );
                                                              });
                                                            }
                                                            setState(() {
                                                              Scrollable.ensureVisible(
                                                                // titlecat_key!.currentContext!,
                                                                  _formKeys["key_${commentlist[i]["list"]["comment_seq"]}"]!.currentContext!,
                                                                  alignment : top_alignment
                                                              );
                                                            });
                                                          });
                                                        });



                                                        // print('2222222222222222');


                                                      }
                                                    },
                                                    child : Container(
                                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                            17 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                        child : Row(
                                                          children: [
                                                            Image(image: AssetImage("assets/reply_icon.png"), width: 16 * (MediaQuery.of(context).size.width / 360),),
                                                            Text("  답글", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w600, fontSize: 12 * (MediaQuery.of(context).size.width / 360)),),
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap : () {
                                                      Navigator.push(context, MaterialPageRoute(
                                                        builder: (context) {
                                                          return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${commentlist[i]["list"]["conts"]}",board_seq: board_seq, comment_seq: commentlist[i]["list"]["comment_seq"],);
                                                        },
                                                      ));
                                                    },
                                                    child : Container(
                                                        child : Row(
                                                          children: [
                                                            Image(image: AssetImage("assets/report_icon2.png"), width: 16 * (MediaQuery.of(context).size.width / 360),),
                                                            //Icon(Icons.report_gmailerrorred, color: Color(0xffC4CCD0),),
                                                            Text("  신고", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w600, fontSize: 12 * (MediaQuery.of(context).size.width / 360)),),
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    Visibility(
                                      visible: commentlist[i]['list']['visible2'],
                                      child: Container(
                                          width : 360 * (MediaQuery.of(context).size.width / 360),
                                          height : commentlist[i]["list"]["_pickedImgs"].length <= 0 ? 62 * (MediaQuery.of(context).size.height / 360) : 92 * (MediaQuery.of(context).size.height / 360),
                                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffF3F6F8)
                                            ),
                                            borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child : Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width : 360 * (MediaQuery.of(context).size.width / 360),
                                                height : 40 * (MediaQuery.of(context).size.height / 360),
                                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                child : TextFormField(
                                                  controller: _recommentController,
                                                  minLines: 1,
                                                  maxLines: 3,
                                                  autofocus: true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                                      borderSide: BorderSide(
                                                        color: Color.fromRGBO(255, 255, 255, 1),
                                                      ),
                                                    ),
                                                    // labelText: 'Search',
                                                  ),
                                                  style: TextStyle(fontFamily: ''),
                                                ),
                                              ),
                                              if(commentlist[i]["list"]["_pickedImgs"].length > 0)
                                                Container(
                                                    width: 60 * (MediaQuery.of(context).size.width / 360),
                                                    height: 30 * (MediaQuery.of(context).size.height / 360),
                                                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                    child : DottedBorder(
                                                        color: Color(0xffE47421),
                                                        dashPattern: [5,3],
                                                        borderType: BorderType.RRect,
                                                        radius: Radius.circular(10),
                                                        child: Stack(
                                                          alignment: Alignment.topRight,
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    image: DecorationImage(fit: BoxFit.cover,image: FileImage(File("${commentlist[i]["list"]["_pickedImgs"][0].path}")))
                                                                ),
                                                                child :  null
                                                            ),
                                                            Container (
                                                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xffffffff),
                                                                  borderRadius: BorderRadius.circular(15),
                                                                ),
                                                                //삭제버튼
                                                                child : IconButton(
                                                                    padding: EdgeInsets.zero,
                                                                    constraints: BoxConstraints(),
                                                                    icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        commentlist[i]["list"]["_pickedImgs"] = [];
                                                                      });
                                                                    }
                                                                )
                                                            )
                                                          ],
                                                          //child : Center(child: _boxContents[index])
                                                        )
                                                    )
                                                ),
                                              Container(
                                                  child : Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                          onTap : () {
                                                            _pickImg2(ImageSource.gallery, i);
                                                          },
                                                          child : Container(
                                                              padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                  8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                              child : Image(image: AssetImage("assets/add_a_gallary.png"), color:Color(0xffC4CCD0), width : 18 * (MediaQuery.of(context).size.width / 360))
                                                          )
                                                      ),
                                                      GestureDetector(
                                                          onTap : () {
                                                            _pickImg2(ImageSource.camera, i);
                                                          },
                                                          child : Container(
                                                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                  8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                              child : Image(image: AssetImage("assets/add_a_photo.png"), color:Color(0xffC4CCD0), width : 20 * (MediaQuery.of(context).size.width / 360))
                                                          )
                                                      ),
                                                      GestureDetector(
                                                        onTap : () {
                                                          if(commentlist[i]["list"]["visible2"] == false) {
                                                            commentlist[i]["list"]["visible2"] = true;
                                                            write_bar1 = false;
                                                            write_bar2 = false;
                                                          } else {
                                                            commentlist[i]["list"]["visible2"] = false;
                                                            write_bar1 = true;
                                                            write_bar2 = false;
                                                          }
                                                          _recommentController.text = "";
                                                          setState(() {
                                                            if( commentlist[i]["list"]["_pickedImgs"].length > 0) {
                                                              commentlist[i]["list"]["_pickedImgs"].removeLast();
                                                            }
                                                          });
                                                        },
                                                        child : Container(
                                                            padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                                8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Color(0xffE47421)
                                                              ),
                                                              borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                                            ),
                                                            child : Text("취소", style: TextStyle(color : Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap : () {
                                                          setState(() {
                                                            if(commentlist[i]["list"]["write"] == false) {
                                                              if(_recommentController.text != '' && _recommentController.text != null) {
                                                                FlutterDialog2(context,widget.head_seq,commentlist[i]["list"]["comment_seq"],commentlist[i]["list"]["comment_seq"],i);  
                                                              } else {
                                                                showDialog(context: context,
                                                                    barrierColor: Color(0xffE47421).withOpacity(0.4),
                                                                    builder: (BuildContext context) {
                                                                      return MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                        child: textalert(context,'답글을 입력하여주시기 바랍니다.'),
                                                                      );
                                                                    }
                                                                );
                                                              }
                                                            }
                                                          });
                                                        },
                                                        child : Container(
                                                            margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                            padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                                8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xffE47421),
                                                              borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                                            ),
                                                            child : Text("저장", style: TextStyle(color : Color(0xffFFFFFF), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            for(var j = 0; j < commentlist.length; j++)
                              if(commentlist[j]["list"]["lv"] == "2" && (commentlist[i]["list"]["comment_seq"] == commentlist[j]["list"]["parent_seq"]))
                                Container(
                                    margin : EdgeInsets.fromLTRB(55 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                    decoration : BoxDecoration (
                                        border : Border(
                                            bottom: BorderSide(color : Color(0xffF3F6F8), width: 1 * (MediaQuery.of(context).size.width / 360),)
                                        )
                                    ),
                                    child : Column(
                                      children: <Widget> [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 250 * (MediaQuery.of(context).size.width / 360),
                                                key: _formKeys["key_${commentlist[j]["list"]["comment_seq"]}"],
                                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                child: Row(
                                                  children: [
                                                    Text("${commentlist[j]["list"]["reg_nm"]} ", style: TextStyle(color: Color(0xff151515), fontSize : 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w700),),
                                                    Icon(My_icons.rate,
                                                      color: commentlist[j]["list"]['group_seq'] == '4' ? Color(0xff27AE60) :
                                                      commentlist[j]["list"]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                      commentlist[j]["list"]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                      commentlist[j]["list"]['group_seq'] == '7' ? Color(0xffE47421) :
                                                      commentlist[j]["list"]['group_seq'] == '10' ? Color(0xffE47421) :
                                                      Color(0xff27AE60),
                                                      size: 12 * (MediaQuery.of(context).size.width / 360),),
                                                  ],
                                                ),
                                              ),
                                                  Container(
                                                    width: 25 * (MediaQuery.of(context).size.width / 360),
                                                    height: 8 * (MediaQuery.of(context).size.height / 360),
                                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                        5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                    child: PopupMenuButton(
                                                      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                          0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
                                                      iconSize : 55 * (MediaQuery.of(context).size.width / 360),
                                                      icon: Image(image: AssetImage("assets/more_vert.png"),color: Color(0xffC4CCD0), width : 60 * (MediaQuery.of(context).size.width / 360), height : 60 * (MediaQuery.of(context).size.height / 360)),
                                                      itemBuilder : (BuildContext context) => [
                                                        if(reg_id == commentlist[j]["list"]["reg_id"] || adminChk == "Y")
                                                          PopupMenuItem(value : 'delete',
                                                            child : GestureDetector(
                                                              onTap : () {
                                                                deleteDialog(context,commentlist[j]["list"]["comment_seq"]);
                                                              },
                                                              child: Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),
                                                            ),
                                                          ),
                                                        if(reg_id == commentlist[j]["list"]["reg_id"] || adminChk == "Y")
                                                          PopupMenuItem(value : 'Edit',
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                   Navigator.push(context, MaterialPageRoute(
                                                                      builder: (context) {
                                                                        return KinCommentModify(article_seq: widget.article_seq, comment_seq: commentlist[j]["list"]["comment_seq"], head_seq: widget.head_seq, parent_seq: widget.parent_seq, table_nm: widget.table_nm, state: widget.state);
                                                                      },
                                                                    ));
                                                                },
                                                                child: Text(
                                                                  "수정하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                                                )
                                                            ),
                                                          ),
                                                        // if(reg_id != null && reg_id != "")
                                                        PopupMenuItem(value : 'Report',
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context) {
                                                                    return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${commentlist[j]["list"]["conts"]}",board_seq: board_seq, comment_seq: commentlist[j]["list"]["comment_seq"],);
                                                                  },
                                                                ));
                                                              },
                                                              child: Text(
                                                                "신고하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                                              )
                                                          ),

                                                        )
                                                      ],
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                        if(commentlist[j]['files'].length > 0)
                                        Container(
                                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360) ),

                                          child: SingleChildScrollView (
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if(commentlist[j]['files'].length > 0)
                                                  for(var f = 0; f < commentlist[j]['files'].length; f++)
                                                    GestureDetector(
                                                      onTap: (){
                                                        showDialog(context: context,
                                                            barrierDismissible: false,
                                                            barrierColor: Colors.black,
                                                            builder: (BuildContext context) {
                                                              return PhotoAlbum_User(apptitle: '${commentlist[j]['list']['conts']}',fileresult: commentlist[j]['files'], table_nm: widget.table_nm,);
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 290 * (MediaQuery.of(context).size.width / 360),
                                                        margin : EdgeInsets.fromLTRB(f == 0 ? 0 : 5 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider('http://www.hoty.company/upload/'+widget.table_nm+'/${commentlist[j]['files'][f]["yyyy"]}/${commentlist[j]['files'][f]['mm']}/${commentlist[j]['files'][f]['uuid']}'),
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
                                                                        (f+1).toString() + '/' + commentlist[j]['files'].length.toString(),
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
                                            width : 300 * (MediaQuery.of(context).size.width / 360),
                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                            child :  RichText(
                                                text : TextSpan(
                                                    children: [
                                                      if(commentlist[j]["list"]["parent_nm"] != null)
                                                        TextSpan(text : "@${commentlist[j]["list"]["parent_nm"]} ", style: TextStyle(color: Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),),
                                                      TextSpan(text : "${commentlist[j]["list"]["conts"]}",
                                                        style: TextStyle(color: Color(0xff4E4E4E), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),
                                                      ),
                                                    ]
                                                ),
                                            )
                                        ),
                                        Container(
                                            child : Row(
                                              children: [
                                                Container(
                                                    width : 147 * (MediaQuery.of(context).size.width / 360),
                                                    child : Row(
                                                      children: [
                                                        Text("${commentlist[j]["list"]["reg_dt"]}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                      ],
                                                    )
                                                ),
                                                Container(
                                                  width : 143 * (MediaQuery.of(context).size.width / 360),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          double top_alignment = 0;

                                                          if(reg_id == null || reg_id == "") {
                                                            showModal(context, 'loginalert', '');
                                                          }
                                                          if(reg_id != null && reg_id != "") {
                                                            /*for(var a = 0; a < commentlist.length; a++) {
                                                  commentlist[a]["list"]["visible1"] = false;
                                                  commentlist[a]["list"]["visible2"] = false;
                                                }*/

                                                            _write_bar_close().then((value) {
                                                              _isclose().then((value) {
                                                                if (write_bar1 == false && write_bar2 == false) {
                                                                  top_alignment = 0.42;
                                                                } else {
                                                                  top_alignment = 0.03;
                                                                }

                                                                print("top_alignment : ${top_alignment}");
                                                                if (commentlist[j]["list"]["visible1"] == false) {
                                                                  // top_alignment = 0.3;
                                                                  commentlist[j]["list"]["visible1"] = true;
                                                                  write_bar1 = false;
                                                                  write_bar2 = false;
                                                                } else {
                                                                  commentlist[j]["list"]["visible1"] = false;
                                                                  write_bar1 = true;
                                                                  write_bar2 = false;
                                                                }
                                                                _recommentController.text =
                                                                "";
                                                                setState(() {

                                                                });

                                                                if (value == true) {
                                                                  setState(() {
                                                                    Scrollable.ensureVisible(
                                                                        _formKeys["key_${commentlist[j]["list"]["comment_seq"]}"]!.currentContext!,
                                                                        alignment: top_alignment
                                                                    );
                                                                  });
                                                                }


                                                              });
                                                            });




                                                            setState(() {
                                                              Scrollable.ensureVisible(
                                                                  _formKeys["key_${commentlist[j]["list"]["comment_seq"]}"]!.currentContext!,
                                                                  alignment: top_alignment
                                                              );
                                                            });
                                                          }
                                                        },
                                                        child : Container(
                                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                17 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                            child : Row(
                                                              children: [
                                                                Image(image: AssetImage("assets/reply_icon.png"), width: 16 * (MediaQuery.of(context).size.width / 360),),
                                                                Text("  답글", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w600, fontSize: 12 * (MediaQuery.of(context).size.width / 360)),),
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap : () {
                                                          Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) {
                                                              return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${commentlist[j]["list"]["conts"]}",board_seq: board_seq, comment_seq: commentlist[j]["list"]["comment_seq"],);
                                                            },
                                                          ));
                                                        },
                                                        child : Container(
                                                            child : Row(
                                                              children: [
                                                                Image(image: AssetImage("assets/report_icon2.png"), width: 16 * (MediaQuery.of(context).size.width / 360),),
                                                                //Icon(Icons.report_gmailerrorred, color: Color(0xffC4CCD0),),
                                                                Text("  신고", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w600, fontSize: 12 * (MediaQuery.of(context).size.width / 360)),),
                                                              ],
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Visibility(
                                          visible: commentlist[j]['list']['visible1'],
                                          child: Container(
                                              width : 300 * (MediaQuery.of(context).size.width / 360),
                                              height : commentlist[j]["list"]["_pickedImgs"].length > 0 ? 92 * (MediaQuery.of(context).size.height / 360) : 62 * (MediaQuery.of(context).size.height / 360),
                                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffF3F6F8)
                                                ),
                                                borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child : Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height : 40 * (MediaQuery.of(context).size.height / 360),
                                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                    child : TextFormField(
                                                      controller: _recommentController,
                                                      minLines: 1,
                                                      maxLines: 3,
                                                      autofocus: true,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                                          borderSide: BorderSide(
                                                            color: Color.fromRGBO(255, 255, 255, 1),
                                                          ),
                                                        ),
                                                        // labelText: 'Search',
                                                      ),
                                                      style: TextStyle(fontFamily: ''),
                                                    ),
                                                  ),
                                                  if(commentlist[j]["list"]["_pickedImgs"].length > 0)
                                                    Container(
                                                        width: 60 * (MediaQuery.of(context).size.width / 360),
                                                        height: 30 * (MediaQuery.of(context).size.height / 360),
                                                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                        child : DottedBorder(
                                                            color: Color(0xffE47421),
                                                            dashPattern: [5,3],
                                                            borderType: BorderType.RRect,
                                                            radius: Radius.circular(10),
                                                            child: Stack(
                                                              alignment: Alignment.topRight,
                                                              children: [
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        image: DecorationImage(fit: BoxFit.cover,image: FileImage(File("${commentlist[j]["list"]["_pickedImgs"][0].path}")))
                                                                    ),
                                                                    child :  null
                                                                ),
                                                                Container (
                                                                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                                    decoration: BoxDecoration(
                                                                      color: Color(0xffffffff),
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    //삭제버튼
                                                                    child : IconButton(
                                                                        padding: EdgeInsets.zero,
                                                                        constraints: BoxConstraints(),
                                                                        icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            commentlist[j]["list"]["_pickedImgs"] = [];
                                                                          });
                                                                        }
                                                                    )
                                                                )
                                                              ],
                                                              //child : Center(child: _boxContents[index])
                                                            )
                                                        )
                                                    ),
                                                  Container(
                                                      child : Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          GestureDetector(
                                                              onTap : () {
                                                                _pickImg2(ImageSource.gallery, j);
                                                              },
                                                              child : Container(
                                                                  padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                      8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                                  child : Image(image: AssetImage("assets/add_a_gallary.png"), color:Color(0xffC4CCD0), width : 18 * (MediaQuery.of(context).size.width / 360))
                                                              )
                                                          ),
                                                          GestureDetector(
                                                              onTap : () {
                                                                _pickImg2(ImageSource.camera, j);
                                                              },
                                                              child : Container(
                                                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                      8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                                  child : Image(image: AssetImage("assets/add_a_photo.png"), color:Color(0xffC4CCD0), width : 20 * (MediaQuery.of(context).size.width / 360))
                                                              )
                                                          ),
                                                          GestureDetector(
                                                            onTap : () {
                                                              if(commentlist[j]["list"]["visible1"] == false) {
                                                                commentlist[j]["list"]["visible1"] = true;
                                                              } else {
                                                                write_bar1 = true;
                                                                commentlist[j]["list"]["visible1"] = false;

                                                              }
                                                              _recommentController.text = "";
                                                              setState(() {
                                                                if( commentlist[j]["list"]["_pickedImgs"].length > 0) {
                                                                  commentlist[j]["list"]["_pickedImgs"].removeLast();
                                                                }
                                                              });
                                                            },
                                                            child : Container(
                                                                padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                                    8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Color(0xffE47421)
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                                                ),
                                                                child : Text("취소", style: TextStyle(color : Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap : () {
                                                              setState(() {
                                                                if(commentlist[j]["list"]["write"] == false) {
                                                                  if(_recommentController.text != null && _recommentController.text != '') {
                                                                    FlutterDialog2(context,widget.head_seq,commentlist[j]["list"]["parent_seq"] ?? commentlist[j]["list"]["comment_seq"],commentlist[j]["list"]["comment_seq"],j);
                                                                  } else {
                                                                    showDialog(context: context,
                                                                        barrierColor: Color(0xffE47421).withOpacity(0.4),
                                                                        builder: (BuildContext context) {
                                                                          return MediaQuery(
                                                                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                            child: textalert(context,'답글을 입력하여주시기 바랍니다.'),
                                                                          );
                                                                        }
                                                                    );
                                                                  }
                                                                }
                                                                print("클릭");
                                                              });
                                                            },
                                                            child : Container(
                                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                                padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                                    8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xffE47421),
                                                                  borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                                                ),
                                                                child : Text("저장", style: TextStyle(color : Color(0xffFFFFFF), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  )
                                                ],
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                          ],
                        )
                    ),
                //if(commentlist.length > 0 && cpage < totalpage)
                //  seemore(context),
                if(write_bar1 == true || write_bar2 == true)
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    write_bar1 == true ? 50 * (MediaQuery.of(context).size.height / 360) : 90 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                ),

                if(write_bar1 == false && write_bar2 == false)
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      200 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton : Align(
            alignment: Alignment(0, write_bar1 == true ? 1.048 : 1.055),
            child : Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: write_bar1 == true ? 50 * (MediaQuery.of(context).size.height / 360) : write_bar2 && _pickedImgs.length > 0 ? 122 * (MediaQuery.of(context).size.height / 360) : write_bar2 && _pickedImgs.length <= 0 ? 92 * (MediaQuery.of(context).size.height / 360) : 0,
                color: Color.fromRGBO(255, 255, 255, (write_bar1 == true || write_bar2 == true ? 1 : 0)),
                child : Column(
                  children: [
                    Visibility(
                      visible: write_bar1,
                      child: GestureDetector(
                        onTap : () {
                          if(reg_id == null || reg_id == "") {
                            showModal(context, 'loginalert', '');
                          }
                          if(reg_id != null && reg_id != "") {
                            write_bar1 = false;
                            write_bar2 = true;
                            setState(() {
                              write_bar1 = false;
                              write_bar2 = true;
                            });
                          }
                        },
                        child : Container(
                          width: 330 * (MediaQuery.of(context).size.width / 360),
                          height: 25 * (MediaQuery.of(context).size.height / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 2, color: Color(0xffF3F6F8),
                            ),
                          ),
                          child :
                          Container(
                              child : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      width: 190 * (MediaQuery.of(context).size.width / 360),
                                      alignment: Alignment.centerLeft,
                                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      child : Text("댓글을 남겨보세요", style: TextStyle(color: Color(0xffC4CCD0), ),)
                                  ),
                                  GestureDetector(
                                      onTap : () {
                                        if(reg_id == null || reg_id == "") {
                                          showModal(context, 'loginalert', '');
                                        }
                                        if(reg_id != null && reg_id != "") {
                                          write_bar1 = false;
                                          write_bar2 = true;
                                          setState(() {
                                            write_bar1 = false;
                                            write_bar2 = true;
                                          });
                                        }
                                      },
                                      child : Container(
                                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child : Image(image: AssetImage("assets/add_a_gallary.png"), color:Color(0xffC4CCD0), width : 18 * (MediaQuery.of(context).size.width / 360))
                                      )
                                  ),
                                  GestureDetector(
                                      onTap : () {
                                        if(reg_id == null || reg_id == "") {
                                          showModal(context, 'loginalert', '');
                                        }
                                        if(reg_id != null && reg_id != "") {
                                          write_bar1 = false;
                                          write_bar2 = true;
                                          setState(() {
                                            write_bar1 = false;
                                            write_bar2 = true;
                                          });
                                        }
                                      },
                                      child : Container(
                                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          child : Image(image: AssetImage("assets/add_a_photo.png"), color:Color(0xffC4CCD0), width : 20 * (MediaQuery.of(context).size.width / 360))
                                      )
                                  ),
                                  GestureDetector(
                                    onTap : () {
                                      if(reg_id == null || reg_id == "") {
                                        showModal(context, 'loginalert', '');
                                      }
                                      if(reg_id != null && reg_id != "") {
                                        write_bar1 = false;
                                        write_bar2 = true;
                                        setState(() {
                                          write_bar1 = false;
                                          write_bar2 = true;
                                        });
                                      }
                                    },
                                    child : Container(
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                        padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                        decoration: BoxDecoration(
                                          color: Color(0xffE47421),
                                          borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Text("저장", style: TextStyle(color : Color(0xffFFFFFF), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                                    ),
                                  ),
                                ],
                              )
                          )
                        ),
                      ),
                    ),
                    Visibility(
                      visible: write_bar2,
                      child : Container(
                          width: 360 * (MediaQuery.of(context).size.width / 360),
                          height: _pickedImgs.length > 0 ? 102 * (MediaQuery.of(context).size.height / 360) : 72 * (MediaQuery.of(context).size.height / 360),
                          margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                            color: Color(0xffFFFFFF),
                            border: Border.all(
                              width: 2, color: Color(0xffF3F6F8),
                            ),
                          ),
                          child : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 330 * (MediaQuery.of(context).size.width / 360),
                                height: 50 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child : TextFormField(
                                  maxLines: 9,
                                  minLines: 3,
                                  controller: _commentController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    // labelText: 'Search',
                                    hintText: '댓글을 남겨보세요',
                                    hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                                  ),
                                  style: TextStyle(fontFamily: ''),
                                ),
                              ),
                              if(_pickedImgs.length > 0)
                                Container(
                                    width: 60 * (MediaQuery.of(context).size.width / 360),
                                    height: 30 * (MediaQuery.of(context).size.height / 360),
                                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child : DottedBorder(
                                        color: Color(0xffE47421),
                                        dashPattern: [5,3],
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(10),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    image: DecorationImage(fit: BoxFit.cover,image: FileImage(File(_pickedImgs[0].path)))
                                                ),
                                                child :  null
                                            ),
                                            Container (
                                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                //삭제버튼
                                                child : IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints: BoxConstraints(),
                                                    icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                                    onPressed: () {
                                                      setState(() {
                                                        _pickedImgs.remove(_pickedImgs[0]);
                                                      });
                                                    }
                                                )
                                            )
                                          ],
                                          //child : Center(child: _boxContents[index])
                                        )
                                    )
                                ),
                              Container(
                                child : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap : () {
                                          _pickImg(ImageSource.gallery);
                                        },
                                        child : Container(
                                            padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                            child : Image(image: AssetImage("assets/add_a_gallary.png"), color:Color(0xffC4CCD0), width : 18 * (MediaQuery.of(context).size.width / 360))
                                        )
                                    ),
                                    GestureDetector(
                                        onTap : () {
                                          _pickImg(ImageSource.camera);
                                        },
                                        child : Container(
                                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                            child : Image(image: AssetImage("assets/add_a_photo.png"), color:Color(0xffC4CCD0), width : 20 * (MediaQuery.of(context).size.width / 360))
                                        )
                                    ),
                                    GestureDetector(
                                      onTap : () {
                                        _commentController.text = '';
                                        write_bar1 = true;
                                        write_bar2 = false;
                                        setState(() {
                                          if(_pickedImgs.length > 0) {
                                            _pickedImgs.removeLast();
                                          }
                                        });
                                      },
                                      child : Container(
                                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffE47421)
                                            ),
                                            borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child : Text("취소", style: TextStyle(color : Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap : () {
                                        if(saved == false) {
                                          if(_commentController.text != '' && _commentController.text != null) {
                                            FlutterDialog(context).then((value) {
                                              setState(() {
                                              });
                                            });
                                          } else {
                                            showDialog(context: context,
                                                barrierColor: Color(0xffE47421).withOpacity(0.4),
                                                builder: (BuildContext context) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                    child: textalert(context,'댓글을 입력하여주시기 바랍니다.'),
                                                  );
                                                }
                                            );
                                          }

                                        }
                                      },
                                      child : Container(
                                          padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                              8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                                            color: Color(0xffE47421),
                                          ),
                                          child : Text("저장", style: TextStyle(color: Color(0xffFFFFFF), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800,),)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                )
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          extendBody: false,
          bottomNavigationBar: Footer(nowPage: 'Main_menu'),
        )
      /*)*/
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
                write_bar1 = true;
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
                              showDialog(context: context,
                                  builder: (BuildContext context) {
                                    adoptmessage = value;
                                    return adoptalert(context);
                                  }
                              );
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

  void _iscommentlike(String seq) {
    comment_seq = seq;
    updatecommentlike().then((_) {
      setState(() {
        getcommentdata().then((_) {
          setState(() {
          });
        });
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


  void _isLiked() {

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

  var saved = false;

  Future<void> FlutterDialog(context) async {

    saved = true;

    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    final List<MultipartFile> _files =
    _pickedImgs.map(
            (img) => MultipartFile.fromFileSync(img.path,  contentType: new MediaType("image", "jpg"))
    ).toList();


    /*print("#############################################");
    print("files :::: ${_files}");*/

    FormData _formData = FormData.fromMap(
        {
          "attach" : _files,
          "conts" : _commentController.text,
          "board_seq" : "10",
          "article_seq" : widget.article_seq,
          "cms_menu_seq" : cms_menu_seq.toString(),
          "session_ip" : data["ip"].toString(),
          "session_member_id" : reg_id,
          "session_member_nm" : reg_nm,
          "table_nm" : "KIN",
          "head_seq" : widget.head_seq == 0 || widget.head_seq == null || widget.head_seq == '' ? null : widget.head_seq,
          "parent_seq": 0 ,
          "state" : widget.state,
          "parent_nm_seq" : 0
        }
    );

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/comment/write.do", data: _formData).then((res) {
      print("작성결과 ##############################################");
      print(res);
      return res.data;
    });

    /*Future initWrite(rst) async {
      writeApi_result = await mainCategoryProvider.writeApi(rst);
    }*/
    print("####################################### 작성결과 ##############################################");
    print(res);
    print(res["result"]);
    print(res["resultstatus"]);
    print(res["errorcode"]);
    if(res["result"] != null && res["resultstatus"] == "N") {
    //  showDialog(
    //      context: context,
    //      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
    //      barrierDismissible: false,
    //      builder: (BuildContext context) {
    //        return MediaQuery(
    //          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    //          child: textalert2(context, '댓글 작성이 완료되었습니다.'),
    //        );
    //      }
    //  ).then((value) => {

        commentlist.clear();
        cpage = 1;
        getcommentdata().then((_) {

          setState(() {
            _generateFormKeys(commentlist);
            saved = false;
            _commentController.text = "";
            FocusManager.instance.primaryFocus?.unfocus();
            write_bar2 = false;
            write_bar1 = true;
          });
        });
      //});
    }
  }

  Future<void> FlutterDialog2(context, head_seq, parent_seq, parent_nm_seq, index) async {

    commentlist[index]["list"]["write"] = true;

    setState(() {

    });

    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    FormData _formData = FormData.fromMap(
        {
        }
    );

    if(commentlist[index]["list"]["_pickedImgs"] != null && commentlist[index]["list"]["_pickedImgs"].length > 0) {
      List<XFile> files = commentlist[index]["list"]["_pickedImgs"];

      final List<MultipartFile> _files =
      files.map(
              (img) =>
              MultipartFile.fromFileSync(
                  img.path, contentType: new MediaType("image", "jpg"))
      ).toList();


      /*print("#############################################");
    print("files :::: ${_files}");*/

      _formData = FormData.fromMap(
          {
            "attach": _files,
            "conts": _recommentController.text,
            "board_seq": "10",
            "article_seq": widget.article_seq,
            "cms_menu_seq": cms_menu_seq.toString(),
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "KIN",
            "head_seq": head_seq == 0 || head_seq == null || head_seq == '' ? null : head_seq,
            "parent_seq": parent_seq == 0 || parent_seq == null || parent_seq == '' ? 0 : parent_seq,
            "state": widget.state,
            "parent_nm_seq": parent_nm_seq == 0 || parent_nm_seq == null || parent_nm_seq == '' ? 0 : parent_nm_seq
          }
      );
    } else {
      _formData = FormData.fromMap(
          {
            "conts": _recommentController.text,
            "board_seq": "10",
            "article_seq": widget.article_seq,
            "cms_menu_seq": cms_menu_seq.toString(),
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "KIN",
            "head_seq": head_seq == 0 || head_seq == null || head_seq == '' ? null : head_seq,
            "parent_seq": parent_seq == 0 || parent_seq == null || parent_seq == '' ? 0 : parent_seq,
            "state": widget.state,
            "parent_nm_seq": parent_nm_seq == 0 || parent_nm_seq == null || parent_nm_seq == '' ? 0 : parent_nm_seq
          }
      );
    }

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/comment/write.do", data: _formData).then((res) {
      print("작성결과 ##############################################");
      print(res);
      return res.data;
    });

    /*Future initWrite(rst) async {
      writeApi_result = await mainCategoryProvider.writeApi(rst);
    }*/
    print("####################################### 작성결과 ##############################################");
    print(res);
    print(res["result"]);
    print(res["resultstatus"]);
    print(res["errorcode"]);
    if(res["result"] != null && res["resultstatus"] == "N") {
      //showDialog(
      //    context: context,
      //    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      //    barrierDismissible: false,
      //    builder: (BuildContext context) {
      //      return MediaQuery(
      //        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      //        child: textalert2(context, '댓글 작성이 완료되었습니다.'),
      //      );
      //    }
      //).then((value) => {
        commentlist[index]["list"]["write"] = false;
        _commentController.text = "";
        commentlist.clear();
        cpage = 1;
        write_bar1 = true;
        getcommentdata().then((_) {
          _generateFormKeys(commentlist);

          setState(() {

          });
        });
      //});
    }
  }


  Future<void> deleteDialog(BuildContext context, seq) async{
    showDialog(
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: deletecheck2(context,),
        );
      },
    ).then((value) {
      if(value == true) {
        deletecomment(seq).then((value) {
          setState(() {
            showDialog(context : context,
                barrierColor: Color(0xffE47421).withOpacity(0.4),
                builder : (BuildContext context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: delalert(context,),
                  );
                }
            ).then((value) {
              // Navigator.pop(context);
              // Navigator.pop(context);
              /*Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  // return TradeList(checkList : []);
                  return Profile_my_post(table_nm : 'USED_TRNSC', category: 'USED_TRNSC',);
                },
              ));*/
              _commentController.text = "";
              commentlist.clear();
              cpage = 1;
              write_bar1 = true;
              Navigator.pop(context);
              getcommentdata().then((_) {
                _generateFormKeys(commentlist);

                setState(() {

                });
              });
            });
          });
        });
      }
    });
  }

  AlertDialog deletealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "삭제가 완료되었습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            // Navigator.pop(context);
            // Navigator.pop(context);
           /* Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return TradeList(checkList : []);
              },
            ));*/
            _commentController.text = "";
            commentlist.clear();
            cpage = 1;
            write_bar1 = true;
            getcommentdata().then((_) {
              _generateFormKeys(commentlist);

              setState(() {

              });
            });
          },
        ),
      ],
    );
  }

}