import 'package:flutter/material.dart';

class Nodata extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
    Container(
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: [
          Container(
            width: 185 * (MediaQuery.of(context).size.width / 360),
            height: 110 * (MediaQuery.of(context).size.height / 360),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/map_search.png'),
                // fit: BoxFit.cover
              ),
            ),
            // color: Colors.amberAccent,
          ),
          Container(
            child: Text(
              "게시물이 없습니다.",
              style: TextStyle(
                fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                color: Color(0xff151515),
                fontWeight: FontWeight.bold,
                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
              ),
            ),
          ),
        ],
      ),
    );
  }

}