import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/profile/customer/profile_customer_service_detail2.dart';
import 'package:hoty/profile/profile_frequently_question.dart';
import 'package:hoty/profile/profile_partnership.dart';
import 'package:hoty/profile/profile_service_guide.dart';
import 'package:hoty/profile/profile_setting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hoty/main/main_page.dart';

import '../common/icons/my_icons.dart';
import 'customer/profile_customer_service_detail.dart';

class ProfileCustomerService extends StatefulWidget {
  const ProfileCustomerService({super.key});

  @override
  State<ProfileCustomerService> createState() => _ProfileCustomerServiceState();
}
class _ProfileCustomerServiceState extends State<ProfileCustomerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
          color: Colors.black,
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
        titleSpacing: 5,
        leadingWidth: 40,
        title: Container(

          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          alignment: Alignment.centerLeft,
          child: Text("고객센터" , style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360),  color: Colors.black, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.left,
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              // height: 25 * (MediaQuery.of(context).size.height / 360),
              //color: Colors.deepPurple,
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileCustomerServiceDetail(cat: 55, title: '자주하는 질문');
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
                            padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            child:Icon(My_icons.my_05,  size: 20 * (MediaQuery.of(context).size.width / 360), color: Color(0xffE47421),),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("자주하는 질문" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            /*Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              //color: Colors.deepPurple,
              child: TextButton(
                onPressed: (){
                  *//*Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileCustomerServiceDetail(cat: 56, title: "이메일 문의하기");
                    },
                  ));*//*
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            child:Icon(Icons.mail, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff2F67D3),),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("이메일 문의하기" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),*/
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              //color: Colors.deepPurple,
              child: TextButton(
                onPressed: (){
                  _launchURL("http://pf.kakao.com/_gYrxnG");

                  /*   Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileCustomerServiceDetail(cat: 57, title: "카카오톡 1:1 문의하기");
                    },
                  ));*/
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            //color: Colors.blue,
                            child: Image(image: AssetImage("assets/my_talk.png"),
                                width: 12 * (MediaQuery.of(context).size.width / 360),
                                height: 10 * (MediaQuery.of(context).size.height / 360)
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("카카오톡 1:1 문의하기" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              //color: Colors.deepPurple,
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfilePartnership();
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
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            //color: Colors.blue,
                            child: Image(image: AssetImage("assets/my_01.png"),
                                width: 8 * (MediaQuery.of(context).size.width / 360), height: 7 * (MediaQuery.of(context).size.height / 360)
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("제휴문의" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              //color: Colors.deepPurple,
              child: TextButton(
                onPressed: (){
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
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            //color: Colors.blue,
                            child: Image(image: AssetImage("assets/my_02.png"),
                                width: 8 * (MediaQuery.of(context).size.width / 360), height: 7  * (MediaQuery.of(context).size.height / 360)
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("서비스 이용약관" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              //color: Colors.deepPurple,
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileCustomerServiceDetail2(cms_menu_seq: 38, title: "개인정보처리방침");
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
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            //color: Colors.blue,
                            child: Image(image: AssetImage("assets/my_03.png"),
                                width: 8 * (MediaQuery.of(context).size.width / 360), height: 8 * (MediaQuery.of(context).size.height / 360)
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("개인정보처리방침" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
            Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //color: Colors.deepPurple,
              margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileCustomerServiceDetail2(cms_menu_seq: 39, title: "위치기반서비스 이용약관");
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
                            padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            child:Icon(My_icons.maker02, size: 18 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff53B5BB),),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                            //color: Colors.red,
                            child: Text("위치기반서비스 이용약관" ,
                              style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
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

            ),
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}