import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/profile/profile_admin_detail.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../common/Nodata.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  State<ProfileAdmin> createState() => _Profile_adminState();
}

class _Profile_adminState extends State<ProfileAdmin> {
  final storage = FlutterSecureStorage();
  String? reg_id;
  var keyword = "";
  var selectServiceGubun = "";
  var cateGubun = "";

  var cateIndex = 0;
  var cateSize = 5;
  var cateTitle = ['전체보기', '비자 서비스', '출장 서비스', '24시 긴급 출장 통역', '부동산통역서비스'];

  var countType = "";

  String count1 = "0";
  String count2 = "0";

  List<dynamic> list = [];
  Map<String, dynamic> count = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getBoardList();
      });
    });

  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }

  void getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberServiceBoardAll.do',
      //'http://192.168.0.119:8080/mf/member/getMemberServiceBoardAll.do',

    );

    try {

      Map data = {
        "boardGubun": "service",
        "serviceGubun" : selectServiceGubun,
        "cateGubun":cateGubun,
        "countType":countType,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body));
        setState(() {
          list = json.decode(response.body)['result']['boardList'];
          count = json.decode(response.body)['result']['count'];
          count1 = count["COUNT_1"].toString();
          count2 = count["COUNT_2"].toString();
          print(count1);
          print(count2);
        });
        setState(() {

        });
      }

    }catch(e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
            color: Colors.black
        ),*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 25,
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
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
        titleSpacing: -8.0,
        title: Container(

          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("관리자 메뉴" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                apply_count(context),
                category(context),
                status(context),
                history_list(context),

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
          )
      ),
      extendBody: true,
    bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }

  Column history_list(BuildContext context) {

    var category = ["assets/complete_color.png", "assets/progress_color.png","assets/soldout_color.png", "assets/canceled_color.png"];

    String getVND(pay) {
      String payment = "";

      if(pay != null && pay != ''){
        var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
        getpay.format(int.parse(pay));
        payment = getpay.format(int.parse(pay)) + " VND";
      }

      return payment;
    }

    return
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for(int i = 0 ; i < list.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProfileAdminDetail(idx: list[i]['ARTICLE_SEQ']);
                    },
                  ));
                },
                child: Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  height: 80 * (MediaQuery.of(context).size.height / 360),
                  child: Column(
                    children: [
                      Container(
                        height: 50 * (MediaQuery.of(context).size.height / 360),
                        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50 * (MediaQuery.of(context).size.width / 360),
                              height: 30 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child: Image(image: AssetImage("assets/repair.png")),
                            ),
                            Container(
                              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              width: 260 * (MediaQuery.of(context).size.width / 360),
                              height: 45 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15 * (MediaQuery.of(context).size.height / 360),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 230 * (MediaQuery.of(context).size.width / 360),
                                          child: Text(list[i]['SERVICE_NM'],
                                            style: TextStyle(
                                              fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 30 * (MediaQuery.of(context).size.width / 360),
                                          child:Image(image: AssetImage(
                                              list[i]['CAT01'] == 'SRVE_001' ? 'assets/complete_color.png' : list[i]['CAT01'] == 'SRVE_002' ? 'assets/progress_color.png' : list[i]['CAT01'] == 'SRVE_003' ? 'assets/soldout_color.png' : 'assets/canceled_color.png'
                                          ),width: 30 * (MediaQuery.of(context).size.width / 360),height: 30 * (MediaQuery.of(context).size.height / 360),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 17 * (MediaQuery.of(context).size.height / 360),
                                    constraints: BoxConstraints(maxWidth : 250 * (MediaQuery.of(context).size.width / 360)),
                                    child: Text(list[i]['CONTS'].toString(),
                                      style: TextStyle(
                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                          color: Color(0xff0F1316),
                                          fontWeight: FontWeight.w400
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    height: 12 * (MediaQuery.of(context).size.height / 360),
                                    child: Text(
                                      getVND(list[i]['ETC02']),
                                      style: TextStyle(
                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                        fontWeight: FontWeight.bold,
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
                        height: 20 * (MediaQuery.of(context).size.height / 360),
                        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child: Row(
                          children: [
                            Container(
                              width: 200 * (MediaQuery.of(context).size.width / 360),
                              child: Text("ID: " + list[i]['SERVICE_ID'].toString(),
                                style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    color: Color(0xff0F1316)
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                ),
                                textAlign: TextAlign.left,),
                            ),
                            Container(
                              width: 120 * (MediaQuery.of(context).size.width / 360),
                              child: Text(list[i]['REG_DT'],
                                style: TextStyle(
                                    fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(196, 204, 208, 1)
                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                ),
                                textAlign: TextAlign.right,),
                            ),
                          ],
                        ),
                      ),
                      if(i != category.length - 1)
                        Divider(thickness: 5, height: 7 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                    ],
                  ),
                ),
              ),
            if(list.length == 0)
              Container(
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child: Nodata(),
              )
          ]
      );
  }

  SingleChildScrollView status(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 50 * (MediaQuery.of(context).size.height / 360),
            padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_001";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_01.png"), width: 80 * (MediaQuery.of(context).size.width / 360), fit: BoxFit.fill,),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_002";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_02.png"), width: 80 * (MediaQuery.of(context).size.width / 360)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_003";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_03.png"), width: 80 * (MediaQuery.of(context).size.width / 360)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80 * (MediaQuery.of(context).size.width / 360),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: (){
                      setState(() {
                        cateGubun = "SRVE_004";
                        getBoardList();
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Image(image: AssetImage("assets/service_history_icon_ko_04.png"), width:  80 * (MediaQuery.of(context).size.width / 360)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container category(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xffF3F6F8),  width: 2 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: GestureDetector(
                child: Row(
                  children: [
                    for(var i = 0; i < cateSize; i++)
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            cateIndex = i;
                            if(i == 1) {
                              selectServiceGubun = "AGENCY_SRVC";
                            } else if(i == 2) {
                              selectServiceGubun = "ON_SITE";
                            } else if(i == 3) {
                              selectServiceGubun = "INTRP_SRVC";
                            } else if(i == 4) {
                              selectServiceGubun = "REAL_ESTATE_INTRP_SRVC";
                            } else {
                              selectServiceGubun = "";
                            }
                            getBoardList();
                          });
                        },
                        child: Container(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                8 * (MediaQuery.of(context).size.width / 360),
                                0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360),
                                0 * (MediaQuery.of(context).size.height / 360),
                              ),
                              child: Text(
                                cateTitle[i],
                                style: TextStyle(
                                  color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
    );
  }

  /*Container search(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 20 * (MediaQuery.of(context).size.height / 360),
      color : Color(0xffF3F6F8),
      alignment: Alignment.center,
      child: TextField(
        decoration: InputDecoration(
          //border: OutlineInputBorder(),
          // labelText: 'Search',
          border: InputBorder.none,
          hintText: '   검색 할 키워드를 입력 해주세요',
          suffixIcon: Icon(Icons.search_rounded , color: Colors.black, size: 30,),
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
      ),
    );
  }*/
  Container apply_count(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 110 * (MediaQuery.of(context).size.height / 360),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                countType = 'count_1';
                getBoardList();
              });
            },
            child: CircleAvatarWithNumber(number: count1, color: Color(0xffE47421), text: '금일 전체 서비스\n사용자 신청 건수', additionalData: countType),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                countType = 'count_2';
                getBoardList();
              });
            },
            child: CircleAvatarWithNumber(number: count2, color: Color(0xffE47421), text: '금일 신규 서비스\n사용자 신청 건수', additionalData: countType),
          ),
        ],
      ),
    );
  }
}

class CircleAvatarWithNumber extends StatelessWidget {
  final String number;
  final Color color;
  final String text;
  final String additionalData;

  CircleAvatarWithNumber({
    required this.number,
    required this.color,
    required this.text,
    required this.additionalData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160 * (MediaQuery.of(context).size.width / 360),
          height: 70 * (MediaQuery.of(context).size.height / 360),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50 * (MediaQuery.of(context).size.width / 360),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 5 * (MediaQuery.of(context).size.height / 360),),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15 * (MediaQuery.of(context).size.width / 360),
            ),
          ),
        ),
      ],
    );
  }


}
