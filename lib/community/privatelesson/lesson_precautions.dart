
import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/privatelesson/lesson_write.dart';
import 'package:hoty/main/main_page.dart';
import 'dart:math' as math;

class LessonPrecautions extends StatefulWidget {
  @override
  _LessonPrecautions createState() => _LessonPrecautions();
}

class _LessonPrecautions extends State<LessonPrecautions> {

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
        backgroundColor: Color(0xffE47421),
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Color(0xffFFFFFF),
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
            "개인과외 유의사항",
            style: TextStyle(
              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xffFFFFFF),
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
              height: 140 * c_height,
              decoration: BoxDecoration(
                color: Color(0xffE47421),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(500.0),
                  bottomRight: Radius.circular(500.0),
                ),
                image : DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/precautions_01.png"),
                ),
              ),
              child: Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                child : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), MediaQuery.of(context).size.width > 400 ? 5 * (MediaQuery.of(context).size.height / 360) : 2 * (MediaQuery.of(context).size.height / 360) ,
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Stack(
                        children: [
                          Text("개인과외",
                          style: TextStyle(
                            fontSize: isFold == true ? 44 * (MediaQuery.of(context).size.height / 360) : 44 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.w800,
                            //color: Color(0xffFFFFFF),
                            shadows: [
                              Shadow(
                                color: Color(0xffBB550B).withOpacity(0.8),
                                offset: Offset(-0.5, 3.5),
                                blurRadius: 1,
                              ),
                            ],
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3
                              ..color = Color(0xffBB550B), // <-- Border color
                          ),
                        ),
                          Text("개인과외",
                            style: TextStyle(
                              fontSize: isFold == true ? 44 * (MediaQuery.of(context).size.height / 360) : 44 * (MediaQuery.of(context).size.width / 360),
                              fontWeight: FontWeight.w800,
                              color: Color(0xffFFFFFF),
                              shadows: [
                                Shadow(
                                  color: Color(0xffBB550B).withOpacity(0.8),
                                  offset: Offset(-0.5, 3.5),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Text("글 등록 ",
                                style: TextStyle(
                                  fontSize: isFold == true ? 44 * (MediaQuery.of(context).size.height / 360) : 44 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                  //color: Color(0xffFBCD58),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xffBB550B).withOpacity(0.8),
                                      offset: Offset(-0.5, 3.5),
                                      blurRadius: 1,
                                    ),
                                  ],
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Color(0xffBB550B),
                                ),),
                              Text("글 등록 ",
                                style: TextStyle(
                                  fontSize: isFold == true ? 44 * (MediaQuery.of(context).size.height / 360) : 44 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xffFBCD58),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xffBB550B).withOpacity(0.8),
                                      offset: Offset(-0.5, 3.5),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),),
                            ],
                          ),
                          Stack(
                            children: [
                              Text("유의사항!",
                                style: TextStyle(
                                  fontSize: isFold == true ? 44 * (MediaQuery.of(context).size.height / 360) : 44 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                  //color: Color(0xffFFFFFF),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xffBB550B).withOpacity(0.8),
                                      offset: Offset(-0.5, 3.5),
                                      blurRadius: 1,
                                    ),
                                  ],
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Color(0xffBB550B),
                                ),
                              ),
                              Text("유의사항!",
                                style: TextStyle(
                                  fontSize: isFold == true ? 44 * (MediaQuery.of(context).size.height / 360) : 44 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xffFFFFFF),
                                  shadows: [
                                    Shadow(
                                      color: Color(0xffBB550B).withOpacity(0.8),
                                      offset: Offset(-0.5, 3.5),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360) ,
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ,
                        0 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360)),
                    child : Row(
                      children: [
                        Stack(
                          children: [
                            Transform.rotate(angle: 45 * math.pi / 180,
                              child : Container(
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                height: isFold == false ? 15 * (MediaQuery.of(context).size.height / 360) : 13 * c_height,
                                decoration: BoxDecoration(
                                    color: Color(0xffFFCE4F),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(isFold == true ? 12 * (MediaQuery.of(context).size.width / 360) : 10 * (MediaQuery.of(context).size.width / 360), isFold == true ? 7 * (MediaQuery.of(context).size.height / 360) : 5 * (MediaQuery.of(context).size.height / 360) ,
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text("01", style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ,
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          child : Text("개인과외 등록시 연락처와 글 내용에\n회당 시간을 꼭 등록해주세요!",
                            style: TextStyle(
                              height: isFold == true ? 0.55 * (MediaQuery.of(context).size.height / 360) : 0.7 * (MediaQuery.of(context).size.height / 360),
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            ),
                          )
                        ),
                      ],
                    )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ,
                          0 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Row(
                        children: [
                          Stack(
                            children: [
                              Transform.rotate(angle: 45 * math.pi / 180,
                                child : Container(
                                  width: 30 * (MediaQuery.of(context).size.width / 360),
                                  height: isFold == false ? 15 * (MediaQuery.of(context).size.height / 360) : 13 * c_height,
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFCE4F),
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(isFold == true ? 12 * (MediaQuery.of(context).size.width / 360) : 10 * (MediaQuery.of(context).size.width / 360), isFold == true ? 7 * (MediaQuery.of(context).size.height / 360) : 5 * (MediaQuery.of(context).size.height / 360) ,
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child : Text("02", style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                              )
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ,
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text("자세한 비용안내 부탁드려요 !\nex) 1회당 50만동 / 2시간",
                                style: TextStyle(
                                  height: isFold == true ? 0.55 * (MediaQuery.of(context).size.height / 360) : 0.7 * (MediaQuery.of(context).size.height / 360),
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ,
                          0 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Row(
                        children: [
                          Stack(
                            children: [
                              Transform.rotate(angle: 45 * math.pi / 180,
                                child : Container(
                                  width: 30 * (MediaQuery.of(context).size.width / 360),
                                  height: isFold == false ? 15 * (MediaQuery.of(context).size.height / 360) : 13 * c_height,
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFCE4F),
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(isFold == true ? 12 * (MediaQuery.of(context).size.width / 360) : 10 * (MediaQuery.of(context).size.width / 360), isFold == true ? 7 * (MediaQuery.of(context).size.height / 360) : 5 * (MediaQuery.of(context).size.height / 360) ,
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  child : Text("03", style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),)
                              )
                            ],
                          ),
                          Container(
                              //width: 330 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ,
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text("위와 같은 내용이 없으면, 글 등록이 반려될 수 \n있으니 꼭 유의하셔서 글 등록 부탁드릴게요!",
                                style: TextStyle(
                                  height: isFold == true ? 0.55 * (MediaQuery.of(context).size.height / 360) : 0.7 * (MediaQuery.of(context).size.height / 360),
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                ],
              )
            ),

            Container(
                margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : Row(
                children: [
                  Image(image: AssetImage("assets/notification.png"), width: 18 * (MediaQuery.of(context).size.width / 360),),
                  Text("  여권은 본인확인 용도로만 사용되니 안심하세요!", style: TextStyle(color: Color(0xffE47421), fontWeight: FontWeight.bold, fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                ],
              )
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 13 * c_height : 10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : Text("*글 작성 예시", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),)
            ),

            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 13 * c_height : 10 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffF3F6F8)),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child : Row(
                children: [
                  Container(
                    width: 270 * (MediaQuery.of(context).size.width / 360),
                    child : Text("골프", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30 * (MediaQuery.of(context).size.width / 360),
                  ),
                ],
              )
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffF3F6F8)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child : Row(
                  children: [
                    Container(
                      width: 270 * (MediaQuery.of(context).size.width / 360),
                      padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("골프 1:1 레슨합니다.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                    ),
                  ],
                )
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffF3F6F8)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child : Row(
                  children: [
                    Container(
                      width: 270 * (MediaQuery.of(context).size.width / 360),
                      padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("500,000VND", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                    ),
                  ],
                )
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffF3F6F8)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child : Row(
                  children: [
                    Container(
                      width: 270 * (MediaQuery.of(context).size.width / 360),
                      padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("0123456789", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                    ),
                  ],
                )
            ),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), isFold == true ? 8 * c_height : 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffF3F6F8)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child : Row(
                  children: [
                    Container(
                      width: 270 * (MediaQuery.of(context).size.width / 360),
                      padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("골프 1:1 레슨합니다.\n레슨은 1회 2시간 50만동에 하고 있습니다.\n시간은 협의 가능합니다.\n카카오톡 HOTY 또는 전화로 연락주세요!\n", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: isFold == true ? 0.55 * (MediaQuery.of(context).size.height / 360) : 0.65 * (MediaQuery.of(context).size.height / 360), ),),
                    ),
                  ],
                )
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
                          return Lessonwrite();
                        },
                        ));
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child :  Text('개인과외 글 등록하러가기 !', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Colors.white, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            Center(
              child: Stack(
                children: [
                  Image(image: AssetImage("assets/comming_soon_sign_01.png"), width: isFold == true ? 105 * (MediaQuery.of(context).size.width / 360) : 175 * (MediaQuery.of(context).size.width / 360),),
                  Text("COMING SOON", style: TextStyle(fontSize: 30 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800, ),)
                ],
              ),
            ),
           /* Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 20 * c_height,
              decoration: BoxDecoration(
                image : DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: AssetImage("assets/comming_soon_sign_01.png"),
                ),
              ),
              child : Text("COMING SOON", style: TextStyle(fontSize: 30 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800, ),textAlign: TextAlign.center,)
            ),*/

            Container(
                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child : Text("개인과외 선생님/회원님들을 위한 다양한\n이벤트가 준비되어 있으니 많은 기대해주세요!", style: TextStyle(fontWeight: FontWeight.w600, height: isFold == true ? 0.5 * (MediaQuery.of(context).size.height / 360) : 0.7 * (MediaQuery.of(context).size.height / 360), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),textAlign: TextAlign.center,)
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