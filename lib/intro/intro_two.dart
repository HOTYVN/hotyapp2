import 'package:flutter/material.dart';
import 'package:hoty/guide/guide.dart';
import 'package:hoty/intro/intro_one.dart';
import 'package:hoty/intro/intro_three.dart';
import 'package:hoty/login/login.dart';
import 'package:hoty/main/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroTwo extends StatelessWidget {
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
                        skipTutorial();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Guide();
                            // return MainPage();
                          },
                        ));
                      },
                      child: Text('건너뛰기', style: TextStyle(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/intro2.png'),
                    fit: BoxFit.cover
                )
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.fromLTRB(0, 190 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('호치민 거주자들의\n커뮤니티를 이용 해보세요', style: TextStyle(
                          fontSize: 28 * (MediaQuery.of(context).size.width / 360),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'NanumSquareEB'
                      ), textAlign: TextAlign.center),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      ),
                      Text('중고거래, 개인과외, 자유게시판 둘러보기', style: TextStyle(
                          fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                          color: Color.fromRGBO(228, 116, 33, 1),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'NanumSquareEB'
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
                        child: Image(image: AssetImage('assets/intro_page2.png')),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100 * (MediaQuery.of(context).size.width / 360),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 10 * (MediaQuery.of(context).size.height / 360)),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        backgroundColor: Color.fromRGBO(243, 246, 248, 1),
                        padding: EdgeInsets.symmetric(horizontal: 8 * (MediaQuery.of(context).size.height / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      icon: Icon(Icons.arrow_back, color: Colors.black, size: 18 * (MediaQuery.of(context).size.width / 360),),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return IntroOne();
                          },
                        ));
                      },
                      label: Text('뒤로', style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), fontFamily: 'NanumSquareR', fontWeight: FontWeight.w700, color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 100 * (MediaQuery.of(context).size.width / 360),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                        backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                        padding: EdgeInsets.symmetric(horizontal: 8 * (MediaQuery.of(context).size.height / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return IntroThree();
                          },
                        ));
                      },
                      child: Row(
                        children: [
                          Text('다음', style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), fontFamily: 'NanumSquareR', fontWeight: FontWeight.w700, color: Colors.white)),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 3 * (MediaQuery.of(context).size.height / 360), 0),
                            child: Text(""),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 18 * (MediaQuery.of(context).size.width / 360),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}