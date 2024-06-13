import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:http/http.dart' as http;

class Profile_hoty_point extends StatefulWidget {
  const Profile_hoty_point({super.key});

  @override
  State<Profile_hoty_point> createState() => _Profile_hoty_pointState();
}

class _Profile_hoty_pointState extends State<Profile_hoty_point> {
  String? reg_id;
  var point_info;
  var point_limit;
  var cateIndex = 0;
  var cateSize = 3;
  var gubun = "";
  var cateTitle = ['전체보기', '적립내역', '사용내역'];
  final storage = FlutterSecureStorage();

  List<dynamic> list = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getPoint();
        getPointLimit();
      });
    });

  }

  Future<dynamic> _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = await storage.read(key:'memberId');
    return true;
  }
  void getPoint() async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberPoint.do',
      //'http://192.168.100.31:8080/mf/member/getMemberPoint.do',
    );

    try {

      Map data = {
        "memberId": reg_id,
      };
      if(cateIndex > 0){
        data = {
          "memberId": reg_id,
          "ptEnext": gubun
        };
      }
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('LOCAL');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body)['result']['pointList']);


        setState(() {
          point_info = json.decode(response.body)['result']['pointInfo']['RTN_POINT'];
          list = json.decode(response.body)['result']['pointList'];
        });

      }else {
        setState(() {
          point_info = 0;
        });
      }

    } catch(e) {
      print(e);

      setState(() {
        point_info = 0;
      });
    }

  }

  void getPointLimit() async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/point_limit.do',
      //'http://www.hoty.company/mf/common/point_limit.do',
    );

    try {
      Map data = {
        "member_id": reg_id,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if(response.statusCode == 200) {
        setState(() {
          point_limit = json.decode(response.body)['result'];
        });

      }else {
        setState(() {
          point_limit = 0;
        });
      }

    } catch(e) {
      print(e);

      setState(() {
        point_limit = 0;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: Container(
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            iconSize: 12 * (MediaQuery.of(context).size.height / 360),
            color: Color(0xff151515),
            // alignment: Alignment.center,
            // padding: EdgeInsets.zero,
            // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        titleSpacing: 5,
        leadingWidth: 40,
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("호티포인트" , style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),
            color: Color(0xff151515), fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                  color: Color(0xffFFF3EA),
                ),
                child : Column(
                  children: [
                    Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(image: AssetImage("assets/coin.png"), height: 10 * (MediaQuery.of(context).size.height / 360),),
                            Container(
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1  * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child : Text(' ${point_info ?? 0} P', style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 20 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515))),
                            )
                          ],
                        )
                    ),
                    Container(
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("적립 가능  ",  style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 11 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515))),
                            Container(
                              //width: 42 * (MediaQuery.of(context).size.width / 360),
                              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                  5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                                color: Color(0xff925331),
                              ),
                              child : Text("${point_limit ?? 0}", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.w700, fontSize: 8 * (MediaQuery.of(context).size.width / 360), ),textAlign: TextAlign.center,),
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
            GestureDetector(
              onTap: (){
                // Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return KinList(success: false, failed: false,main_catcode: '',);
                  },
                ));
              },
              child : Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                //height: 50 * (MediaQuery.of(context).size.height / 360),
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                  color: Color(0xff0075FE),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container( //이미지
                        child : Image(image: AssetImage("assets/kin_icon.png"), width: 30 * (MediaQuery.of(context).size.width / 360),)
                    ),
                    Container( //글
                      width: 250 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("호치민 뭐든지 물어봐!",
                            style: TextStyle(
                                fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareEB',
                                color: Color(0xffFFFFFF)
                            ),
                          ),
                          Text(" 지식iN",
                            style: TextStyle(
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareEB',
                                color: Color(0xff03E166)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container( //화살표
                      child: Icon(Icons.keyboard_arrow_right, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Colors.white,),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 360 *  (MediaQuery.of(context).size.width / 360),
              child: Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 10 *  (MediaQuery.of(context).size.width / 360),
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                // color: Color(0xffF3F6F8),
                                // color:Color(0xffF3F6F8),
                                color:Color(0xffF3F6F8),
                                width: 1 * (MediaQuery.of(context).size.width / 360),),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              0 * (MediaQuery.of(context).size.width / 360),
                              0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360),
                              5 * (MediaQuery.of(context).size.height / 360),
                            ),
                            child: Text(
                              "",
                              style: TextStyle(
                                // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                          ),
                        ),
                        Container(
                          // width: 230 *  (MediaQuery.of(context).size.width / 360),
                          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          /*decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color(0xffF3F6F8),
                            color:Color(0xffF3F6F8),
                            width: 1 * (MediaQuery.of(context).size.width / 360),),
                        ),
                      ),*/
                          child: GestureDetector(
                            child: Row(
                              children: [
                                for(var i = 0; i < cateSize; i++)
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        cateIndex = i;
                                        if(i == 1) {
                                          gubun = "I";
                                        } else if(i == 2) {
                                          gubun = "O";
                                        }
                                        getPoint();
                                      });
                                    },
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                          0 * (MediaQuery.of(context).size.width / 360),
                                          0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360),
                                          0 * (MediaQuery.of(context).size.height / 360),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              // color: Color(0xffF3F6F8),
                                              color: cateIndex == i ? Color(0xffE47421) : Color(0xffF3F6F8),
                                              width: 1 * (MediaQuery.of(context).size.width / 360),),
                                          ),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                            7 * (MediaQuery.of(context).size.width / 360),
                                            0 * (MediaQuery.of(context).size.height / 360),
                                            7 * (MediaQuery.of(context).size.width / 360),
                                            5 * (MediaQuery.of(context).size.height / 360),
                                          ),
                                          child: Text(
                                            cateTitle[i],
                                            style: TextStyle(
                                              color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                              //color: Color(0xff151515),
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                        )
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // width: 25 *  (MediaQuery.of(context).size.width / 360),
                      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color(0xffF3F6F8),
                            // color:Color(0xffF3F6F8),
                            color:Color(0xffF3F6F8),
                            width: 1 * (MediaQuery.of(context).size.width / 360),),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          5 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Text(
                          "",
                          style: TextStyle(
                            // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ),


            for(var item in list)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              /*height: 30 * (MediaQuery.of(context).size.height / 360),*/
              child : Column(
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360)),
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 45 * (MediaQuery.of(context).size.width / 360),
                          /*height: 40 * (MediaQuery.of(context).size.height / 360),*/
                          child: Image(image: AssetImage("assets/point_icon.png"),width: 45 * (MediaQuery.of(context).size.width / 360),),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                        ),
                        Container(
                          width: 280 * (MediaQuery.of(context).size.width / 360),
                          child: Column(
                            children: [
                              Container(
                                padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                // height: 20 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 240 * (MediaQuery.of(context).size.width / 360),
                                      child: Text(item['PT_TYPE'], style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      //width: 45 * (MediaQuery.of(context).size.width / 360),
                                      padding : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                          3 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                      //color: Colors.lightGreen,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        color:item['PT_ENEXT'] == 'I' ? Color(0xffEBF2FF) : Color(0xffFFFBF9),
                                        border: Border.all(
                                          width: 1, color: item['PT_ENEXT'] == 'I' ? Color(0xff729EF3) : Color(0xffE47421),
                                        ),
                                      ),

                                      child:
                                      Text(item['PT_ENEXT'] == 'I' ? "적립" : '사용', style: TextStyle(fontSize: 10 * (MediaQuery.of(context).size.width / 360), color:
                                      item['PT_ENEXT'] == 'I' ? Color(0xff729EF3) : Color(0xffE47421))
                                        ,textAlign: TextAlign.center,),
                                    ),
                                  ],
                                ),
                              ),
                              if(item['CONTS'] != null)
                              Container(
                                width : 360 * (MediaQuery.of(context).size.width / 360),
                                padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Text(item['CONTS'] == null ? '' : item['CONTS'],
                                  style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,),
                              ),
                              Container(
                                padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150 * (MediaQuery.of(context).size.width / 360),
                                      child: Text(item['PT_USEPAY'].toString() + " P", style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold, fontFamily: 'NanumSquareEB'),),
                                    ),
                                    Container(
                                      //width: 110 * (MediaQuery.of(context).size.width / 360),
                                      child: Text(item['REG_DT'], style: TextStyle(
                                          fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xffC4CCD0)
                                      ),),
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
                  Column(
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
                  )
                ],
              ),
            ),

            if(list.length <= 0)
              Container(
                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Text('포인트 적립/사용 이력이 존재하지 않습니다.'),
              )


            ,Container(
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
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}
