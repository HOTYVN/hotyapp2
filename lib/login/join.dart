import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoty/login/main_intro.dart';
import 'package:hoty/main/main_page.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
enum GenderSet {M, F}
class Join extends StatefulWidget {
  final String subtitle;
  final String snsKey;
  final String email;
  final String name;
  final String phone;
  final String nick;
  final String gender;
  final String birthDay;
  final String accessToken;
  const Join({Key? key,
    required this.subtitle,
    required this.snsKey,
    required this.email,
    required this.name,
    required this.phone,
    required this.nick,
    required this.gender,
    required this.birthDay,
    required this.accessToken
  }) : super(key:key);

  @override
  _Join createState() => _Join();
}

class _Join extends State<Join> {

  int click_check = 1;

  static final storage = FlutterSecureStorage();
  DateTime date = DateTime.now();

  GenderSet _gender = GenderSet.M;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _nick = TextEditingController();
  final TextEditingController _birth = TextEditingController();

  late FocusNode nameNode;
  late FocusNode phoneNode;
  late FocusNode nickNode;
  late FocusNode emailNode;
  late FocusNode birthNode;

  Future<bool> joinInWithSns() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/join.do',
      //'http://192.168.100.31:8080/mf/member/join.do',
    );
    try{
      Map data = {
        "memberId": widget.snsKey,
        "email": _email.text,
        "name": _name.text,
        "gender": _gender.toString(),
        "phone": _phone.text,
        "nick": _nick.text,
        "birth": _birth.text,
        "accessToken": widget.accessToken
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('response api ');
      print(json.decode(response.body));
      if(json.decode(response.body)['state'] == 200) {
        await storage.write(key: "memberNm", value: _name.text);
        await storage.write(key: "memberNick", value: _nick.text);
        await storage.write(key: "memberId", value: widget.snsKey);
      }
    } catch(e) {
      print(e);
    }
    return true;
  }
  @override
  void initState() {
    super.initState();
    _phone.text = widget.phone;
    _email.text = widget.email;
    _nick.text = widget.nick;
    _name.text = widget.name;
    _birth.text = widget.birthDay;
    _gender = GenderSet.M;

    nameNode = FocusNode();
    phoneNode = FocusNode();
    nickNode = FocusNode();
    emailNode = FocusNode();
    birthNode = FocusNode();
  }

  @override
  void dispose() {
    nameNode.dispose();
    phoneNode.dispose();
    nickNode.dispose();
    emailNode.dispose();
    birthNode.dispose();
    super.dispose();
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
        title: Container(
          width: 80 * (MediaQuery.of(context).size.width / 360),
          height: 80 * (MediaQuery.of(context).size.height / 360),
          child: Image(image: AssetImage('assets/logo.png')),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child : Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child: TextFormField(
                      controller: _name,
                      focusNode: nameNode,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          nameNode.requestFocus();
                          return "이름은 필수 입력값입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child: TextFormField(
                      controller: _phone,
                      focusNode: phoneNode,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: '전화번호',
                        hintStyle: TextStyle(
                          color: Color(0xffC4CCD0),
                          fontFamily: 'NanumSquareR',
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_name.text != null && _name.text != '') {
                            phoneNode.requestFocus();
                          }
                          return "전화번호는 필수 입력값입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child: TextFormField(
                      controller: _nick,
                      focusNode: nickNode,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_name.text != null && _name.text != '' && _phone.text != null && _phone.text != '') {
                            nickNode.requestFocus();
                          }
                          return "닉네임은 필수 입력값입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child: TextFormField(
                      controller: _email,
                      focusNode: emailNode,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: '이메일주소',
                        hintStyle: TextStyle(
                          color: Color(0xffC4CCD0),
                          fontFamily: 'NanumSquareR',
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_name.text != null && _name.text != '' && _phone.text != null && _phone.text != '' && _nick.text != null && _nick.text != '') {
                            emailNode.requestFocus();
                          }
                          return "이메일 주소는 필수 입력값입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child: TextFormField(
                      controller: _birth,
                      focusNode: birthNode,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F6F8), width: 1.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: '생년월일',
                        hintStyle: TextStyle(color: Colors.black12,),
                        suffixIcon: Icon(Icons.edit_calendar_outlined , color: Colors.black87, size: 22,),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_name.text != null && _name.text != '' && _phone.text != null && _phone.text != '' && _nick.text != null && _nick.text != '' && _email.text != null && _email.text != '') {
                            birthNode.requestFocus();
                          }
                          return "생년월일은 필수 입력값입니다.";
                        }
                        return null;
                      },
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context, // 팝업으로 띄우기 때문에 context 전달
                          initialDate: date, // 달력을 띄웠을 때 선택된 날짜. 위에서 date 변수에 오늘 날짜를 넣었으므로 오늘 날짜가 선택돼서 나옴
                          firstDate: DateTime(1950), // 시작 년도
                          lastDate: DateTime.now(), // 마지막 년도. 오늘로 지정하면 미래의 날짜는 선택할 수 없음
                        );

                        if (selectedDate != null) {
                          setState(() {
                            _birth.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                        }

                      },
                    ),
                  ),
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child: Wrap(
                      children: [
                        Container(
                          width: 100 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
                          child: RadioListTile(
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Transform.translate(
                              offset: const Offset(-20, 0),
                              child: Text(
                                '남자',
                                style: TextStyle(
                                  color: Color(0xff151515),
                                  fontFamily: 'NanumSquareR',
                                ),
                              ),
                            ),
                            value: GenderSet.M,
                            // checkColor: Colors.white,
                            activeColor: Color(0xffE47421), onChanged: (value) {
                            setState(() {
                              _gender = GenderSet.M;
                            });
                          }, groupValue: _gender,
                          ),

                        ),
                        Container(
                          width: 100 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
                          child: RadioListTile(
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Transform.translate(
                              offset: const Offset(-20, 0),
                              child: Text(
                                '여자',
                                style: TextStyle(
                                  color: Color(0xff151515),
                                  fontFamily: 'NanumSquareR',
                                ),
                              ),
                            ),
                            value: GenderSet.F,
                            // checkColor: Colors.white,
                            activeColor: Color(0xffE47421), onChanged: (value) {
                            setState(() {
                              _gender = GenderSet.F;
                            });
                          }, groupValue: _gender,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                    padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.height / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                onPressed: () async{
                  if(_formKey.currentState!.validate()) {
                    if(click_check == 1) {
                      setState(() {
                        click_check = 0;
                      });
                      if(await joinInWithSns()) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MaterialApp(
                              theme: ThemeData(
                                  unselectedWidgetColor: Color(0xffC4CCD0), // 언셀렉트
                                  scaffoldBackgroundColor: Colors.white,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  fontFamily: 'NanumSquareR',
                                  appBarTheme: AppBarTheme(
                                      color: Colors.white
                                  )
                              ),
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                  child: child!,
                                );
                              },
                              home: MainIntro(subtitle: widget.subtitle,memberId: widget.snsKey,), // added

                            );
                          },
                        ));
                      }
                    }
                  }
                },
                child: Text('회원가입', style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'NanumSquareEB')),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

