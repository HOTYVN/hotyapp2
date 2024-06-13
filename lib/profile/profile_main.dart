import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/login/login.dart';
import 'package:hoty/profile/profile_admin.dart';
import 'package:hoty/profile/profile_apartment.dart';
import 'package:hoty/profile/profile_customer_service.dart';
import 'package:hoty/profile/profile_hoty_point.dart';
import 'package:hoty/profile/profile_like.dart';
import 'package:hoty/profile/profile_my_post.dart';
import 'package:hoty/profile/profile_partnership.dart';
import 'package:hoty/profile/profile_report.dart';
import 'package:hoty/profile/profile_service_guide.dart';
import 'package:hoty/profile/profile_service_history.dart';
import 'package:hoty/profile/profile_setting.dart';
import 'package:hoty/profile/profile_visiting_service.dart';
import 'package:hoty/main/main_menu.dart';
import 'package:hoty/main/main_notification.dart';
import 'package:http/http.dart' as http;

import '../common/icons/my_icons.dart';
import '../main/main_menu_login.dart';
import '../main/main_page.dart';
import 'customer/profile_customer_service_detail2.dart';

class Profile_main extends StatefulWidget {

  @override
  State<Profile_main> createState() => _Profile_mainState();
}

class _Profile_mainState extends State<Profile_main> {
  String? reg_id;
  String? userNick;
  var point_info;
  var point_limit;
  bool initFalg = false;

  final storage = FlutterSecureStorage();



  @override
  void initState() {
    super.initState();
    _asyncMethod().then((value){
      notification_check();
      getPoint();
      getPointLimit();
      initFalg = true;
      setState(() {

      });
    });

  }
  var adminChk = "";

  Future<dynamic> _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = await storage.read(key:'memberId');
    userNick = await storage.read(key:'memberNick');
    adminChk = (await storage.read(key:'memberAdminChk')) ?? "";

