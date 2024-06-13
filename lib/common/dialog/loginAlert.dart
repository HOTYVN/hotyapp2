import 'package:flutter/material.dart';
import 'package:hoty/common/dialog/showDialog_modal.dart';

import '../../login/login.dart';

AlertDialog loginalert(BuildContext context, subtitle) {
  return AlertDialog(
    // insetPadding: EdgeInsets.all(25),
    // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
    content: Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360) ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360) ),
              width: 55 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  Image(image: AssetImage('assets/Vector.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "로그인이 필요한 기능입니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "로그인 하시겠습니까?",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          )
        ],
      ),
    ),
    actions: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xffFFFFFF),
                    padding: EdgeInsets.symmetric(horizontal: 16 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                    ),
                    side: BorderSide(width:2, color:Color(0xffE47421)), //border width and color
                    elevation: 0
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 100 * (MediaQuery.of(context).size.width / 360),
                  // padding: EdgeInsets.symmetric(horizontal: 15 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("아니요",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xffE47421),
                    padding: EdgeInsets.symmetric(horizontal: 16 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                    ),
                    side: BorderSide(width:2, color:Color(0xffE47421)), //border width and color
                    elevation: 0
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 100 * (MediaQuery.of(context).size.width / 360),
                  // padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("예",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      /*return  MaterialApp(
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
                        home:goroute('loginalert',subtitle),
                      );*/
                      return AlertPageRoute(context,'loginalert' , subtitle);
                    },
                  ));
                },
              ),
              // SizedBox(width: 7 * (MediaQuery.of(context).size.width / 360)),
              /*TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xffE47421),
                    padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                    ),
                    side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                    elevation: 0
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 43 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("예", style: TextStyle(color: Color(0xffFFFFFF)),),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Login(subtitle: subtitle);
                    },
                  ));
                },
              ),*/
            ],
          )
      )
    ],
  );
}

// 텍스트 얼랏(경고)
AlertDialog logoutalert(BuildContext context, text) {
  return
    AlertDialog(
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
          30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      title : Container(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        child: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360) ),
            width: 40 * (MediaQuery.of(context).size.width / 360),
            child: Wrap(
              children: [
                // Image(image: AssetImage('assets/writecompl.png')),
                Image(image: AssetImage('assets/Vector.png')),
              ],
            ),
          ),
        ),
      ),
      contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
            margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
            child : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xffE47421),
                      padding: EdgeInsets.symmetric(horizontal: 22 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                      ),
                      side: BorderSide(width:2, color:Color(0xffE47421)), //border width and color
                      elevation: 0
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 220 * (MediaQuery.of(context).size.width / 360),
                    // padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child : Text("홈으로 이동하기",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontFamily: "NanumSquareR",
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
        )
      ],
    );
}