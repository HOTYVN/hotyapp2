import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/main/main_page.dart';

import 'package:http/http.dart' as http;

import '../login/login.dart';

class ProfileDeletion extends StatefulWidget {
  @override
  _ProfileDeletionState createState() => _ProfileDeletionState();
}

class _ProfileDeletionState extends State<ProfileDeletion> {

  String regist_id = "";

  bool _isCheck1 = false;
  bool _isCheck2 = false;
  bool _isCheck3 = false;
  bool _isCheck4 = false;

  List<String> checkList = [];

  TextEditingController inputController1 = TextEditingController();  // 텍스트박스4개
  TextEditingController inputController2 = TextEditingController();
  TextEditingController inputController3 = TextEditingController();
  TextEditingController inputController4 = TextEditingController();
  TextEditingController inputController5 = TextEditingController();
  TextEditingController inputController6 = TextEditingController();

  final _contsController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId')) ?? "";
  }

  Future<void> _userDelete(context) async{
    final url = Uri.parse('http://www.hoty.company/mf/member/userDelete.do');
    //final url = Uri.parse('http://192.168.0.119:8080/mf/member/userDelete.do');
    final storage = FlutterSecureStorage();
    String? regId = await storage.read(key: "memberId");
    String combinedString = checkList.join(',');
    try {

      Map data = {
        "member_id" : regId,
        "del_type" : combinedString,
        "leave_cont" : _contsController.text,
        "birth" : inputController1.text + inputController2.text + inputController3.text + inputController4.text + inputController5.text + inputController6.text
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

        if(state == 300){
          inputController1.clear();
          inputController2.clear();
          inputController3.clear();
          inputController4.clear();
          inputController5.clear();
          inputController6.clear();
          showDialog(
            barrierDismissible: false,
            barrierColor: Color(0xffE47421).withOpacity(0.4),
            context: context,
            builder: (BuildContext context) {
              return textalert(context, msg);
            },
          );
        }else{
          await storage.delete(key: "memberId");
          showDialog(
            barrierDismissible: false,
            barrierColor: Color(0xffE47421).withOpacity(0.4),
            context: context,
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: textalert(context, msg),
              );
            },
          ).then((value) {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Login(subtitle: '',);
              },
            ));
          });
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
      barrierDismissible: false,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            content: Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 160 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 65 * (MediaQuery.of(context).size.width / 360),
                      child: Wrap(
                        children: [
                          Image(image: AssetImage('assets/Vector.png')),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 300 * (MediaQuery.of(context).size.width / 360),
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      10 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Text(
                      "정말 탈퇴 하시겠습니까?",
                      style: TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 28 * (MediaQuery.of(context).size.width / 360),
                          fontFamily: 'NanumSquareEB'
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 300 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      10 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Text(
                      "HOTY 서비스를 탈퇴하게 되면, HOTY 아이디를 포함 한 모든 서비스 이용 기록 및 적립 포인트가 삭제됩니다. 삭제된 정보는 복원 할 수 없습니다.",
                      style: TextStyle(
                        fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 300 * (MediaQuery.of(context).size.width / 360),
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      5 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Text(
                      "본인 확인(생년월일 앞 6자리)",
                      style: TextStyle(
                          fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                          fontFamily: 'NanumSquareEB'
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      4 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildNumericInput(inputController1, context),
                            SizedBox(width: 0 *(MediaQuery.of(context).size.width / 360)),
                            buildNumericInput(inputController2, context),
                            SizedBox(width: 0 *(MediaQuery.of(context).size.width / 360)),
                            buildNumericInput(inputController3, context),
                            SizedBox(width: 0 *(MediaQuery.of(context).size.width / 360)),
                            buildNumericInput(inputController4, context),
                            SizedBox(width: 0 *(MediaQuery.of(context).size.width / 360)),
                            buildNumericInput(inputController5, context),
                            SizedBox(width: 0 *(MediaQuery.of(context).size.width / 360)),
                            buildNumericInput(inputController6, context),
                            SizedBox(width: 0 *(MediaQuery.of(context).size.width / 360)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
                  child : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xffFFFFFF),
                            padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.width / 360), vertical: 7 * (MediaQuery.of(context).size.height / 360)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                            ),
                            side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                            elevation: 0
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: 100 * (MediaQuery.of(context).size.width / 360),
                          padding: EdgeInsets.symmetric(horizontal: 15 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                          child : Text("돌아가기",
                            style: TextStyle(
                                color: Color(0xffE47421),
                                fontFamily: "NanumSquareR",
                                fontWeight: FontWeight.bold,
                                fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);

                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xffE47421),
                            padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.width / 360), vertical: 7 * (MediaQuery.of(context).size.height / 360)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                            ),
                            side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                            elevation: 0
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: 100 * (MediaQuery.of(context).size.width / 360),
                          padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                          child : Text("탈퇴하기",
                            style: TextStyle(
                                color: Color(0xffFFFFFF),
                                fontFamily: "NanumSquareR",
                                fontWeight: FontWeight.bold,
                                fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                          // Navigator.of(context, rootNavigator: true).pop();
                        },
                      )
                    ],
                  )
              )
            ],
          ),
        );
      },
    ).then((value) {
      if(value == true){
        _userDelete(context).then((_) {
          setState(() {

          });
        });
      }
    });
  }

  void checkedList(bool isCheck, String name) {
    if (isCheck) {
      checkList.add(name);
      print(checkList);
    } else {
      checkList.remove(name);
      print(checkList);
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
        titleSpacing: 5,
        leadingWidth: 40,
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("탈퇴하기" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  7 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                width: 300 * (MediaQuery.of(context).size.width / 360),
                child: Text(
                  "탈퇴 사유를 알려주시면\n개선을 위해 노력하겠습니다.",
                  style: TextStyle(
                    fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                    color: Colors.black,
                    fontFamily: 'NanumSquareEB',
                    // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ),
            Center(
                child: Container(
                  width: 300 * (MediaQuery.of(context).size.width / 360),
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    7 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Text(
                    "다중 선택이 가능해요",
                    style: TextStyle(
                      fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black,
                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                10 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _isCheck1,
                    checkColor: Colors.white,
                    activeColor: Color(0xffE47421),
                    onChanged: (value) {
                      setState(() {
                        _isCheck1 = value!;
                        checkedList(_isCheck1,"del_type1");
                      });
                    },
                  ),
                  Text(
                    "서비스 기능이 불편함",
                    style: TextStyle(
                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Checkbox(
                    value: _isCheck2,
                    checkColor: Colors.white,
                    activeColor: Color(0xffE47421),
                    onChanged: (value) {
                      setState(() {
                        _isCheck2 = value!;
                        checkedList(_isCheck2,"del_type2");
                      });
                    },
                  ),
                  Text(
                    "사용할 일이 없음",
                    style: TextStyle(
                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isCheck3,
                        checkColor: Colors.white,
                        activeColor: Color(0xffE47421),
                        onChanged: (value) {
                          setState(() {
                            _isCheck3 = value!;
                            checkedList(_isCheck3,"del_type3");
                          });
                        },
                      ),
                      Text(
                        "정확하지 않은 정보가 많고 유용한 정보 제공이 없음",
                        style: TextStyle(
                          fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Checkbox(
                    value: _isCheck4,
                    checkColor: Colors.white,
                    activeColor: Color(0xffE47421),
                    onChanged: (value) {
                      setState(() {
                        _isCheck4 = value!;
                        checkedList(_isCheck4,"del_type4");
                      });
                    },
                  ),
                  Text(
                    "기타",
                    style: TextStyle(
                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Center(
                child: Container(
                  width: 300 * (MediaQuery.of(context).size.width / 360),
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    10 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    5 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Text(
                    "탈퇴사유를 HOTY에게 알려주세요",
                    style: TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 80 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextFormField(
                maxLines: 5,
                minLines: 5,
                controller: _contsController,
                decoration: InputDecoration(
                  contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  // labelText: 'Search',
                  hintText: '탈퇴사유를 작성해주세요',
                  hintStyle: TextStyle(color:Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360),),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: TextStyle(fontFamily: ''),
                /*validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "설명 값 입력은 필수 입니다.";
                  }
                  return null;
                },*/
              ),
            ),
            Center(
                child: Container(
                  width: 300 * (MediaQuery.of(context).size.width / 360),
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    10 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Text(
                    "유의사항을 확인해주세요",
                    style: TextStyle(
                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                10 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Container(
                width: 320 * (MediaQuery.of(context).size.width / 360),
                height: 20 * (MediaQuery.of(context).size.height / 360),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child:DottedBorder(
                  borderType: BorderType.RRect,
                  color: Color(0xffE47421),
                  strokeWidth: 1,
                  dashPattern: [3,2],
                  radius: Radius.circular(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          10 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Image.asset(
                          'assets/number1.png',
                          width: 25 * (MediaQuery.of(context).size.width / 360),
                          height: 16 * (MediaQuery.of(context).size.height / 360),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          55 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Center(
                          child: Text(
                            "회원 탈퇴 유의사항 1번",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xffE47421),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                10 * (MediaQuery.of(context).size.width / 360),
                4 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Container(
                width: 320 * (MediaQuery.of(context).size.width / 360),
                height: 20 * (MediaQuery.of(context).size.height / 360),
                child:DottedBorder(
                    borderType: BorderType.RRect,
                    color: Color(0xffE47421),
                    strokeWidth: 1,
                    dashPattern: [3,2],
                    radius: Radius.circular(25),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          10 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Image.asset(
                          'assets/number2.png',
                          width: 25 * (MediaQuery.of(context).size.width / 360),
                          height: 16 * (MediaQuery.of(context).size.height / 360),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          55 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Center(
                          child: Text(
                            "회원 탈퇴 유의사항 2번",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xffE47421),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                10 * (MediaQuery.of(context).size.width / 360),
                4 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Container(
                width: 320 * (MediaQuery.of(context).size.width / 360),
                height: 20 * (MediaQuery.of(context).size.height / 360),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Color(0xffE47421),
                  strokeWidth: 1,
                  dashPattern: [3,2],
                  radius: Radius.circular(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          10 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Image.asset(
                          'assets/number3.png',
                          width: 25 * (MediaQuery.of(context).size.width / 360),
                          height: 16 * (MediaQuery.of(context).size.height / 360),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          55 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360),
                          0 * (MediaQuery.of(context).size.height / 360),
                        ),
                        child: Center(
                          child: Text(
                            "회원 탈퇴 유의사항 3번",
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xffE47421),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "개인정보 보유에 대한 기간",
                      style: TextStyle(
                        fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      " 6개월",
                      style: TextStyle(
                        fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                10 * (MediaQuery.of(context).size.width / 360),
                10 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Container(
                width: 320 * (MediaQuery.of(context).size.width / 360),
                height: 30 * (MediaQuery.of(context).size.height / 360),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.0),
                  color: Color(0xffE47421),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: (){
                      SaveDialog(context);
                    },
                    child: Center(
                      child: Text(
                        "탈퇴하기",
                        style: TextStyle(
                          fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                10 * (MediaQuery.of(context).size.width / 360),
                4 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
              child: Container(
                width: 320 * (MediaQuery.of(context).size.width / 360),
                height: 30 * (MediaQuery.of(context).size.height / 360),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.0),
                  border: Border.all(
                    color: Color(0xffE47421),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return MainPage();
                        },
                      ));
                    },
                    child: Center(
                      child: Text(
                        "돌아가기",
                        style: TextStyle(
                          fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                          color: Color(0xffE47421),
                          fontWeight: FontWeight.bold,
                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumericInput(TextEditingController controller, BuildContext context) {
    return Container(
      width: 40 * (MediaQuery.of(context).size.width / 360),
      color: Color(0xffF3F6F8),
      margin: EdgeInsets.fromLTRB(
        3 * (MediaQuery.of(context).size.width / 360),
        0 * (MediaQuery.of(context).size.height / 360),
        2 * (MediaQuery.of(context).size.width / 360),
        0 * (MediaQuery.of(context).size.height / 360),
      ),
      child: TextField(
        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
            hintText: '0',
            filled: false,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            )
        ),
        style: TextStyle(
          fontSize: 23 * (MediaQuery.of(context).size.width / 360),
          fontWeight: FontWeight.bold,
          color: Color(0xff151515),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

}