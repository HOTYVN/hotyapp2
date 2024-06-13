
import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/privatelesson/lesson_write.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'dart:math' as math;

import 'package:hoty/today/today_list.dart';

class KinPrecautions extends StatefulWidget {
  @override
  _KinPrecautions createState() => _KinPrecautions();
}

class _KinPrecautions extends State<KinPrecautions> {

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
        backgroundColor: Color(0xffFFFFFF),
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
            "글등록 유의사항",
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
              margin : EdgeInsets.fromLTRB(35 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  35 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360)),
              child : Image(image: AssetImage("assets/precautions_kin_01.png"),)
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                child : Image(image: AssetImage("assets/precautions_kin_02.png"),)
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360)),
                child : Image(image: AssetImage("assets/precautions_kin_03.png"),)
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xffDCE4EA),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xffF3F6F8),  width: 5 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                child : Image(image: AssetImage("assets/precautions_kin_04.png"),)
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
                          return KinList(success: false, failed: false, main_catcode: '');
                        },
                        ));
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child :  Text('지식iN 바로가기 !', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Colors.white, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
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
                child : Image(image: AssetImage("assets/precautions_kin_05.png"),)
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