    return true;
  }
  void getPoint() async{
    print('get point call');
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberPoint.do',
      //'http://192.168.100.31:8080/mf/member/getMemberPoint.do',
    );

    try {
      Map data = {
        "memberId": reg_id,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(json.decode(response.body)['state'] == 200) {
        setState(() {
          point_info = json.decode(response.body)['result']['pointInfo']['RTN_POINT'];
        });

      }else {
        setState(() {
          point_info = 0;
        });
      }

    } catch(e) {
      print(e);

      setState(() {
        point_info = 0;
      });
    }

  }

  void getPointLimit() async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/point_limit.do',
      //'http://www.hoty.company/mf/common/point_limit.do',
    );

    try {
      Map data = {
        "member_id": reg_id,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(response.statusCode == 200) {
        setState(() {
          point_limit = json.decode(response.body)['result'];
        });

      }else {
        setState(() {
          point_limit = 0;
        });
      }

    } catch(e) {
      print(e);

      setState(() {
        point_limit = 0;
      });
    }

  }

  List<String> notificationList = [];
  List<String> getStorageData(String item) {
    final box = GetStorage();
    notificationList = List<String>.from(box.read(item) ?? []);
    return List<String>.from(box.read(item) ?? []);
  }
  void removeStorageData(String item) {
    final box = GetStorage();
    box.remove(item);
  }

  var notification_check_value = "N";
  Future<dynamic> notification_check () async {
    var result = [];

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/notification.do',
    );

    try {
      Map data = {
        "reg_id" : (await storage.read(key:'memberId')) ?? "",
        "table_nm" : '',
        "main_category" : '',
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        result = json.decode(response.body)['result'];
        setState(() {
          getStorageData("notification");
        });

        var notification = [];

        for(int i = 0; i < notificationList.length; i++) {
          if(notification.length == 0) {
            notification.add(notificationList[i]);
          }
          for(int j = 0; j < notification.length; j++) {
            if(!notification.contains(notificationList[i])) {
              notification.add(notificationList[i]);
            }
          }
        }
        setState(() {
          if(result.length == notification.length) {
            notification_check_value = "N";
          } else if(result.length > notification.length) {
            notification_check_value = "Y";
          }
        });

      }
    }
    catch(e){
      print(e);
    }
  }

  void ready(){
    showDialog(
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
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
                      "로그인 후 이용해주세요.",
                      style: TextStyle(
                        fontSize: 24 * (MediaQuery.of(context).size.width / 360),
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
                          Navigator.of(context).pop();
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
  }

  Container login(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding : EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
            // height: 20 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              children: [
                Text("좋은 아침이에요",style : TextStyle(
                  fontSize : 20 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.bold,
                ),
                ),
                Container(
                  margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                  child:  Image(image: AssetImage('assets/greetings_icon.png'),
                    width: 24 * (MediaQuery.of(context).size.width / 360) ,
                    // height: 30 * (MediaQuery.of(context).size.height / 360),
                  ),
                )

              ],
            ),
          ),
          if(userNick != null || userNick != '')
          Container(
            padding : EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 8  * (MediaQuery.of(context).size.height / 360)),
            // height: 10 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              children: [
                Text("$userNick",style : TextStyle(
                  fontSize : 15 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.w600,
                ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap : () {
              if(reg_id != null){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Profile_hoty_point();
                  },
                ));
              }
              if(reg_id == null){
                ready();
              }
            },
            child :  Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                  color: Color(0xffFFF3EA),
                ),
                child : Column(
                  children: [
                    Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(image: AssetImage("assets/coin.png"), height: 10 * (MediaQuery.of(context).size.height / 360),),
                            Container(
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1  * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text(' ${point_info ?? 0} P', style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 20 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515))),
                            )
                          ],
                        )
                    ),
                    Container(
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("적립 가능  ",  style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 11 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515))),
                            Container(
                              //width: 42 * (MediaQuery.of(context).size.width / 360),
                              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                  5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                                color: Color(0xff925331),
                              ),
                              child : Text("${point_limit ?? 0}", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w700, fontSize: 8 * (MediaQuery.of(context).size.width / 360), ),textAlign: TextAlign.center,),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
          ),
          GestureDetector(
            onTap: (){
              // Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return KinList(success: false, failed: false,main_catcode: '',);
                },
              ));
            },
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 50 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                color: Color(0xff0075FE),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container( //이미지
                      child : Image(image: AssetImage("assets/kin_icon.png"), width: 30 * (MediaQuery.of(context).size.width / 360),)
                  ),
                  Container( //글
                    width: 250 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("호치민 뭐든지 물어봐!",
                          style: TextStyle(
                              fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                              fontWeight: FontWeight.w800,
                              fontFamily: 'NanumSquareEB',
                              color: Color(0xffFFFFFF)
                          ),
                        ),
                        Text(" 지식iN",
                          style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              fontWeight: FontWeight.w800,
                              fontFamily: 'NanumSquareEB',
                              color: Color(0xff03E166)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container( //화살표
                    child: Icon(Icons.keyboard_arrow_right, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container non_login(BuildContext context) {
    return Container(
      child: Column(
        children: [
          /*Container(
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360) ),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 85 * (MediaQuery.of(context).size.height / 360),
            child : Image(image: AssetImage('assets/unlogin_banner_01.png')),
          ),*/
          Container(
            width: 330 * (MediaQuery.of(context).size.width / 360),
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            child : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                  padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                  )

              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    // return Profile_main_login();
                    return Login(subtitle : '마이페이지');
                  },
                ));
              },
              child: Text('로그인 / 회원가입', style: TextStyle(fontSize: 20, color: Color(0xffFFFFFF),
                  fontWeight: FontWeight.bold),),
            ),
          ),

        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight( 30 * (MediaQuery.of(context).size.height / 360)),
          child: Column(
            children: [
              AppBar(
                leadingWidth: 25 * (MediaQuery.of(context).size.width / 360),
                toolbarHeight: 30 * (MediaQuery.of(context).size.height / 360),
                leading:
                Container(
                  margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                  child: IconButton(icon: Icon(Icons.menu_rounded),
                    iconSize: 14 * (MediaQuery.of(context).size.height / 360),
                    color: Colors.black,
                    alignment: Alignment.centerLeft,
                    onPressed: (){
                      //Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MainMenuLogin();
                        },
                      )); //테스트
                      // showMiniGame2(context);
                    },
                  ),
                ),
                actions: [
                  IconButton(icon: Image(image: AssetImage("${notification_check_value == 'Y' ? 'assets/notification_on.png' : 'assets/notification_off.png'}"),width: 25 * (MediaQuery.of(context).size.width / 360),),
                    color: Colors.black,
                    alignment: Alignment.centerRight,
                    iconSize: 14 * (MediaQuery.of(context).size.height / 360),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          // return Intro();
                          // return Guide();
                          return MainNotification();
                        },
                      ));
                    },
                  ),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
                automaticallyImplyLeading: true,
               /* title: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MainPage();
                      },
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 1 * (MediaQuery.of(context).size.height / 360),),
                    width: 90 * (MediaQuery.of(context).size.width / 360),
                    height: 50 * (MediaQuery.of(context).size.height / 360),
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                ),
                centerTitle: true,*/
              ),
            ],
          )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if((reg_id == "" || reg_id == null) )
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        /*Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Login(subtitle: 'Main');
                },
              ));*/
                      },
                      child:Container( //배너 이미지
                        width: 330 * (MediaQuery.of(context).size.width / 360),
                        height: 90 * c_height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/unlogin_banner_01.png'),

                            // colorFilter: ColorFilter.mode(Color(0xffFF8A00), BlendMode.color),
                          ),
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                        ),
                      ),
                    ),
                    non_login(context),
                  ],
                ),
              ),
            if((reg_id != "" && reg_id != null) )
              login(context),
            Container(
              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width: 360 * (MediaQuery.of(context).size.width / 360),
              child: Column(
                children: [
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_apartment();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                // child : Image(image: AssetImage('assets/apartment_icon.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                                child:Icon(My_icons.my_01, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff2F67D3),),

                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("나의 아파트 관리",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 26 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_service_history();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_02, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff925331),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("서비스 신청 내역",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 26 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_my_post(table_nm : '', category: '',);
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_03, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff27AE60),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("내 게시물 보기",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_like(title_catcode: '', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_04, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffEB5757),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("좋아요",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfileCustomerService();
                        },
                      ));
                      /* if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileCustomerService();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }*/
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_05, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffE47421),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("고객센터",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                     /* if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileCustomerServiceDetail2(cms_menu_seq: 37, title: "서비스 이용약관");
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }*/
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfileCustomerServiceDetail2(cms_menu_seq: 37, title: "서비스 이용약관");
                        },
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [

                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_06, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff9B51E0),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("이용약관",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Profile_service_guide();
                        },
                      ));
                      /*if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_service_guide();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }*/
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [Container(
                              padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                              width: 30 * (MediaQuery.of(context).size.width / 360),
                              child:Icon(My_icons.my_07, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffFFC2C2),),
                            ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("이용방법안내",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileSetting();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_08, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff53B5BB),),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("설정",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileReport();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [Container(
                              padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                              width: 30 * (MediaQuery.of(context).size.width / 360),
                              child:Icon(My_icons.my_09, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffBBC964),),
                            ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("불편사항 접수",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  //group_seq 필요
                  if(reg_id != null && adminChk == 'Y')
                  TextButton(
                    onPressed: (){
                      if(reg_id != null){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileAdmin();
                          },
                        ));
                      }
                      if(reg_id == null){
                        ready();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child : Image(image: AssetImage('assets/report_inconvenience_icon.png'), width: (24 * (MediaQuery.of(context).size.width / 360))),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 180 * (MediaQuery.of(context).size.width / 360),
                                child: Text("관리자 메뉴",
                                  style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      color: Color(0xff0F1316),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          // width: 25 * (MediaQuery.of(context).size.width / 360),
                          child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                          // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                        ),
                      ],
                    ),
                  ),
                  if(reg_id != null && adminChk == 'Y')
                    Container(
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  Container(
                    width: 340 * (MediaQuery.of(context).size.width / 360),
                    height: 45 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      color: Color.fromRGBO(72, 36, 16, 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80 * (MediaQuery.of(context).size.width / 360),
                          child : Image(image: AssetImage('assets/kakaotalk.png'),
                            width: (25 * (MediaQuery.of(context).size.width / 360)),
                            height: (25 * (MediaQuery.of(context).size.height / 360)),
                          ),
                        ),
                        Container(
                          /*height : 6 * (MediaQuery.of(context).size.height / 360) ,*/
                          child :  DottedLine(
                            lineThickness: 1,
                            dashLength: 1.5,
                            dashColor: Color(0xffC4CCD0),
                            direction: Axis.vertical,
                          ),
                        ),
                        Container(
                          padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          width: 239 * (MediaQuery.of(context).size.width / 360),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 190 * (MediaQuery.of(context).size.width / 360),
                                height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Text('카카오 1:1 문의서비스 안내',
                                  style: TextStyle(
                                    fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                  ),
                                ),
                              ),
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 30 * (MediaQuery.of(context).size.height / 360),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('월요일 ~ 토요일 / 09:00 ~ 18:00\n(베트남시간)',
                                        style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          color: Colors.white,
                                          fontFamily: 'NanumSquareR',
                                          height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                        ),
                                      ),
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
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 8 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                  Follow_us(),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      40 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                  )

                ],
              ),
            ),


          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }

}