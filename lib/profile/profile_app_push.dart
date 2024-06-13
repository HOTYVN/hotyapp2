import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileAppPush extends StatefulWidget {
  @override
  _ProfileAppPushState createState() => _ProfileAppPushState();
}

class _ProfileAppPushState extends State<ProfileAppPush> {

  bool _isChecked1 = false; //업데이트&소식 알림

  bool _isChecked2 = false; //지식인 답변알림
  bool _isChecked3 = false; //지식인 채택알림
  bool _isChecked4 = false; //지식인 댓글알림

  bool _isChecked5 = false; //서비스 알림

  bool _isChecked6 = false; //중고거래 알림

  bool _isChecked7 = false; //개인과외 알림

  bool _isChecked8 = false; //커뮤니티 알림

  bool _isChecked9 = false; //오늘의 정보 - 오늘의 환율 알림
  bool _isChecked10 = false; //오늘의 정보 - 금주의 상영영화

  String update_push_yn = ""; //업데이트&소식 알림

  String kin_adopt_comment_push_yn = ""; //지식인 답변알림
  String kin_adopt_push_yn = ""; //지식인 채택알림
  String kin_comment_push_yn = ""; //지식인 댓글알림

  String service_push_yn = ""; //서비스 알림

  String used_trnsc_push_yn = ""; //중고거래 알림

  String personal_lesson_push_yn = ""; //개인과외 알림

  String community_push_yn = ""; //커뮤니티 알림

  String today_info_exchange_push_yn = ""; //오늘의 정보 - 오늘의 환율 알림
  String today_info_movie_push_yn = ""; //오늘의 정보 - 금주의 상영영화

  String regist_id = "";

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    userInfo().then((_){
      setState(() {

      });
    });
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId'))!;
  }

  /* 회원 앱푸시 사용 정보 */
  Future<void> userInfo() async{
    final url = Uri.parse('http://www.hoty.company/mf/member/userInfo.do');
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    try {
      Map data = {
        "member_id" : reg_id,
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        update_push_yn = responseData['result']['UPDATE_PUSH_YN'];

        kin_adopt_comment_push_yn = responseData['result']['KIN_ADOPT_COMMENT_PUSH_YN'];
        kin_adopt_push_yn = responseData['result']['KIN_ADOPT_PUSH_YN'];
        kin_comment_push_yn = responseData['result']['KIN_COMMENT_PUSH_YN'];

        service_push_yn = responseData['result']['SERVICE_PUSH_YN'];

        used_trnsc_push_yn = responseData['result']['USED_TRNSC_PUSH_YN'];

        personal_lesson_push_yn = responseData['result']['PERSONAL_LESSON_PUSH_YN'];

        community_push_yn = responseData['result']['COMMUNITY_PUSH_YN'];

        today_info_exchange_push_yn = responseData['result']['TODAY_INFO_EXCHANGE_PUSH_YN'];
        today_info_movie_push_yn = responseData['result']['TODAY_INFO_MOVIE_PUSH_YN'];


        _isChecked1 = update_push_yn == 'Y' ? true : false;

        _isChecked2 = kin_adopt_comment_push_yn == 'Y' ? true : false;
        _isChecked3 = kin_adopt_push_yn == 'Y' ? true : false;
        _isChecked4 = kin_comment_push_yn == 'Y' ? true : false;

        _isChecked5 = service_push_yn == 'Y' ? true : false;

        _isChecked6 = used_trnsc_push_yn == 'Y' ? true : false;

        _isChecked7 = personal_lesson_push_yn == 'Y' ? true : false;

        _isChecked8 = community_push_yn == 'Y' ? true : false;

        _isChecked9 = today_info_exchange_push_yn == 'Y' ? true : false;
        _isChecked10 = today_info_movie_push_yn == 'Y' ? true : false;
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  /* 앱푸시 사용 설정 */
  Future<void> _appPushUpdate(String push_type, bool _isChecked) async {
    final url = Uri.parse('http://www.hoty.company/mf/member/appPushUpdate.do');
    //final url = Uri.parse('http://www.hoty.company/mf/minigame/point_update.do');

    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    regist_id = reg_id!;

    Map<String, dynamic> data = {
      "member_id": reg_id,
      push_type : _isChecked == false ? "N" : "Y",
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
    return Scaffold(
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
        titleSpacing: -8.0,
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/

          child: Text("알림설정" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 업데이트&소식
            Container(
              padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
              child : Row(
                children: [
                  Container(
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child : Text("업데이트&소식",
                      style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        fontFamily: 'NanumSquareEB',
                        // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: _isChecked1,
                      activeColor: Color(0xffE47421),
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked1 = value ?? false;
                          _appPushUpdate("update_push_yn", _isChecked1);
                        });
                      },
                    ),
                  )
                ],
              )
            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),

            // 지식인 (답변,채택,댓글)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
              child : Text("지식인",
                style: TextStyle(
                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                  color: Color(0xff151515),
                  fontFamily: 'NanumSquareEB',
                  // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("답변알림",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareR',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked2,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked2 = value ?? false;
                            _appPushUpdate("kin_adopt_comment_push_yn", _isChecked2);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("채택알림",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareR',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked3,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked3 = value ?? false;
                            _appPushUpdate("kin_adopt_push_yn", _isChecked3);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("댓글알림",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareR',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked4,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked4 = value ?? false;
                            _appPushUpdate("kin_comment_push_yn", _isChecked4);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),

            //서비스
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("서비스",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareEB',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked5,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked5 = value ?? false;
                            _appPushUpdate("service_push_yn", _isChecked5);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),

            //중고거래
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("중고거래",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareEB',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked6,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked6 = value ?? false;
                            _appPushUpdate("used_trnsc_push_yn", _isChecked6);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),

            //개인과외
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("개인과외",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareEB',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked7,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked7 = value ?? false;
                            _appPushUpdate("personal_lesson_push_yn", _isChecked7);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),

            //커뮤니티
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("커뮤니티",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareEB',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked8,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked8 = value ?? false;
                            _appPushUpdate("community_push_yn", _isChecked8);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),

            // 오늘의 정보 (환율,영화)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360)  ),
              child : Text("오늘의 정보",
                style: TextStyle(
                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                  color: Color(0xff151515),
                  fontFamily: 'NanumSquareEB',
                  // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("오늘의 환율",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareR',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked9,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked9 = value ?? false;
                            _appPushUpdate("today_info_exchange_push_yn", _isChecked9);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360)  ),
                child : Row(
                  children: [
                    Container(
                      width: 280 * (MediaQuery.of(context).size.width / 360),
                      child : Text("금주의 상영영화",
                        style: TextStyle(
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontFamily: 'NanumSquareR',
                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: _isChecked10,
                        activeColor: Color(0xffE47421),
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked10 = value ?? false;
                            _appPushUpdate("today_info_movie_push_yn", _isChecked10);
                          });
                        },
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}