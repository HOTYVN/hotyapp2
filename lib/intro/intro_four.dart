import 'package:flutter/material.dart';
import 'package:hoty/guide/guide.dart';
import 'package:hoty/login/login.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/main/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroFour extends StatelessWidget {
  void skipTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstRun', false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( 45 * (MediaQuery.of(context).size.height / 360)),
        child: Column(
          children: [
            Container(
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0, 15 * (MediaQuery.of(context).size.height / 360),0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 120 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.centerLeft,
                    // color: Colors.red,
                  ),
                  Container(
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    //height: 110 * (MediaQuery.of(context).size.height / 360),
                    // margin: EdgeInsets.fromLTRB(0, 0, 30 * (MediaQuery.of(context).size.height / 360), 0),
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                  Container(
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            /*return Guide();*/
                            return MainPage();
                          },
                        ));
                      },
                      child: Text('', style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff2F67D3),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareR',
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 1000 * (MediaQuery.of(context).size.width / 360),
              height: 160 * (MediaQuery.of(context).size.height / 360),
              child: Image(image: AssetImage('assets/intro4.png')),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(0, 15 * (MediaQuery.of(context).size.height / 360), 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('호치민 생활 필수앱\nHOTY', style: TextStyle(
                    fontSize: 28 * (MediaQuery.of(context).size.width / 360),
                    fontWeight: FontWeight.w800,
                    fontFamily: 'NanumSquareEB',
                  ), textAlign: TextAlign.center),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  ),
                  Text('부동산, 비자 대행, 통역 신청하기', style: TextStyle(
                    fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                    color: Color.fromRGBO(228, 116, 33, 1),
                    fontWeight: FontWeight.w800,
                    fontFamily: 'NanumSquareEB',
                  ), textAlign: TextAlign.center)
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 9 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    width: 70 * (MediaQuery.of(context).size.width / 360),
                    height: 4 * (MediaQuery.of(context).size.height / 360),
                    child: Image(image: AssetImage('assets/intro_page4.png')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0,
            10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
        width: (MediaQuery.of(context).size.width),
        height: 30 * (MediaQuery.of(context).size.height / 360),
        decoration: BoxDecoration(
          color:  Color.fromRGBO(228, 116, 33, 1), // Container의 배경색
          borderRadius: BorderRadius.circular(15), // 둥근 모서리 설정
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            backgroundColor: Color.fromRGBO(228, 116, 33, 1),
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.height / 360), vertical: 6 * (MediaQuery.of(context).size.height / 360)),
          ),
          onPressed: (){
            skipTutorial();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                // return Login();
                return Guide();
                /*return MainPage();*/
              },
            ));
          },
          child: Text('지금 시작하세요!', style: TextStyle(fontSize: 18, fontFamily: 'NanumSquareR', fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ),
    );
  }
}