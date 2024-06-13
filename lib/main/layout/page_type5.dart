import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:intl/intl.dart';

import '../../common/icons/my_icons.dart';
import '../../community/usedtrade/trade_view.dart';


Container MainPage_Type5(section05List, context) {
  var urlpath = 'http://www.hoty.company';

  return Container(
    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
    child: Column(
      children: [
        Container(
          child: Wrap(
            children: [
              // 1cow
              if(section05List.length > 0)
                for(var i=0; i<section05List.length; i++)
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return TradeView(article_seq : section05List[i]['article_seq'], table_nm : section05List[i]['table_nm'], params: {},checkList: [],);
                        },
                      ));
                    },
                    child: Container(
                      width: 170 * (MediaQuery.of(context).size.width / 360),
                      height: 120 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      // padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            // padding: EdgeInsets.fromLTRB(20,30,10,15),
                            // color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  width: 165 * (MediaQuery.of(context).size.width / 360),
                                  height: 80 * (MediaQuery.of(context).size.height / 360),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider('$urlpath${section05List[i]['main_img_path']}${section05List[i]['main_img']}'),
                                        fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                      topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                  ),
                                  // color: Colors.amberAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(section05List[i]['cat02'] == 'D201')
                                        Container(
                                            margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                0 , 0 ),

                                            decoration: BoxDecoration(
                                              color: Color(0xff53B5BB),
                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text(
                                                    '판매 중',
                                                    style: TextStyle(
                                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                      if(section05List[i]['cat02'] == 'D202')
                                        Container(
                                            margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                0 , 0 ),

                                            decoration: BoxDecoration(
                                              color: Color(0xff925331),
                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Text(
                                                    '판매완료',
                                                    style: TextStyle(
                                                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                      if(section05List[i]['like_yn'] != null && section05List[i]['like_yn'] > 0)
                                        Container(
                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                3 * (MediaQuery.of(context).size.height / 360), 0 ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                )
                                              ],
                                            )
                                        ),
                                      if(section05List[i]['like_yn'] == null || section05List[i]['like_yn'] == 0)
                                        Container(
                                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                3 * (MediaQuery.of(context).size.height / 360), 0 ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child:Row(
                                              children: [
                                                Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                )
                                              ],
                                            )
                                        ),
                                    ],
                                  ),
                                ),
                                // 하단 정보
                                Container(
                                  width: 155 * (MediaQuery.of(context).size.width / 360),
                                  // height: 30 * (MediaQuery.of(context).size.height / 360),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin : EdgeInsets.fromLTRB(1, 8  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        width: 160 * (MediaQuery.of(context).size.width / 360),
                                        height: 15 * (MediaQuery.of(context).size.height / 360),
                                        child: Text(
                                          "${section05List[i]['title']}",
                                          style: TextStyle(
                                            fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                            // color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Container(
                                        margin : EdgeInsets.fromLTRB(1, 3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                        width: 170 * (MediaQuery.of(context).size.width / 360),
                                        height: 10 * (MediaQuery.of(context).size.height / 360),
                                        child: Text(
                                          getVND("${section05List[i]['etc01']}"),
                                          style: TextStyle(
                                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                            // color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            height: 80 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/main_tr02.png'),
                                // fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                              ),
                            ),
                            // color: Colors.amberAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff925331),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Text('Sold Out',
                                            style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                    margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                        3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Icon(Icons.favorite, color: Color(0xffE6E8E9), size: 14 , ),
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 하단 정보
                          Container(
                            width: 155 * (MediaQuery.of(context).size.width / 360),
                            // height: 30 * (MediaQuery.of(context).size.height / 360),
                            child: Column(
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(1, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 160 * (MediaQuery.of(context).size.width / 360),
                                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    "Inheriting District 2 apartment.",
                                    style: TextStyle(
                                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(1, 3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 170 * (MediaQuery.of(context).size.width / 360),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    "15,000,000 VND",
                                    style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),*/

                        ],
                      ),
                    ),
                  ),





            ],
          ),
        ),
        Container(
          width: 100 * (MediaQuery.of(context).size.width / 360),
          // height: 30 * (MediaQuery.of(context).size.height / 360),
          margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),

          child: Wrap(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                    side : BorderSide(color: Color(0xff2F67D3),width: 2),
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TradeList(checkList: [],);
                    },
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360),
                          8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360)),
                      alignment: Alignment.center,
                      // width: 50 * (MediaQuery.of(context).size.width / 360),
                      child: Text('더보기', style: TextStyle(fontSize: 16, color: Color(0xff2F67D3),fontWeight: FontWeight.bold,),
                      ),
                    ),
                    Icon(My_icons.rightarrow, size: 12, color: Color(0xff2F67D3),),
                  ],
                ),
              ),
            ],
          ),
        ),
        // more
      ],
    ),

  );
}
String getVND(pay) {
  String payment = "";

  if(pay != null && pay != ''){
    var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
    getpay.format(int.parse(pay));
    payment = getpay.format(int.parse(pay)) + " VND";
  }

  return payment;
}
/*Container MainPage_Type5(section05List, context) {
  return Container(
    margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
    child: Column(
      children: [
        Container(
          child: Wrap(
            children: [
              // 1cow
              Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                height: 125 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(0,  5* (MediaQuery.of(context).size.height / 360), 0, 0),
                // padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            height: 80 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/main_tr01.png'),
                                // fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                              ),
                            ),
                            // color: Colors.amberAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff53B5BB),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Text('On Sale',
                                            style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                    margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                        3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 , ),
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 하단 정보
                          Container(
                            width: 155 * (MediaQuery.of(context).size.width / 360),
                            // height: 30 * (MediaQuery.of(context).size.height / 360),
                            child: Column(
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(1, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 160 * (MediaQuery.of(context).size.width / 360),
                                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    "Inheriting District 2 apartment.",
                                    style: TextStyle(
                                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(1, 3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 170 * (MediaQuery.of(context).size.width / 360),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    "15,000,000 VND",
                                    style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      // padding: EdgeInsets.fromLTRB(20,30,10,15),
                      // color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            width: 165 * (MediaQuery.of(context).size.width / 360),
                            height: 80 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/main_tr02.png'),
                                // fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                              ),
                            ),
                            // color: Colors.amberAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                        0 , 0 ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff925331),
                                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Text('Sold Out',
                                            style: TextStyle(
                                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                    margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                        3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        Container(
                                          padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Icon(Icons.favorite, color: Color(0xffE6E8E9), size: 14 , ),
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                          // 하단 정보
                          Container(
                            width: 155 * (MediaQuery.of(context).size.width / 360),
                            // height: 30 * (MediaQuery.of(context).size.height / 360),
                            child: Column(
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(1, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 160 * (MediaQuery.of(context).size.width / 360),
                                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    "Inheriting District 2 apartment.",
                                    style: TextStyle(
                                      fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(1, 3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  width: 170 * (MediaQuery.of(context).size.width / 360),
                                  height: 10 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    "15,000,000 VND",
                                    style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
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


            ],
          ),
        ),
        Container(
          width: 140 * (MediaQuery.of(context).size.width / 360),
          height: 30 * (MediaQuery.of(context).size.height / 360),
          margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),

          child: Wrap(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                    side : BorderSide(color: Color(0xff2F67D3),width: 2.5),
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TradeList(checkList: [],);
                    },
                  ));
                },
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                      alignment: Alignment.center,
                      width: 80 * (MediaQuery.of(context).size.width / 360),
                      child: Text('더보기', style: TextStyle(fontSize: 16, color: Color(0xff2F67D3)),
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 10 * (MediaQuery.of(context).size.height / 360), color: Color(0xff2F67D3),),
                  ],
                ),
              ),
            ],
          ),
        ),
        // more
      ],
    ),

  );
}*/

