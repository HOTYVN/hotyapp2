import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/categorymenu/providers/living_provider.dart';
import 'package:hoty/community/device_id.dart';


class MainPage_Type1 extends StatefulWidget {
  final List<dynamic> section01List;
  final List<dynamic> coderesult;

  const MainPage_Type1({Key? key,
    required this.section01List,
    required this.coderesult,
  }) : super(key:key);

  @override
  State<MainPage_Type1> createState() => _MainPage_Type1State();
}

class _MainPage_Type1State extends State<MainPage_Type1> {

  var urlpath = 'http://www.hoty.company';
  var likes_yn = "";

  static final storage = FlutterSecureStorage();

  Future<dynamic> updatelike(int aritcle_seq, String table_nm, apptitle) async {
    String like_status = "";

    Map params = {
      "article_seq" : aritcle_seq,
      "table_nm" : table_nm,
      "title" : apptitle,
      "likes_yn" : likes_yn,
      "reg_id" : (await storage.read(key:'memberId')) ?? await getMobileId(),
    };
    like_status = await livingProvider().updatelike(params);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(widget.section01List.isNotEmpty)
            for(int i = 0 ; i < widget.section01List.length; i++)
              GestureDetector(
                onTap : () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return LivingView(article_seq: widget.section01List[i]['article_seq'], table_nm : widget.section01List[i]['table_nm'], title_catcode: widget.section01List[i]['main_category'], params: {},);
                    },
                  ));
                },
                child : Container(
                  width: 290 * (MediaQuery.of(context).size.width / 360),
                  height: 125 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(10, 0 * (MediaQuery.of(context).size.height / 360), widget.section01List.length-1 == i ? 10 : 0, 0),
                  // padding: EdgeInsets.fromLTRB(20,30,10,15),
                  // color: Colors.black,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child : Container(
                          width: 265 * (MediaQuery.of(context).size.width / 360),
                          height: 80 * (MediaQuery.of(context).size.height / 360),
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                              10 * (MediaQuery.of(context).size.width / 360), 0 ),
                          decoration: BoxDecoration(
                            image: widget.section01List[i]['main_img'] != '' &&  widget.section01List[i]['main_img']!= null ? DecorationImage(
                                image: CachedNetworkImageProvider('$urlpath${widget.section01List[i]['main_img_path']}${widget.section01List[i]['main_img']}'),
                                fit: BoxFit.cover
                            ) : DecorationImage(
                                image: AssetImage('assets/noimage.png'),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          // color: Colors.amberAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                      0 , 0 ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffEB5757),
                                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                  ),
                                  child:Row(
                                    children: [
                                      for(int j = 0; j < widget.coderesult.length; j++)
                                        if(widget.section01List[i]["cat10"] == widget.coderesult[j]["idx"])
                                          Container(
                                            padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                              7 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                            child: Text('${widget.coderesult[j]['name']}',
                                              // child: Text('${widget.section01List[i]['like_yn']}',
                                              style: TextStyle(
                                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                color: Colors.white,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                    ],
                                  )
                              ),
                              if(widget.section01List[i]['like_yn'] != null && widget.section01List[i]['like_yn'] > 0)
                                GestureDetector(
                                  onTap : () {
                                    _isLiked(true, widget.section01List[i]["article_seq"], "LIVING_INFO", widget.section01List[i]["title"], i);
                                  },
                                  child : Container(
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                          7 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
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
                                ),
                              if(widget.section01List[i]['like_yn'] == null || widget.section01List[i]['like_yn'] == 0)
                                GestureDetector(
                                  onTap : () {
                                    _isLiked(false, widget.section01List[i]["article_seq"], "LIVING_INFO", widget.section01List[i]["title"], i);
                                  },
                                  child : Container(
                                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                          7 * (MediaQuery.of(context).size.width / 360) , 0 ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
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
                                ),
                            ],
                          ),
                        ),
                      ),
                      // 하단 정보
                      Container(
                        width: 290 * (MediaQuery.of(context).size.width / 360),
                        //height: 20 * (MediaQuery.of(context).size.height / 360),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin : EdgeInsets.fromLTRB( 5  * (MediaQuery.of(context).size.height / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                  0, 0),
                              width: 270 * (MediaQuery.of(context).size.width / 360),
                              // height: 15 * (MediaQuery.of(context).size.height / 360),
                              child: Text(
                                "${widget.section01List[i]["title"]}",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  // color: Colors.white,
                                  fontFamily: 'NanumSquareEB',
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 주소
                      Container(
                          margin : EdgeInsets.fromLTRB( 7 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360), 0, 2 * (MediaQuery.of(context).size.height / 360)),
                          width: 290 * (MediaQuery.of(context).size.width / 360),
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 1  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                child:Icon(Icons.location_on_sharp, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffBBC964),),
                              ),
                              Container(
                                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                width: 255 * (MediaQuery.of(context).size.width / 360),
                                child: Text(
                                  '${widget.section01List[i]['adres']}',
                                  style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    // color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )

                      ),

                      Container(
                        width: 290 * (MediaQuery.of(context).size.width / 360),
                        // height: 15 * (MediaQuery.of(context).size.height / 360),
                        // color: Colors.purpleAccent,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                            child : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                                    // width: 120 * (MediaQuery.of(context).size.width / 360),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // width: 70 * (MediaQuery.of(context).size.width / 360),
                                            child: Row(
                                              children: [
                                                Icon(Icons.favorite, size: 7 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                                Container(
                                                  constraints: BoxConstraints(maxWidth : 70 * (MediaQuery.of(context).size.width / 360)),
                                                  margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                  padding: EdgeInsets.fromLTRB(0, 0, 8 * (MediaQuery.of(context).size.width / 360), 0),
                                                  child: Text(
                                                    '${widget.section01List[i]['like_cnt']}',
                                                    style: TextStyle(
                                                      fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                                      color: Color(0xff151515),
                                                      overflow: TextOverflow.ellipsis,
                                                      // fontWeight: FontWeight.bold,
                                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                        Container(
                                          width : 1 * (MediaQuery.of(context).size.width / 360),
                                          height: 7 * (MediaQuery.of(context).size.height / 360),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xffF3F6F8),
                                                width: 1,
                                              )
                                          ),
                                        ),
                                        Container(
                                          // width: 70 * (MediaQuery.of(context).size.width / 360),
                                          padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.remove_red_eye, size: 7 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                              Container(
                                                constraints: BoxConstraints(maxWidth : 70 * (MediaQuery.of(context).size.width / 360)),
                                                margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                padding: EdgeInsets.fromLTRB(0, 0, 8 * (MediaQuery.of(context).size.width / 360), 0),
                                                child: Text(
                                                  '${widget.section01List[i]['view_cnt']}',
                                                  style: TextStyle(
                                                    fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                                    color: Color(0xff151515),
                                                    overflow: TextOverflow.ellipsis,
                                                    // fontWeight: FontWeight.bold,
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
                                  for(var a = 0; a < widget.section01List[i]["icon_list"].length; a++)
                                    Container(
                                        child : Row (
                                          children: [
                                            Container(
                                              width : 1 * (MediaQuery.of(context).size.width / 360),
                                              height: 7 * (MediaQuery.of(context).size.height / 360),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xffF3F6F8),
                                                    width: 1,
                                                  )
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                                              child: Row(
                                                children: [
                                                  Image(image: CachedNetworkImageProvider("http://www.hoty.company/images/app_icon/${widget.section01List[i]["icon_list"][a]["icon"]}.png"), height: 8 * (MediaQuery.of(context).size.height / 360),),
                                                  Container(
                                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                    child: Text(
                                                      " ${widget.section01List[i]["icon_list"][a]["icon_nm"]}",
                                                      style: TextStyle(
                                                        fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                                        color: Color(0xff151515),
                                                        overflow: TextOverflow.ellipsis,
                                                        // fontWeight: FontWeight.bold,
                                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                ],
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

        ]
    );
  }

  void _isLiked(like_yn, article_seq, table_nm, apptitle, index) {

    setState(() {
      like_yn = !like_yn;
      if(like_yn) {
        likes_yn = 'Y';
        updatelike( article_seq, table_nm, apptitle);
        widget.section01List[index]['like_yn'] = 1;
        widget.section01List[index]['like_cnt'] = widget.section01List[index]['like_cnt'] + 1;
        setState(() {

        });
      } else{
        likes_yn = 'N';
        updatelike( article_seq, table_nm, apptitle);
        widget.section01List[index]['like_yn'] = 0;
        widget.section01List[index]['like_cnt'] = widget.section01List[index]['like_cnt'] - 1;
        setState(() {

        });
      }

    });
  }
}