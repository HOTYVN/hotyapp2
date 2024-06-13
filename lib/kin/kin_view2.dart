import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:emoji_keyboard_flutter/emoji_keyboard_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/Report/commentreport_write.dart';
import 'package:hoty/community/Report/report_write.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_modify.dart';
import 'package:hoty/kin/kin_coment_modify.dart';
import 'package:hoty/kin/kin_coment_modify2.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import "package:back_button_interceptor/back_button_interceptor.dart";
import 'package:share_plus/share_plus.dart';

import '../../common/dialog/loginAlert.dart';
import '../../common/dialog/showDialog_modal.dart';
import '../../common/icons/my_icons.dart';
import '../../common/js/common_js.dart';
import '../../common/photo/photo_album_user.dart';
import '../../login/login.dart';
import '../community/device_id.dart';
import 'kinlist.dart';

class KinView2 extends StatefulWidget {
  final int article_seq;
  final dynamic table_nm;
  final dynamic main_catcode;
  final Map params;


  const KinView2({Key? key,
    required this.article_seq,
    required this.table_nm,
    required this.main_catcode,
    required this.params,
  }) : super(key:key);
  @override
  State<KinView2> createState() => _KinView2State();
}

class _KinView2State extends State<KinView2> {

  List<dynamic> coderesult = []; // 공통코드 리스트
  List<dynamic> cattitle = []; // 카테고리타이틀
  Map<String, dynamic> getresult = {};
  Map result = {};
  List<dynamic> filelist = [];
  List<dynamic> catname = []; // 세부카테고리
  List<dynamic> commentlist = [];
  List<dynamic> commentfilelist = [];
  List<dynamic> visiable1 = [];
  List<dynamic> visiable2 = [];

  bool write_bar1 = true;
  bool write_bar2 = false;

  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickermodify = ImagePicker();
  List<XFile> _pickedImgs = [];
  List<XFile> _pickedmodifyImgs = [];

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

  Future<void> _pickmodifyImg() async {
    final List<XFile>? images = await _pickermodify.pickMultiImage();
    if(images != null) {
      setState(() {
        _pickedmodifyImgs = images;
      });
    }
    if(images == null) {
      setState(() {
        _pickedmodifyImgs = [];
      });
    }
  }

  bool _visibility1 = true;
  bool _visibility2 = false;

  final _commentController = TextEditingController();
  final _recommentController = TextEditingController();
  final _modifycommentcontroller = TextEditingController();
  final _initComnmentcontroller = TextEditingController(text: "");

  var _sortvalue = ""; // sort
  var keyword = ""; // search
  var condition = "TITLE";

  var totalpage = 0;
  var totalcount = 0;
  var cpage = 1;
  var rows = 10;
  var board_seq = 10;
  var article_seq = 167;
  var cms_menu_seq = 22;
  var reg_id = "";
  var subtitle = "KIN";
  var adminChk = "";
  String apptitle = "";

  int _current = 0;


  final CarouselController _controller = CarouselController();

  Future<dynamic> getviewdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/community/view.do',
      /*'http://www.hoty.company/mf/community/view.do',*/
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
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
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

  Future<dynamic> getcommentdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/comment/list.do',
      //'http://www.hoty.company/mf/comment/list.do',
      /*'http://www.hoty.company/mf/comment/list.do',*/
      // 'http://192.168.0.109/mf/comment/list.do',
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
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
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
        for(int i=0; i<json.decode(response.body)['result'].length; i++){
          commentlist.add(json.decode(response.body)['result'][i]);
        }

        for(int i=0; i<commentlist.length; i++){
          commentlist[i]["list"]["visible1"] = false as bool;
          commentlist[i]["list"]["visible2"] = false as bool;
          commentlist[i]["list"]["_pickedImgs"] = [];
          commentlist[i]["list"]["write"] = false;
        }

        Map paging = json.decode(response.body)['pagination'];
        print(json.decode(response.body)['pagination']);
        //totalpage = paging['totalpage']; // totalpage
        //totalcount = paging['totalcount']; // totalcount



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

