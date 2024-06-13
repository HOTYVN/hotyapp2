import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_admin.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileAdminDetail extends StatefulWidget{
  final int idx;

  ProfileAdminDetail({super.key, required this.idx});

  @override
  State<ProfileAdminDetail> createState() => _ProfileAdminDetailState();
}

class _ProfileAdminDetailState extends State<ProfileAdminDetail> {
  final storage = FlutterSecureStorage();
  int click_check = 1;
  String? reg_id;
  String? table_nm;
  bool asyncFlag = false;
  Map result = {};

  String selectedImage = '';
  String? state;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        asyncFlag = true;
        getBoardList();
      });
    });

  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }
  void setServiceState(context) async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/setServiceState.do',
      //'http://192.168.100.31:8080/mf/member/setServiceState.do',
    );

    Map jsoData = {
      "memberId": reg_id,
      "articleSeq" : result['ARTICLE_SEQ'],
      "cat01" : state,
    };
    var body = json.encode(jsoData);
    if(state == null || state == '') {
      showDialog(
        barrierColor: Color(0xffE47421).withOpacity(0.4),
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
              padding: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                10 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
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
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Text(
                      "상태를 선택해주세요.",
                      style: TextStyle(
                        fontSize: 26 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      10 * (MediaQuery.of(context).size.width / 360),
                      15 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Container(
                      width: 130 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Color(0xffE47421),
                      ),
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProfileAdmin();
                            },
                          ));
                        },
                        child: Center(
                          child: Text(
                            "닫기",
                            style: TextStyle(
                              fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }else{
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print(json.decode(response.body));
      if(json.decode(response.body)['state'] == 200) {
        showDialog(
          barrierDismissible: false,
          barrierColor: Color(0xffE47421).withOpacity(0.4),
          context: context,
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: AlertDialog(
                insetPadding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                content: Container(
                  width: 350 * (MediaQuery.of(context).size.width / 360),
                  height: 82 * (MediaQuery.of(context).size.height / 360),
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    10 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
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
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Text(
                          "변경 완료되었습니다.",
                          style: TextStyle(
                            fontSize: 26 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          10 * (MediaQuery.of(context).size.width / 360),
                          15 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Container(
                          width: 130 * (MediaQuery.of(context).size.width / 360),
                          height: 30 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: Color(0xffE47421),
                          ),
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfileAdmin();
                                },
                              ));
                            },
                            child: Center(
                              child: Text(
                                "닫기",
                                style: TextStyle(
                                  fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
      }else{
        showDialog(
          barrierDismissible: false,
          barrierColor: Color(0xffE47421).withOpacity(0.4),
          context: context,
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: AlertDialog(
                insetPadding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                content: Container(
                  width: 350 * (MediaQuery.of(context).size.width / 360),
                  height: 82 * (MediaQuery.of(context).size.height / 360),
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    10 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
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
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Text(
                          json.decode(response.body)['msg'],
                          style: TextStyle(
                            fontSize: 21 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          10 * (MediaQuery.of(context).size.width / 360),
                          15 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Container(
                          width: 130 * (MediaQuery.of(context).size.width / 360),
                          height: 30 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.0),
                            color: Color(0xffE47421),
                          ),
                          child: TextButton(
                            onPressed: (){
                              Navigator.pop(context, true);
                            },
                            child: Center(
                              child: Text(
                                "닫기",
                                style: TextStyle(
                                  fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
        ).then((value) {
          if(value == true) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ProfileAdmin();
              },
            ));
          }
        });
      }
    }

  }

  void setServiceStart(context) async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/setServiceStart.do',
      //'http://192.168.100.31:8080/mf/member/setServiceStart.do',
    );

    Map jsoData = {
      "memberId": reg_id,
      "articleSeq" : result['ARTICLE_SEQ'],
      "cat01" : state,
    };
    var body = json.encode(jsoData);
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print(json.decode(response.body));
    if(json.decode(response.body)['state'] == 200) {
      showDialog(
        barrierDismissible: false,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              insetPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              content: Container(
                width: 350 * (MediaQuery.of(context).size.width / 360),
                height: 110 * (MediaQuery.of(context).size.height / 360),
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
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
                        0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text(
                        "출장 시작시간이 저장 되었습니다.\n고객에게 앱푸시가 전송 되었습니다.",
                        style: TextStyle(
                          fontSize: 21 * (MediaQuery.of(context).size.width / 360),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        10 * (MediaQuery.of(context).size.width / 360),
                        15 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Container(
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: Color(0xffE47421),
                        ),
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context, true);
                          },
                          child: Center(
                            child: Text(
                              "닫기",
                              style: TextStyle(
                                fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
      ).then((value) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProfileAdmin();
          },
        ));
      });
    }else{
      showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              insetPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              content: Container(
                width: 350 * (MediaQuery.of(context).size.width / 360),
                height: 82 * (MediaQuery.of(context).size.height / 360),
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
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
                        0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text(
                        json.decode(response.body)['msg'],
                        style: TextStyle(
                          fontSize: 21 * (MediaQuery.of(context).size.width / 360),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        10 * (MediaQuery.of(context).size.width / 360),
                        15 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Container(
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: Color(0xffE47421),
                        ),
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context, true);
                          },
                          child: Center(
                            child: Text(
                              "닫기",
                              style: TextStyle(
                                fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
      ).then((value) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProfileAdmin();
          },
        ));
      });
    }
  }

  void setServiceComplete(context) async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/setServiceComplete.do',
      //'http://192.168.0.119:8080/mf/member/setServiceComplete.do',
    );

    Map jsoData = {
      "memberId": reg_id,
      "articleSeq" : result['ARTICLE_SEQ'],
      "cat01" : state,
    };
    var body = json.encode(jsoData);
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print(json.decode(response.body));
    if(json.decode(response.body)['state'] == 200) {
      showDialog(
        barrierDismissible: false,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            content: Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 120 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                10 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
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
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Text(
                      "출장 완료시간이 저장 되었습니다.",
                      style: TextStyle(
                        fontSize: 26 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      10 * (MediaQuery.of(context).size.width / 360),
                      15 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Container(
                      width: 130 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Color(0xffE47421),
                      ),
                      child: TextButton(
                        onPressed: (){
                          Navigator.pop(context, true);
                        },
                        child: Center(
                          child: Text(
                            "닫기",
                            style: TextStyle(
                              fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((value) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProfileAdmin();
          },
        ));
      });
    }else{
      showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              insetPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              content: Container(
                width: 350 * (MediaQuery.of(context).size.width / 360),
                height: 82 * (MediaQuery.of(context).size.height / 360),
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
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
                        0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text(
                        json.decode(response.body)['msg'],
                        style: TextStyle(
                          fontSize: 21 * (MediaQuery.of(context).size.width / 360),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        10 * (MediaQuery.of(context).size.width / 360),
                        15 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Container(
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: Color(0xffE47421),
                        ),
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context, true);
                          },
                          child: Center(
                            child: Text(
                              "닫기",
                              style: TextStyle(
                                fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
      ).then((value) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProfileAdmin();
          },
        ));
      });
    }
  }

  Future<void> getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberServiceBoardView.do',
      //'http://192.168.0.119:8080/mf/member/getMemberServiceBoardView.do',
    );

    try {

      Map data = {
        "memberId": reg_id,
        "articleSeq": widget.idx
      };

      print('test');
      print(reg_id);
      print(widget.idx);

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body)['result']);
        setState(() {
          result = json.decode(response.body)['result']['view'];
          table_nm = result['TABLE_NM'];
        });
      }

    }catch(e) {
      print(e);
    }

  }

  Future<void> stateAlert(context) async {
    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
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
                    setState(() {
                      click_check = 1;
                    });
                    Navigator.of(context, rootNavigator: true).pop('dialog');
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
            content: Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 80 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      8 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Row(
                      children: [
                        _buildImageContainer(
                          'assets/service_history_icon_ko_02.png',
                          context,
                          'SRVE_002',
                        ),
                        SizedBox(width: 7 * (MediaQuery.of(context).size.height / 360),),
                        _buildImageContainer(
                          'assets/service_history_icon_ko_03.png',
                          context,
                          'SRVE_003',
                        ),
                        SizedBox(width: 7 * (MediaQuery.of(context).size.height / 360),),
                        _buildImageContainer(
                          'assets/service_history_icon_ko_04.png',
                          context,
                          'SRVE_004',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child: Container(
                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        width: (MediaQuery.of(context).size.width),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                              padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                              )
                          ),
                          onPressed: (){
                            Navigator.pop(context, true);

                          },
                          child: Text('상태변경', style: TextStyle(fontSize: 18, color: Colors.white),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setServiceState(context);
    });
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
          child: Text("서비스 신청 내역" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('서비스 신청 ID', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text(result['SERVICE_ID'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('서비스 종류', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text(result['SERVICE_NM'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('진행상태', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text(result['CAT01'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('신청일', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text(result['REG_DT'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('이름', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text(result['REG_NM'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('전화번호', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text(result['ETC09'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            if(table_nm == 'ON_SITE' || table_nm == 'INTRP_SRVC')...[
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                width:  MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('주소', style: TextStyle(fontSize: 16, color: Colors.black,)),
                    Text(
                      result['ADRES'].toString(),
                      style: TextStyle(
                        fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',
                      ),
                    )
                  ],
                ),
              ),
            ],
            if(table_nm == 'ON_SITE')...[ //출장서비스
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                width:  MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('통역 수준', style: TextStyle(fontSize: 16, color: Colors.black,)),
                    Text(result['CAT02'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                  ],
                ),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                width:  MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('출장 시작 시간', style: TextStyle(fontSize: 16, color: Colors.black,)),
                    Text(result['SDATE'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                  ],
                ),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                width:  MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('출장 종료 시간', style: TextStyle(fontSize: 16, color: Colors.black,)),
                    Text(result['EDATE'].toString(), style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                  ],
                ),
              ),
            ],
            if(table_nm == 'ON_SITE' || table_nm == 'AGENCY_SRVC' || table_nm == 'REAL_ESTATE_INTRP_SRVC')...[
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text('신청 내용', style: TextStyle(fontSize: 16, color: Colors.black,)),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth : 250 * (MediaQuery.of(context).size.width / 360)),
                      child: Text(
                        result['CONTS'].toString(),
                        style: TextStyle(
                          fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.left,
                      ),
                    )

                  ],
                ),
              ),
            ],
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('서비스 비용', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text("${result['SERVICE_FEE']} VND", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('포인트 사용 금액', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text("${result['ETC01']} P", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width:  MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('현장 결제 금액', style: TextStyle(fontSize: 16, color: Colors.black,)),
                  Text("${getVND(result['ETC02'])}", style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'NanumSquareRound',))
                ],
              ),
            ),
            Container(
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: click_check == 0
                        ? Color.fromRGBO(255, 243, 234, 1)
                        : Color.fromRGBO(228, 116, 33, 1),
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                onPressed: (){
                  if(click_check == 1) {
                    setState(() {
                      click_check = 0;
                    });
                    stateAlert(context);
                  }
                },
                child: Text('처리상태 변경', style: TextStyle(fontSize: 18, color: click_check == 0 ? Color(0xffE47421) : Colors.white),),
              ),
            ),
            if(table_nm != 'AGENCY_SRVC' && asyncFlag)...[
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                width: (MediaQuery.of(context).size.width),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: click_check == 0
                          ? Color.fromRGBO(255, 243, 234, 1)
                          : Color.fromRGBO(228, 116, 33, 1),
                      padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                      )
                  ),
                  onPressed: (){
                    if(click_check == 1) {
                      setState(() {
                        click_check = 0;
                      });
                      setServiceStart(context);
                    }
                  },
                  child: Text('출장시작', style: TextStyle(fontSize: 18, color: click_check == 0 ? Color(0xffE47421) : Colors.white),),
                ),
              ),
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                width: (MediaQuery.of(context).size.width),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: click_check == 0
                          ? Color.fromRGBO(255, 243, 234, 1)
                          : Color.fromRGBO(228, 116, 33, 1),
                      padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                      )
                  ),
                  onPressed: (){
                    if(click_check == 1) {
                      setState(() {
                        click_check = 0;
                      });
                      setServiceComplete(context);
                    }
                  },
                  child: Text('출장완료', style: TextStyle(fontSize: 18, color: click_check == 0 ? Color(0xffE47421) : Colors.white),),
                ),
              ),
            ],

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
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'My_page'),
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

  Widget _buildImageContainer(String imagePath, BuildContext context, String state_type) {
    bool isSelected = selectedImage == imagePath;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Update the selected image
          selectedImage = isSelected ? '' : imagePath;
          state = state_type;
          Navigator.pop(context);
          stateAlert(context);
        });
      },
      child: Container(
        width: 80 * (MediaQuery.of(context).size.width / 360),
        height: 80 * (MediaQuery.of(context).size.width / 360),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Color(0xffE47421) : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: ClipOval(
            child: Image(
              image: AssetImage(imagePath),
              width: 30 * (MediaQuery.of(context).size.width / 360),
            ),
          ),
        ),
      ),
    );
  }
}
