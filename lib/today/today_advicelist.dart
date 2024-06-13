import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/today/today_exchangerate.dart';
import 'package:hoty/today/today_list.dart';


class TodayAdvicelist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leadingWidth: 27 * (MediaQuery.of(context).size.width / 360),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 26 * (MediaQuery.of(context).size.width / 360),
          color: Colors.black,
          // alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
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
        title:
        Container(
          // width: 240 * (MediaQuery.of(context).size.width / 360),
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          child: Text(
            "호티's Pick!",
            style: TextStyle(
              fontSize: 17 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xff0F1316),
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container( //상단메뉴 ,카테고리
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: 75 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    Container( //배너 이미지
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      height: 70 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/today01.png'),
                            fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Row(
                  children: [
                    Container(
                      width: 330 * (MediaQuery.of(context).size.width / 360),
                      height: 25 * (MediaQuery.of(context).size.height / 360),
                      // color: Colors.redAccent,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return TodayList(main_catcode: '', table_nm: 'TODAY_INFO',);
                                },
                              ));
                            },
                            child: Container(
                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360)),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xffF3F6F8), width: 1.5 * (MediaQuery.of(context).size.width / 360),),
                                ),
                              ),
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: AssetImage('assets/today_menu01.png'), height: 8 * (MediaQuery.of(context).size.height / 360),),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                    child: Text(
                                      "오늘의 정보",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Color(0xff151515),
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                            },
                            child: Container(
                              padding : EdgeInsets.fromLTRB(0 , 0 ,
                                  0 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360)),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xffE47421), width: 1.5 * (MediaQuery.of(context).size.width / 360),),
                                ),
                              ),
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: AssetImage('assets/today_menu02.png'), height: 8 * (MediaQuery.of(context).size.height / 360),),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                    child: Text(
                                      "호치민 정착가이드",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.black87,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      2 * (MediaQuery.of(context).size.width / 360),
                                      0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360),
                                      9 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                    width: 4 * (MediaQuery.of(context).size.width / 360),
                                    height: 4 * (MediaQuery.of(context).size.height / 360),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffEB5757),
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
                ),
              ),
              Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: 15 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                child : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(  // 카테고리
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // width: 50 * (MediaQuery.of(context).size.width / 360),
                        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                        // padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                        height: 15 * (MediaQuery.of(context).size.height / 360),
                        decoration: ShapeDecoration(
                          color: Color(0xff482410),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(120),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x14545B5F),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child:
                        Container(
                          padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 1, 10 * (MediaQuery.of(context).size.width / 360), 1),
                          child: GestureDetector(
                            onTap: () {  },
                            child: Container(
                              child : Text(
                                "전체",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360),0,0,0),
                        padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                          color: Color(0xffF3F6F8),
                        ),
                        child: Text(
                          "오늘뭐먹지?",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360),0,0,0),
                        padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                          color: Color(0xffF3F6F8),
                        ),
                        child: Text(
                          "오늘뭐하지?",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),0,0,0),
                        padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                          color: Color(0xffF3F6F8),
                        ),
                        child: Text(
                          "호치민 정착가이드",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container( // 게시판
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    // col1
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      height: 60 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                          image: DecorationImage(
                              image: AssetImage("assets/hotys_pick01.png"),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 20 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("호티 선정 호치민 고깃집 Best 7", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          ),
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 40 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                110 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("시내의 부이비엔 배낭여행자 거리에서 멀지 않은 레라이거리에 위치한 뉴월드 사이공이 7위를 차지했다.", style: TextStyle(color: Colors.white, fontSize : 12),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  decoration : BoxDecoration (
                      border : Border(
                          bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                      )
                  )
              ),
              Container( // 게시판
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    // col1
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      height: 60 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                          image: DecorationImage(
                              image: AssetImage("assets/hotys_pick02.png"),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 20 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("호티 선정 호치민 여행지 Best 7", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          ),
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 40 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                110 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("시내의 부이비엔 배낭여행자 거리에서 멀지 않은 레라이거리에 위치한 뉴월드 사이공이 7위를 차지했다.", style: TextStyle(color: Colors.white, fontSize : 12),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  decoration : BoxDecoration (
                      border : Border(
                          bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                      )
                  )
              ),
              Container( // 게시판
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    // col1
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      height: 60 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                          image: DecorationImage(
                              image: AssetImage("assets/hotys_pick01.png"),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 20 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("호티 선정 호치민 여행지 Best 7", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          ),
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 40 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                110 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("시내의 부이비엔 배낭여행자 거리에서 멀지 않은 레라이거리에 위치한 뉴월드 사이공이 7위를 차지했다.", style: TextStyle(color: Colors.white, fontSize : 12),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  decoration : BoxDecoration (
                      border : Border(
                          bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 5 * (MediaQuery.of(context).size.width / 360),)
                      )
                  )
              ),
              Container( // 게시판
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Column(
                  children: [
                    // col1
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      height: 60 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                          image: DecorationImage(
                              image: AssetImage("assets/hotys_pick02.png"),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 20 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("호티 선정 호치민 여행지 Best 7", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          ),
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            height: 40 * (MediaQuery.of(context).size.height / 360),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                110 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            child: Text("시내의 부이비엔 배낭여행자 거리에서 멀지 않은 레라이거리에 위치한 뉴월드 사이공이 7위를 차지했다.", style: TextStyle(color: Colors.white, fontSize: 12),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  40 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
              ),
            ]
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'Today_page'),
    );
  }
}