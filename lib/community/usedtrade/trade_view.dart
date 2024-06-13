import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/common/modifyinfo/modify_infomation.dart';
import 'package:hoty/common/photo/view_photo_user.dart';
import 'package:hoty/community/Report/commentreport_write.dart';
import 'package:hoty/community/common/coment_modify.dart';
import 'package:hoty/community/device_id.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_modify.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/dialog/commonAlert.dart';
import '../../common/dialog/loginAlert.dart';
import '../../common/dialog/showDialog_modal.dart';
import '../../common/icons/my_icons.dart';
import '../../common/js/common_js.dart';
import '../../common/photo/photo_album_user.dart';
import '../../login/login.dart';
import '../../profile/profile_my_post.dart';
import '../Report/report_write.dart';

class TradeView extends StatefulWidget {
  final int article_seq;
  final dynamic table_nm;
  final Map params;
  final List<String> checkList;


  const TradeView({Key? key,
    required this.article_seq,
    required this.table_nm,
    required this.params,
    required this.checkList,
  }) : super(key:key);


  @override
  _TradeView createState() => _TradeView();

}

class _TradeView extends State<TradeView> {

  int? rating_cnt;

  List<dynamic> coderesult = []; // 공통코드 리스트
  bool isLiked = false; // 좋아요상태
  String likes_yn = '';


  Map<String, dynamic> getresult = {};
  List<dynamic> result = [];

  Map viewresult = {};
  List<dynamic> fileresult = [];
  String apptitle = "";
  var reg_id = "";
  var adminChk = "";
  var board_seq = 15;

  bool write_bar1 = true;
  bool write_bar2 = false;

  var urlpath = 'http://www.hoty.company';

  var longurl = "";
  var url1 = "https://hotyapp.page.link/?link=https://hotyapp.page.link?";
  var url2 = "type=view@@table_nm=USED_TRNSC@@article_seq=";
  var url3 = "&apn=com.hotyvn.hoty";
  var shorturl = "";


  var cpage = 1;
  var rows = 10;
  var cms_menu_seq = 27;

  List<dynamic> listresult = [];

  TextEditingController _recommentController = TextEditingController();

  TextEditingController _commentController = TextEditingController();

  // GlobalKey를 저장할 리스트 선언
  final Map<String, GlobalKey<FormState>> _formKeys = {

  };

  // 폼 키를 생성하고 리스트에 추가하는 함수
  void _generateFormKeys(dynamic list) {
    for (int i = 0; i < list.length; i++) {
      _formKeys["key_${listresult[i]["list"]["comment_seq"]}"] = GlobalKey<FormState>();
    }
  }

  Future<bool> _isclose() async {
    bool isclose = false;

    for(var a = 0; a < listresult.length; a++) {
      listresult[a]["list"]["visible1"] = false;
      listresult[a]["list"]["visible2"] = false;
    }

    isclose = true;


    return isclose;
  }

