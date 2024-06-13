import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/dialog/loginAlert.dart';
import 'package:hoty/login/login.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_deletion.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import '../common/dialog/commonAlert.dart';
import '../service/model/serviceVO.dart';
import '../service/providers/service_provider.dart';

class ProfileAccount extends StatefulWidget {
  @override
  _ProfileAccountState createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {

  String? regist_id;
  String? formattedDate;
  String country_code = "";
  DateTime date = DateTime.now();

  List<serviceVO> phoneNumberCategory = [];
  String? _phoneNumberCategoryValue ;
  serviceProvider mainCategoryProvider = serviceProvider();

  late  TextEditingController _phone = TextEditingController();
  late  TextEditingController _email = TextEditingController();
  late  TextEditingController _name = TextEditingController();
  late  TextEditingController _nick = TextEditingController();
  late  TextEditingController _birth = TextEditingController();

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    initphoneNumberCategory().then((_) {
      setState(() {

      });
    });
    _userInfo().then((_){
      setState(() {

      });
    });
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId'))!;
  }

  Future initphoneNumberCategory() async {
    phoneNumberCategory = await mainCategoryProvider.getphoneNumberCategory();
  }

  /* 회원 앱푸시 사용 정보 */
  Future<void> _userInfo() async{
    final url = Uri.parse('http://www.hoty.company/mf/member/userInfo.do');
    final storage = FlutterSecureStorage();
    String? regId = await storage.read(key: "memberId");
    try {
      Map data = {
        "member_id" : regId,
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String birthString = responseData['result']['BIRTH'];
        DateTime date = DateTime.parse(birthString);
        String formattedDate = DateFormat('yyyy/MM/dd').format(date);
        _phone = TextEditingController(text: responseData['result']['CELL']);
        _email = TextEditingController(text: responseData['result']['EMAIL']);
        _name = TextEditingController(text: responseData['result']['MEMBER_NM']);
        _nick = TextEditingController(text: responseData['result']['NICKNAME']);
        _birth = TextEditingController(text: formattedDate);
        country_code = responseData['result']['COUNTRY_CODE'];
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _userUpdate(context) async{
    final url = Uri.parse('http://www.hoty.company/mf/member/userUpdate.do');
    final storage = FlutterSecureStorage();
    String? regId = await storage.read(key: "memberId");
    String birthreplace= _birth.text.replaceAll('/', '-');
    try {

      Map data = {
        "member_id" : regId,
        "cell" : _phone.text,
        "email" : _email.text,
        "birth" : birthreplace,
        "nickname" : _nick.text,
        "country_code": _phoneNumberCategoryValue.toString(),
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String msg = responseData['msg'];
        int state = responseData['state'];
        print(msg);
        print(state);

        if(state == 300){
          showDialog(
              context: context,
              //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
              barrierDismissible: false,
              barrierColor: Color(0xffE47421).withOpacity(0.4),
              builder: (BuildContext context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: textalert(context, "중복된 닉네임입니다."),
                );
              });
        } else {
          await storage.write(key: "memberNick", value: _nick.text);
        }
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> SaveDialog(BuildContext context) async{
    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: deletechecktext(context,'저장하시겠습니까?'),
        );
      },
    ).then((value)  {
      if(value == true) {
        setState(() {
          _userUpdate(context).then((_){
            _userInfo();
            setState(() {
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
        child : Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 5,
          leadingWidth: 40,
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
          title: Container(
            //width: 80 * (MediaQuery.of(context).size.width / 360),
            //height: 80 * (MediaQuery.of(context).size.height / 360),
            /*child: Image(image: AssetImage('assets/logo.png')),*/
            alignment: Alignment.centerLeft,
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Text("회원정보 설정" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  15 * (MediaQuery.of(context).size.width / 360),
                  5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "내 정보",
                  style: TextStyle(
                    fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                child: TextField(
                  enabled: false,
                  controller: _name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: ''
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                    ),
                    border: OutlineInputBorder(),
                    hintText: '이름',
                    hintStyle: TextStyle(
                      color: Color(0xffC4CCD0),
                      fontFamily: 'NanumSquareR',
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                child: TextField(
                  controller: _nick,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: ''
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                    ),
                    border: OutlineInputBorder(),
                    hintText: '닉네임',
                    hintStyle: TextStyle(
                      color: Color(0xffC4CCD0),
                      fontFamily: 'NanumSquareR',
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      // height: 25 * (MediaQuery.of(context).size.height / 360),
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 1 * (MediaQuery.of(context).size.height / 360)),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 140 * (MediaQuery.of(context).size.width / 360),
                            // height: 25 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(243, 246, 248, 1)
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: DropdownButtonFormField(
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              isExpanded: true,
                              style: TextStyle(
                                  fontSize: 15 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515)
                              ),
                              hint: Text(
                                "+84 (베트남)", style: TextStyle(
                                  fontSize: 15 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515)
                              ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: Color(0xffFFFFFF),
                                border: InputBorder.none,
                                /*focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                  borderSide: BorderSide(
                                    color:Color(0xffFFFFFF),
                                  ),
                                ),*/
                                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                                    9 * (MediaQuery.of(context).size.height / 360),
                                    0,
                                    9 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              items: phoneNumberCategory.map((serviceVO item) =>
                                  DropdownMenuItem(value: item.idx,child: Text(item.name),),)
                                  .toList(),
                              onChanged: (String? value) => setState(() {
                                this._phoneNumberCategoryValue = value;
                                setState(() {

                                });
                              }),
                              value : _phoneNumberCategoryValue,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                value = value?.trim();
                                if(value == null || value.isEmpty) {
                                  return "전화번호를 입력해주세요.";
                                }
                                return null;
                              },
                            ),
                          ),
                          // SizedBox(width : 6 * (MediaQuery.of(context).size.width / 360)),
                          Container(
                            width: 190 * (MediaQuery.of(context).size.width / 360),
                            // height: 25 * (MediaQuery.of(context).size.height / 360),
                            /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(243, 246, 248, 1)
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: TextFormField(
                              controller: _phone,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                                    10 * (MediaQuery.of(context).size.height / 360),
                                    0,
                                    10 * (MediaQuery.of(context).size.height / 360)),
                                border: InputBorder.none,
                                /*enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),*/
                                // labelText: 'Search',
                                hintText: '전화 번호',
                                hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                              ),
                              validator: (value) {
                                value = value?.trim();
                                if(value == null || value.isEmpty) {
                                  return "전화번호를 입력해주세요.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
              child: TextField(
                controller: _email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: ''
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  hintText: '이메일',
                  hintStyle: TextStyle(
                    color: Color(0xffC4CCD0),
                    fontFamily: 'NanumSquareR',
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
              child: TextField(
                controller: _birth,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: ''
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                  ),
                  border: OutlineInputBorder(),
                  hintText: '생일',
                  hintStyle: TextStyle(
                    color: Color(0xffC4CCD0),
                    fontFamily: 'NanumSquareR',
                  ),
                  suffixIcon: Icon(Icons.edit_calendar_outlined , color: Color(0xff151515), size: 22,),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context, // 팝업으로 띄우기 때문에 context 전달
                    initialDate: date, // 달력을 띄웠을 때 선택된 날짜. 위에서 date 변수에 오늘 날짜를 넣었으므로 오늘 날짜가 선택돼서 나옴
                    firstDate: DateTime(1950), // 시작 년도
                    lastDate: DateTime.now(), // 마지막 년도. 오늘로 지정하면 미래의 날짜는 선택할 수 없음
                  );
                  if (selectedDate != null) {
                    setState(() {
                      String formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
                      setState(() {
                        _birth = TextEditingController(text: formattedDate);
                      });
                    });
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                15 * (MediaQuery.of(context).size.width / 360),
                10 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "기타",
                style: TextStyle(
                  fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                ),
              ),
            ),
         /*   Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  8 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),*/
           /* TextButton(
              onPressed: () async {
                await storage.delete(key: "memberId");
                await storage.delete(key: "memberNick");
                await storage.delete(key: "memberNm");
                logout_dialog();
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 , 0 ),
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    child: Text("로그아웃",
                      style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360) ),
                    // width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),*/
            Container(
             /*   decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )*/
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileDeletion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 , 0 ),
                    width: 100 * (MediaQuery.of(context).size.width / 360),
                    child: Text("회원탈퇴",
                      style: TextStyle(
                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360) ),
                    // width: 25 * (MediaQuery.of(context).size.width / 360),
                    child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                    // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
         
          ],
        ),
      ),
          floatingActionButton: SizedBox(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            child:  Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              margin: EdgeInsets.fromLTRB(30 * (MediaQuery.of(context).size.width / 360),0,0 * (MediaQuery.of(context).size.width / 360),0),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                onPressed: (){
                  SaveDialog(context);
                },
                child: (
                    Text("저장", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color:Color.fromRGBO(255,255,255,1)),)
                ),
              ),
            ),
          ),
        )
    );
  }

  void logout_dialog(){
    showDialog(
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return logoutalert(context, '로그아웃 되었습니다.');
      },
    ).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MainPage();
        },
      ));
    });
  }
}

