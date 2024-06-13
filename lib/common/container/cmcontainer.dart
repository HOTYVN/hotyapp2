import 'package:flutter/material.dart';


Container filtertip(BuildContext context) {
  return Container(
    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
    width: 360 * (MediaQuery.of(context).size.width / 360),
    height: 45 * (MediaQuery.of(context).size.height / 360),
    decoration: BoxDecoration(
      border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1)
      ),
      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
      color: Color.fromRGBO(243, 246, 248, 1),
    ),

    child: Column(
      children: [
        Container(
          width: 350 * (MediaQuery.of(context).size.width / 360),
          // height: 15 * (MediaQuery.of(context).size.height / 360),
          padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
          child: Text("TIP!", style: TextStyle(
            fontSize: 16,
            fontFamily: 'NanumSquareR',
            fontWeight: FontWeight.w800,
          ),
          ),
        ),
        Container(
          width: 350 * (MediaQuery.of(context).size.width / 360),
          // height: 20 * (MediaQuery.of(context).size.height / 360),
          padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
              20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
          child: Text("원하시는 카테고리를 선택하면 세부 선택 필터를 볼수있어요.", style: TextStyle(
            fontSize: 14,
            height: 0.8 * (MediaQuery.of(context).size.height / 360),
            fontFamily: 'NanumSquareR',
          ),
          ),
        ),
      ],
    ),
  );
}