  final ImagePicker _picker = ImagePicker();
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
          listresult[index]["list"]["_pickedImgs"] = _pickedImgs2;
        });
      }
    }

    if(imageSource == ImageSource.gallery) {
      final XFile? images = await _picker.pickImage(source: imageSource);
      if (images != null) {
        setState(() {
          _pickedImgs2.add(images);
          listresult[index]["list"]["_pickedImgs"] = _pickedImgs2;
        });
      }

    }
  }

  Future<dynamic> getviewdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/community/view.do',
    );

    try {
      Map data = {
          "article_seq" : widget.article_seq,
          "table_nm" : widget.table_nm,
          "reg_id" : (await storage.read(key:'memberId')) ?? await getMobileId(),
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
        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];
        // print(getresult);

        getresult.forEach((key, value) {
          if(key == 'data'){
            viewresult.addAll(value);
          }
          if(key == 'files'){
            fileresult.addAll(value);
          }
        });
        if(viewresult['title'] != null) {
          apptitle = viewresult['title'];
        }

        // 좋아요 유무
        if(viewresult['like_yn'] != null) {
          var like_cnt = viewresult['like_yn'];
          print(like_cnt);
          if(like_cnt > 0) {
            isLiked = true;
          }
        }

        print(viewresult);
        print(fileresult);

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
        coderesult = json.decode(response.body)['result'];
      }
      // print(result.length);
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
        "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
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

  Future<dynamic> delete() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/community/delete.do',
    );

    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "reg_id" : reg_id,
        "table_nm" : widget.table_nm,
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

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    adminChk = (await storage.read(key:'memberAdminChk')) ?? "";
    print("#############################################");
    print(reg_id);
  }

  final GlobalKey pre_article_key = GlobalKey();
  final GlobalKey title_key = GlobalKey();
  Map prev_cnt = {};
  Map next_cnt = {};
  Map prev_article = {};
  //var Baseurl = "http://www.hoty.company/mf";
  var Baseurl = "http://www.hoty.company/mf";
  Map next_article = {};
  List<dynamic> pnlist = [];
  List<dynamic> checklist = [];

  // list 호출
  Future<dynamic> getpnlistdata() async {
    Map<String, dynamic> rst = {};
    Map<String, dynamic> getresult = {};

    var totalpage = '';

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
        Baseurl + "/common/pnlist.do"
    );
    print('#####2222#');

    List<String> main_checklist = [];
    List<String> listcat02 = [];


    for(var i = 0; i < widget.checkList.length; i++) {
      if(widget.checkList[i].contains("D1")) {
        main_checklist.add(widget.checkList[i]);
      }
      if(widget.checkList[i].contains("D2")) {
        listcat02.add(widget.checkList[i]);
      }
    }

    print(main_checklist);
    print(listcat02);

    print("데이터체크");


    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : widget.table_nm,
        "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
        "sort_nm" : widget.params['sort_nm'],
        "keyword" : widget.params['keyword'],
        "condition" : widget.params['condition'],
        "main_checklist": main_checklist.toList(),
        "listcat02" : listcat02.toList(),
        "board_seq": board_seq.toString(),

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

        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];

        getresult.forEach((key, value) {
          if(key == 'pnlist'){
            pnlist.addAll(value);
          }
          if(key == 'prev_cnt'){
            prev_cnt.addAll(value);
          }
          if(key == 'next_cnt'){
            next_cnt.addAll(value);
          }
          if(key == 'prev_seq'){
            if(value != null){
              prev_article.addAll(value);
            }
          }
          if(key == 'next_seq'){
            if(value != null){
              next_article.addAll(value);
            }
          }
        });

        print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
        print(getresult);

      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }

    return rst;
  }



  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
      'http://www.hoty.company/mf/comment/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": board_seq.toString(),
        "cpage": cpage.toString(),
        "rows": rows.toString(),
        "table_nm" : "USED_TRNSC",
        "cms_menu_seq" : cms_menu_seq.toString(),
        "article_seq" : widget.article_seq,
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


        listresult = json.decode(response.body)['result'];

        for(int i=0; i<listresult.length; i++){
          listresult[i]["list"]["visible1"] = false as bool;
          listresult[i]["list"]["visible2"] = false as bool;
          listresult[i]["list"]["_pickedImgs"] = [];
          listresult[i]["list"]["write"] = false;
        }

        setState(() {

        });
        // paging = json.decode(response.body)['pagination'];

        // totalpage = paging['totalpage']; // totalpage
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
    _asyncMethod();
    getviewdata().then((_) {
      getcodedata().then((_) {
        getlistdata().then((_) {
          getpnlistdata().then((_) {
            setState(() {
              if(pnlist.length > 0) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scrollable.ensureVisible(
                    pre_article_key.currentContext!,
                  );
                });
              }
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Scrollable.ensureVisible(
                  title_key.currentContext!,
                );
              });
              _generateFormKeys(listresult);
            });
          });
        });
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
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
        title:
        Container(
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          // width: 240 * (MediaQuery.of(context).size.width / 360),
          child: Text(
            apptitle,
            style: TextStyle(
            fontSize: 17 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xff151515),
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0,12 * (MediaQuery.of(context).size.width / 360), 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    getUrl().then((_) {
                      setState(() {

                      });
                      _onShare(context, viewresult["title"], shorturl);
                    });
                  },
                  child: Icon(Icons.ios_share,color: Color(0xffC4CCD0),size: 24,),
                ),
                GestureDetector(
                  onTap: () {
                      _isLiked();
                  },
                  child: Row(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child: Icon(
                          Icons.favorite,
                          color: Color(isLiked ? 0xffE47421 : 0xffC4CCD0),
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(viewresult.length > 0 )
            Container(
              key: title_key,
              child: getConts(context),
            )
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'Main_menu'),
    );
  }

  Widget getPreNext(context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 120 * (MediaQuery.of(context).size.height / 360),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      color: Color(0xffF9FBFB),
      child: Column(
        children: [
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            height: 15 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360) , 0, 0),
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:() {
                 /*         if(prev_cnt['prev_cnt'] > 0) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TradeView(
                                  article_seq: prev_article['article_seq'],
                                  table_nm: widget.table_nm,
                                  params: widget.params,
                                );
                              },
                            ));
                          }*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 16,),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        child: Text(
                          "이전게시글",
                          style: TextStyle(
                            // color: Color(0xff151515),
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            fontFamily: 'NanumSquareEB',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "다음게시글",
                          style: TextStyle(
                            // color: Color(0xff151515),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NanumSquareEB',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:() {
                /*          if(next_cnt['next_cnt'] > 0) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TradeView(
                                  article_seq: prev_article['article_seq'],
                                  table_nm: widget.table_nm,
                                  params: widget.params,
                                );
                              },
                            ));
                          }*/
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,size: 16,),
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
            width: 340 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xffE47421), )
              ),
            ),
          ),
          if(pnlist.length > 0)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 70 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
              // color: Colors.blue,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(prev_cnt['prev_cnt'] != null)
                      if(prev_cnt['prev_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 55 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '이전 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareR',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    for(var i=0; i<pnlist.length; i++)
                      Container(
                        child: Row(
                          children: [
                            if(prev_article['article_seq'] != '' && prev_article['article_seq'] != null)
                              if(prev_article['article_seq'] == pnlist[i]['article_seq'])
                                GestureDetector(
                                  onTap:() {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(
                                      // fullscreenDialog: true,
                                      builder: (context) {
                                        return TradeView(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], params: widget.params,checkList: widget.checkList,);
                                      },
                                    ));
                                  },
                                  child: Container(
                                    key : pre_article_key,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 165 * (MediaQuery.of(context).size.width / 360),
                                          height: 55 * (MediaQuery.of(context).size.height / 360),
                                          decoration: BoxDecoration(
                                            image: pnlist[i]['main_img'] != null && pnlist[i]['main_img'] != '' ? DecorationImage(
                                                image:  CachedNetworkImageProvider(urlpath+'${pnlist[i]['main_img_path']}${pnlist[i]['main_img']}'),
                                                fit: BoxFit.cover
                                            ) : DecorationImage(
                                                image: AssetImage('assets/noimage.png'),
                                                fit: BoxFit.cover
                                            ),
                                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                      0 , 0 ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff2F67D3),
                                                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      if(pnlist[i]['area_category'] != null && pnlist[i]['area_category'] != '' )
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Text(getCodename(pnlist[i]['area_category'], coderesult),
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
                                              Container(
                                                  margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                      6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child:Row(
                                                    children: [
                                                      if(pnlist[i]['like_yn'] != null && pnlist[i]['like_yn'] > 0)
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                        ),
                                                      if(pnlist[i]['like_yn'] == null || pnlist[i]['like_yn'] == 0)
                                                        Container(
                                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                          child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                        ),
                                                    ],
                                                  )
                                              )
                                            ],

                                          ),
                                        ),
                                        Container(
                                          width: 165 * (MediaQuery.of(context).size.width / 360),
                                          margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                          constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text(
                                            '${pnlist[i]['title']}',
                                            // '${pnlist[i]['article_seq']}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              // color: Colors.red,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'NanumSquareR',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            // if(prev_article['article_seq'] == null || prev_article['article_seq'] == '')
                            if(prev_article['article_seq'] != pnlist[i]['article_seq'])
                              GestureDetector(
                                onTap:() {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                    // fullscreenDialog: true,
                                    builder: (context) {
                                      return TradeView(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], params: widget.params, checkList: widget.checkList,);
                                    },
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 55 * (MediaQuery.of(context).size.height / 360),
                                        decoration: BoxDecoration(
                                          image: pnlist[i]['main_img'] != null && pnlist[i]['main_img'] != '' ? DecorationImage(
                                              image:  CachedNetworkImageProvider(urlpath+'${pnlist[i]['main_img_path']}${pnlist[i]['main_img']}'),
                                              fit: BoxFit.cover
                                          ) : DecorationImage(
                                              image: AssetImage('assets/noimage.png'),
                                              fit: BoxFit.cover
                                          ),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                    0 , 0 ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xff2F67D3),
                                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                ),
                                                child:Row(
                                                  children: [
                                                    if(pnlist[i]['area_category'] != null && pnlist[i]['area_category'] != '' )
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Text(getCodename(pnlist[i]['area_category'], coderesult),
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
                                            Container(
                                                margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                    6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                  shape: BoxShape.circle,
                                                ),
                                                child:Row(
                                                  children: [
                                                    if(pnlist[i]['like_yn'] != null && pnlist[i]['like_yn'] > 0)
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                      ),
                                                    if(pnlist[i]['like_yn'] == null || pnlist[i]['like_yn'] == 0)
                                                      Container(
                                                        padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                          4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                        child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                      ),
                                                  ],
                                                )
                                            )
                                          ],

                                        ),
                                      ),
                                      Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                        child: Text(
                                          '${pnlist[i]['title']}',
                                          // '${pnlist[i]['article_seq']}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NanumSquareR',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    if(next_cnt['next_cnt'] != null)
                      if(next_cnt['next_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 55 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '다음 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareR',
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
          if(pnlist.length == 0)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 70 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
              // color: Colors.blue,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(prev_cnt['prev_cnt'] != null)
                      if(prev_cnt['prev_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 55 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '이전 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareR',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    if(next_cnt['next_cnt'] != null)
                      if(next_cnt['next_cnt'] < 5)
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                          child: Column(
                            children: [
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                height: 55 * (MediaQuery.of(context).size.height / 360),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              Container(
                                width: 165 * (MediaQuery.of(context).size.width / 360),
                                margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                child: Text(
                                  '다음 게시글이 없습니다.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    // color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareR',
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
        ],
      ),
    );
  }

  Widget getConts(context) {
    return
      Column(
        children: [
          // if(viewresult['main_img_path'] != null && viewresult['main_img'] != null)
            Container(
              margin: EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
              child: ViewInfo_Photo_User(mainfile: '${viewresult['main_img']}', fileresult: fileresult, table_nm: widget.table_nm, code_nm: getSubcodename(viewresult['cat02']),apptitle : '${viewresult['title']}'),
            ),
            /*Container(
              margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : SingleChildScrollView (
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(fileresult.length > 0)
                      for(var f=0; f<fileresult.length; f++)
                    Container(
                      width: 330 * (MediaQuery.of(context).size.width / 360),
                      height: 100 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(urlpath+'/upload/'+widget.table_nm+'/${fileresult[f]["yyyy"]}/${fileresult[f]['mm']}/${fileresult[f]['uuid']}'),
                            // image: NetworkImage(''),
                            fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                  0 , 0 ),
                              decoration: BoxDecoration(
                                color: Color(0xff53B5BB),
                                borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child:Row(
                                children: [
                                  if(viewresult['cat02'] == 'D201')
                                    Container(
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 , 0 ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff53B5BB),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child:Row(
                                          children: [
                                            Container(
                                              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                              child: Text(
                                                '판매중',
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
                                  if(viewresult['cat02'] == 'D202')
                                    Container(
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 , 0 ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff925331),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child:Row(
                                          children: [
                                            Container(
                                              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
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
                              )
                          ),
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
                                      (f+1).toString() + '/' + fileresult.length.toString(),
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
                    )

                  ],
                ),

              ),

            ),*/
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            // height: 0 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(0, 0  * (MediaQuery.of(context).size.height / 360), 0, 0),
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  // height: 10 * (MediaQuery.of(context).size.height / 360),
                  child: Row(
                    children: [
                      Container(
                        width: 320 * (MediaQuery.of(context).size.width / 360),
                        child : Text(
                          getVND(viewresult['etc01']),
                          style: TextStyle(
                            fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff151515),
                            fontFamily: 'NanumSquareEB',
                            fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      //if(reg_id != null && reg_id != "")
                        Container(
                          width: 20 * (MediaQuery.of(context).size.width / 360),
                          height: 20 * (MediaQuery.of(context).size.height / 360),
                          child: PopupMenuButton(
                            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
                            iconSize : 55 * (MediaQuery.of(context).size.width / 360),
                            icon: Image(image: AssetImage("assets/more_vert.png"),color: Color(0xffC4CCD0), width : 60 * (MediaQuery.of(context).size.width / 360), height : 60 * (MediaQuery.of(context).size.height / 360)),
                            itemBuilder : (BuildContext context) => [
                              if(reg_id == viewresult["reg_id"] || adminChk == "Y")
                                PopupMenuItem(value : 'delete',
                                  child : GestureDetector(
                                    onTap : () {
                                      deleteDialog(context);
                                      /*showDialog(context : context,
                                                  builder : (BuildContext context) {
                                                    return deletealert(context);
                                                  }
                                              )*/
                                    },
                                    child: Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),
                                  ),
                                ),
                              if(reg_id == viewresult["reg_id"] || adminChk == "Y")
                                PopupMenuItem(value : 'Edit',
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return TradeModify(article_seq : widget.article_seq, table_nm : widget.table_nm);
                                          },
                                        ));
                                      },
                                      child: Text(
                                        "수정하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                      )
                                  ),
                                ),
                              if(reg_id != null && reg_id != "")
                                PopupMenuItem(value : 'Report',
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return Reportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: apptitle,board_seq: board_seq,);
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
                        )
                    ],
                  )
                ),
                Container(
                  margin : EdgeInsets.fromLTRB(0, 1  * (MediaQuery.of(context).size.height / 360), 0, 5),
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  // height: 15 * (MediaQuery.of(context).size.height / 360),
                  child: Text(
                    '${viewresult['title']}',
                    style: TextStyle(
                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                      color: Color(0xff4E4E4E),
                      fontFamily: 'NanumSquareR',
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      height: 1.4 * (MediaQuery.of(context).size.width / 360),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child : Row(
                    children: [
                      /*GestureDetector(
                        onTap : () {

                        },
                        child : Image(
                          image: AssetImage("assets/service_guide.png"),
                          width: 100 * (MediaQuery.of(context).size.width / 360),
                        )
                      ),
                      Container(
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                      ),*/
                      Container(
                        width: 240 * (MediaQuery.of(context).size.width / 360),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(reg_id != null && reg_id != "") {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ModifyInfomation(article_seq: widget.article_seq,table_nm: widget.table_nm,article_title: apptitle,board_seq: board_seq,);
                              },
                            ));
                          }

                          if(reg_id == null || reg_id == "") {
                            showModal(context, 'loginalert', '');
                          }
                        },
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage("assets/report_icon3.png"),
                              color: Color(0xffEB5757),
                              width: 15 * (MediaQuery.of(context).size.width / 360),
                            ),
                            Text(" 정보 수정 요청",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  )
                ),
              ],
            ),
          ),


          // 하단 컨텐츠
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),

            // width: 100 * (MediaQuery.of(context).size.width / 360),
            // height: 100 * (MediaQuery.of(context).size.width / 360),
            child:Row(
              children: [
                Container(
                  height: 25 * (MediaQuery.of(context).size.width / 360),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                    ),
                  ),
                ),
                Container(
                  width : 220 * (MediaQuery.of(context).size.width / 360),
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360)),
                  child:
                  Text('상품 내용',
                    style: TextStyle(
                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                      fontFamily: 'NanumSquareEB',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if(reg_id == viewresult["reg_id"] && (viewresult["cat02"] == "D201" || viewresult["cat02"] == "D203"))
                GestureDetector(
                  onTap: () {
                    cat02Update(context, viewresult["cat02"] == 'D201' ? 'D202' : viewresult["cat02"] == 'D203' ? 'D204' : '');
                  },
                  child : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        //width : 25 * (MediaQuery.of(context).size.width / 360),
                          padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                              7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child : Text("${viewresult["cat02"] == 'D203' ? '구매완료로 변경' : viewresult["cat02"] == 'D201' ? '판매완료로 변경' : '' }", style: TextStyle(color: Color(0xffFFFFFF), fontFamily: "NanumSquareR", fontWeight: FontWeight.w800, fontSize: 12 * (MediaQuery.of(context).size.width / 360)),)
                      )
                    ],
                  )
                )
              ],
            ),
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xffE47421), )
              ),
            ),
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 *(MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 15 *(MediaQuery.of(context).size.height / 360)),
                  child: Text(viewresult['conts'],
                    style: TextStyle(
                    fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                    // fontWeight: FontWeight.bold,
                  ),) ,
                  /*child: Html(
                    data: viewresult['conts'],
                  ) ,*/
                  /*Text(
                    viewresult['conts'],
                    style: TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      // fontWeight: FontWeight.bold,
                    ),
                  ),*/
                ),

              ],
            ),
          ),
          Container(
            width : 350 * (MediaQuery.of(context).size.width / 360),
            height : 15 * (MediaQuery.of(context).size.height / 360),
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        height: 25 * (MediaQuery.of(context).size.width / 360),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
                        width : 120 * (MediaQuery.of(context).size.width / 360),
                        child: Text("댓글", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'NanumSquareEB',),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color:  Color(0xffE47421), )
              ),
            ),
          ),
          if(listresult.length > 0)
            for(int i = 0; i < listresult.length; i++)
              if(listresult[i]['list']['lv'] == '1')
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 300 * (MediaQuery.of(context).size.width / 360),
                                        key: _formKeys["key_${listresult[i]["list"]["comment_seq"]}"],
                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        child: Row(
                                          children: [
                                            Text("${listresult[i]["list"]["reg_nm"]} ", style: TextStyle(color: Color(0xff2F67D3), fontSize : 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w700),),
                                            Icon(My_icons.rate,
                                              color: listresult[i]["list"]['group_seq'] == '4' ? Color(0xff27AE60) :
                                              listresult[i]["list"]['group_seq'] == '5' ? Color(0xff27AE60) :
                                              listresult[i]["list"]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                              listresult[i]["list"]['group_seq'] == '7' ? Color(0xffE47421) :
                                              listresult[i]["list"]['group_seq'] == '10' ? Color(0xffE47421) :
                                              Color(0xff27AE60),
                                              size: 12 * (MediaQuery.of(context).size.width / 360),),
                                            /*if(listresult[i]['list']['rating_cnt'] != null)
                                              Container(
                                                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                                                //width: 330 * (MediaQuery.of(context).size.width / 360),
                                                //height: 10 * (MediaQuery.of(context).size.height / 360),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "   후기",
                                                        style: TextStyle(
                                                          fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                          color: Color(0xff000000),
                                                          overflow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    if(listresult[i]['list']['rating_cnt'] != null)
                                                      Container(
                                                        margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                                        child: Text(
                                                          listresult[i]['list']['rating_cnt'] != null ? '${listresult[i]['list']['rating_cnt'].toDouble()}' : '',
                                                          style: TextStyle(
                                                            fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                            color: Color(0xff4E4E4E),
                                                            overflow: TextOverflow.ellipsis,
                                                            fontWeight: FontWeight.w400,
                                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                          ),
                                                        ),
                                                      ),
                                                    if(listresult[i]['list']['rating_cnt'] != null)
                                                      Container(
                                                        margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RatingBarIndicator(
                                                              unratedColor: Color(0xffC4CCD0),
                                                              rating: listresult[i]['list']['rating_cnt'] != null ? listresult[i]['list']['rating_cnt'].toDouble() : 0,
                                                              itemBuilder: (context, index) => Icon(
                                                                Icons.star,
                                                                color: Colors.amber,
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 20.0,
                                                              direction: Axis.horizontal,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),*/
                                          ],
                                        ),
                                      ),
                                      /*if(reg_id != null && reg_id != "")
                                        if(reg_id == listresult[i]["list"]["reg_id"] || adminChk == "Y")*/
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
                                                if(reg_id == listresult[i]["list"]["reg_id"] || adminChk == "Y")
                                                  PopupMenuItem(value : 'delete',
                                                    child : GestureDetector(
                                                      onTap : () async {
                                                        Navigator.pop(context);
                                                        deletecomment(listresult[i]["list"]["comment_seq"]);
                                                      },
                                                      child: Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),
                                                    ),
                                                  ),
                                                if(reg_id == listresult[i]["list"]["reg_id"] || adminChk == "Y")
                                                  PopupMenuItem(value : 'Edit',
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) {
                                                              return CommentModify(article_seq: widget.article_seq, comment_seq: listresult[i]["list"]["comment_seq"], table_nm: widget.table_nm, main_catcode: viewresult["main_catcode"]);
                                                            },
                                                          ));
                                                        },
                                                        child: Text(
                                                          "수정하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                                        )
                                                    ),
                                                  ),
                                                 if(reg_id != null && reg_id != "")
                                                PopupMenuItem(value : 'Report',
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) {
                                                                return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${listresult[i]["list"]["conts"]}",board_seq: board_seq, comment_seq: listresult[i]["list"]["comment_seq"],);
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
                                if(listresult[i]['files'].length > 0)
                                Container(
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360) ),

                                  child: SingleChildScrollView (
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        if(listresult[i]['files'].length > 0)
                                          for(var f = 0; f < listresult[i]['files'].length; f++)
                                            GestureDetector(
                                              onTap: (){
                                                showDialog(context: context,
                                                    barrierDismissible: false,
                                                    barrierColor: Colors.black,
                                                    builder: (BuildContext context) {
                                                      return PhotoAlbum_User(apptitle: '${listresult[i]['list']['conts']}',fileresult: listresult[i]['files'], table_nm: widget.table_nm,);
                                                    }
                                                );
                                              },
                                              child: Container(
                                                width: 325 * (MediaQuery.of(context).size.width / 360),
                                                margin : EdgeInsets.fromLTRB(f == 0 ? 0 : 5 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: CachedNetworkImageProvider('http://www.hoty.company/upload/'+widget.table_nm+'/${listresult[i]['files'][f]["yyyy"]}/${listresult[i]['files'][f]['mm']}/${listresult[i]['files'][f]['uuid']}'),
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
                                                                (f+1).toString() + '/' + listresult[i]['files'].length.toString(),
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
                                          if(listresult[i]["list"]["parent_nm"] != null)
                                            TextSpan(text : "@${listresult[i]["list"]["parent_nm"]} ", style: TextStyle(color: Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),),
                                          TextSpan(text : "${listresult[i]["list"]["conts"]}",
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
                                                Text("${listresult[i]["list"]["reg_dt"]}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
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
                                                    _isclose().then((value) {
                                                      if(write_bar1 == false && write_bar2 == false) {
                                                        top_alignment = 0.42;
                                                      } else {
                                                        top_alignment = 0.03;
                                                      }

                                                      if (listresult[i]["list"]["visible2"] == false) {
                                                        // top_alignment = 0.3;
                                                        listresult[i]["list"]["visible2"] = true;
                                                        write_bar1 = false;
                                                        write_bar2 = false;

                                                      } else {
                                                        listresult[i]["list"]["visible2"] = false;
                                                        write_bar1 = true;
                                                        write_bar2 = false;
                                                      }


                                                      _recommentController.text = "";
                                                      if(value == true) {
                                                        setState(() {
                                                          print('@@@@@@@@@@@@@@@@@@@@@@@@@@>>>');
                                                          print(top_alignment);
                                                          Scrollable.ensureVisible(
                                                            // titlecat_key!.currentContext!,
                                                              _formKeys["key_${listresult[i]["list"]["comment_seq"]}"]!.currentContext!,
                                                              alignment : top_alignment
                                                          );
                                                        });
                                                      }
                                                    });
                                                    setState(() {
                                                      print('@@@@@@@@@@@@@@@@@@@@@@@@@@>>>');
                                                      print(top_alignment);
                                                      Scrollable.ensureVisible(
                                                        // titlecat_key!.currentContext!,
                                                          _formKeys["key_${listresult[i]["list"]["comment_seq"]}"]!.currentContext!,
                                                          alignment : top_alignment
                                                      );
                                                    });

                                                    // print('2222222222222222');


                                                  }
                                                },
                                                child : Container(
                                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                        12 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                                                      return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${listresult[i]["list"]["conts"]}",board_seq: board_seq, comment_seq: listresult[i]["list"]["comment_seq"],);
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
                                  visible: listresult[i]['list']['visible2'],
                                  child: Container(
                                      width : 360 * (MediaQuery.of(context).size.width / 360),
                                      height : listresult[i]["list"]["_pickedImgs"].length <= 0 ? 62 * (MediaQuery.of(context).size.height / 360) : 92 * (MediaQuery.of(context).size.height / 360),
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
                                          if(listresult[i]["list"]["_pickedImgs"].length > 0)
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
                                                                image: DecorationImage(fit: BoxFit.cover,image: FileImage(File("${listresult[i]["list"]["_pickedImgs"][0].path}")))
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
                                                                    listresult[i]["list"]["_pickedImgs"] = [];
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
                                                      if(listresult[i]["list"]["visible2"] == false) {
                                                        listresult[i]["list"]["visible2"] = true;
                                                        write_bar1 = false;
                                                        write_bar2 = false;
                                                      } else {
                                                        listresult[i]["list"]["visible2"] = false;
                                                        write_bar1 = true;
                                                        write_bar2 = false;
                                                      }
                                                      _recommentController.text = "";
                                                      setState(() {

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
                                                        if(listresult[i]["list"]["write"] == false) {
                                                          if(_recommentController.text != null && _recommentController.text != '') {
                                                            FlutterDialog2(context, '', listresult[i]["list"]["comment_seq"], listresult[i]["list"]["comment_seq"], i);
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
                                                        // print("클릭 AA : ${listresult[i]["list"]["head_seq"]}");
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
                        for(var j = 0; j < listresult.length; j++)
                          if(listresult[j]["list"]["lv"] == "2" && (listresult[i]["list"]["comment_seq"] == listresult[j]["list"]["parent_seq"]))
                            Container(
                                margin : EdgeInsets.fromLTRB(55 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
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
                                            key: _formKeys["key_${listresult[j]["list"]["comment_seq"]}"],
                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                            child: Row(
                                              children: [
                                                Text("${listresult[j]["list"]["reg_nm"]} ", style: TextStyle(color: Color(0xff151515), fontSize : 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w700),),
                                                Icon(My_icons.rate,
                                                  color: listresult[j]["list"]['group_seq'] == '4' ? Color(0xff27AE60) :
                                                  listresult[j]["list"]['group_seq'] == '5' ? Color(0xff27AE60) :
                                                  listresult[j]["list"]['group_seq'] == '6' ? Color(0xffFBCD58) :
                                                  listresult[j]["list"]['group_seq'] == '7' ? Color(0xffE47421) :
                                                  listresult[j]["list"]['group_seq'] == '10' ? Color(0xffE47421) :
                                                  Color(0xff27AE60),
                                                  size: 12 * (MediaQuery.of(context).size.width / 360),),
                                              ],
                                            ),
                                          ),
                                          /*if(reg_id != null && reg_id != "")
                                            if(reg_id == listresult[j]["list"]["reg_id"] || adminChk == "Y")*/
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
                                                    if(reg_id == listresult[j]["list"]["reg_id"] || adminChk == "Y")
                                                      PopupMenuItem(value : 'delete',
                                                        child : GestureDetector(
                                                          onTap : () async {
                                                            Navigator.pop(context);
                                                            deletecomment(listresult[j]["list"]["comment_seq"]);
                                                          },
                                                          child: Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),
                                                        ),
                                                      ),
                                                    if(reg_id == listresult[j]["list"]["reg_id"] || adminChk == "Y")
                                                      PopupMenuItem(value : 'Edit',
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                              Navigator.push(context, MaterialPageRoute(
                                                                builder: (context) {
                                                                  return CommentModify(article_seq: widget.article_seq, comment_seq: listresult[j]["list"]["comment_seq"], table_nm: widget.table_nm, main_catcode: viewresult["main_catcode"]);
                                                                },
                                                              ));
                                                            },
                                                            child: Text(
                                                              "수정하기", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w400, fontSize: 16),
                                                            )
                                                        ),
                                                      ),
                                                    if(reg_id != null && reg_id != "")
                                                    PopupMenuItem(value : 'Report',
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context) {
                                                                    return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${listresult[j]["list"]["conts"]}",board_seq: board_seq, comment_seq: listresult[j]["list"]["comment_seq"],);
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
                                    if(listresult[j]['files'].length > 0)
                                    Container(
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360) ),

                                      child: SingleChildScrollView (
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            if(listresult[j]['files'].length > 0)
                                              for(var f = 0; f < listresult[j]['files'].length; f++)
                                                GestureDetector(
                                                  onTap: (){
                                                    showDialog(context: context,
                                                        barrierDismissible: false,
                                                        barrierColor: Colors.black,
                                                        builder: (BuildContext context) {
                                                          return PhotoAlbum_User(apptitle: '${listresult[j]['list']['conts']}',fileresult: listresult[j]['files'], table_nm: widget.table_nm,);
                                                        }
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 290 * (MediaQuery.of(context).size.width / 360),
                                                    margin : EdgeInsets.fromLTRB(f == 0 ? 0 : 5 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider('http://www.hoty.company/upload/'+widget.table_nm+'/${listresult[j]['files'][f]["yyyy"]}/${listresult[j]['files'][f]['mm']}/${listresult[j]['files'][f]['uuid']}'),
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
                                                                    (f+1).toString() + '/' + listresult[j]['files'].length.toString(),
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
                                                if(listresult[j]["list"]["parent_nm"] != null)
                                                  TextSpan(text : "@${listresult[j]["list"]["parent_nm"]} ", style: TextStyle(color: Color(0xffE47421), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),),
                                                TextSpan(text : "${listresult[j]["list"]["conts"]}",
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
                                                width : 145 * (MediaQuery.of(context).size.width / 360),
                                                child : Row(
                                                  children: [
                                                    Text("${listresult[j]["list"]["reg_dt"]}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
                                                  ],
                                                )
                                            ),
                                            Container(
                                              width : 145 * (MediaQuery.of(context).size.width / 360),
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
                                                        _isclose().then((value) {
                                                          if (write_bar1 == false &&
                                                              write_bar2 == false) {
                                                            top_alignment = 0.42;
                                                          } else {
                                                            top_alignment = 0.03;
                                                          }

                                                          if (listresult[j]["list"]["visible1"] ==
                                                              false) {
                                                            // top_alignment = 0.3;
                                                            listresult[j]["list"]["visible1"] =
                                                            true;
                                                            write_bar1 = false;
                                                            write_bar2 = false;
                                                          } else {
                                                            listresult[j]["list"]["visible1"] =
                                                            false;
                                                            write_bar1 = true;
                                                            write_bar2 = false;
                                                          }

                                                          _recommentController.text =
                                                          "";
                                                          if (value == true) {
                                                            setState(() {
                                                              print(
                                                                  '@@@@@@@@@@@@@@@@@@@@@@@@@@>>>');
                                                              print(top_alignment);
                                                              Scrollable.ensureVisible(
                                                                // titlecat_key!.currentContext!,
                                                                  _formKeys["key_${listresult[j]["list"]["comment_seq"]}"]!
                                                                      .currentContext!,
                                                                  alignment: top_alignment
                                                              );
                                                            });
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child : Container(
                                                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                            12 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                                                          return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${listresult[j]["list"]["conts"]}",board_seq: board_seq, comment_seq: listresult[j]["list"]["comment_seq"],);
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
                                      visible: listresult[j]['list']['visible1'],
                                      child: Container(
                                          width : 300 * (MediaQuery.of(context).size.width / 360),
                                          height : listresult[j]["list"]["_pickedImgs"].length <= 0 ? 62 * (MediaQuery.of(context).size.height / 360) : 92 * (MediaQuery.of(context).size.height / 360) ,
                                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xffF3F6F8)
                                            ),
                                            borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                          ),
                                          child : Column(
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
                                              if(listresult[j]["list"]["_pickedImgs"].length > 0)
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
                                                                    image: DecorationImage(fit: BoxFit.cover,image: FileImage(File("${listresult[j]["list"]["_pickedImgs"][0].path}")))
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
                                                                        listresult[j]["list"]["_pickedImgs"] = [];
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
                                                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
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
                                                          if(listresult[j]["list"]["visible1"] == false) {
                                                            listresult[j]["list"]["visible1"] = true;
                                                          } else {
                                                            write_bar1 = true;
                                                            listresult[j]["list"]["visible1"] = false;

                                                          }
                                                          _recommentController.text = "";
                                                          setState(() {

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
                                                            if(listresult[j]["list"]["write"] == false) {
                                                              if(_recommentController.text != null && _recommentController.text != '') {
                                                                FlutterDialog2(context, '', listresult[j]["list"]["parent_seq"] ?? listresult[j]["list"]["comment_seq"], listresult[j]["list"]["comment_seq"], j);
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
                                                            // print("클릭");
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

          Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: write_bar1 == true ? 50 * (MediaQuery.of(context).size.height / 360) : write_bar2 == true && _pickedImgs.length > 0 ? 122 * (MediaQuery.of(context).size.height / 360) : write_bar2 == true && _pickedImgs.length <= 0 ? 92 * (MediaQuery.of(context).size.height / 360) : 0,
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
                                  /*RatingBar.builder(
                                    glow: false,
                                    initialRating: 0,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 25 * (MediaQuery.of(context).size.width / 360),
                                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      rating_cnt = rating.toInt();
                                    },
                                  ),*/
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
                                      rating_cnt = 0;
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
          Container(
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360) , 10 * (MediaQuery.of(context).size.height / 360) ),
              width : 100 * (MediaQuery.of(context).size.width / 360),
              child : GestureDetector(
                  onTap:() {
                    if(reg_id != null && reg_id != "") {
                      Navigator.push(context, MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          /*return AlertDialog(
                            content: Cm_Filter(subtitle: 'USED_TRNSC',),
                          );*/
                          return Reportwrite(article_title: apptitle,
                              article_seq: widget.article_seq,
                              table_nm: widget.table_nm,
                              board_seq: viewresult['board_seq']);
                        },
                      ));
                    }
                    if(reg_id == null || reg_id == "") {
                      showModal(context, 'loginalert', '');
                    }
                  },
                  child : Image(image : AssetImage("assets/report_icon.png"), height : 15 * (MediaQuery.of(context).size.height / 360),)

              ),
          ),

          Container(
              decoration : BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                  )
              )
          ),

          if(viewresult.length > 0 )
          // prenextview, // 미리보기
            getPreNext(context),

          Follow_us(),

          Container(
            margin: EdgeInsets.fromLTRB(
              0 * (MediaQuery.of(context).size.width / 360),
              40 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
            ),
          ),
        ],
      );
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
            "관심등록 성공! 관심내역은 마이페이지에서 확인 가능합니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);

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
            "관심등록을 취소했습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);

          },
        ),
      ],
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


  Future<void> deleteDialog(BuildContext context) async{
    showDialog(
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: deletecheck(context,),
        );
      },
    ).then((value) {
      if(value == true) {
        delete().then((value) {
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
              Navigator.pop(context);
              Navigator.pop(context);
              print("CCC : ${widget.params}");
              if(widget.params["history_dart"] == "myPost") {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    //return TradeList(checkList : []);
                    return Profile_my_post(table_nm : 'USED_TRNSC', category: 'USED_TRNSC',);
                  },
                ));
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return TradeList(checkList : []);
                    //return Profile_my_post(table_nm : 'USED_TRNSC', category: 'USED_TRNSC',);
                  },
                ));
              }
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
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return TradeList(checkList : []);
              },
            ));
          },
        ),
      ],
    );
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

  void _onShare(BuildContext context, text, link) async {
    final box = context.findRenderObject() as RenderBox?;

    // subject is optional but it will be used
    // only when sharing content over email
    await Share.share(text,
        subject: link,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
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
          "board_seq" : "15",
          "rating_cnt" : rating_cnt,
          "article_seq" : widget.article_seq,
          "cms_menu_seq" : cms_menu_seq.toString(),
          "session_ip" : data["ip"].toString(),
          "session_member_id" : reg_id,
          "session_member_nm" : reg_nm,
          "table_nm" : "USED_TRNSC",
          "head_seq" : 0,
          "parent_seq": 0 ,
          "state" : 'C',
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

      listresult.clear();
      cpage = 1;
      getlistdata().then((_) {

        setState(() {
          _generateFormKeys(listresult);
          saved = false;
          _commentController.text = "";
          rating_cnt = 0;
          FocusManager.instance.primaryFocus?.unfocus();
          write_bar2 = false;
          write_bar1 = true;
          _pickedImgs.removeLast();
        });
      });
      //});
    }
  }

  Future<void> FlutterDialog2(context, head_seq, parent_seq, parent_nm_seq, index) async {

    listresult[index]["list"]["write"] = true;
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

    if(listresult[index]["list"]["_pickedImgs"] != null && listresult[index]["list"]["_pickedImgs"].length > 0) {
      List<XFile> files = listresult[index]["list"]["_pickedImgs"];

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
            "board_seq": "15",
            "article_seq": widget.article_seq,
            "cms_menu_seq": cms_menu_seq.toString(),
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "USED_TRNSC",
            "head_seq": head_seq == 0 || head_seq == null || head_seq == '' ? null : head_seq,
            "parent_seq": parent_seq == 0 || parent_seq == null || parent_seq == '' ? 0 : parent_seq,
            "state": "C",
            "parent_nm_seq": parent_nm_seq == 0 || parent_nm_seq == null || parent_nm_seq == '' ? 0 : parent_nm_seq
          }
      );
    } else {
      _formData = FormData.fromMap(
          {
            "conts": _recommentController.text,
            "board_seq": "15",
            "article_seq": widget.article_seq,
            "cms_menu_seq": cms_menu_seq.toString(),
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "USED_TRNSC",
            "head_seq": head_seq == 0 || head_seq == null || head_seq == '' ? null : head_seq,
            "parent_seq": parent_seq == 0 || parent_seq == null || parent_seq == '' ? 0 : parent_seq,
            "state": "C",
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
      //_commentController.text = "";
      listresult.clear();
      cpage = 1;
      write_bar1 = true;
      getlistdata().then((_) {
        _generateFormKeys(listresult);

        setState(() {

        });
      });
      //});
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
        "table_nm" : "USED_TRNSC",
        "main_category" : viewresult["main_category"],
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
        getlistdata();
        setState(() {

        });
      }

      return json.decode(response.body)['result'];

    }
    catch(e){
      print(e);
    }
  }

  Future<void> cat02Update(context, cat02) async {

    final List<MultipartFile> _files =
    _pickedImgs.map(
            (img) => MultipartFile.fromFileSync(img.path,  contentType: new MediaType("image", "jpg"))
    ).toList();

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    // Create storage
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    FormData _formData = FormData.fromMap(
        {
          "title": viewresult["title"],
          "conts" : viewresult["conts"],
          "etc01" : viewresult["etc01"],
          "main_category" : viewresult["main_category"],
          "cat02" : cat02,
          "board_seq" : "15",
          "session_ip" : data["ip"].toString(),
          "session_member_id" : reg_id,
          "session_member_nm" : reg_nm,
          "table_nm" : "USED_TRNSC",
          "article_seq" : viewresult["article_seq"]
        }
    );

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/community/modify.do", data: _formData).then((res) {
      /*print("작성결과 ##############################################");
      print(res);*/
      return res.data;
    });

    /*Future initWrite(rst) async {
      writeApi_result = await mainCategoryProvider.writeApi(rst);
    }*/
    /* print("####################################### 작성결과 ##############################################");
    print(res);
    print(res["result"]);
    print(res["resultstatus"]);
    print(res["errorcode"]);*/
    if(res["result"] != null && res["resultstatus"] == "N") {
      showDialog(
          context: context,
          barrierColor: Color(0xffE47421).withOpacity(0.4),
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: false,
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: textalert2(context, "수정이 완료되었습니다."),
            );
          }).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return TradeList(checkList: [],);
          },
        ));
      });
    } else {
      showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: false,
          barrierColor: Color(0xffE47421).withOpacity(0.4),
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: textalert(context, "수정중 오류가 발생했습니다."),
            );
          });
    }
  }
}