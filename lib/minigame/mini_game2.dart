import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/main/main_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


void showMiniGame2(BuildContext context, isShow) {
  showDialog(
    barrierColor: isShow == 0 ? Color(0xffE47421).withOpacity(0.4) : Colors.transparent,
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => MiniGame2(),
  );
}

class MiniGame2 extends StatefulWidget {
  @override
  _MiniGame2State createState() => _MiniGame2State();
}


class _MiniGame2State extends State<MiniGame2> {

  TextEditingController inputController1 = TextEditingController();  // 텍스트박스4개
  TextEditingController inputController2 = TextEditingController();
  TextEditingController inputController3 = TextEditingController();
  TextEditingController inputController4 = TextEditingController();

  String resultMessage = ""; //오답메시지
  bool isButtonPressed = false; //버튼사용유무
  String _title = ''; //퀴즈제목
  String _quiz_question = ''; //퀴즈 질문
  String _quiz_answer = ''; //퀴즈 정답
  String _quiz_hint= ''; // 퀴즈 힌트
  String _qPoint = ''; //퀴즈 포인트
  String _notice_yn = '';

  String regist_id = "";
  String regist_nm = "";

  List<dynamic> getresult = [];

  var Baseurl = "http://www.hoty.company/mf";
  //var Baseurl = "http://www.hoty.company/mf";
  var Base_Imgurl = "http://www.hoty.company";

  Future<dynamic> getlistdata() async {

    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
        Baseurl + "/popup/list.do"
    );
    try {
      Map data = {
        "table_nm" : "main"
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

        getresult = json.decode(response.body)['result'];
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(getresult);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }


  late SharedPreferences _prefs;

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId')) ?? "";
    regist_nm = (await storage.read(key:'memberNick')) ?? "";
    print("#############################################");
  }

