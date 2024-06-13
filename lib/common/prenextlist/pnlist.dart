import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/categorymenu/living_view.dart';

import 'package:http/http.dart' as http;

import '../../community/device_id.dart';
import '../js/common_js.dart';



class PreNextList extends StatefulWidget {
  final int article_seq;
  final String table_nm;
  final String main_cat;
  final String pre_article_seq;
  final String next_article_seq;
  final List<dynamic> pnlist;
  final List<dynamic> coderesult;
  final Map params;


  const PreNextList({super.key,
    required this.article_seq,
    required this.table_nm,
    required this.main_cat,
    required this.pre_article_seq,
    required this.pnlist,
    required this.next_article_seq,
    required this.coderesult,
    required this.params
  });

  @override
  _PreNextList createState() => _PreNextList();
}


class _PreNextList extends State<PreNextList> {
  Map params = {};
  var urlpath = 'http://www.hoty.company';
  var Baseurl = "http://www.hoty.company/mf";
  // var Baseurl = "http://192.168.0.109/mf";
  // var Baseurl = "http://192.168.0.3/mf";

  List<dynamic> pnlist = [];
  List<dynamic> coderesult = []; // 공통코드 리스트

  final GlobalKey pre_article_key = GlobalKey();


  // 이전,다음글 시퀀스
  String next_seq = '';
  String pre_seq = '';


  Map prev_cnt = {};
  Map next_cnt = {};
  Map prev_article = {};
  Map next_article = {};

  static final storage = FlutterSecureStorage();


