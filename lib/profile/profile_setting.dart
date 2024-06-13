import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_account_setting.dart';
import 'package:hoty/profile/profile_app_push.dart';
import 'package:hoty/profile/profile_language.dart';

import '../common/dialog/loginAlert.dart';

class ProfileSetting extends StatefulWidget {

  static final storage = FlutterSecureStorage();

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String? regist_id;

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await ProfileSetting.storage.read(key:'memberId'))!;
  }

  void removeStorageData(String item) {
    final box = GetStorage();
    box.remove(item);
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
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("설정" , style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360),  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileAccount();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          width: 30 * (MediaQuery.of(context).size.width / 360),
                          child : Image(image: AssetImage('assets/setting_icon.png'),  height: 9 * (MediaQuery.of(context).size.height / 360), color: Color(0xffE47421),),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 , 0 ),
                          child: Text("회원정보 설정",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    // width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
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
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileLanguage();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          width: 30 * (MediaQuery.of(context).size.width / 360),
                          child : Image(image: AssetImage('assets/language.png'), height: (9 * (MediaQuery.of(context).size.height / 360)), color: Color(0xff27AE60),),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 , 0 ),
                          child: Text("언어 설정",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
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
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileAppPush();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          width: 30 * (MediaQuery.of(context).size.width / 360),
                          child : Image(image: AssetImage('assets/app_push_icon.png'), height: (9 * (MediaQuery.of(context).size.height / 360)), color: Color(0xff53B5BB),),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 , 0 ),
                          child: Text("앱 푸시 설정",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(// width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
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
            TextButton(
              onPressed: () async{
                await ProfileSetting.storage.delete(key: "memberId");
                await ProfileSetting.storage.delete(key: "memberNick");
                await ProfileSetting.storage.delete(key: "memberNm");
                removeStorageData('notification');
                logout_dialog();
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          width: 30 * (MediaQuery.of(context).size.width / 360),
                          child : Image(image: AssetImage('assets/logout.png'), height: (9 * (MediaQuery.of(context).size.height / 360)), color: Color(0xffEB5757),),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 , 0 ),
                          child: Text("로그아웃",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(

                    // width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
         /*   Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),*/

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

  void logout_dialog(){
    showDialog(
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return logoutalert(context, '로그아웃 되었습니다.');
      },
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MainPage();
        },
      ));
    });
  }
}