  bool showEmojiKeyboard = false;

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    adminChk = (await storage.read(key:'memberAdminChk')) ?? "";
    print("#############################################");
    print(reg_id);
  }

  var longurl = "";
  var url1 = "https://hotyapp.page.link/?link=https://hotyapp.page.link?";
  var url2 = "type=view@@table_nm=DAILY_TALK@@article_seq=";
  var url3 = "&apn=com.hotyvn.hoty";
  var shorturl = "";

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

  final GlobalKey pre_article_key = GlobalKey();
  final GlobalKey title_key = GlobalKey();
  Map prev_cnt = {};
  Map next_cnt = {};
  Map prev_article = {};
  // var Baseurl = "http://192.168.0.109/mf";
  var Baseurl = "http://www.hoty.company/mf";
  Map next_article = {};
  List<dynamic> pnlist = [];
  List<dynamic> checklist = [];
  var urlpath = 'http://www.hoty.company';


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
    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : widget.table_nm,
        "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
        "sort_nm" : widget.params['sort_nm'].toString(),
        "keyword" : widget.params['keyword'].toString(),
        "condition" : widget.params['condition'].toString(),
        "board_seq": board_seq.toString(),
        "main_category" : widget.main_catcode,

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
  // GlobalKey를 저장할 리스트 선언
  final Map<String, GlobalKey<FormState>> _formKeys = {

  };

