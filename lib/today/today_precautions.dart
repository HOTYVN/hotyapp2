
import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/privatelesson/lesson_write.dart';
import 'package:hoty/main/main_page.dart';
import 'dart:math' as math;

import 'package:hoty/today/today_list.dart';

class TodayPrecautions extends StatefulWidget {
  @override
  _TodayPrecautions createState() => _TodayPrecautions();
}

class _TodayPrecautions extends State<TodayPrecautions> {

  bool isFold = false;
  double c_height = 0; // 기종별 height 값

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double c_height = m_height;
    double m_width = (MediaQuery.of(context).size.width/360);

    bool isFold = pageWidth > 480 ? true : false;

    if(aspectRatio > 0.55) {
      if(isFold == true) {
        c_height = m_height * (m_width * aspectRatio);
        // c_height = m_height * ( aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 40,
        backgroundColor: Color(0xffFFE8D7).withOpacity(0.78),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Color(0xff151515),
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
        title:
        Container(
          // width: 240 * (MediaQuery.of(context).size.width / 360),
          child: Text(
            "오늘의 정보 안내",
            style: TextStyle(
              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xff151515),
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              child : Image(image: AssetImage("assets/precautions_exchange_01.png"),)
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                child : Image(image: AssetImage("assets/precautions_exchange_02.png"),)
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : Row(
                children: [
                  Text("비자법 변경?", style: TextStyle(color: Color(0xffFBCD58), fontSize: isFold == true ? 32 * (MediaQuery.of(context).size.height / 360) : 32 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareR'),),
                  Text(" 주거등록?", style: TextStyle(color: Color(0xff7C3D0E), fontSize: isFold == true ? 32 * (MediaQuery.of(context).size.height / 360) : 32 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareR'),)
                ],
              )
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : Row(
                children: [
                  Text("헤드라인 뉴스!  ", style: TextStyle(color: Color(0xff2F67D3), fontSize: isFold == true ? 32 * (MediaQuery.of(context).size.height / 360) : 32 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareR'),),
                  Image(image: AssetImage("assets/news_paper_icon.png"),width: 90 * (MediaQuery.of(context).size.width / 360),)
                ],
              )
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("매주 월요일 업데이트 되는 베트남 헤드라인 뉴스를 만나보세요!", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("'베트남 기술대기업 VNG, 엔비디아\n클라우드 파트너 공식합류'", style: TextStyle(fontSize: 20 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360), fontWeight: FontWeight.bold, color: Color(0xff151515), fontFamily: 'NanumSquareR'),),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("베트남 국민메신저 잘로(Zalo)의 모회사인 기술대기업 VNG(UPCoM 증권코드 VNZ)가 미국 반도체기업인 엔비디아의 클라우드 파트너로 공식 합류했다.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("니케이아시아는 'VNG가 엔비디아와 클라우드 컴퓨팅 부문 협약을 체결했다'고 지난 15일 보도했다. 이에따라 VNG는 엔비디아 제품에 대한 우선권은 물론 엔비디아와 호환되는 소프트웨어 아키텍처 및 기술을 사용할 수 있어 잠재 고객 확보에 큰 이점을 갖게됐다.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("이에앞서 VNG의 AI(인공지능) GPU(그래픽처리장치) 클라우드 서비스 자회사 그린노드(GreenNode)는 이미 지난달부터 엔비디아 제품을 사용하는 고객사에게 AI 및 소프트웨어 서비스를 제공하기 시작했다.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Text("또한 VNG는 최근 태국에서 운영중인 데이터센터에 엔비디아 GPU 제품 1000여개 설치를 마친 것으로 나타났다.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 40 * (MediaQuery.of(context).size.height / 360),
              padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                    //height: 28 * (MediaQuery.of(context).size.height / 360),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      onPressed : () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return TodayList(main_catcode: '', table_nm: "TODAY_INFO");
                        },
                        ));
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child :  Text('오늘의 정보 바로가기', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Colors.white, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                child : Image(image: AssetImage("assets/precautions_exchange_03.png"),)
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