  // list 호출
  Future<dynamic> getlistdata() async {
    Map<String, dynamic> rst = {};
    Map<String, dynamic> getresult = {};


    var totalpage = '';

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
        Baseurl + "/living/pnlist.do"
    );
    print('######');
    try {
      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : widget.table_nm,
        "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
        "sort_nm" : widget.params['sort_nm'],
        "keyword" : widget.params['keyword'],
        "condition" : widget.params['condition'],
        "main_category" : widget.main_cat,
        "sub_category" : widget.params['sub_category'].toList(),
        "checklist" : widget.params['checklist'].toList(),
        "area_category" : widget.params['area_category'].toList(),

      };

      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];

        getresult.forEach((key, value) {
          if(key == 'pnlist'){
            pnlist.addAll(value);
          }
          if(key == 'prev_cnt'){
            prev_cnt.addAll(value);
          }
          if(key == 'next_cnt'){
            next_cnt.addAll(value);
          }
          if(key == 'prev_seq'){
            if(value != null){
              prev_article.addAll(value);
            }
          }
          if(key == 'next_seq'){
            if(value != null){
              next_article.addAll(value);
            }
          }
        });

      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }

    return rst;
  }

  final ScrollController _scrollController = ScrollController();

  void controll() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(
        pre_article_key.currentContext!,
      );
    });
  }


  @override
  void initState() {

    super.initState();
    getlistdata().then((_) {
      setState(() {
       /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Scrollable.ensureVisible(
            pre_article_key.currentContext!,
          );
        });*/
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 120 * (MediaQuery.of(context).size.height / 360),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      color: Color(0xffF9FBFB),
      child: Column(
        children: [
          Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            height: 15 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360) , 0, 0),
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:() {
                          if(prev_cnt['prev_cnt'] > 0) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LivingView(
                                    article_seq: prev_article['article_seq'],
                                    table_nm: widget.table_nm,
                                    title_catcode: widget.main_cat, params: widget.params,
                                );
                              },
                            ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,size: 16,),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        child: Text(
                          "이전게시글",
                          style: TextStyle(
                            // color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            fontFamily: 'NanumSquareEB',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: 40 * (MediaQuery.of(context).size.width / 360),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "다음게시글",
                          style: TextStyle(
                            // color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NanumSquareEB',
                            fontSize: 17,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:() {
                          if(next_cnt['next_cnt'] > 0) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LivingView(
                                  article_seq: next_article['article_seq'],
                                  table_nm: widget.table_nm,
                                  title_catcode: widget.main_cat, params: widget.params,
                                );
                              },
                            ));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,size: 16,),
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
            width: 340 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xffE47421), )
              ),
            ),
          ),
          if(pnlist.length > 0)
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 70 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
            // color: Colors.blue,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(prev_cnt['prev_cnt'] != null)
                    if(prev_cnt['prev_cnt'] < 5)
                    Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                    child: Column(
                      children: [
                        Container(
                          width: 165 * (MediaQuery.of(context).size.width / 360),
                          height: 55 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/noimage.png'),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                        ),
                        Container(
                          width: 165 * (MediaQuery.of(context).size.width / 360),
                          margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                          constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                          child: Text(
                            '이전 게시글이 없습니다.',
                            style: TextStyle(
                              fontSize: 15,
                              // color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NanumSquareR',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                    for(var i=0; i<pnlist.length; i++)
                    Container(
                      child: Row(
                        children: [
                          if(prev_article['article_seq'] != '' && prev_article['article_seq'] != null)
                            if(prev_article['article_seq'] == pnlist[i]['article_seq'])
                            GestureDetector(
                              onTap:() {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                  // fullscreenDialog: true,
                                  builder: (context) {
                                    return LivingView(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], title_catcode: pnlist[i]['main_category'], params: widget.params,);
                                  },
                                ));
                              },
                              child: Container(
                                key : pre_article_key,
                                margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 165 * (MediaQuery.of(context).size.width / 360),
                                      height: 55 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: pnlist[i]['main_img'] != null && pnlist[i]['main_img'] != '' ? DecorationImage(
                                            image:  CachedNetworkImageProvider(urlpath+'${pnlist[i]['main_img_path']}${pnlist[i]['main_img']}'),
                                            fit: BoxFit.cover
                                        ) : DecorationImage(
                                            image: AssetImage('assets/noimage.png'),
                                            fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                  0 , 0 ),
                                              decoration: BoxDecoration(
                                                color: Color(0xff2F67D3),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child:Row(
                                                children: [
                                                  if(pnlist[i]['area_category'] != null && pnlist[i]['area_category'] != '' )
                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                      child: Text(getCodename(pnlist[i]['area_category'], widget.coderesult),
                                                        style: TextStyle(
                                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                          color: Colors.white,
                                                          // fontWeight: FontWeight.bold,
                                                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                ],
                                              )
                                          ),
                                          Container(
                                              margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                  6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                shape: BoxShape.circle,
                                              ),
                                              child:Row(
                                                children: [
                                                  if(pnlist[i]['like_yn'] != null && pnlist[i]['like_yn'] > 0)
                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                      child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                    ),
                                                  if(pnlist[i]['like_yn'] == null || pnlist[i]['like_yn'] == 0)
                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                      child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                    ),
                                                ],
                                              )
                                          )
                                        ],

                                      ),
                                    ),
                                    Container(
                                      width: 165 * (MediaQuery.of(context).size.width / 360),
                                      margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                      child: Text(
                                        '${pnlist[i]['title']}',
                                        // '${pnlist[i]['article_seq']}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          // color: Colors.red,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // if(prev_article['article_seq'] == null || prev_article['article_seq'] == '')
                            if(prev_article['article_seq'] != pnlist[i]['article_seq'])
                            GestureDetector(
                              onTap:() {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(
                                  // fullscreenDialog: true,
                                  builder: (context) {
                                    return LivingView(article_seq: pnlist[i]['article_seq'], table_nm: pnlist[i]['table_nm'], title_catcode: pnlist[i]['main_category'], params: widget.params,);
                                  },
                                ));
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 165 * (MediaQuery.of(context).size.width / 360),
                                      height: 55 * (MediaQuery.of(context).size.height / 360),
                                      decoration: BoxDecoration(
                                        image: pnlist[i]['main_img'] != null && pnlist[i]['main_img'] != '' ? DecorationImage(
                                            image:  CachedNetworkImageProvider(urlpath+'${pnlist[i]['main_img_path']}${pnlist[i]['main_img']}'),
                                            fit: BoxFit.cover
                                        ) : DecorationImage(
                                            image: AssetImage('assets/noimage.png'),
                                            fit: BoxFit.cover
                                        ),
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                  0 , 0 ),
                                              decoration: BoxDecoration(
                                                color: Color(0xff2F67D3),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              child:Row(
                                                children: [
                                                  if(pnlist[i]['area_category'] != null && pnlist[i]['area_category'] != '' )
                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        6 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                      child: Text(getCodename(pnlist[i]['area_category'], widget.coderesult),
                                                        style: TextStyle(
                                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                          color: Colors.white,
                                                          // fontWeight: FontWeight.bold,
                                                          // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                ],
                                              )
                                          ),
                                          Container(
                                              margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360),
                                                  6 * (MediaQuery.of(context).size.width / 360) , 0 ),                                // width: 40 * (MediaQuery.of(context).size.width / 360),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                                shape: BoxShape.circle,
                                              ),
                                              child:Row(
                                                children: [
                                                  if(pnlist[i]['like_yn'] != null && pnlist[i]['like_yn'] > 0)
                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                      child: Icon(Icons.favorite, color: Color(0xffE47421), size: 16 , ),
                                                    ),
                                                  if(pnlist[i]['like_yn'] == null || pnlist[i]['like_yn'] == 0)
                                                    Container(
                                                      padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                        4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                      child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 16 , ),
                                                    ),
                                                ],
                                              )
                                          )
                                        ],

                                      ),
                                    ),
                                    Container(
                                      width: 165 * (MediaQuery.of(context).size.width / 360),
                                      margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                      constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                                      child: Text(
                                        '${pnlist[i]['title']}',
                                        // '${pnlist[i]['article_seq']}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NanumSquareR',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  if(next_cnt['next_cnt'] != null)
                    if(next_cnt['next_cnt'] < 5)
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10  * (MediaQuery.of(context).size.width / 360) , 0),
                        child: Column(
                          children: [
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              height: 55 * (MediaQuery.of(context).size.height / 360),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/noimage.png'),
                                    fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              ),
                            ),
                            Container(
                              width: 165 * (MediaQuery.of(context).size.width / 360),
                              margin: EdgeInsets.fromLTRB(0, 5  * (MediaQuery.of(context).size.height / 360), 0, 0),
                              constraints: BoxConstraints(maxWidth : 165 * (MediaQuery.of(context).size.width / 360)),
                              child: Text(
                                '다음 게시글이 없습니다.',
                                style: TextStyle(
                                  fontSize: 15,
                                  // color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NanumSquareR',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}