import 'package:flutter/material.dart';

class CgvTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Container(
          width: 350 * (MediaQuery.of(context).size.width / 360),
          height: 985 * (MediaQuery.of(context).size.height / 360),
          margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 25 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(24)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 100 * (MediaQuery.of(context).size.width / 360),
                                    height: 25 * (MediaQuery.of(context).size.height / 360),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:AssetImage("assets/cgv.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 25 * (MediaQuery.of(context).size.height / 360),
                            //padding: const EdgeInsets.all(10),
                            padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              //mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'Cinema type',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 16,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 40 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Su Van Hanh',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w600,
                                              height: 1.5
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'D10',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 16,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                            height: 0.7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 40 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD, STARIUM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w400,
                                        height : 1.5
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Hung Vuong Plaza',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w600,
                                              height: 1.5
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D5',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD, GOLD CLASS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w400,
                                        height : 1.5
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Aeon Binh Tan',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'binh Tan',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Crescent Mall',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D7',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'CINELIVING ROOM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Ly Chinh Thang',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D3',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Vincom Go Vap',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Go Vap',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Menas Mall (CGV CT Plaza)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Tan Binh',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Pearl Plaza',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Binh Thanh',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Vincom Center Landmark 81',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Binh Thanh',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Pandora City',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Tan Phu',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Aeon Tan Phu',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Tan Phu',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Satra Cu Chi',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Cu Chi',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Vincom Thu Duc',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Thu Duc',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD, STARIUM',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Vivo City',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D7',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'CINESUITE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Giga Mall Thu Duc',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Thu Duc',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Saigonres Nguyen Xi',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Binh Thanh',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV  Thao Dien Pearl',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D2',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Liberty Citypoint',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D1',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'STANDARD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            'CGV Vincom Dong Khoi',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF0F1316),
                                              fontSize: 14,
                                              fontFamily: 'NanumSquareRound',
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'D1',
                                          style: TextStyle(
                                            color: Color(0xFF0F1316),
                                            fontSize: 14,
                                            fontFamily: 'NanumSquareRound',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Text(
                                      'GOLD CLASS',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0F1316),
                                        fontSize: 14,
                                        fontFamily: 'NanumSquareRound',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35 * (MediaQuery.of(context).size.height / 360),
                        padding: const EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Text(
                                  'Price',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF0F1316),
                                    fontSize: 16,
                                    fontFamily: 'NanumSquareRound',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Color(0xFFC4CBD0)),
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(24)),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Text(
                                  "STANDARD 75.000 - 290.000  GOLD CLASS 300.000  L'AMOUR 600.000   CINE & LIVING 130.000 - 600.000",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF0F1316),
                                    fontSize: 16,
                                    fontFamily: 'NanumSquareRound',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}