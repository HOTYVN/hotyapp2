import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_service_history.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/dialog/commonAlert.dart';

class ProfileServiceHistoryDetail extends StatefulWidget{
  final int idx;

  ProfileServiceHistoryDetail({super.key, required this.idx});

  @override
  State<ProfileServiceHistoryDetail> createState() => _ProfileServiceHistoryDetailState();
}

class _ProfileServiceHistoryDetailState extends State<ProfileServiceHistoryDetail> {
  final storage = FlutterSecureStorage();
  String? reg_id;
  Map result = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getBoardList().then((_) {
          setState(() {

          });
        });
      });
    });

  }


  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }
  void setServiceCancel(context) async{
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/setServiceCancel.do',
      //'http://192.168.100.31:8080/mf/member/setServiceCancel.do',
    );

    Map jsoData = {
      "memberId": reg_id,
      "articleSeq" : result['ARTICLE_SEQ']
    };
    var body = json.encode(jsoData);
    var response = await http .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print('state ==> ');
    print(json.decode(response.body));
    if(json.decode(response.body)['state'] == 200) {
      showDialog(
        context: context,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: delalert2(context,),
          );
        },
      ).then((value) {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Profile_service_history();
          },
        ));
      });
    }
  }

  Future<dynamic> getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberServiceBoardView.do',
      //'http://192.168.100.31:8080/mf/member/getMemberServiceBoardView.do',
    );

    try {

      Map data = {
        "memberId": reg_id,
        "articleSeq": widget.idx
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body)['result']['view']);
        setState(() {
          result = json.decode(response.body)['result']['view'];
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
          child: Text("서비스 신청 내역" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(result.length > 0)
            Container(
              child: Column(
                children: [
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('서비스', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR', )),
                        Text(result['SERVICE_NM'].toString(), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',)),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('이름', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text(result['REG_NM'].toString(), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',)),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('전화번호', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text(result['ETC09'].toString(), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',)),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('주소', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Container(
                          constraints: BoxConstraints(maxWidth : 210 * (MediaQuery.of(context).size.width / 360)),
                          child: Text(result['ADRES'].toString(), style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',
                          ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('상세주소', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Container(
                          constraints: BoxConstraints(maxWidth : 210 * (MediaQuery.of(context).size.width / 360)),
                          child: Text(result['ADRES_DETAIL'].toString(), style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black,fontFamily: 'NanumSquareR',
                          )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('통역 수준', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text('${result['CAT02'] == null ? '': result['CAT02']}', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black,fontFamily: 'NanumSquareR',))
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('출장 시작 시간', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text(result['SDATE'].toString(), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black,fontFamily: 'NanumSquareR',))
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('출장 종료 시간', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text(result['EDATE'].toString(), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',))
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('신청 내용', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Container(
                          constraints: BoxConstraints(maxWidth : 210 * (MediaQuery.of(context).size.width / 360)),
                          child: Text('${result['CONTS']}', style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black,fontFamily: 'NanumSquareR',
                          )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('서비스 비용', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text(sumVND('${result['ETC01']}','${result['ETC02']}'), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',)),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('포인트 사용 금액', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text("${result['ETC01']} P", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',)),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width:  MediaQuery.of(context).size.width,
                    /*decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffF3F6F8),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),*/
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('현장 결제 금액', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',)),
                        Text(getVND('${result['ETC02']}'), style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black, fontFamily: 'NanumSquareR',)),
                      ],
                    ),
                  ),
                  Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width: (MediaQuery.of(context).size.width),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      onPressed: (){
                        _launchURL("http://pf.kakao.com/_gYrxnG");
                      },
                      child: Text('1:1 문의하기', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360), color: Colors.white,fontWeight: FontWeight.w800,fontFamily: 'NanumSquareR',),),
                    ),
                  ),
                  if(result['CAT01'] == '신청완료')
                    Container(
                      margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                      width: (MediaQuery.of(context).size.width),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                              side : BorderSide(color: Color(0xffE47421)),

                            )
                        ),
                        onPressed: (){
                          deleteAlert(context);
                        },
                        child: Text('취소', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360), color: Color(0xffE47421)),),
                      ),
                    ),
              /*    Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      40 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      // bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  String sumVND(pay1,pay2) {
    String payment = "";

    if(pay1 == null || pay1 == '') {
      pay1 = '0';
    }
    if(pay2 == null || pay2 == '') {
      pay2 = '0';
    }

    var getpay = NumberFormat.simpleCurrency(locale: 'ko_KR', name: "", decimalDigits: 0);
    getpay.format(int.parse(pay1) + int.parse(pay2));
    payment = getpay.format(int.parse(pay1) + int.parse(pay2)) + " VND";

    return payment;
  }

  deleteAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: deletechecktext(context,'서비스를 취소 하시겠습니까?'),
        );
      },
    ).then((value) => {
      if(value == true) {
        setServiceCancel(context),
      }
    });
  }
}
