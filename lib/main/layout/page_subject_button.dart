import 'package:flutter/material.dart';
import 'package:hoty/common/dataManager.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';

import '../../categorymenu/living_list.dart';


class MainPage_Subject_Button extends StatefulWidget {
  final String subtitle;
  final String urlbutton;
  const MainPage_Subject_Button({Key? key,
    required this.subtitle,
    required this.urlbutton
  }) : super(key:key);

  @override
  State<MainPage_Subject_Button> createState() => _MainPage_Subject_ButtonState();
}

class _MainPage_Subject_ButtonState extends State<MainPage_Subject_Button> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        height: 22 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
        // width: 100 * (MediaQuery.of(context).size.width / 360),
        // height: 100 * (MediaQuery.of(context).size.width / 360),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.urlbutton == 'KinList')
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return movepage(widget.urlbutton);
                    },
                  ));
                },
                child : Row(
                  children: [
                    Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child: Row(
                          children: [
                            Container(
                              height: 25 * (MediaQuery.of(context).size.width / 360),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                              child: Text('지식 in HOTY',
                                style: TextStyle(
                                  fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'NanumSquareEB',
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Container(
                        margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0,
                            0 , 5 * (MediaQuery.of(context).size.height / 360) ),
                        child:Row(
                          children: [
                            Container(
                              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                5 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360),),
                              child: Image(image: AssetImage('assets/hot.png')),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              )
            else if(widget.urlbutton == 'KinList2')
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return movepage(widget.urlbutton);
                    },
                  ));
                },
                child : Row(
                  children: [
                    Container(
                        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child: Row(
                          children: [
                            Container(
                              height: 25 * (MediaQuery.of(context).size.width / 360),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                                ),
                              ),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                              child: Text('지식 in 최신글',
                                style: TextStyle(
                                  fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                  fontFamily: 'NanumSquareEB',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Container(
                        margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0,
                            0 , 5 * (MediaQuery.of(context).size.height / 360) ),
                        child:Row(
                          children: [
                            Container(
                                padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                  5 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360),),
                                child: Image(image: AssetImage('assets/new.png'))
                            )
                          ],
                        )
                    ),
                  ],
                ),
              )
            else if(widget.urlbutton == '')
                GestureDetector(
                  onTap: (){
                  },
                  child : Container(
                    // width: 300 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        children: [
                          Container(
                            height: 25 * (MediaQuery.of(context).size.width / 360),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                              ),
                            ),
                          ),
                          Container(
                            margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                            child: Text(widget.subtitle,
                              style: TextStyle(
                                fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                fontFamily: 'NanumSquareEB',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                )
            else
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return movepage(widget.urlbutton);
                    },
                  ));
                },
                child : Container(
                  // width: 300 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      children: [
                        Container(
                          height: 25 * (MediaQuery.of(context).size.width / 360),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                          child: Text(widget.subtitle,
                            style: TextStyle(
                              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                              fontFamily: 'NanumSquareEB',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            if(widget.urlbutton != 'hoty_recommend' && widget.urlbutton != "SchoolList" && widget.urlbutton != '')
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return movepage(widget.urlbutton);
                  },
                ));
              },
              child: Container(
                // width: 30 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),

                child:Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                    Container(
                      /*padding : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                      child: ImageIcon(AssetImage('assets/arrow_right.png'), size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                    ),
                  ],
                ),
              ),
            ),
            if(widget.urlbutton == 'hoty_recommend')
              GestureDetector(
                onTap: () {
                  final dataManager = DataManager();
                  final dataToSave = {'hoty_recommend': 'N'};
                  dataManager.saveData(dataToSave);
                  setState(() {

                  });
                },
                child: Container(
                  // width: 30 * (MediaQuery.of(context).size.width / 360),
                  margin : EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),

                  child:Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Icon(Icons.keyboard_arrow_right, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),
                      Container(
                        /*padding : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                        /*child: ImageIcon(AssetImage('assets/arrow_right.png'), size: 10 * (MediaQuery.of(context).size.height / 360),  color: Colors.black,),*/
                        child : Icon(Icons.close, color: Color(0xffC4CCD0),)
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      )
    ;
  }

  Widget movepage(String subtitle) {

    if(subtitle != null){
      if(subtitle == 'TodayList'){
        return TodayList(main_catcode: '', table_nm: 'TODAY_INFO',);
      }
      if(subtitle == 'SchoolList'){
        return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
      }
      if(subtitle == 'KinList'){
        return KinList(success: false, failed: false,main_catcode: '',);
      }
      if(subtitle == 'KinList2'){
        return KinList(success: false, failed: false,main_catcode: '',);
      }
      if(subtitle == 'TradeList'){
        return TradeList(checkList: [],);
      }
      if(subtitle == 'LessonList'){
        return LessonList(checkList: [],);
      }
    }

    return MainPage();


  }
}
