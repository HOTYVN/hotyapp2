import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/profile/apart/profile_apartment_write.dart';
import 'package:hoty/profile/apart/profile_apartment_edit.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;

import '../common/Nodata.dart';
import '../common/dialog/commonAlert.dart';

class Profile_apartment extends StatefulWidget {
  const Profile_apartment({super.key});

  @override
  State<Profile_apartment> createState() => _Profile_apartmentState();
}

class _Profile_apartmentState extends State<Profile_apartment> {
  final storage = FlutterSecureStorage();
  String? reg_id;
  int? delSeq;
  List<dynamic> list = [];
  Widget _noData = Container();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getBoardList().then((_) {
          _noData = Nodata();
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

  Future<dynamic> getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberApartment.do',
      //'http://192.168.100.31:8080/mf/member/getMemberApartment.do',
    );

    try {

      Map data = {
        "memberId": reg_id,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body)['result']['apartList']);
        setState(() {
          list = json.decode(response.body)['result']['apartList'];
        });
      } else {
        setState(() {
          list = [];
        });
      }

    }catch(e) {
      print(e);
    }

  }

  void deleteSend() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/deleteMemberApartment.do',
      //'http://192.168.100.31:8080/mf/member/deleteMemberApartment.do',
    );

    try {

      Map data = {
        "apartSeq": delSeq,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print(json.decode(response.body));
      if(json.decode(response.body)['state'] == 200) {
        print('삭제 OK');
        getBoardList();
        //Navigator.pop(context);
      }

    }catch(e) {
      print(e);
    }

  }

  void deleteBbs(context) async {
    showDialog(
      context: context,
      // useSafeArea: false,
      // useRootNavigator: true,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: deletechecktext(context,'이 아파트를 삭제 하시겠습니까?'),
        );
      },
    ).then((value) => {
      if(value == true) {
        deleteSend(),
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
            color: Colors.black
        ),*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
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
        title: Container(

          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          child: Text("나의 아파트 관리" , style: TextStyle(fontSize: 17,  color: Color(0xff0F1316), fontWeight: FontWeight.w600,),
          ),
        ),
        actions: [
          Container(
            width: 80 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            child : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                  padding: EdgeInsets.symmetric(horizontal: 1 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                  ),
                  elevation: 0
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileApartmentWrite();
                  },
                ));
              },
              child: Text('아파트 추가', style: TextStyle(
                  fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                  color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center
                ,),

            ),
          ),
        ],
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(var i = 0; i < list.length; i++)
              Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                child: Column(
                  children: [
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      width: 340 * (MediaQuery.of(context).size.width / 360),
                      //height: 40 * (MediaQuery.of(context).size.height / 360),
                      child: Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            //height: 20 * (MediaQuery.of(context).size.height / 360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  width: 225 * (MediaQuery.of(context).size.width / 360),
                                  child: Text(
                                    list[i]['NAME'],
                                    style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  width: 65 * (MediaQuery.of(context).size.width / 360),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Color.fromRGBO(255, 255, 255, 1),
                                      padding: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                        Image(image: AssetImage("assets/edit.png"), width: 15 * (MediaQuery.of(context).size.width / 360)),
                                        Text(' 수정', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3), fontWeight: FontWeight.w700),),
                                      ],
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileApartmentEdit(apartSeq: list[i]['APART_SEQ']);
                                        },
                                      ));
                                    },
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  width: 30 * (MediaQuery.of(context).size.width / 360),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Color.fromRGBO(255, 255, 255, 1),
                                      padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child : Image(image: AssetImage("assets/delete.png"), width: 20 * (MediaQuery.of(context).size.width / 360)),
                                    onPressed: (){
                                      setState(() {
                                        delSeq = list[i]['APART_SEQ'];
                                        deleteBbs(context);


                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            child : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  width: 225 * (MediaQuery.of(context).size.width / 360),
                                  child: Text(
                                    list[i]['NAME'],
                                    style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w800, height: 0.7 * (MediaQuery.of(context).size.height / 360)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ProfileApartmentEdit(apartSeq: list[i]['APART_SEQ']);
                                      },
                                    ));
                                  },
                                  child : Container(
                                    width: 75 * (MediaQuery.of(context).size.width / 360),
                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                        3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(image: AssetImage("assets/edit.png"), width: 18 * (MediaQuery.of(context).size.width / 360)),
                                        Text(' 수정', style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360), color: Color(0xff2F67D3), fontWeight: FontWeight.w700),),
                                      ],
                                    )
                                  )
                                ),
                                GestureDetector(
                                  onTap : () {
                                    setState(() {
                                      delSeq = list[i]['APART_SEQ'];
                                      deleteBbs(context);
                                    });
                                  },
                                  child : Container(
                                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    child : Image(image: AssetImage("assets/delete.png"), width: 18 * (MediaQuery.of(context).size.width / 360)),
                                  )
                                )
                              ],
                            )
                          ),
                          Container(
                            width: 360 * (MediaQuery.of(context).size.width / 360),
                            margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            // height: 20 * (MediaQuery.of(context).size.height / 360),
                            child: Text(
                              list[i]['ADDRESS'] +" "+ list[i]['ADDRESS_DETAIL'],
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(list.length != i+1)
                    Divider(thickness: 5, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                  ],
                ),
              ),
            if(list.length == 0)
              _noData,
          /*  Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 3 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),*/

            Container(
              margin: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                40 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
            ),
            ]
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}