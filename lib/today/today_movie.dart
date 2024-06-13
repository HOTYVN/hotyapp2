import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/today/cgv_table.dart';
import 'package:hoty/today/lottecinema_table.dart';


class TodayMovie extends StatelessWidget {
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
          iconSize: 25,
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        titleSpacing: -8.0,
        title: Container(
          /*width: 80 * (MediaQuery.of(context).size.width / 360),
          height: 80 * (MediaQuery.of(context).size.height / 360),
          child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("Now In Theaters" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,)
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 10 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              /*padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),*/
              decoration: BoxDecoration (
                  //color: Colors.white,
                  border : Border(
                      left: BorderSide(color: Color.fromRGBO(228, 116, 33, 1), width : 5 * (MediaQuery.of(context).size.width / 360))
                  ),
              ),
              child: Text("  Now In Theaters", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              //color: Colors.teal,
            ),
            Container(
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration (
                //color: Colors.white,
                border : Border(
                    bottom: BorderSide(color: Color.fromRGBO(228, 116, 33, 1), width : 1 * (MediaQuery.of(context).size.width / 360))
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          border: Border.all(
                              color: Color.fromRGBO(228, 116, 33, 1)
                          ),
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      width: 110 * (MediaQuery.of(context).size.width / 360),
                      height: 80 * (MediaQuery.of(context).size.height / 360),
                      child: Row(
                        children: [
                          Container(
                            width: 104 * (MediaQuery.of(context).size.width / 360),
                            height: 80 * (MediaQuery.of(context).size.height / 360),
                            margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                2 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image(image: AssetImage("assets/movie_poster01.png"),fit: BoxFit.cover,),
                            )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      width: 110 * (MediaQuery.of(context).size.width / 360),
                      height: 80 * (MediaQuery.of(context).size.height / 360),
                      child: Row(
                        children: [
                          Container(
                              width: 104 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                  2 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image(image: AssetImage("assets/movie_poster02.png"),fit: BoxFit.cover,),
                              )
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      ),
                      width: 110 * (MediaQuery.of(context).size.width / 360),
                      height: 80 * (MediaQuery.of(context).size.height / 360),
                      child: Row(
                        children: [
                          Container(
                              width: 104 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                  2 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image(image: AssetImage("assets/movie_poster03.png"),fit: BoxFit.cover,),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 10 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              /*padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),*/
              decoration: BoxDecoration (
                //color: Colors.white,
                border : Border(
                    left: BorderSide(color: Color.fromRGBO(228, 116, 33, 1), width : 5 * (MediaQuery.of(context).size.width / 360))
                ),
              ),
              child: Text("  Details", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              //color: Colors.teal,
            ),
            Container(
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration (
                //color: Colors.white,
                border : Border(
                    bottom: BorderSide(color: Color.fromRGBO(228, 116, 33, 1), width : 1 * (MediaQuery.of(context).size.width / 360))
                ),
              ),
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: 310 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(image: AssetImage("assets/movie_mainposter01.png"),fit: BoxFit.cover,),
                )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("천박사 퇴마 연구소: 설경의 비밀", style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("Dr.Cheon And The Lost Talisman", style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 50 * (MediaQuery.of(context).size.height / 360),
              child: Row(
                children: [
                  Container(
                    width: 110 * (MediaQuery.of(context).size.width / 360),
                    height: 35 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      border : Border(
                          right: BorderSide(color: Color.fromRGBO(196, 204, 208, 1), width : 1 * (MediaQuery.of(context).size.width / 360))
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          width: 60 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          //color: Colors.amber,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                            color: Color(0xFFF3F6F7),
                          ),
                          child: Row(
                            children: [
                              Image(image: AssetImage("assets/Timer.png"), width: 20 * (MediaQuery.of(context).size.width / 360),height: 20 * (MediaQuery.of(context).size.height / 360),),
                              Text(" Hour", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Container(
                          height: 10 * (MediaQuery.of(context).size.height / 360),
                          child: Text("98 Minutes", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 130 * (MediaQuery.of(context).size.width / 360),
                    height: 35 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      border : Border(
                          right: BorderSide(color: Color.fromRGBO(196, 204, 208, 1), width : 1 * (MediaQuery.of(context).size.width / 360))
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          width: 85 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          //color: Colors.amber,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                            color: Color(0xFFF3F6F7),
                          ),
                          child: Row(
                            children: [
                              Image(image: AssetImage("assets/movie.png"), width: 20 * (MediaQuery.of(context).size.width / 360),height: 20 * (MediaQuery.of(context).size.height / 360),),
                              Text(" Director", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Container(
                          height: 10 * (MediaQuery.of(context).size.height / 360),
                          child: Text("Seongsik Kim", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 110 * (MediaQuery.of(context).size.width / 360),
                    height: 35 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child: Column(
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          width: 70 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          //color: Colors.amber,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                            color: Color(0xFFF3F6F7),
                          ),
                          child: Row(
                            children: [
                              Image(image: AssetImage("assets/genre.png"), width: 20 * (MediaQuery.of(context).size.width / 360),height: 20 * (MediaQuery.of(context).size.height / 360),),
                              Text(" Genre", style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                        Container(
                          height: 10 * (MediaQuery.of(context).size.height / 360),
                          child: Text("Fantasy", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Text("Introduction", style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NanumSquareRound',
                  fontWeight: FontWeight.w800,
                  height: 0.03,
                ),
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 85 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Text(
                '대대로 마을을 지켜 온 당주집 장손이지만 정작 귀신은 믿지 않는 가짜 퇴마사 ‘천박사’(강동원). 사람의 마음을 꿰뚫는 통찰력으로 가짜 퇴마를 하며, 의뢰받은 사건들을 해결해 오던 그에게 귀신을 보는 의뢰인 ‘유경’(이솜)이 찾아와 거액의 수임료로 거절하기 힘든 제안을 한다. ‘천박사’는 파트너 ‘인배’(이동휘)와 함께 ‘유경’의 집으로 향하고 그곳에서 벌어지는 사건을 쫓으며 자신과 얽혀 있는 부적인 ‘설경’의 비밀을 알게 되는데… 귀신을 믿지 않는 가짜 퇴마사! 그의 세계를 흔드는 진짜 사건이 나타났다!',
                style: TextStyle(
                  color: Color(0xFF0F1316),
                  fontSize: 15,
                  fontFamily: 'NanumSquareRound',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 20 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 170 * (MediaQuery.of(context).size.width / 360),
                    child: Text("Running Time",
                      style: TextStyle(
                        color: Color(0xFF0F1316),
                        fontSize: 16,
                        fontFamily: 'NanumSquareRound',
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ),
                  Container( //
                    width: 160 * (MediaQuery.of(context).size.width / 360),
                    child: Text("Updated date: 2023/10/16",
                      style: TextStyle(
                        color: Color(0xFF151515),
                        fontSize: 14,
                        fontFamily: 'NanumSquareRound',
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ),
                ],
              )
            ),
            /*CgvTable(),
            LottecinemaTable(),*/
            Container(
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
              child : Image(image: AssetImage("assets/cgv_table.png"),)
            ),
            Container(
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child : Image(image: AssetImage("assets/lotte_cinema_table.png"),)
            ),
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'Today_page'),
    );
  }
}