/*

class MainPage_Type5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
      child: Column(
        children: [
          Container(
            child: Wrap(
              children: [
                // 1cow
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  height: 125 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  // padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        // padding: EdgeInsets.fromLTRB(20,30,10,15),
                        // color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/main_tr01.png'),
                                  // fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                  topRight : Radius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                ),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff53B5BB),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('On Sale',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 , ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 155 * (MediaQuery.of(context).size.width / 360),
                              // height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 160 * (MediaQuery.of(context).size.width / 360),
                                    // height: 20 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "Inheriting District 2 apartment.",
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 170 * (MediaQuery.of(context).size.width / 360),
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "15,000,000 VND",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
                        // padding: EdgeInsets.fromLTRB(20,30,10,15),
                        // color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/main_tr02.png'),
                                  // fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft : Radius.circular(24),
                                  topRight : Radius.circular(24),
                                ),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff925331),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('Sold Out',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffE6E8E9), size: 14 , ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 155 * (MediaQuery.of(context).size.width / 360),
                              height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 0  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 160 * (MediaQuery.of(context).size.width / 360),
                                    height: 18 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "Inheriting District 2 apartment.",
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 170 * (MediaQuery.of(context).size.width / 360),
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "15,000,000 VND",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
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
                // 2col
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  height: 110 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  // padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // padding: EdgeInsets.fromLTRB(20,30,10,15),
                        // color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/main_tr03.png'),
                                  // fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft : Radius.circular(24),
                                  topRight : Radius.circular(24),
                                ),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff53B5BB),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('On Sale',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 , ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 155 * (MediaQuery.of(context).size.width / 360),
                              height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 0  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 160 * (MediaQuery.of(context).size.width / 360),
                                    height: 18 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "Inheriting District 2 apartment.",
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 170 * (MediaQuery.of(context).size.width / 360),
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "15,000,000 VND",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
                        // padding: EdgeInsets.fromLTRB(20,30,10,15),
                        // color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/main_tr04.png'),
                                  // fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft : Radius.circular(24),
                                  topRight : Radius.circular(24),
                                ),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff925331),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('Sold Out',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffE6E8E9), size: 14 , ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 155 * (MediaQuery.of(context).size.width / 360),
                              height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 0  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 160 * (MediaQuery.of(context).size.width / 360),
                                    height: 18 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "Inheriting District 2 apartment.",
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 170 * (MediaQuery.of(context).size.width / 360),
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "15,000,000 VND",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
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
                // 3col
                Container(
                  width: 340 * (MediaQuery.of(context).size.width / 360),
                  height: 110 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(0, 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  // padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // padding: EdgeInsets.fromLTRB(20,30,10,15),
                        // color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/main_tr01.png'),
                                  // fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft : Radius.circular(24),
                                  topRight : Radius.circular(24),
                                ),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff53B5BB),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('On Sale',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffEB5757), size: 14 , ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 155 * (MediaQuery.of(context).size.width / 360),
                              height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 0  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 160 * (MediaQuery.of(context).size.width / 360),
                                    height: 18 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "Inheriting District 2 apartment.",
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 170 * (MediaQuery.of(context).size.width / 360),
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "15,000,000 VND",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
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
                        // padding: EdgeInsets.fromLTRB(20,30,10,15),
                        // color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 80 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/main_tr02.png'),
                                  // fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft : Radius.circular(24),
                                  topRight : Radius.circular(24),
                                ),
                              ),
                              // color: Colors.amberAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                          0 , 0 ),
                                      decoration: BoxDecoration(
                                        color: Color(0xff925331),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('Sold Out',
                                              style: TextStyle(
                                                fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                      margin : EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.height / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child:Row(
                                        children: [
                                          Container(
                                            padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Icon(Icons.favorite, color: Color(0xffE6E8E9), size: 14 , ),
                                          )
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                            // 하단 정보
                            Container(
                              width: 155 * (MediaQuery.of(context).size.width / 360),
                              height: 30 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 0  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 160 * (MediaQuery.of(context).size.width / 360),
                                    height: 18 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "Inheriting District 2 apartment.",
                                      style: TextStyle(
                                        fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    margin : EdgeInsets.fromLTRB(1, 2  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                    width: 170 * (MediaQuery.of(context).size.width / 360),
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      "15,000,000 VND",
                                      style: TextStyle(
                                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                        // color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                      ),
                                    ),
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
              ],
            ),
          ),
          Container(
            width: 140 * (MediaQuery.of(context).size.width / 360),
            height: 30 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(0, 8 * (MediaQuery.of(context).size.height / 360), 0, 0),

            child: Wrap(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                      side : BorderSide(color: Color(0xff2F67D3),width: 2.5),
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TradeList(checkList: [],);
                      },
                    ));
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        alignment: Alignment.center,
                        width: 80 * (MediaQuery.of(context).size.width / 360),
                        child: Text('더보기', style: TextStyle(fontSize: 16, color: Color(0xff2F67D3)),
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 10 * (MediaQuery.of(context).size.height / 360), color: Color(0xff2F67D3),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // more
        ],
      ),

    );
  }
}*/
