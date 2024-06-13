import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/profile/profile_main.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class ProfileReport extends StatefulWidget {
  const ProfileReport({super.key});

  @override
  State<ProfileReport> createState() => _ProfileReportState();
}

class _ProfileReportState extends State<ProfileReport> {
  final storage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  String? reg_id;
  String? reg_nm;
  String? cate;
  int? resultState;
  List<dynamic> coderesult = []; // 공통코드 리스트
  List<String> dropdown = [];

  String? select_category;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _report = TextEditingController();

  late FocusNode titleNode;
  late FocusNode reportNode;

  @override
  void initState() {
    super.initState();

    titleNode = FocusNode();
    reportNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
      getcodedata();
    });
  }

  @override
  void dispose() {
    titleNode.dispose();
    reportNode.dispose();

    super.dispose();
  }


  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    reg_nm = await storage.read(key:'memberNick');
    return true;
  }

  void reportWirte() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/setMemberReport.do',
      //'http://192.168.0.119:8080/mf/member/setMemberReport.do',
    );

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    if(cate == 'BUG'){
      cate = '50';
    }else if(cate == 'APP'){
      cate = '51';
    }else if(cate == 'CONTENTS'){
      cate = '52';
    }

    try{
      Map rst = {
        "regId": reg_id,
        "title": _title.text,
        "conts" : _report.text,
        "cat" : cate,
        "board_seq" : "25",
        "session_ip" : data["ip"].toString(),
        "session_member_id" : reg_id,
        "session_member_nm" : reg_nm,
        "etc03" : "APP_REPORT"
      };
      var body = json.encode(rst);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('response api ');
      print(json.decode(response.body));
      if(json.decode(response.body)['state'] == 200) {
          setState(() {
            resultState = 200;
          });

      }
    } catch(e) {
      print(e);
    }
  }

  Future<dynamic> getcodedata() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
    );
    try {
      Map data = {
        "pidx": "USER_REPORT",
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if(response.statusCode == 200) {
        coderesult = json.decode(response.body)['result'];
        print(" val == $coderesult");
        for(var i in coderesult){
          setState(() {
            dropdown.add(i['name'].toString());
          });
        }
        print(dropdown);

      }
    }
    catch(e){
      print(e);
    }
  }
  var _drop1open = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child : Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: Container(
            // margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 12 * (MediaQuery.of(context).size.height / 360),
              color: Colors.black,
              // alignment: Alignment.centerLeft,
              // padding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          titleSpacing: 0,
          leadingWidth: 40,
          title: Container(
            child: Text("불편사항 접수" , style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360),  color: Colors.black, fontWeight: FontWeight.bold,),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 20 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 20 * (MediaQuery.of(context).size.height / 360)),
                width : 165 * (MediaQuery.of(context).size.width / 360),
                child: Image(image : AssetImage("assets/myReport.png")),
              ),
              Form(
                  key: _formKey,
                  child : Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(14 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            14 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        //height: 25 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(243, 246, 248, 1)
                          ),
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child : DropdownButtonFormField2(
                            isExpanded: true,
                            value: select_category,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              value = value?.trim();
                              if(value == null || value.isEmpty) {
                                return "카테고리는 필수 선택값입니다.";
                              }
                              return null;
                            },
                            //isDense : true,
                            hint: Text("카테고리를 선택해주세요.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xffC4CCD0)),),
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                              elevation: 0,
                            ),
                            iconStyleData: IconStyleData(
                              openMenuIcon: Icon(
                                Icons.keyboard_arrow_up_rounded,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              iconSize: 30 * (MediaQuery.of(context).size.width / 360),
                              iconEnabledColor: Color(0xff151515),
                            ),
                            dropdownStyleData: DropdownStyleData( //드롭다운 스타일
                              elevation: 0,
                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            menuItemStyleData: MenuItemStyleData( //드롭다운 내 메뉴 별 스타일
                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            selectedItemBuilder: (BuildContext context) {
                              return dropdown.map<Widget>((item) {
                                return Container(
                                    width:double.infinity,
                                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                    alignment:Alignment.centerLeft,
                                    decoration:BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                    ),
                                    //padding: const EdgeInsets.fromLTRB(0,8.0,0,6.0),
                                    child:Text(item)
                                );
                              }).toList();
                            },
                            items: dropdown
                                .map<DropdownMenuItem<String>>((String value) =>
                                DropdownMenuItem(value: value,
                                  child: Container(
                                      width:double.infinity,
                                      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                      alignment:Alignment.centerLeft,
                                      decoration:BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          border:Border(
                                              top:BorderSide(color:Color(0xffF3F6F8),width: value == "앱 버그 신고" ? 1 : 0),
                                              bottom:BorderSide(color:Color(0xffF3F6F8),width:1),
                                              left:BorderSide(color:Color(0xffF3F6F8),width:1),
                                              right:BorderSide(color:Color(0xffF3F6F8),width:1)
                                          )
                                      ),
                                      //padding: const EdgeInsets.fromLTRB(0,8.0,0,6.0),
                                      child:Text(value)
                                  ),
                                ),
                            ).toList(),
                            onChanged: (String? value) => setState(() {
                              _drop1open = false;

                              for(var i in coderesult) {
                                if(i['name'] == value){
                                  select_category = i['name'];
                                  print(i);
                                  cate = i['idx'];
                                }
                              }
                            }),
                          ),
                        )
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      //height: 25 * (MediaQuery.of(context).size.height / 360),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(243, 246, 248, 1)
                        ),
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: TextFormField(
                        controller: _title,
                        focusNode: titleNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                          /*enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),*/
                          // labelText: 'Search',
                          hintText: '제목',
                          hintStyle: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xffC4CCD0)),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          value = value?.trim();
                          if(value == null || value.isEmpty) {
                            titleNode.requestFocus();
                            return "제목을 입력해주세요";
                          }
                          return null;
                        },
                        style: TextStyle(fontFamily: ''),
                      ),
                    ),
                    Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      height: 80 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(243, 246, 248, 1)
                        ),
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: TextFormField(
                        controller: _report,
                        focusNode: reportNode,
                        maxLines: 5,
                        minLines: 5,
                        decoration: InputDecoration(
                          contentPadding : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          border: InputBorder.none,
                          /*enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),*/
                          // labelText: 'Search',
                          hintText: '신고 사유 입력',
                          hintStyle: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xffC4CCD0)),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          value = value?.trim();
                          if(value == null || value.isEmpty) {
                            if(_title.text != null && _title.text != '') {
                              reportNode.requestFocus();
                            }
                            return "신고 사유를 입력해주세요";
                          }
                          return null;
                        },
                        style: TextStyle(fontFamily: ''),
                      ),
                    ),

                      /*Container(
                        width: 340 * (MediaQuery.of(context).size.width / 360),
                        height: 30 * (MediaQuery.of(context).size.height / 360),
                        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        child: Row(
                          children: [
                            Container(
                              width: 330 * (MediaQuery.of(context).size.width / 360),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: click_check == 0
                                        ? Color.fromRGBO(255, 243, 234, 1)
                                        : Color.fromRGBO(228, 116, 33, 1),
                                    padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                                    )
                                ),
                                onPressed : () {
                                  setState(() {
                                    if(_formKey.currentState!.validate()) {
                                      if(click_check == 1) {
                                        setState(() {
                                          click_check = 0;
                                        });
                                        reportWirte();
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0)),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "접수 되었습니다.",
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: new Text("확인"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(context, MaterialPageRoute(
                                                        builder: (context) {
                                                          return Profile_main();
                                                        },
                                                      ));
                                                    },
                                                  ),
                                                ],
                                              );
                                            }
                                        );
                                      }
                                    }
                                  });
                                },
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('등록하기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: click_check == 0 ? Color(0xffE47421) : Colors.white),textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),*/
                    ],
                  )
              ),
              // apply(context)

              /*Container(
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
        //extendBody: true,
        //bottomNavigationBar: Footer(nowPage: 'My_page'),
        bottomNavigationBar: Container(
          width: 360 * (MediaQuery.of(context).size.width / 360),
          height: 30 * (MediaQuery.of(context).size.height / 360),
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
          child: Row(

            children: [
              Container(
                width: 330 * (MediaQuery.of(context).size.width / 360),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: click_check == 0
                          ? Color.fromRGBO(255, 243, 234, 1)
                          : Color.fromRGBO(228, 116, 33, 1),
                      padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                      )
                  ),
                  onPressed : () {
                    setState(() {
                      if(_formKey.currentState!.validate()) {
                        if(click_check == 1) {
                          setState(() {
                            click_check = 0;
                          });
                          reportWirte();
                          showDialog(
                            context: context,
                            barrierColor: Color(0xffE47421).withOpacity(0.4),
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                child: textalert2(context, "접수 되었습니다."),
                              );
                            },
                          ).then((value) => {
                            Navigator.pop(context),
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Profile_main();
                              },
                            )),
                          });
                        }
                      }
                    });
                  },
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('등록하기', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w700, color: click_check == 0 ? Color(0xffE47421) : Colors.white),textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}