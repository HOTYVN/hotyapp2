import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/counseling/counseling_list.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/service/service.dart';

class Counseling_guide extends StatefulWidget {
  final String table_nm;

  const Counseling_guide({Key? key,
    required this.table_nm
  }) : super(key:key);

  @override
  State<Counseling_guide> createState() => _Counseling_guideState();
}

class _Counseling_guideState extends State<Counseling_guide> {

  final GlobalKey servicecat_key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(
        servicecat_key.currentContext!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
            color: Colors.black
        ),*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Colors.black,
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
        title: Container(
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("부동산 상담 신청하기" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            category(context),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 42 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Column(
                children: [
                  Container(
                    child: Text("호티와 부동산을 계약하면",
                      style: TextStyle(
                        fontSize: 28,
                        // fontFamily: 'NanumSquareB',
                        fontWeight: FontWeight.bold,
                        color: Color(0xffE47421),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    child: Text("이런 장점이 있어요!",
                      style: TextStyle(
                        fontSize: 25,
                        // fontFamily: 'NanumSquareB',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              /*height: 275 * (MediaQuery.of(context).size.height / 360),*/
              child: Column(
                children: [
                  Container(
                    height: 70 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 251, 249, 1),
                            ),
                          child:
                          Center(
                            child: Image(image: AssetImage("assets/counseling_g01.png"), width: 100 * (MediaQuery.of(context).size.width / 360), height: 50 * (MediaQuery.of(context).size.height / 360), fit: BoxFit.fill,),
                          )
                        ),
                        Container(
                          width: 215 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                height: 20 * (MediaQuery.of(context).size.height / 360),
                                child : Text(
                                  "01",
                                  style: TextStyle(
                                    color: Color.fromRGBO(228, 116, 33, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NanumSquareB',
                                  ),
                                )
                              ),
                              Container(
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                height: 30 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "호치민 전 지역에 있는 매물을 가장 빠르게, 가장 많이 보실 수 있어요",
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontFamily: 'NanumSquareB',
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      height: 0.8 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    height : 2 * (MediaQuery.of(context).size.height / 360) ,
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    child :  DottedLine(
                      lineThickness: 2,
                      dashLength: 1.5,
                      dashColor: Color(0xffE47421),
                      /*direction: Axis.vertical,*/
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    height: 75 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 251, 249, 1),
                            ),
                            child:
                            Center(
                              child: Image(image: AssetImage("assets/counseling_g02.png"), width: 100 * (MediaQuery.of(context).size.width / 360), height: 50 * (MediaQuery.of(context).size.height / 360), fit: BoxFit.fill,),
                            )
                        ),
                        Container(
                          width: 215 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  height: 20 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "02",
                                    style: TextStyle(
                                        color: Color.fromRGBO(228, 116, 33, 1),
                                        fontSize: 25,
                                        fontFamily: 'NanumSquareB',
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  height: 30 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "부동산을 보러갈때, 계약할 때 HOTY 차량 픽업서비스를 이용해서 편하게 볼 수 있어요",
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontFamily: 'NanumSquareB',
                                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      height: 0.8 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    height : 2 * (MediaQuery.of(context).size.height / 360) ,
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    child :  DottedLine(
                      lineThickness: 2,
                      dashLength: 1.5,
                      dashColor: Color(0xffE47421),
                      /*direction: Axis.vertical,*/
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),  0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    height: 75 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            height: 50 * (MediaQuery.of(context).size.height / 360),
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360),
                                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 251, 249, 1),
                            ),
                            child:
                            Center(
                              child: Image(image: AssetImage("assets/counseling_g03.png"), width: 100 * (MediaQuery.of(context).size.width / 360), height: 50 * (MediaQuery.of(context).size.height / 360), fit: BoxFit.fill,),
                            )
                        ),
                        Container(
                          width: 210 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "03",
                                    style: TextStyle(
                                        color: Color.fromRGBO(228, 116, 33, 1),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2  * (MediaQuery.of(context).size.height / 360),
                                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 50 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "정수기, 연수기 설치, 인터넷 설치 등 입주 시 필요한 대행서비스를 무료로 제공하며, 계약 후 사후관리까지 도와드려요",
                                    style: TextStyle(
                                        color: Colors.black,
                                        // fontFamily: 'NanumSquareB',
                                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                      height: 0.8 * (MediaQuery.of(context).size.height / 360),
                                    ),
                                  )
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
            Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 340 * (MediaQuery.of(context).size.width / 360),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CounselingList(table_nm: "REAL_ESTATE",);
                          },
                        ));
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('다음으로', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                50 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: ''),
    );
  }
  Container category(BuildContext context) {
    return Container(
      child : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if(widget.table_nm == "ON_SITE")
              Container(
                key: servicecat_key,
                child : TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service(table_nm : "ON_SITE");
                      },
                    ));
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration (
                        color: Colors.white,
                        border : Border(
                            bottom: BorderSide(
                                color: widget.table_nm == "ON_SITE"
                                    ? Color(0xffE47421)
                                    : Color(0xffF3F6F8),
                                width : 2 * (MediaQuery.of(context).size.width / 360)
                            )
                        )
                    ),
                    child: Text(
                      "출장 서비스",
                      style: TextStyle(
                        fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NanumSquareR',
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                  ),
                ),
              ),
            if(widget.table_nm != "ON_SITE")
              Container(
                child : TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service(table_nm : "ON_SITE");
                      },
                    ));
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration (
                        color: Colors.white,
                        border : Border(
                            bottom: BorderSide(
                                color: widget.table_nm == "ON_SITE"
                                    ? Color(0xffE47421)
                                    : Color(0xffF3F6F8),
                                width : 2 * (MediaQuery.of(context).size.width / 360)
                            )
                        )
                    ),
                    child: Text(
                      "출장 서비스",
                      style: TextStyle(
                        fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NanumSquareR',
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                  ),
                ),
              ),
            //if(widget.table_nm == "INTRP_SRVC")
            //Container(
            //  key: servicecat_key,
            //  child : TextButton(
            //    style: TextButton.styleFrom(
            //        padding: EdgeInsets.zero,
            //        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //        alignment: Alignment.center
            //    ),
            //    onPressed: (){
            //      Navigator.push(context, MaterialPageRoute(
            //        builder: (context) {
            //          return Service(table_nm : "INTRP_SRVC");
            //        },
            //      ));
            //    },
            //    child: Container(
            //      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            //          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            //      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            //          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            //      decoration: BoxDecoration (
            //          color: Colors.white,
            //          border : Border(
            //              bottom: BorderSide(
            //                  color: widget.table_nm == "INTRP_SRVC"
            //                      ? Color(0xffE47421)
            //                      : Color(0xffF3F6F8),
            //                  width : 2 * (MediaQuery.of(context).size.width / 360)
            //              )
            //          )
            //      ),
            //      child: Text(
            //        "24시 긴급 출장 통역 서비스",
            //        style: TextStyle(
            //          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
            //          color: Color(0xff151515),
            //          fontWeight: FontWeight.w800,
            //          fontFamily: 'NanumSquareR',
            //          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
            //        ),
            //      ),
            //    ),
            //  )
            //),
            //if(widget.table_nm != "INTRP_SRVC")
            //Container(
            //    child : TextButton(
            //      style: TextButton.styleFrom(
            //          padding: EdgeInsets.zero,
            //          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //          alignment: Alignment.center
            //      ),
            //      onPressed: (){
            //        Navigator.push(context, MaterialPageRoute(
            //          builder: (context) {
            //            return Service(table_nm : "INTRP_SRVC");
            //          },
            //        ));
            //      },
            //      child: Container(
            //        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            //            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            //        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            //            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            //        decoration: BoxDecoration (
            //            color: Colors.white,
            //            border : Border(
            //                bottom: BorderSide(
            //                    color: widget.table_nm == "INTRP_SRVC"
            //                        ? Color(0xffE47421)
            //                        : Color(0xffF3F6F8),
            //                    width : 2 * (MediaQuery.of(context).size.width / 360)
            //                )
            //            )
            //        ),
            //        child: Text(
            //          "24시 긴급 출장 통역 서비스",
            //          style: TextStyle(
            //            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
            //            color: Color(0xff151515),
            //            fontWeight: FontWeight.w800,
            //            fontFamily: 'NanumSquareR',
            //            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
            //          ),
            //        ),
            //      ),
            //    )
            //),
            if(widget.table_nm == "AGENCY_SRVC")
              Container(
                  key: servicecat_key,
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "AGENCY_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "AGENCY_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "비자 서비스",
                        style: TextStyle(
                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'NanumSquareR',
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm != "AGENCY_SRVC")
              Container(
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "AGENCY_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "AGENCY_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "비자 서비스",
                        style: TextStyle(
                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'NanumSquareR',
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            //if(widget.table_nm == "REAL_ESTATE")
            //Container(
            //  key: servicecat_key,
            //  child : TextButton(
            //    style: TextButton.styleFrom(
            //        padding: EdgeInsets.zero,
            //        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //        alignment: Alignment.center
            //    ),
            //    onPressed: (){
            //      Navigator.push(context, MaterialPageRoute(
            //        builder: (context) {
            //          return Counseling_guide(table_nm : "REAL_ESTATE");
            //        },
            //      ));
            //    },
            //    child: Container(
            //      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            //          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            //      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            //          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            //      decoration: BoxDecoration (
            //          color: Colors.white,
            //          border : Border(
            //              bottom: BorderSide(
            //                  color: widget.table_nm == "REAL_ESTATE"
            //                      ? Color(0xffE47421)
            //                      : Color(0xffF3F6F8),
            //                  width : 2 * (MediaQuery.of(context).size.width / 360)
            //              )
            //          )
            //      ),
            //      child: Text(
            //        "부동산 상담 신청",
            //        style: TextStyle(
            //          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
            //          color: Color(0xff151515),
            //          fontWeight: FontWeight.w800,
            //          fontFamily: 'NanumSquareR',
            //          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
            //        ),
            //      ),
            //    ),
            //  )
            //),
            //if(widget.table_nm != "REAL_ESTATE")
            //Container(
            //    child : TextButton(
            //      style: TextButton.styleFrom(
            //          padding: EdgeInsets.zero,
            //          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //          alignment: Alignment.center
            //      ),
            //      onPressed: (){
            //        Navigator.push(context, MaterialPageRoute(
            //          builder: (context) {
            //            return Counseling_guide(table_nm : "REAL_ESTATE");
            //          },
            //        ));
            //      },
            //      child: Container(
            //        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            //            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            //        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            //            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            //        decoration: BoxDecoration (
            //            color: Colors.white,
            //            border : Border(
            //                bottom: BorderSide(
            //                    color: widget.table_nm == "REAL_ESTATE"
            //                        ? Color(0xffE47421)
            //                        : Color(0xffF3F6F8),
            //                    width : 2 * (MediaQuery.of(context).size.width / 360)
            //                )
            //            )
            //        ),
            //        child: Text(
            //          "부동산 상담 신청",
            //          style: TextStyle(
            //            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
            //            color: Color(0xff151515),
            //            fontWeight: FontWeight.w800,
            //            fontFamily: 'NanumSquareR',
            //            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
            //          ),
            //        ),
            //      ),
            //    )
            //),
            if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
              Container(
                  key: servicecat_key,
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "REAL_ESTATE_INTRP_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "REAL_ESTATE_INTRP_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "부동산통역서비스",
                        style: TextStyle(
                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'NanumSquareR',
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm != "REAL_ESTATE_INTRP_SRVC")
              Container(
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "REAL_ESTATE_INTRP_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "REAL_ESTATE_INTRP_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "부동산통역서비스",
                        style: TextStyle(
                          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.w800,
                          fontFamily: 'NanumSquareR',
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
          ],
        ),
      ),

    );
  }
  /*Container category(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
      child : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if(widget.table_nm == "ON_SITE")
              Container(
                key: servicecat_key,
                child : TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service(table_nm : "ON_SITE");
                      },
                    ));
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration (
                        color: Colors.white,
                        border : Border(
                            bottom: BorderSide(
                                color: widget.table_nm == "ON_SITE"
                                    ? Color(0xffE47421)
                                    : Color(0xffF3F6F8),
                                width : 2 * (MediaQuery.of(context).size.width / 360)
                            )
                        )
                    ),
                    child: Text(
                      "출장 서비스",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                  ),
                ),
              ),
            if(widget.table_nm != "ON_SITE")
              Container(
                child : TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Service(table_nm : "ON_SITE");
                      },
                    ));
                  },
                  child: Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration (
                        color: Colors.white,
                        border : Border(
                            bottom: BorderSide(
                                color: widget.table_nm == "ON_SITE"
                                    ? Color(0xffE47421)
                                    : Color(0xffF3F6F8),
                                width : 2 * (MediaQuery.of(context).size.width / 360)
                            )
                        )
                    ),
                    child: Text(
                      "출장 서비스",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        color: Color(0xff151515),
                        fontWeight: FontWeight.bold,
                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                      ),
                    ),
                  ),
                ),
              ),
            if(widget.table_nm == "INTRP_SRVC")
              Container(
                  key: servicecat_key,
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "INTRP_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "INTRP_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "24시 긴급 출장 통역 서비스",
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm != "INTRP_SRVC")
              Container(
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "INTRP_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "INTRP_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "24시 긴급 출장 통역 서비스",
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm == "AGENCY_SRVC")
              Container(
                  key: servicecat_key,
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "AGENCY_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "AGENCY_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "대행 서비스",
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm != "AGENCY_SRVC")
              Container(
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Service(table_nm : "AGENCY_SRVC");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "AGENCY_SRVC"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "대행 서비스",
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm == "REAL_ESTATE")
              Container(
                  key: servicecat_key,
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Counseling_guide(table_nm : "REAL_ESTATE");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "REAL_ESTATE"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "부동산 상담 신청",
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
            if(widget.table_nm != "REAL_ESTATE")
              Container(
                  child : TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.center
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Counseling_guide(table_nm : "REAL_ESTATE");
                        },
                      ));
                    },
                    child: Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration (
                          color: Colors.white,
                          border : Border(
                              bottom: BorderSide(
                                  color: widget.table_nm == "REAL_ESTATE"
                                      ? Color(0xffE47421)
                                      : Color(0xffF3F6F8),
                                  width : 2 * (MediaQuery.of(context).size.width / 360)
                              )
                          )
                      ),
                      child: Text(
                        "부동산 상담 신청",
                        style: TextStyle(
                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xff151515),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  )
              ),
          ],
        ),
      ),

    );
  }*/
}