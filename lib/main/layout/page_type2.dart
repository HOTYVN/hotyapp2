import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/kin/kinlist.dart';

import '../../categorymenu/living_view.dart';
import '../../common/icons/my_icons.dart';
import '../../community/dailytalk/community_dailyTalk.dart';
import '../../community/privatelesson/lesson_list.dart';
import '../../community/usedtrade/trade_list.dart';
import '../../service/service_guide.dart';
import '../../today/today_list.dart';


Row MainPage_Type2(section02List,coderesult,context) {
  var urlpath = 'http://www.hoty.company';
  List<dynamic> getsection02List = [];
  var title_living = ['M01','M02','M03','M04','M05'];
  var title_menu_cat = ""; // 타이틀메뉴 코드 idx
  var title_menu_cidx = ""; // 타이틀메뉴 cidx(기존메뉴IDX)
  List<dynamic> subcat = [];
  int hexToInteger(String hex) => int.parse(hex, radix: 16);

  var menu_code = [];

  section02List.forEach((val){
    menu_code.add(val['main_category']);
  });


  coderesult.forEach((value) {
    if(menu_code.contains(value['idx'])){
      subcat.add(value);
    }
  });

  print("###");
  print(section02List);

  getsection02List = section02List;

 /* var cat_nm = 'C1';
  if(section02List.length > 0) {
    for (var i = 0; i < coderesult.length; i++) {
      if (coderesult[i]['pidx'] == cat_nm) {
        getsection02List.addAll(section02List[coderesult[i]['idx']]);
      }
    }
  }*/

  String getTitlecode(idx) {
    var title_code = '';

    coderesult.forEach((value) {
      if(value['idx'] == idx) {
        title_code = value['cidx'];
      }
    });


    return title_code;
  }

  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(getsection02List.length > 0)
          for(var i=0; i<getsection02List.length; i++)
            //if(getsection02List[i]["main_category"] != "C106")
            GestureDetector(
              onTap: (){
                // Navigator.pop(context);
                if(title_living.contains(getsection02List[i]['table_nm'])){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return LivingList(title_catcode: getTitlecode('${getsection02List[i]['table_nm']}'), check_sub_catlist: [getTitlecode('${getsection02List[i]['main_category']}')], check_detail_catlist: [], check_detail_arealist: [],);
                    },
                  ));
                }
                if(getsection02List[i]['table_nm'] == 'M06'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Service_guide(table_nm : "${getsection02List[i]['main_category']}");
                    },
                  ));
                }
                if(getsection02List[i]['table_nm'] == 'M07'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      if(getsection02List[i]['main_category'] == 'M0701') {
                        return TradeList(checkList: [],);
                      } else if(getsection02List[i]['main_category'] == 'M0702'){
                        return LessonList(checkList: [],);
                      } else {
                        return CommunityDailyTalk(main_catcode: getTitlecode('${getsection02List[i]['main_category']}'));
                      }
                    },
                  ));
                }
                if(getsection02List[i]['table_nm'] == 'M08'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TodayList(main_catcode: '',table_nm : getTitlecode('${getsection02List[i]['main_category']}'));
                    },
                  ));
                }
                if(getsection02List[i]['table_nm'] == 'M10'){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return KinList(success: false, failed: false,main_catcode: '',);
                    },
                  ));
                }
              },
              child: Container(
                height: 70 * (MediaQuery.of(context).size.height / 360),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0.5,
                      blurRadius: 8,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                margin : EdgeInsets.fromLTRB(8, 0 * (MediaQuery.of(context).size.height / 360), 8, 0),
                // padding: EdgeInsets.fromLTRB(20,30,10,15),
                // color: Colors.black,
                width: 125 * (MediaQuery.of(context).size.width / 360),
                child: Column(
                  children: [
                      Container(
                      width: 105 * (MediaQuery.of(context).size.width / 360),
                      height: 50 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),5 * (MediaQuery.of(context).size.width / 360), 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        // color: Color(0xff+int.parse(getsection02List[i]['bak_colr'], radix: 16)),
                        color: getsection02List[i]['bak_colr'] != null ? Color(hexToInteger('FF${getsection02List[i]['bak_colr']}')) : Color(0xffF3F6F8),

                      ),
                        child: getSubIcons('${getsection02List[i]['main_category']}', context),

                        // color: Colors.amberAccent,
                    ),
                    // 하단 정보
                    for(var m=0; m<coderesult.length; m++)
                      if(coderesult[m]['idx'] == getsection02List[i]['main_category'])
                        Container(
                          width: 126 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0, 1 * (MediaQuery.of(context).size.height / 360), 0, 0),
                          // height: 15 * (MediaQuery.of(context).size.height / 360),
                          child: Column(
                            children: [
                              Container(
                                margin : EdgeInsets.fromLTRB( 1  * (MediaQuery.of(context).size.height / 360), 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                width: 160 * (MediaQuery.of(context).size.width / 360),
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Text(
                                  "${coderesult[m]['name']}",
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w700,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),

      ]
  );
}


Container getSubIcons(idx, BuildContext context) {
  var catcolor = Color(0xffE47421);
  var caticon = My_icons.M0101;
  // print(idx);
  if(idx != null) {
    // 생활정보
    if(idx == 'M0101'){
      caticon = My_icons.M0101;
      catcolor = Color(0xffE47421);
    }
    if(idx == 'M0102'){
      caticon = My_icons.M0102;
      catcolor = Color(0xff1C52DD);
    }
    if(idx == 'M0103'){
      caticon = My_icons.M0103;
      catcolor = Color(0xffFFC2C2);
    }
    if(idx == 'M0104'){
      caticon = My_icons.M0104;
      catcolor = Color(0xff0F8F78);
    }
    if(idx == 'M0105'){
      caticon = My_icons.M0105;
      catcolor = Color(0xffFBCD58);
    }
    if(idx == 'M0106'){
      caticon = My_icons.M0106;
      catcolor = Color(0xffC7A276);
    }
    if(idx == 'M0107'){
      caticon = My_icons.M0107;
      catcolor = Color(0xff719EF3);
    }
    if(idx == 'M0108'){
      caticon = My_icons.M0108;
      catcolor = Color(0xff2F67D3);
    }
    // 음식점
    if(idx == 'M0201'){
      caticon = My_icons.M0201;
      catcolor = Color(0xff925330);
    }
    if(idx == 'M0202'){
      caticon = My_icons.M0202;
      catcolor = Color(0xffEB5757);
    }
    if(idx == 'M0203'){
      caticon = My_icons.M0203;
      catcolor = Color(0xffB22222);
    }
    if(idx == 'M0204'){
      caticon = My_icons.M0204;
      catcolor = Color(0xff9B51E0);
    }
    // 취미
    if(idx == 'M0301'){
      caticon = My_icons.M0301;
      catcolor = Color(0xff85AEE3);
    }
    if(idx == 'M0302'){
      caticon = My_icons.M0302;
      catcolor = Color(0xffEB5757);
    }
    if(idx == 'M0303'){
      caticon = My_icons.M0303;
      catcolor = Color(0xff15B797);
    }
    if(idx == 'M0304'){
      caticon = My_icons.M0304;
      catcolor = Color(0xffBBC964);
    }
    // 의료
    if(idx == 'M0401'){
      caticon = My_icons.M0401;
      catcolor = Color(0xffFBCD58);
    }
    if(idx == 'M0402'){
      caticon = My_icons.M0402;
      catcolor = Color(0xff2D9CDB);
    }
    if(idx == 'M0403'){
      caticon = My_icons.M0403;
      catcolor = Color(0xffDE8F8F);
    }
    if(idx == 'M0404'){
      caticon = My_icons.M0404;
      catcolor = Color(0xff0F8F78).withOpacity(0.75);
    }
    // 교육
    if(idx == 'M0501'){
      caticon = My_icons.M0501;
      catcolor = Color(0xffDABE87);
    }
    if(idx == 'M0502'){
      caticon = My_icons.M0502;
      catcolor = Color(0xffD6AEE9);
    }
    // 서비스
    if(idx == 'M0601'){
      caticon = My_icons.M0601;
      catcolor = Color(0xff2F67D3);
    }
    if(idx == 'M0602'){
      caticon = My_icons.M0602;
      catcolor = Color(0xffFFC2C2);
    }
    if(idx == 'M0603'){
      caticon = My_icons.M0603;
      catcolor = Color(0xff925330);
    }
    // 커뮤니티
    if(idx == 'M0701'){
      caticon = My_icons.M0701;
      catcolor = Color(0xff53B5BB);
    }
    if(idx == 'M0702'){
      caticon = My_icons.M0702;
      catcolor = Color(0xff27AE60);
    }
    if(idx == 'M0703'){
      caticon = My_icons.M0703;
      catcolor = Color(0xffFBCD58);
    }
    if(idx == 'M0704'){
      caticon = My_icons.M0704;
      catcolor = Color(0xffBBC964);
    }
    if(idx == 'M0705'){
      caticon = My_icons.M0705;
      catcolor = Color(0xffE47421);
    }
    if(idx == 'M0706'){
      caticon = My_icons.M0706;
      catcolor = Color(0xff9B51E0);
    }
    // 호티의추천
    if(idx == 'M0801'){
      caticon = My_icons.M0801;
      catcolor = Color(0xff2F67D3);
    }
    if(idx == 'M0802'){
      caticon = My_icons.M0802;
      catcolor = Color(0xff2F67D3);
    }
    if(idx == "M1001") {
      caticon = My_icons.M1001;
      catcolor = Color(0xff3290FF);
    }


  }
  // 아이콘 세팅
  Icon subicon = Icon(caticon, size: 30 * (MediaQuery.of(context).size.height / 360),  color: catcolor,);
  Image subimage = Image(image: AssetImage('assets/today_menu01_1.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);

  var gubun = ['M0801','M0802','M0203'];
  // 아이콘미사용
  if(idx != null) {
    if(idx == 'M0203') {
      subimage = Image(image: AssetImage('assets/M0203.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);
    }
    if(idx == 'M0801') {
      subimage = Image(image: AssetImage('assets/M0801.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);
    }
    if(idx == 'M0802') {
      subimage = Image(image: AssetImage('assets/M0802.png'), height: 55 * (MediaQuery.of(context).size.height / 360),);
    }
  }

  return Container(
    child: subicon,
  );
}
