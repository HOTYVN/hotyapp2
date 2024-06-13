import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../community/dailytalk/community_dailyTalk.dart';
import '../../community/privatelesson/lesson_list.dart';
import '../../kin/kinlist.dart';
import '../../profile/profile_my_post.dart';



// 등록완료
AlertDialog adoptalert(BuildContext context) {
  return AlertDialog(
    elevation: 0,
    insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
    // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)),
    title : Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      child: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360) ),
          width: 50 * (MediaQuery.of(context).size.width / 360),
          child: Wrap(
            children: [
              // Image(image: AssetImage('assets/writecompl.png')),
              Image(image: AssetImage('assets/check_circle.png')),
            ],
          ),
        ),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "등록이 완료되었습니다.",
            style: TextStyle(
                fontFamily: "NanumSquareR",
                fontWeight: FontWeight.bold,
                fontSize: 16 * (MediaQuery.of(context).size.width / 360)
            ),
          ),
        ),
      ],
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    actions: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360)),
          padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xffE47421),
                    padding: EdgeInsets.symmetric(horizontal: 22 * (MediaQuery.of(context).size.width / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                    ),
                    side: BorderSide(width:2, color:Color(0xffE47421)), //border width and color
                    elevation: 0
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 220 * (MediaQuery.of(context).size.width / 360),
                  padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("확인",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          )
      )
    ],
  );
}
// 삭제확인 text
AlertDialog deletechecktext(BuildContext context,text) {
  return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
    insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
    ),
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
/*
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
*/
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
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    actions: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("아니요",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("예",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}

AlertDialog deletechecktext2(BuildContext context,text, notext, yestext) {
  return AlertDialog(
    elevation: 0,
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
                fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                height: 0.7 * (MediaQuery.of(context).size.height / 360),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    actions: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  child : Text(notext,
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  child : Text(yestext,
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}


// 텍스트 얼랏(경고)
AlertDialog textalert(BuildContext context, text) {
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
                    child : Text("확인",
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
// 텍스트 얼랏(완료)
AlertDialog textalert2(BuildContext context, text) {
  return
    AlertDialog(
        insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
                width: 40 * (MediaQuery.of(context).size.width / 360),
                child: Wrap(
                  children: [
                    Image(image: AssetImage('assets/check_circle.png')),
                  ],
                ),
              ),
            ),
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
      ),
      contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    child : Text("확인",
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

AlertDialog textlimitalert(BuildContext context, text) {
  return
    AlertDialog(
        insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
      ),
      contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
      actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                    child : Text("확인",
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





AlertDialog listalert(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  Image(image: AssetImage('assets/check_circle.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "마지막 게시글입니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  child : Text("확인",
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

AlertDialog deletecheck(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  Image(image: AssetImage('assets/Vector.png')),
                  // Image(image: AssetImage('assets/check_circle.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "게시글을 삭제 하시겠습니까?",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}

AlertDialog deletecheck2(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
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
              "댓글을 삭제 하시겠습니까?",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}


AlertDialog delalert(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
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
              "삭제 처리가 완료되었습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  child : Text("확인",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          )
      )
    ],
  );
}

AlertDialog delalert2(BuildContext context) {
  return AlertDialog(elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
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
              "취소 처리가 완료되었습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  child : Text("확인",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          )
      )
    ],
  );
}

// 작성 취소
AlertDialog writeback(BuildContext context, subtitle) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
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
              "게시글 작성을 취소 하시겠습니까?",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    actions: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xffE47421),
                    padding: EdgeInsets.symmetric(horizontal: 16 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360))
                    ),
                    side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}

// 제휴문의 등록
AlertDialog partnershipalert(BuildContext context,text) {
  return AlertDialog(
    elevation: 0,
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
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "NanumSquareR",
              fontWeight: FontWeight.bold,
              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    actions: <Widget>[
      Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("돌아가기",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("신청하기",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}

// 서비스취소
AlertDialog servicedel(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
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
              "서비스를 취소 하시겠습니까?",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);

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
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      )
    ],
  );
}


// 작성 완료
AlertDialog writecomplete(BuildContext context, subtitle, table_nm, category) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              // width: 120 * (MediaQuery.of(context).size.width / 360),
              width: 40 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  // Image(image: AssetImage('assets/writecompl.png')),
                  Image(image: AssetImage('assets/check_circle.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "게시물이 등록되었습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("목록",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  if(subtitle == 'KinList'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:KinList(success: false, failed: false,main_catcode: '',),
                        );
                      },
                    ));
                  }
                  if(subtitle == 'Trade'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:TradeList(checkList: []),
                        );
                      },
                    ));
                  }
                  if(subtitle == 'LessonList'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:LessonList(checkList: []),
                        );
                      },
                    ));
                  }
                  if(subtitle == 'CommunityDailyTalk'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:CommunityDailyTalk(main_catcode: 'F101',),
                        );
                      },
                    ));
                  }
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("내 게시물 보기",
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
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MaterialApp(
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
                        home: Profile_my_post(table_nm: table_nm, category: category,),
                      );

                    },
                  ));
                },
              )
            ],
          )
      )
    ],
  );
}