  @override
  void initState() {

    super.initState();
    _asyncMethod();
    initSharedPreferences();
    _loadData();
    getlistdata();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setData(String memberId) async {
    await _prefs.setString("memberId", memberId);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _title = prefs.getString("_title")!;
      _quiz_question = prefs.getString("_quiz_question")!;
      _quiz_answer = prefs.getString("_quiz_answer")!;
      _quiz_hint = prefs.getString("_quiz_hint")!;
      _qPoint = prefs.getString("_qPoint")!;
      _notice_yn = prefs.getString("notice_yn") ?? '';
    });
  }

  var _conts = "";


  /* 미니게임 포인트지급 api */
  void _pointUpdate() async {
    //final url = Uri.parse('http://10.0.2.2:8080/mf/minigame/point_update.do');
    final url = Uri.parse('http://www.hoty.company/mf/minigame/point_update.do');

    _conts = "퀴즈 게임 당첨금";

    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");
    regist_nm = reg_nm!;
    regist_id = reg_id!;
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic ipdata = await ipAddress.getIpAddress();

    Map<String, dynamic> data = {
      "member_id": reg_id,
      "member_nm": reg_nm,
      "pt_type": "출석게임",
      "conts": _conts,
      "pt_enext": "I",
      "pt_usepay": _qPoint,
      "pt_ip": ipdata["ip"].toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('성공적으로 전송되었습니다.');
        print(response.body);
      } else {
        print('요청 실패: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('오류: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'NanumSquareR',
          appBarTheme: AppBarTheme(
              color: Colors.white
          )
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: 'MiniGame1',
      home: AlertDialog(
        insetPadding: EdgeInsets.fromLTRB(10, 20,
            10  , 20 ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Container(
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_rounded , size: 30,),
              ),
            ),
          ],
        ),
        titlePadding: EdgeInsets.fromLTRB(
          0 * (MediaQuery.of(context).size.width / 360),
          10,
          10,
          0 * (MediaQuery.of(context).size.height / 360),
        ),
        content: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Text(
                    _title,
                    style: TextStyle(
                      fontSize: 28 ,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "안녕하세요. ",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "${regist_nm} 님! ",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "반갑습니다",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  0 ,
                  0,
                  0,
                  0,
                ),
                child: Column(
                  children: [
                    Text(
                      _quiz_question,
                      style: TextStyle(
                        fontSize: 16 ,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      0,
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0), // 패딩 조절
                      decoration: BoxDecoration(
                        color: Color(0xff2F67D3),
                        borderRadius: BorderRadius.circular(3.0), // 조절 가능한 값으로 변경
                      ),
                      child: Text(
                        "HINT",
                        style: TextStyle(
                          fontSize: 10 ,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // width: 257,
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      0,
                      0 ,
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 3, 10, 3), // 패딩 조절
                      decoration: BoxDecoration(
                        color: Color(0xffeaf3fd),
                        borderRadius: BorderRadius.circular(3.0), // 조절 가능한 값으로 변경
                      ),
                      child: Text(
                        _quiz_hint,
                        style: TextStyle(
                          fontSize: 10 ,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 200,
                margin: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  8 ,
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                child:  Image(image: AssetImage('assets/blue_question.png')),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  8 ,
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNumericInput(inputController1, context),
                        SizedBox(width: 10),
                        buildNumericInput(inputController2, context),
                        SizedBox(width: 15),
                        buildNumericInput(inputController3, context),
                        SizedBox(width: 15),
                        buildNumericInput(inputController4, context),
                        SizedBox(width: 0),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    15,
                    0 * (MediaQuery.of(context).size.width / 360),
                    15 ,
                  ),
                  child: Text(
                    resultMessage,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(20 , 0,
                20, 20 ),
            child: Container(
              // height: 30,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.0),
              ),
              child: Center(

                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: isButtonPressed ? Color(0xffFFF3EA) : Color(0xffE47421),
                    splashFactory: NoSplash.splashFactory,
                    elevation: 0,
                  ),
                  onPressed: isButtonPressed
                      ? null
                      : () async {
                    setState(() {
                      isButtonPressed = true;
                    });
                    await setData('${regist_id}');
                    String combinedText = inputController1.text +
                        inputController2.text +
                        inputController3.text +
                        inputController4.text;
                    if (combinedText == _quiz_answer) {
                      _pointUpdate();
                      Navigator.of(context, rootNavigator: true)
                          .pop('dialog');
                      return SuccessDialog(context);
                    } else {
                      setState(() {
                        isButtonPressed = false;
                        inputController1.clear();
                        inputController2.clear();
                        inputController3.clear();
                        inputController4.clear();
                        resultMessage = '다시 한번 생각해보세요';
                      });
                    }
                    //_noticeModal(context);
                    //SuccessDialog(context);
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        "정답확인",
                        style: TextStyle(
                          fontSize: 18,
                          color: isButtonPressed ? Color(0xffE47421) : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumericInput(TextEditingController controller, BuildContext context) {
    return Container(
      width: 60 ,
      margin: EdgeInsets.fromLTRB(
        0,
        5,
        0,
        0 * (MediaQuery.of(context).size.height / 360),
      ),
      child: TextField(
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
            hintText: '?',
            hintStyle: TextStyle(
              color:Color(0xffC4CCD0),
              fontSize: 24,
            ),
            filled: true,
            fillColor: Color(0xffF3F6F8),
          isDense: true, // 텍스트필드 기본간격 사용유무
          contentPadding: EdgeInsets.fromLTRB(20, 25, 20, 25),
          border: InputBorder.none, // 언더라인 등,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF3F6F8),
                // color: Colors.red,
                width: 1.0,
              )
          ), // 힌트텍스트 스타일
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffF3F6F8),
                // color: Colors.green,
                width: 1.0,
              )
          ), // 포커싱 스타일
          errorBorder: InputBorder.none, // 에러텍스트 스타일
          disabledBorder: InputBorder.none, // 사용한하는 필드 스타일
        ),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void SuccessDialog(BuildContext context) {

    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding: EdgeInsets.fromLTRB(10, 20,
                10  , 20 ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            elevation: 0,
            title: Container(
              height: 14 ,
              alignment: Alignment.centerRight,
              child : IconButton(
                icon: Icon(Icons.close_rounded, size: 28 ,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            titlePadding: EdgeInsets.fromLTRB(
              0 * (MediaQuery.of(context).size.width / 360),
              5 ,
              5,
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            content: Container(
              width: 300 ,
              height: 300,
              margin: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      5,
                      0 * (MediaQuery.of(context).size.width / 360),
                      5,
                    ),
                    child: Text(
                      "축하드립니다",
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 28 ,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareEB',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${regist_nm} 님! ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "${_qPoint}P",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " 당첨!",
                          style: TextStyle(
                            fontSize: 13 ,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 190 ,
                    child: Wrap(
                      children: [
                        Image(image: AssetImage('assets/gift_box.png')),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      5,
                      2 ,
                      5 ,
                      0 ,
                    ),
                    child: Container(
                      width: 300 ,
                      padding: EdgeInsets.fromLTRB(
                        0,
                        1 ,
                        0 ,
                        1 ,
                      ),
                      // height: 29 ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Color(0xffE47421),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "홈으로 돌아가기",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

void _noticeModal(context, getresult){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            IconButton(
              icon: Icon(Icons.close_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        titlePadding: EdgeInsets.fromLTRB(
          0 * (MediaQuery.of(context).size.width / 360),
          0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360),
          0 * (MediaQuery.of(context).size.height / 360),
        ),
        content: SizedBox(
          width: 330 * (MediaQuery.of(context).size.width / 360),
          height: 182 * (MediaQuery.of(context).size.height / 360),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                child : Text(
                  "${getresult[0]["title"]}",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 300 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                child : Text(
                  "${getresult[0]["alt"]}",
                  style: TextStyle(
                    fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                child: SizedBox(
                  width: 210 * (MediaQuery.of(context).size.width / 360),
                  height: 64 * (MediaQuery.of(context).size.height / 360),
                  child: Wrap(
                    children: [Image(image: CachedNetworkImageProvider('http://www.hoty.company${getresult[0]["file_path"]}'),),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return MaterialApp(
                                    theme: ThemeData(
                                        scaffoldBackgroundColor: Colors.white,
                                        fontFamily: 'NanumSquareR',
                                        appBarTheme: AppBarTheme(
                                            color: Colors.white
                                        )
                                    ),
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                        child: child!,
                                      );
                                    },
                                    home: MainPage(),
                                  );
                                },
                              ));
                            },
                            child: Center(
                              child: Text(
                                "이벤트 참여",
                                style: TextStyle(
                                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                  color: Colors.blueAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 28 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                    child: Container(
                      width: 130 * (MediaQuery.of(context).size.width / 360),
                      height: 37 * (MediaQuery.of(context).size.height / 360),
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
                            _noticeCancle();
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MainPage();
                              },
                            ));
                          },
                          child: Center(
                            child: Text(
                              "다시 보지않기",
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
                    margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 28 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                    child: Container(
                      width: 130 * (MediaQuery.of(context).size.width / 360),
                      height: 37 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffE47421),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              "이벤트에 참여하세요",
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

/* 공지 다시보지 않기 여부 */
void _noticeCancle() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("notice_yn", 'N');
  print(prefs.getString("notice_yn"));
}
