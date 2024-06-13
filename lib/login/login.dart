import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hoty/login/join.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../profile/customer/profile_customer_service_detail2.dart';
enum LoginPlatform {
  facebook,
  google,
  kakao,
  naver,
  apple,
  none, // logout
}


class Login extends StatefulWidget {
  final String subtitle;

  const Login({Key? key,
    required this.subtitle,
  }) : super(key:key);

  @override
  _Login createState() => _Login();

}

class _Login extends State<Login> {
  var accessToken = "";
  var userKey = "";
  var userEmail = "";
  var userName = "";
  var userPhone = "";
  var userNick = "";
  var userGender = "";
  var userBirthDay = "";
  bool flag = false;
  static final storage = FlutterSecureStorage();

  void goJoin() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Join(subtitle: '제목', snsKey: userKey, email: userEmail, name: userName, phone: userPhone, nick: userNick, gender: userGender, birthDay: userBirthDay, accessToken: accessToken);
      },
    ));
  }

  void goMain() {
    print('go main');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return MainPage();
      },
    ));
  }
  void signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final url = Uri.https('graph.facebook.com', '/v2.12/me',
          {'fields': 'email, name', 'access_token': result.accessToken!.token});

      final response = await http.get(url);

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

    }
  }

  void signInWithGoogle() async {
    print("Google API Start ");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    String? token = "";
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    if (googleUser != null) {
      print('get User Info Google ');
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');
      print(googleUser);

      userKey = googleUser.id;
      userName = googleUser.displayName!;
      userEmail = googleUser.email;
      accessToken = token ?? '';
      var url = Uri.parse(
        'http://www.hoty.company/mf/member/login.do',
        //'http://192.168.0.176:8080/mf/member/login.do',
      );

      try {
        Map data = {
          "authKey": userKey,
          "accessToken": accessToken
        };
        var body = json.encode(data);
        var response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: body
        );


        if(json.decode(response.body)['state'] == 200) {
          var result = json.decode(response.body)['result'];
          await storage.write(key: "memberNm", value: userName);
          await storage.write(key: "memberNick", value: userNick);
          await storage.write(key: "memberId", value: userKey);
          await storage.write(key : "memberAdminChk", value : result["ADMIN_CHECK"]);
          await storage.write(key : "memberInteresting", value : result["INTERESTING"]);
          goMain();
        }else if(json.decode(response.body)['state'] == 300){
          String msg = json.decode(response.body)['msg'];
          fail_dialog(msg);
        }else {
          goJoin();
        }
      } catch (e) {
        print(e);
      }

    } else {
      print('get User Info Google Null');
    }
  }

  void signInWithNaver() async {

    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    String? token = "";
    /*if (Platform.isAndroid) {*/
      token = await FirebaseMessaging.instance.getToken();
    /*} else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }*/
    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account}');
      print('id = ${result.account.id}');

      print("내 디바이스 토큰");
      print(token);

      userKey = result.account.id;
      userName = result.account.name;
      userPhone = result.account.mobile;
      userNick = result.account.nickname;
      userEmail = result.account.email;
      userBirthDay = result.account.birthyear+"-"+result.account.birthday;
      accessToken = token ?? '';
      var url = Uri.parse(
        'http://www.hoty.company/mf/member/login.do',
        //'http://192.168.0.176:8080/mf/member/login.do',
      );

      try {
        Map data = {
          "authKey": userKey,
          "accessToken": accessToken
        };
        var body = json.encode(data);
        var response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: body
        );


        if(json.decode(response.body)['state'] == 200) {
          var result = json.decode(response.body)['result'];
          await storage.write(key: "memberNm", value: userName);
          await storage.write(key: "memberNick", value: userNick);
          await storage.write(key: "memberId", value: userKey);
          await storage.write(key : "memberAdminChk", value : result["ADMIN_CHECK"]);
          await storage.write(key : "memberInteresting", value : result["INTERESTING"]);
          goMain();
        }else if(json.decode(response.body)['state'] == 300){
          String msg = json.decode(response.body)['msg'];
          fail_dialog(msg);
        }else {
          goJoin();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  /*
  *  카카오톡 소셜로그인
  *  카카오 개발자 비즈앱 전환후에 로그 찍어서 해당 데이터 각각 집어넣어 주면 끝
  *  현재 카카오에 등록된 앱은 일반앱이랑 비즈 앱 전환후 이메일 / 핸드폰번호 등등 가져올수있음
  *
  * */

  void signInWithKakao() async {

    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        User user = await UserApi.instance.me();
        kakaoLoingSuccess(user);
        print('해쉬값>>>>>>>>>');
        print(await KakaoSdk.origin);
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        print(await KakaoSdk.origin);
        print('해쉬값>>>>>>>>>');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          User user = await UserApi.instance.me();
          kakaoLoingSuccess(user);
          print('해쉬값>>>>>>>>>');
          print(await KakaoSdk.origin);
          print('카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          print(await KakaoSdk.origin);
          print('해쉬값>>>>>>>>>');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        User user = await UserApi.instance.me();
        kakaoLoingSuccess(user);
        print('해쉬값>>>>>>>>>');
        print(await KakaoSdk.origin);
        print('해쉬값>>>>>>>>>');
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        print(await KakaoSdk.origin);
        print('해쉬값>>>>>>>>>');
      }
    }
  }

  void kakaoLoingSuccess(User user) async {
    print(user);
    print(user.id);
    print(user.kakaoAccount?.profile?.nickname);
    String? token = "";
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    String? nick = user.kakaoAccount?.profile?.nickname;
    userKey = user.id.toString();
    userNick = nick!;
    accessToken = token ?? '';
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/login.do',
      //'http://192.168.0.176:8080/mf/member/login.do',
    );

    try {
      Map data = {
        "authKey": userKey,
        "accessToken": accessToken
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );


      if(json.decode(response.body)['state'] == 200) {
        var result = json.decode(response.body)['result'];
        await storage.write(key: "memberNm", value: userName);
        await storage.write(key: "memberNick", value: userNick);
        await storage.write(key: "memberId", value: userKey);
        await storage.write(key : "memberAdminChk", value : result["ADMIN_CHECK"]);
        await storage.write(key : "memberInteresting", value : result["INTERESTING"]);
        goMain();
      }else if(json.decode(response.body)['state'] == 300){
        String msg = json.decode(response.body)['msg'];
        fail_dialog(msg);
      }else {
        goJoin();
      }
    } catch (e) {
      print(e);
    }
  }

  void appleLoingSuccess(AuthorizationCredentialAppleID user) async {
    print("User ###:::: ${user}");
    String? token = "";
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    String? nick = "";
    userKey = user.userIdentifier!;
    userNick = nick!;
    accessToken = token ?? '';
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/login.do',
      //'http://192.168.0.176:8080/mf/member/login.do',
    );

    try {
      Map data = {
        "authKey": userKey,
        "accessToken": accessToken
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );


      if(json.decode(response.body)['state'] == 200) {
        var result = json.decode(response.body)['result'];
        await storage.write(key: "memberNm", value: userName);
        await storage.write(key: "memberNick", value: userNick);
        await storage.write(key: "memberId", value: userKey);
        await storage.write(key : "memberAdminChk", value : result["ADMIN_CHECK"]);
        await storage.write(key : "memberInteresting", value : result["INTERESTING"]);
        goMain();
      }else if(json.decode(response.body)['state'] == 300){
        String msg = json.decode(response.body)['msg'];
        fail_dialog(msg);
      }else {
        goJoin();
      }
    } catch (e) {
      print(e);
    }
  }


  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30 * (MediaQuery.of(context).size.height / 360),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                  leadingWidth: 25 * (MediaQuery.of(context).size.width / 360),
                  toolbarHeight: 30 * (MediaQuery.of(context).size.height / 360),
                  backgroundColor: Color.fromRGBO(245, 245, 245, 100),
                  elevation: 0,
                  // titleSpacing: 10 * (MediaQuery.of(context).size.width / 360),
                  automaticallyImplyLeading: true,
                  /*iconTheme: IconThemeData(
            color: Colors.black,
          ),*/
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
                // centerTitle: false,
              ),
            ],
          )
      ),
      body:  Container(
        color: Color.fromRGBO(245, 245, 245, 100),
        // width: double.infinity,
        // height: double.infinity,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/sign_bg.png')
          )
        ),*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
     /*       Container(
              width: 15 * (MediaQuery.of(context).size.width / 360),
              height: 10 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                iconSize: 12  * (MediaQuery.of(context).size.height / 360),
                color: Colors.white,
                alignment: Alignment.centerLeft,
                // padding: EdgeInsets.zero,
                // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
                onPressed: (){

                  //Navigator.pop(context);
                },
              ),
            ),*/
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    child: Text("호치민", style: TextStyle(
                      fontSize: 30 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                      color: Color(0xff151515),
                      fontFamily: 'NanumSquareEB',
                    ), textAlign: TextAlign.center),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB( 10 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                    child: Text("생활의 시작", style: TextStyle(
                      fontSize: 30 * (MediaQuery.of(context).size.width / 360),
                      color: Color(0xff151515),
                      fontFamily: 'NanumSquareR',
                      //fontWeight: FontWeight.bold,
                    ), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Container(
              // width: 100 * (MediaQuery.of(context).size.width / 360),
              height: 44 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360),
                  0, 25 * (MediaQuery.of(context).size.height / 360)),
              child: Image(image: AssetImage('assets/logo.png')),
            ),

            Container(
              width: 320  * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                0,
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: GestureDetector(
                onTap: signInWithKakao,

                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      width: 40 * (MediaQuery.of(context).size.width / 360),
                      /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login01.png'),
                          // fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      // child: Image(image: AssetImage('assets/kakaotalk02.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text('Kakao 으로 로그인', style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                        color: Color(0xff151515),
                      )),
                    )
                  ],
                ),

              ),
            ),
            Container(
              width: 320  * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                0,
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: GestureDetector(
                onTap: signInWithNaver,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      width: 40 * (MediaQuery.of(context).size.width / 360),
                      /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login02.png'),
                          // fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      // child: Image(image: AssetImage('assets/kakaotalk02.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text('Naver 으로 로그인', style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                        color: Color(0xff151515),
                      )),
                    )
                  ],
                ),

              ),
            ),
            Container(
              width: 320  * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                0,
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: GestureDetector(
                onTap: signInWithGoogle,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      width: 40 * (MediaQuery.of(context).size.width / 360),
                      /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login03.png'),
                          // fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      // child: Image(image: AssetImage('assets/kakaotalk02.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text('Gmail 으로 로그인', style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                        color: Color(0xff151515),
                      )),
                    )
                  ],
                ),

              ),
            ),
            Container(
              width: 320  * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                0,
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: GestureDetector(
                onTap: (){
                  SignInWithApple.getAppleIDCredential(
                      scopes: [
                        // 사용할 사용자 정보 범위
                        AppleIDAuthorizationScopes.email,
                        AppleIDAuthorizationScopes.fullName,
                      ],
                      webAuthenticationOptions: WebAuthenticationOptions(
                          clientId: "com.hotyvn.hoty-web",
                          redirectUri: Uri.parse("https://hoty-65cd7.firebaseapp.com/__/auth/handler")
                      )
                  ).then((AuthorizationCredentialAppleID user) {
                    print("애플 로그인 체크");
                    print(user);

                    appleLoingSuccess(user);

                    // 로그인 후 로직
                  }).onError((error, stackTrace) {
                    if (error is PlatformException) return;
                    print(error);
                  });
                },
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      width: 40 * (MediaQuery.of(context).size.width / 360),
                      /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login04.png'),
                          // fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      // child: Image(image: AssetImage('assets/kakaotalk02.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(40 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text('Apple 으로 로그인', style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                        color: Color(0xff151515),
                      )),
                    )
                  ],
                ),

              ),
            ),
            Container(
              width: 320  * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                0,
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: GestureDetector(
                onTap: signInWithFacebook,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      width: 40 * (MediaQuery.of(context).size.width / 360),
                      /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login05.png'),
                          // fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      // child: Image(image: AssetImage('assets/kakaotalk02.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30 * (MediaQuery.of(context).size.width / 360),
                        0 * (MediaQuery.of(context).size.height / 360),
                        0,
                        0 * (MediaQuery.of(context).size.height / 360),
                      ),
                      child: Text('Facebook 으로 로그인', style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                        color: Color(0xff151515),
                      )),
                    ),
                  ],
                ),

              ),
            ),


            Container(
              width: 360 * (MediaQuery.of(context).size.height / 360) ,
              margin: EdgeInsets.fromLTRB(0, 20 * (MediaQuery.of(context).size.height / 360), 0, 0),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                        5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360),
                        3 * (MediaQuery.of(context).size.height / 360)),
                    child: Text('가입을 진행할 경우, 아래의 정책에 동의한 것으로 간주됩니다.', style: TextStyle(
                      fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                      color: Color(0xff151515),
                      fontFamily: 'NanumSquareB',
                    ), textAlign: TextAlign.center),
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) {
                             return ProfileCustomerServiceDetail2(cms_menu_seq: 37, title: "서비스 이용약관");
                           },
                         ));
                       },
                       child: Container(
                         child: Text('서비스이용약관', style: TextStyle(
                           fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                           // fontWeight: FontWeight.bold,

                           color: Color(0xffC4CCD0),
                           fontFamily: 'NanumSquareB',
                         ), textAlign: TextAlign.center),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){

                       },
                       child: Container(
                         child: Text(' 및 ', style: TextStyle(
                           fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                           // fontWeight: FontWeight.bold,
                           color: Color(0xffC4CCD0),
                           fontFamily: 'NanumSquareB',
                         ), textAlign: TextAlign.center),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) {
                             return ProfileCustomerServiceDetail2(cms_menu_seq: 38, title: "개인정보처리방침");
                           },
                         ));
                       },
                       child: Container(
                         child: Text('개인정보처리방침', style: TextStyle(
                           fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                           // fontWeight: FontWeight.bold,

                           color: Color(0xffC4CCD0),
                           fontFamily: 'NanumSquareB',
                         ), textAlign: TextAlign.center),
                       ),
                     ),
                   ],
                 ),
                ],
              ),
            )

            /*  Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              // height: 30 * (MediaQuery.of(context).size.height / 360),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4 * (MediaQuery.of(context).size.height / 360))
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                  elevation: 0,
                ),
                onPressed: signInWithKakao,
                child: Row(
                  children: [
                    Container(
                      width: 40 * (MediaQuery.of(context).size.width / 360),
                      height: 15 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/login01.png'),
                          // fit: BoxFit.cover
                        ),
                        // borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      // child: Image(image: AssetImage('assets/kakaotalk02.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                      child: Text(""),
                    ),
                    Text('Kakao 으로 로그인', style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff151515),
                      fontFamily: 'NanumSquareB',
                    )),
                  ],
                ),
              ),
            ),*/

            /* Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4 * (MediaQuery.of(context).size.height / 360))
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                  elevation: 0,
                ),
                onPressed: signInWithNaver,
                child: Row(
                  children: [
                    Container(
                      width: 30 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Image(image: AssetImage('assets/Naver.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                      child: Text(""),
                    ),
                    Text('Naver 으로 로그인', style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff151515),
                        fontFamily: 'NanumSquareB',
                    ), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4 * (MediaQuery.of(context).size.height / 360))
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                  elevation: 0,
                ),
                onPressed: signInWithGoogle,
                child: Row(
                  children: [
                    Container(
                      width: 30 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Image(image: AssetImage('assets/Google.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                      child: Text(""),
                    ),
                    Text('Gmail 으로 로그인', style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff151515),
                        fontFamily: 'NanumSquareB',
                    ), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4 * (MediaQuery.of(context).size.height / 360))
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                  elevation: 0,
                ),
                onPressed: () async {
                  SignInWithApple.getAppleIDCredential(
                      scopes: [
                        // 사용할 사용자 정보 범위
                      ],
                    webAuthenticationOptions: WebAuthenticationOptions(
                        clientId: "clientId",
                        redirectUri: Uri.parse("redirectURL")
                    )
                  ).then((AuthorizationCredentialAppleID user) {
                    print("애플 로그인 체크");
                    print(user);
                    // 로그인 후 로직
                  }).onError((error, stackTrace) {
                    if (error is PlatformException) return;
                    print(error);
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 30 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Image(image: AssetImage('assets/Apple.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                      child: Text(""),
                    ),
                    Text('Apple 으로 로그인', style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff151515),
                        fontFamily: 'NanumSquareB',
                    ), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4 * (MediaQuery.of(context).size.height / 360))
                  ),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                  elevation: 0,
                ),
                onPressed: signInWithFacebook,
                child: Row(
                  children: [
                    Container(
                      width: 30 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Image(image: AssetImage('assets/Facebook.png')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                      child: Text(""),
                    ),
                    Text('Facebook 으로 로그인', style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff151515),
                        fontFamily: 'NanumSquareB',
                    ), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text('가입을 진행할 경우, 아래의 정책에 동의한 것으로 간주됩니다.', style: TextStyle(
                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                fontWeight: FontWeight.bold,
                color: Color(0xff151515),
                fontFamily: 'NanumSquareB',
              ), textAlign: TextAlign.center),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text('서비스이용약관 및 개인정보처2리방침', style: TextStyle(
                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                // fontWeight: FontWeight.bold,

                color: Color(0xffC4CCD0),
                fontFamily: 'NanumSquareB',
              ), textAlign: TextAlign.center),
            ),*/
          ],
        ),

      ),
      /*floatingActionButton : SizedBox(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text('가입을 진행할 경우, 아래의 정책에 동의한 것으로 간주됩니다.', style: TextStyle(
                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                fontWeight: FontWeight.bold,
                color: Color(0xff151515),
                fontFamily: 'NanumSquareB',
              ), textAlign: TextAlign.center),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text('서비스이용약관 및 개인정보처2리방침', style: TextStyle(
                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                // fontWeight: FontWeight.bold,

                color: Color(0xffC4CCD0),
                fontFamily: 'NanumSquareB',
              ), textAlign: TextAlign.center),
            )
          ],
        )
      )*/
    );
  }

  void fail_dialog(String msg){
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
              height: 100 * (MediaQuery.of(context).size.height / 360),
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
                      msg,
                      style: TextStyle(
                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      10 * (MediaQuery.of(context).size.width / 360),
                      15 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Container(
                      width: 130 * (MediaQuery.of(context).size.width / 360),
                      height: 29 * (MediaQuery.of(context).size.height / 360),
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
                            "Close",
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
      goJoin();
    });
  }
}