// 지식인 글작성
AlertDialog writecomplete2(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              // width: 120 * (MediaQuery.of(context).size.width / 360),
              width: 40 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  // Image(image: AssetImage('assets/writecompl.png')),
                  Image(image: AssetImage('assets/check_circle.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "게시물이 등록되었습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("목록",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context,"list");

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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("내 게시물 보기",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context,"view");
                },
              )
            ],
          )
      )
    ],
  );
}

AlertDialog writecomplete3(BuildContext context, subtitle, table_nm, category) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  Image(image: AssetImage('assets/check_circle.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "게시물이 등록되었습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("목록",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  print(subtitle);
                  print("subtitle@@@@@@");
                  if(subtitle == 'KinList'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:KinList(success: false, failed: false,main_catcode: '',),
                        );
                      },
                    ));
                  }
                  if(subtitle == 'Trade'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:TradeList(checkList: []),
                        );
                      },
                    ));
                  }
                  if(subtitle == 'LessonList'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:LessonList(checkList: []),
                        );
                      },
                    ));
                  }
                  if(subtitle == 'CommunityDailyTalk'){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MaterialApp(
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
                          home:CommunityDailyTalk(main_catcode: 'F101',),
                        );
                      },
                    ));
                  }
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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("내 게시물 보기",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.canPop(context);
                  Navigator.canPop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MaterialApp(
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
                        home: Profile_my_post(table_nm: table_nm, category: category,),
                      );

                    },
                  ));
                },
              )
            ],
          )
      )
    ],
  );
}

// 지식인 글수정
AlertDialog modifycomplete2(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
              width: 40 * (MediaQuery.of(context).size.width / 360),
              child: Wrap(
                children: [
                  Image(image: AssetImage('assets/writecompl.png')),
                  Image(image: AssetImage('assets/check_circle.png')),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "게시물이 수정되었습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  /*padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),*/
                  child : Text("목록",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context,"list");

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
                  // padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                  child : Text("내 게시물 보기",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context,"view");
                },
              )
            ],
          )
      )
    ],
  );
}

//앱 버전 알럿
AlertDialog versionAlert(BuildContext context) {
  return AlertDialog(
    elevation: 0,
      insetPadding: EdgeInsets.fromLTRB(30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
        30  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
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
          Container(
            alignment: Alignment.center,
            child: Text(
              "앱의 최신 버전이 등록되었습니다.\n앱 업데이트를 진행해 주세요.\n앱 업데이트를 진행하지 않는 경우\n서비스를 이용하실수 없습니다.",
              style: TextStyle(
                  fontFamily: "NanumSquareR",
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * (MediaQuery.of(context).size.width / 360)
              ),
            ),
          ),
        ],
      ),
    ),
    contentPadding: EdgeInsets.all(7 * (MediaQuery.of(context).size.height / 360)),
    actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                  child : Text("업데이트",
                    style: TextStyle(
                        color: Color(0xffE47421),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () async {
                  var url = "";
                  if (Platform.isAndroid) {
                    url = "https://play.google.com/store/apps/details?id=com.hotyvn.hoty";
                  } else if (Platform.isIOS) {
                    url = "http://apps.apple.com/kr/app/com.hotyvn.hoty/id=com.hotyvn.hoty";
                  }
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
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
                  child : Text("종료",
                    style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontFamily: "NanumSquareR",
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360)
                    ),
                  ),
                ),
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }

                  // Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )
      ),
    ],
  );
}