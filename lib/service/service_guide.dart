import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/service/service.dart';

class Service_guide extends StatefulWidget {

  final dynamic table_nm;

  const Service_guide({Key ? key,
    required this.table_nm
  }) : super(key:key);


  @override
  State<Service_guide> createState() => _Service_guideState();
}

class _Service_guideState extends State<Service_guide> {
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
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        titleSpacing: 5,
        leadingWidth: 40,
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("서비스 가이드" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.w800, fontFamily: 'NanumSquareEB',),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360) ),
              child: Text("호티 서비스",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NanumSquareR',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              child: Column(
                children: [
                  Container(
                    height: 60 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          width: 120 * (MediaQuery.of(context).size.width / 360),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 251, 249, 1),
                          ),
                          child:
                          Center(
                            child: Image(image: AssetImage("assets/visiting_service01.png"), width: 60 * (MediaQuery.of(context).size.width / 360), height: 30 * (MediaQuery.of(context).size.height / 360)),
                          )
                        ),
                        Container(
                          width: 200 * (MediaQuery.of(context).size.width / 360),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                // height: 25 * (MediaQuery.of(context).size.height / 360),
                                child : Text(
                                  "출장서비스",
                                  style: TextStyle(
                                    color: Color.fromRGBO(228, 116, 33, 1),
                                      fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'NanumSquareR',
                                  ),
                                )
                              ),
                              Container(
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                    5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                // height: 45 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "출장서비스에는 통역, 렌트카 등이 있어요. 원하시는 장소와 시간을 입력해주시면 호티 직원이 요청사항에 맞춰서 도착해요.",
                                    style: TextStyle(
                                        color: Colors.black,
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
                  /*Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    height: 60 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 251, 249, 1),
                            ),
                            child:
                            Center(
                              child: Image(image: AssetImage("assets/visiting_service02.png"), width: 80 * (MediaQuery.of(context).size.width / 360), height: 30 * (MediaQuery.of(context).size.height / 360)),
                            )
                        ),
                        Container(
                          width: 200 * (MediaQuery.of(context).size.width / 360),
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "24시 긴급 통역 서비스",
                                    style: TextStyle(
                                      color: Color.fromRGBO(228, 116, 33, 1),
                                      fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'NanumSquareR',
                                    ),
                                  )
                              ),
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 45 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "24시 긴급 출장 서비스에는 응급실, 경찰서 통역이 있어요. 신청하시면 즉시 담당자가 계신곳으로 출발해요.",
                                    style: TextStyle(
                                      color: Colors.black,
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
                  ),*/
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    height: 60 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            width: 120 * (MediaQuery.of(context).size.width / 360),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 251, 249, 1),
                            ),
                            child:
                            Center(
                              child: Image(image: AssetImage("assets/agent_service.png"), width: 90 * (MediaQuery.of(context).size.width / 360), height: 30 * (MediaQuery.of(context).size.height / 360)),
                            )
                        ),
                        Container(
                          width: 200 * (MediaQuery.of(context).size.width / 360),
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "비자 서비스",
                                    style: TextStyle(
                                      color: Color.fromRGBO(228, 116, 33, 1),
                                      fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'NanumSquareR',
                                    ),
                                  )
                              ),
                              Container(
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  // height: 45 * (MediaQuery.of(context).size.height / 360),
                                  child : Text(
                                    "비자 서비스에는 비지대행, 대사관 업무대행이 있어요. 필요한 서류를 같이 첨부 해주시면 호티 직원이 대신 업무를 진행해드려요.",
                                    style: TextStyle(
                                      color: Colors.black,
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
              width: 360 * (MediaQuery.of(context).size.width / 360),
              // height: 21 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Text("서비스 STEP",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NanumSquareR',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 21 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Text("출장",// / 24시 긴급 출장 서비스
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NanumSquareR',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
              padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child: Image(image: AssetImage("assets/number_01.png"), width: 70 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Center(
                      child: Image(image: AssetImage("assets/east_icon.png"), width: 50 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text("출장에 필요한 정보를 입력하시고 \n신청 완료를 해주세요.",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        height: 0.8 * (MediaQuery.of(context).size.height / 360),
                        fontFamily: 'NanumSquareR',

                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
              padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child: Image(image: AssetImage("assets/number_02.png"), width: 70 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Center(
                      child: Image(image: AssetImage("assets/east_icon.png"), width: 40 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text("신청이 완료 되면 담당자가 일정이 \n시작되기 전 입력하신 연락처로 \n연락드린 후요청하신 장소로 출발해요.",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        height: 0.8 * (MediaQuery.of(context).size.height / 360),
                        fontFamily: 'NanumSquareR',

                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
              padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child: Image(image: AssetImage("assets/number_03.png"), width: 70 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Center(
                      child: Image(image: AssetImage("assets/east_icon.png"), width: 50 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text("요청하신 서비스가 완료 되면 현장에서 서비스 비용을 결제 해주세요.",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        height: 0.8 * (MediaQuery.of(context).size.height / 360),
                        fontFamily: 'NanumSquareR',

                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              // height: 22 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Text("비자 서비스",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'NanumSquareR',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
              padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child: Image(image: AssetImage("assets/number_01.png"), width: 70 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Center(
                      child: Image(image: AssetImage("assets/east_icon.png"), width: 50 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text("대행 서비스에 필요한 정보를\n입력하시고 신청 완료를 해주세요.",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        height: 0.8 * (MediaQuery.of(context).size.height / 360),
                        fontFamily: 'NanumSquareR',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
              padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child: Image(image: AssetImage("assets/number_02.png"), width: 70 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Center(
                      child: Image(image: AssetImage("assets/east_icon.png"), width: 40 * (MediaQuery.of(context).size.width / 360), height: 35 * (MediaQuery.of(context).size.height / 360),),
                    ),
                  ),
                  Container(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text("신청이 완료 되면 담당자가 입력하신 연락처로 연락드려요. \n필요한 추가 정보, 비용, 결제방법을 안내 드려요.",
                      style: TextStyle(
                        fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                        height: 0.8 * (MediaQuery.of(context).size.height / 360),
                        fontFamily: 'NanumSquareR',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service(table_nm : widget.table_nm);
                          },
                        ));
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('서비스 신청하러 가기', style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'NanumSquareR',
                              color: Colors.white
                          ),textAlign: TextAlign.center,),
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
                40 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'Main_menu'),
    );
  }
}