// 폼 키를 생성하고 리스트에 추가하는 함수
  void _generateFormKeys(dynamic list) {
    for (int i = 0; i < list.length; i++) {
      _formKeys["key_${list[i]["list"]["comment_seq"]}"] = GlobalKey<FormState>();
    }
  }

  Future<bool> _isclose() async {
    bool isclose = false;

    for(var a = 0; a < commentlist.length; a++) {
      commentlist[a]["list"]["visible1"] = false;
      commentlist[a]["list"]["visible2"] = false;
    }

    isclose = true;


    return isclose;
  }

  @override
  void initState() {
    _asyncMethod();
    showEmojiKeyboard = false;
    BackButtonInterceptor.add(myInterceptor);
    print("adminchk");
    print(adminChk);
    super.initState();


    getviewdata().then((_) {
      getcodedata().then((_) {
        getpnlistdata().then((_) {
          getcommentdata().then((_) {
            setState(() {
              _generateFormKeys(commentlist);
              if(pnlist.length > 0) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Scrollable.ensureVisible(
                    pre_article_key.currentContext!,
                  );
                });
              }
              /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Scrollable.ensureVisible(
                  title_key.currentContext!,
                );
              });*/
            });
          });
        });
      });
    });



  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (showEmojiKeyboard) {
      setState(() {
        showEmojiKeyboard = false;
      });
      return true;
    } else {
      return false;
    }
  }

  void onTapEmojiField() {
    if (!showEmojiKeyboard) {
      setState(() {
        showEmojiKeyboard = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () {
       /* FocusManager.instance.primaryFocus?.unfocus();
        for(var i = 0; i <commentlist.length; i++) {
          commentlist[i]["list"]["visible1"] = false;
          commentlist[i]["list"]["visible2"] = false;
        }
        write_bar1 = true;
        write_bar2 = false;
        _recommentController.text = '';
        _commentController.text = '';
        setState(() {
          showEmojiKeyboard = false;
        });*/
      },
      child : Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: Container(
            // margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 26 * (MediaQuery.of(context).size.width / 360),
              color: Colors.black,
              // alignment: Alignment.centerLeft,
              // padding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    height: 16 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: kincat(context),
                    ),

                  ),
                  if(result.length > 0 )
                    Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child : Row(
                          children: [
                            Container(
                              width: 300 * (MediaQuery.of(context).size.width / 360),
                              child : Text("${result["title"]}", style: TextStyle(
                                  fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              width: 20 * (MediaQuery.of(context).size.width / 360),
                              child: PopupMenuButton(
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
                                iconSize : 55 * (MediaQuery.of(context).size.width / 360),
                                icon: Image(image: AssetImage("assets/more_vert.png"),color: Color(0xffC4CCD0), width : 60 * (MediaQuery.of(context).size.width / 360), height : 60 * (MediaQuery.of(context).size.height / 360)),
                                itemBuilder : (BuildContext context) => [
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
                        ),
                    ),
                  if(result.length > 0 )
                    Container(
                        //key: title_key,
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child : Row(
                          children: [
                            Container(
                              width: 300 * (MediaQuery.of(context).size.width / 360),
                              child : Row(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        6 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    //color: Colors.cyan,
                                    child: Text("${result['reg_nm']}", style: TextStyle(fontSize:13 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3), fontWeight: FontWeight.w700),),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child: Row(
                                      children: [
                                        Icon(My_icons.rate,
                                          color: result['group_seq'] == '4' ? Color(0xff27AE60) :
                                          result['group_seq'] == '5' ? Color(0xff27AE60) :
                                          result['group_seq'] == '6' ? Color(0xffFBCD58) :
                                          result['group_seq'] == '7' ? Color(0xffE47421) :
                                          result['group_seq'] == '10' ? Color(0xffE47421)
                                              : Color(0xff27AE60),
                                          size: 14 * (MediaQuery.of(context).size.width / 360),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        )
                    ),
                  if(result.length > 0 )
                    Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("${result["reg_dt"]}", style: TextStyle(color: Color.fromRGBO(196, 204, 208, 1), fontSize: 6 * (MediaQuery.of(context).size.height / 360))),
                          ),
                          Text("  ·  ", style: TextStyle(color: Color.fromRGBO(196, 204, 208, 1), fontSize: 6 * (MediaQuery.of(context).size.height / 360))),
                          Text("자주하는질문", style: TextStyle(color: Color.fromRGBO(196, 204, 208, 1), fontSize: 6 * (MediaQuery.of(context).size.height / 360))),
                          Container(
                            width: 1 * (MediaQuery.of(context).size.width / 360),
                            height : 8 * (MediaQuery.of(context).size.height / 360) ,
                            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffF3F6F8)
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              color: Color(0xffF3F6F8),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  child:Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 * (MediaQuery.of(context).size.width / 360) , ),
                                ),
                                Container(
                                  padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child:
                                  Text(
                                    "${result["like_cnt"]}",
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
                          Container(
                            width: 1 * (MediaQuery.of(context).size.width / 360),
                            height : 8 * (MediaQuery.of(context).size.height / 360) ,
                            margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffF3F6F8)
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              color: Color(0xffF3F6F8),
                            ),
                          ),
                          Container(
                            //width: 100 * (MediaQuery.of(context).size.width / 360),
                            margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Row(
                              children: [
                                Container(
                                  child:Image(image: AssetImage('assets/view_icon.png'), width: 15 * (MediaQuery.of(context).size.width / 360), color: Color(0xff925331),),
                                ),
                                Container(
                                  padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child:
                                  Text(
                                    "${result["view_cnt"]}",
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
                          Container(
                            width: 1 * (MediaQuery.of(context).size.width / 360),
                            height : 8 * (MediaQuery.of(context).size.height / 360) ,
                            margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffF3F6F8)
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              color: Color(0xffF3F6F8),
                            ),
                          ),
                          Container(
                            margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Row(
                              children: [
                                Container(
                                  child:Image(image: AssetImage('assets/comment_icon.png'), width: 15 * (MediaQuery.of(context).size.width / 360), color: Color(0xff5990E3),),
                                ),
                                Container(
                                  padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child:
                                  Text(
                                    "${commentlist.length}",
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
                        ],
                      ),
                    ),
                  if(result.length > 0 )
                    Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Html(
                        data: "${result["conts"]}",
                      ) ,
                      /*child: Text(
                        "${result["conts"]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NanumSquareR',
                        ),
                      ) ,*/
                    ),
                  if(filelist.length > 0)
                    for(var f=0; f<filelist.length; f++)
                      GestureDetector(
                          onTap: (){
                            showDialog(context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.black,
                                builder: (BuildContext context) {
                                  return PhotoAlbum_User(apptitle: '${result["title"]}',fileresult: filelist, table_nm: widget.table_nm,);
                                }
                            );
                          },
                        child: Container(
                          width: 330 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child : Image(
                            image: CachedNetworkImageProvider('http://www.hoty.company/upload/KIN/${filelist[f]["yyyy"]}/${filelist[f]['mm']}/${filelist[f]['uuid']}'), fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),

                  if(result.length > 0 )
                    Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        decoration : BoxDecoration (
                            border : Border(
                                bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                            )
                        )
                    ),
                  /*if(result.length > 0)
                  getPreNext(context),*/
                  if(result.length > 0 )
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
                  if(result.length > 0 )
                   Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color:  Color(0xffE47421), )
                      ),
                    ),
                  ),
                  if(commentlist.length > 0)
                  for(int i = 0; i < commentlist.length; i++)
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            if(reg_id != null && reg_id != "")
                                              if(reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y")
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
                                                            child: Text("삭제하기", style: TextStyle(color: Color(0xffEB5757), fontWeight: FontWeight.w400, fontSize: 16),),
                                                          ),
                                                        ),
                                                      if(reg_id == commentlist[i]["list"]["reg_id"] || adminChk == "Y")
                                                        PopupMenuItem(value : 'Edit',
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context) {
                                                                    return KinCommentModify2(article_seq: widget.article_seq, comment_seq: commentlist[i]["list"]["comment_seq"], table_nm: widget.table_nm,);
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
                                                          _isclose().then((value) {
                                                            if(write_bar1 == false && write_bar2 == false) {
                                                              top_alignment = 0.42;
                                                            } else {
                                                              top_alignment = 0.03;
                                                            }

                                                            if (commentlist[i]["list"]["visible2"] == false) {
                                                              // top_alignment = 0.3;
                                                              commentlist[i]["list"]["visible2"] = true;
                                                              write_bar1 = false;
                                                              write_bar2 = false;

                                                            } else {
                                                              commentlist[i]["list"]["visible2"] = false;
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
                                                                    _formKeys["key_${commentlist[i]["list"]["comment_seq"]}"]!.currentContext!,
                                                                    alignment : top_alignment
                                                                );
                                                              });
                                                            }
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
                                                            return CommentReportwrite(article_seq : widget.article_seq, table_nm : widget.table_nm,article_title: "댓글-${commentlist[i]["list"]["conts"]}",board_seq: board_seq, comment_seq: commentlist[i]["list"]["comment_seq"],);
                                                          },
                                                        ));
                                                      },
                                                      child : Container(
                                                          child : Row(
                                                            children: [
                                                              Image(image: AssetImage("assets/report_icon2.png"), width: 16 * (MediaQuery.of(context).size.width / 360),),
                                                              //Icon(Icons.report_gmailerrorred, color: Color(0xffC4CCD0),),
                                                              Text("  신고", style: TextStyle(color: Color(0xff151515), fontWeight: FontWeight.w600, fontSize: 13 * (MediaQuery.of(context).size.width / 360)),),
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
                                            height : commentlist[i]["list"]["_pickedImgs"].length > 0 ? 92 * (MediaQuery.of(context).size.height / 360) : 62 * (MediaQuery.of(context).size.height / 360),
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
                                                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
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
                                                                FlutterDialog2(context, commentlist[i]["list"]["head_seq"], commentlist[i]["list"]["comment_seq"], commentlist[i]["list"]["comment_seq"], i);
                                                              }
                                                              print("클릭 AA : ${commentlist[i]["list"]["head_seq"]}");
                                                            });
                                                          },
                                                          child : Container(
                                                              margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                                  10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                              padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                                  10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
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
                                                //if(reg_id != null && reg_id != "")
                                                  //if(reg_id == commentlist[j]["list"]["reg_id"] || adminChk == "Y")
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
                                                                        return KinCommentModify2(article_seq: widget.article_seq, comment_seq: commentlist[j]["list"]["comment_seq"], table_nm: widget.table_nm);
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
                                                      width : 145 * (MediaQuery.of(context).size.width / 360),
                                                      child : Row(
                                                        children: [
                                                          Text("${commentlist[j]["list"]["reg_dt"]}", style: TextStyle(color: Color(0xffC4CCD0), fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),),
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

                                                                if (commentlist[j]["list"]["visible1"] ==
                                                                    false) {
                                                                  // top_alignment = 0.3;
                                                                  commentlist[j]["list"]["visible1"] =
                                                                  true;
                                                                  write_bar1 = false;
                                                                  write_bar2 = false;
                                                                } else {
                                                                  commentlist[j]["list"]["visible1"] =
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
                                                                        _formKeys["key_${commentlist[j]["list"]["comment_seq"]}"]!
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
                                                                if(commentlist[j]["list"]["visible1"] == false) {
                                                                  commentlist[j]["list"]["visible1"] = true;
                                                                } else {
                                                                  write_bar1 = true;
                                                                  commentlist[j]["list"]["visible1"] = false;

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
                                                                  if(commentlist[j]["list"]["write"] == false) {
                                                                    FlutterDialog2(context, commentlist[i]["list"]["head_seq"], commentlist[j]["list"]["parent_seq"] ?? commentlist[j]["list"]["comment_seq"], commentlist[j]["list"]["comment_seq"], j);
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
                  if(commentlist.length > 0 && cpage < totalpage)
                    seemore(context),
                  Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      height: write_bar1 == true ? 50 * (MediaQuery.of(context).size.height / 360) : _pickedImgs.length > 0 && write_bar2 == true ? 125 * (MediaQuery.of(context).size.height / 360) :  95 * (MediaQuery.of(context).size.height / 360),
                      child : Column(
                        children: [
                          Visibility(
                            visible: write_bar1,
                            child: GestureDetector(
                              onTap : () {
                                write_bar1 = false;
                                write_bar2 = true;
                                setState(() {
                                  write_bar1 = false;
                                  write_bar2 = true;
                                });
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
                                child : Container(
                                    width: 245 * (MediaQuery.of(context).size.width / 360),
                                    alignment: Alignment.centerLeft,
                                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child : Text("댓글을 남겨보세요.", style: TextStyle(color: Color(0xffC4CCD0), ),)
                                ),
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
                                                          image: DecorationImage(fit: BoxFit.cover,image: FileImage(File("${_pickedImgs[0].path}")))
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
                                                              _pickedImgs = [];
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
                                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
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
                                                margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                    5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                                                }

                                              }
                                            },
                                            child : Container(
                                                padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                                margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                                    12 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: EmojiKeyboard(
                  emotionController: _commentController,
                  emojiKeyboardHeight: 100 * (MediaQuery.of(context).size.height / 360),
                  showEmojiKeyboard: showEmojiKeyboard,
                  darkMode: true),
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: Footer(nowPage: 'Main_menu'),
      )
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
                                        return KinView2(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], params: widget.params, main_catcode: widget.main_catcode,);
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
                                      return KinView2(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], params: widget.params, main_catcode: widget.main_catcode,);
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
  var saved = false;
  
  Future<void> FlutterDialog(context) async {

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


    print("#############################################");
    print("files :::: ${_files}");

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
          "state" : "C"
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
      /*showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: false,
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: textalert2(context, '댓글 작성이 완료되었습니다.'),
            );
          }
      ).then((value) => {*/
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
      /* });*/
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
             "attach" : _files,
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
            "state": "C",
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
      /*showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: false,
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: textalert2(context, '댓글 작성이 완료되었습니다.'),
            );
          }
      ).then((value) => {*/
      _commentController.text = "";
      commentlist.clear();
      cpage = 1;
      write_bar1 = true;
      getcommentdata().then((_) {
        _generateFormKeys(commentlist);

        setState(() {

        });
      });
      /*});*/
    }
  }

  Future<void> commentModify(context, comment_seq) async {

    final List<MultipartFile> _files =
    _pickedmodifyImgs.map(
            (img) => MultipartFile.fromFileSync(img.path,  contentType: new MediaType("image", "jpg"))
    ).toList();


    print("#############################################");
    print("files :::: ${_files}");

    FormData _formData = FormData.fromMap(
        {
          "attach" : _files,
          "conts" : _initComnmentcontroller.text,
          "board_seq" : "23",
          "article_seq" : widget.article_seq,
          "cms_menu_seq" : cms_menu_seq.toString(),
          "comment_seq" : comment_seq.toString(),
          "session_ip" : "127.0.0.1",
          "session_member_id" : "asd111",
          "session_member_nm" : "asd111",
          "table_nm" : "DAILY_TALK",
        }
    );

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/comment/modify.do", data: _formData).then((res) {
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
      showDialog(
          context: context,
          //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              /*title: Column(
            children: <Widget>[
              new Text("Dialog Title"),
            ],
          ),*/
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "댓글이 수정되었습니다",
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: new Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      for(var i=0; i < commentlist.length; i++) {
                        commentlist[i]["list"]["visible1"] = false;
                        commentlist[i]["list"]["visible2"] = false;
                      }
                      _initComnmentcontroller.text = "";
                      getcommentdata().then((_) {
                        setState(() {
                        });
                      });
                      _pickedmodifyImgs = [];
                    });
                    /*Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommunityDailyTalk();
                      },
                    ));*/
                  },
                ),
              ],
            );
          });
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
           /* Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CommunityDailyTalk(main_catcode: widget.main_catcode);
              },
            ));*/
          },
        ),
      ],
    );
  }

  Future<dynamic> deletecomment(int? comment_seq) async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/comment/delete.do',
    );

    try {
      Map data = {
        "comment_seq" : comment_seq,
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

  AlertDialog deletecommentalert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "댓글이 삭제 되었습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
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

                setState(() {

                });
              });
            });
          });
        });
      }
    });
  }

  Future<void> commentwriteDialog(BuildContext context) async{
    showDialog(
      barrierDismissible: false,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360) ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360) ),
                    width: 55 * (MediaQuery.of(context).size.width / 360),
                    child: Wrap(
                      children: [
                        Image(image: AssetImage('assets/Vector.png')),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "댓글을 작성 하시겠습니까?",
                    style: TextStyle(
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 19 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
                child : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xffFFFFFF),
                          padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.width / 360), vertical: 7 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                          ),
                          side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                          elevation: 0
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 100 * (MediaQuery.of(context).size.width / 360),
                        padding: EdgeInsets.symmetric(horizontal: 15 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                        child : Text("아니요",
                          style: TextStyle(
                              color: Color(0xffE47421),
                              fontFamily: "NanumSquareR",
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xffE47421),
                          padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.width / 360), vertical: 7 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                          ),
                          side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                          elevation: 0
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 100 * (MediaQuery.of(context).size.width / 360),
                        padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                        child : Text("예",
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontFamily: "NanumSquareR",
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {

                          FlutterDialog(context);
                          /*_userUpdate(context).then((_){
                                  setState(() {
                                    _userInfo();
                                  });
                                });*/
                        });
                      },
                    )
                  ],
                )
            )
          ],
        );
      },
    );
  }

  Future<void> commentmodifyDialog(BuildContext context, comment_seq) async{
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          content: Container(
            width: 350 * (MediaQuery.of(context).size.width / 360),
            height: 82 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(
              10 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50 * (MediaQuery.of(context).size.width / 360),
                  child: Wrap(
                    children: [
                      Image(image: AssetImage('assets/Vector.png')),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Text(
                    "댓글을 수정 하시겠습니까?",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 22 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Container(
                        width: 133 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffE47421),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "아니요",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  color: Color(0xffE47421),
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
                      margin: EdgeInsets.fromLTRB(9 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      child: Container(
                        width: 133 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffE47421),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                                commentModify(context, comment_seq);
                                /*_userUpdate(context).then((_){
                                  setState(() {
                                    _userInfo();
                                  });
                                });*/
                              });
                            },
                            child: Center(
                              child: Text(
                                "네",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> commentdeleteDialog(BuildContext context, int? comment_seq) async{
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          content: Container(
            width: 350 * (MediaQuery.of(context).size.width / 360),
            height: 82 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(
              10 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50 * (MediaQuery.of(context).size.width / 360),
                  child: Wrap(
                    children: [
                      Image(image: AssetImage('assets/Vector.png')),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Text(
                    "댓글을 삭제 하시겠습니까?",
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 22 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Container(
                        width: 133 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffE47421),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "아니요",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  color: Color(0xffE47421),
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
                      margin: EdgeInsets.fromLTRB(9 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      child: Container(
                        width: 133 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffE47421),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                deletecomment(comment_seq).then((value) =>
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                          return deletecommentalert(context);
                                        }
                                    )
                                );
                              });
                            },
                            child: Center(
                              child: Text(
                                "네",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
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
              ],
            ),
          ),
        );
      },
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
                        Container(
                          width: 50 * (MediaQuery.of(context).size.width / 360),
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                          padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            color: Color(0xffF3F6F8),
                            borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: TextButton(
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
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 3 * (MediaQuery.of(context).size.width / 360), 0),
                              padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                color: Color(0xffF3F6F8),
                                borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child: TextButton(
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
}