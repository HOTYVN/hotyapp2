import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/counseling/counseling_list.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/service/service.dart';

class Guide extends StatefulWidget {
  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  int guide = 1;
  String guide_num = "01";
  double height = 0;

  bool isFold = false;
  double c_height = 0; // 기종별 height 값


  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    isFold = pageWidth > 480 ? true : false;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double m_width = (MediaQuery.of(context).size.width / 360);
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;


    if(aspectRatio > 0.55) {
      if(isFold == true) {
        // c_height = m_height * (m_width * aspectRatio);
        c_height = m_height * (m_width * aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }

    return Scaffold(
      body: Container(
          child : Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
              ),
            child: Row(
                children: [
                  Container(
                    width : 5 * (MediaQuery.of(context).size.width / 360),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                    ),
                  ),
                  if(guide == 5)
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      //height: height == 0 ? 360 * (MediaQuery.of(context).size.height / 360) : height,
                      child: Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        child: GestureDetector(
                            onTap: () {
                              guide = guide + 1;
                              if(guide < 14) {
                                if (guide > 9) {
                                  guide_num = guide.toString();
                                }
                                if (guide <= 9) {
                                  guide_num = "0$guide";
                                }
                              }


                              setState(() {
                                if(guide == 13) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return MainPage();
                                    },
                                  ));
                                }
                              });
                            },

                            child  : Image(image: AssetImage("assets/guide_img_${guide_num}.png"), fit: BoxFit.fill,)
                        ),
                      ),
                    ),
                  if(guide < 5 || guide > 10)
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      height: 364 * c_height,
                      child: GestureDetector(
                          onTap: () {
                            guide = guide + 1;
                            if(guide < 14) {
                              if (guide > 9) {
                                guide_num = guide.toString();
                              }
                              if (guide <= 9) {
                                guide_num = "0$guide";
                              }

                            }


                            setState(() {
                              if(guide == 14) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MainPage();
                                  },
                                ));
                              }
                            });
                          },

                          child  : Image(image: AssetImage("assets/guide_img_${guide_num}.png"), fit: BoxFit.fill,)
                      ),
                    ),
                  if(guide > 5 && guide <= 10)
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      height: 380 * c_height,
                      child: GestureDetector(
                          onTap: () {
                            guide = guide + 1;
                            if(guide < 14) {
                              if (guide > 9) {
                                guide_num = guide.toString();
                              }
                              if (guide <= 9) {
                                guide_num = "0$guide";
                              }

                            }


                            setState(() {
                              if(guide == 14) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return MainPage();
                                  },
                                ));
                              }
                            });
                          },

                          child  : Image(image: AssetImage("assets/guide_img_${guide_num}.png"), fit: BoxFit.fill,)
                      ),
                    ),
                  Container(
                    width : 5 * (MediaQuery.of(context).size.width / 360),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                    ),
                  )
                ],
            )
          )
        ),
      extendBody: true,
    );
  }
}