import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/guide/guide.dart';
import 'package:hoty/main/main_menu_login.dart';
import 'package:hoty/main/main_notification.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;


import '../profile/profile_main.dart';

enum IntroSet {D, B,  R, S}
class MainIntro extends StatefulWidget {
  final String subtitle;
  final String memberId;
  const MainIntro({Key? key,
    required this.subtitle,
    required this.memberId
  }) : super(key:key);

  @override
  State<MainIntro> createState() => _MainIntroState();
}

class _MainIntroState extends State<MainIntro> {
  final storage = FlutterSecureStorage();

  String? reg_id;
  bool isChecked1 = true;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }

  Future<void> setInterests() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/setInterests.do',
      //'http://192.168.100.31:8080/mf/member/setInterests.do',
    );
    var interesting;
    if(isChecked1) {
      interesting = "INTR_01";
    } else if(isChecked2) {
      interesting = "INTR_03";
    } else if(isChecked3) {
      interesting = "INTR_02";
    } else if(isChecked4) {
      interesting = "INTR_04";
    }
    Map jsoData = {
      "member_id": widget.memberId,
      "interesting": interesting,
    };

    print(jsoData);

    var body = json.encode(jsoData);
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print('response api ');
    print(json.decode(response.body));
    if(json.decode(response.body)['state'] == 200) {
      await storage.write(key: "memberInteresting", value: interesting);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return movePage(widget.subtitle);
        },
      ));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 100),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360), 0, 0),
              child: Text('관심 분야 선택', style: TextStyle(
                color: Color(0xff151515),
                fontFamily: 'NanumSquareEB',
                  fontSize: 27 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.bold,
              ), textAlign: TextAlign.center),
            ),
            Container(
              // height: 20 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 12 * (MediaQuery.of(context).size.height / 360)),
              child: Text('고객님의 괸심 분야를 선택해주세요.\n(중복선택은 불가능 해요)', style: TextStyle(
                color: Color(0xff151515),
                fontFamily: 'NanumSquareR',
                  fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                 height: 1.4,
              ), textAlign: TextAlign.center),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    // color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          width: 160 * (MediaQuery.of(context).size.width / 360),
                          height: 100 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap : () {
                                  setState(() {
                                    isChecked1 = true;
                                    isChecked2 = false;
                                    isChecked3 = false;
                                    isChecked4 = false;
                                  });
                                },
                                child : Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                      3 * (MediaQuery.of(context).size.height / 360), 3* (MediaQuery.of(context).size.height / 360)),
                                  width: 160 * (MediaQuery.of(context).size.width / 360),
                                  height: 80 * (MediaQuery.of(context).size.height / 360),
                                  child: Image(image: AssetImage('assets/main_daily.png')),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360) , 1 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      child: Text('일상',style: TextStyle(
                                        color: Color(0xff151515),
                                        // fontFamily: 'NanumSquareEN',
                                        fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                        fontWeight: FontWeight.bold,
                                      ), textAlign: TextAlign.left  ),
                                    ),
                                    Container(
                                      child: Checkbox(
                                        value: isChecked1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        checkColor: Colors.white,
                                        activeColor: Color(0xffE47421),
                                        materialTapTargetSize: MaterialTapTargetSize.padded, onChanged: (bool? value) {
                                          setState(() {
                                            isChecked1 = value!;
                                            isChecked2 = false;
                                            isChecked3 = false;
                                            isChecked4 = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                )
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),
                          width: 160 * (MediaQuery.of(context).size.width / 360),
                          height: 100 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap : () {
                                  setState(() {
                                    isChecked1 = false;
                                    isChecked2 = true;
                                    isChecked3 = false;
                                    isChecked4 = false;
                                  });
                                },
                                child : Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                      3 * (MediaQuery.of(context).size.height / 360), 3* (MediaQuery.of(context).size.height / 360)),                                width: 160 * (MediaQuery.of(context).size.width / 360),
                                  height: 80 * (MediaQuery.of(context).size.height / 360),
                                  child: Image(image: AssetImage('assets/main_restaurant.png')),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360) , 1 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(3, 0 * (MediaQuery.of(context).size.height / 360), 3, 0),

                                        child: Text('맛집',style: TextStyle(
                                          color: Color(0xff151515),
                                          // fontFamily: 'NanumSquareEB',
                                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.bold,
                                        ), textAlign: TextAlign.left  ),
                                      ),
                                      Container(
                                        child: Checkbox(
                                          value: isChecked2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          checkColor: Colors.white,
                                          activeColor: Color(0xffE47421),
                                          materialTapTargetSize: MaterialTapTargetSize.padded, onChanged: (bool? value) {
                                            setState(() {
                                              isChecked1 = false;
                                              isChecked2 = value!;
                                              isChecked3 = false;
                                              isChecked4 = false;
                                            });

                                          },
                                        ),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                    child: Column(
                      children: [
                        Container(
                          width: 160 * (MediaQuery.of(context).size.width / 360),
                          height: 100 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap : () {
                                  setState(() {
                                    isChecked1 = false;
                                    isChecked2 = false;
                                    isChecked3 = true;
                                    isChecked4 = false;
                                  });
                                },
                                child : Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                      3 * (MediaQuery.of(context).size.height / 360), 3* (MediaQuery.of(context).size.height / 360)),                                width: 160 * (MediaQuery.of(context).size.width / 360),
                                  height: 80 * (MediaQuery.of(context).size.height / 360),
                                  child: Image(image: AssetImage('assets/main_business.png')),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360) , 1 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        child: Text('사업',style: TextStyle(
                                          color: Color(0xff151515),
                                          // fontFamily: 'NanumSquareEB',
                                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.bold,
                                        ), textAlign: TextAlign.left  ),
                                      ),
                                      Container(
                                        child: Checkbox(
                                          value: isChecked3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          checkColor: Colors.white,
                                          activeColor: Color(0xffE47421),
                                          materialTapTargetSize: MaterialTapTargetSize.padded, onChanged: (bool? value) {
                                          setState(() {
                                            isChecked1 = false;
                                            isChecked2 = false;
                                            isChecked3 = value!;
                                            isChecked4 = false;
                                          });
                                          },
                                        ),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),
                          width: 160 * (MediaQuery.of(context).size.width / 360),
                          height: 100 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap : () {
                                  setState(() {
                                    isChecked1 = false;
                                    isChecked2 = false;
                                    isChecked3 = false;
                                    isChecked4 = true;
                                  });
                                },
                                child : Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                      3 * (MediaQuery.of(context).size.height / 360), 3* (MediaQuery.of(context).size.height / 360)),                                width: 160 * (MediaQuery.of(context).size.width / 360),
                                  height: 80 * (MediaQuery.of(context).size.height / 360),
                                  child: Image(image: AssetImage('assets/main_shopping.png')),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360) , 1 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(3, 0 * (MediaQuery.of(context).size.height / 360), 3, 0),

                                        child: Text('쇼핑',style: TextStyle(
                                          color: Color(0xff151515),
                                          // fontFamily: 'NanumSquareR',
                                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                          fontWeight: FontWeight.bold,
                                        ), textAlign: TextAlign.left  ),
                                      ),
                                      Container(
                                        child: Checkbox(
                                          value: isChecked4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          checkColor: Colors.white,
                                          activeColor: Color(0xffE47421),
                                          materialTapTargetSize: MaterialTapTargetSize.padded, onChanged: (bool? value) {
                                            setState(() {
                                              isChecked1 = false;
                                              isChecked2 = false;
                                              isChecked3 = false;
                                              isChecked4 = value!;
                                            });
                                        },
                                        ),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
      Container(
        color: Color.fromRGBO(245, 245, 245, 100),
        margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
        padding: EdgeInsets.symmetric(horizontal: 8 * (MediaQuery.of(context).size.height / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
        width: 360 * (MediaQuery.of(context).size.width / 360),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(228, 116, 33, 1),
              padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
              )
          ),
          onPressed: (){
            setInterests();
          },
          child: Text('시작하기', style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget movePage(String subtitle){

    if(subtitle == 'Main') {
      return MainMenuLogin();
    }
    if(subtitle == 'Mypage') {
      return Profile_main();
    }

    if(subtitle == "notification") {
      return MainNotification();
    }


    return MainPage();
    /*return Guide();*/
  }
}