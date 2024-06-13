
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/profile_apartment.dart';
import 'package:http/http.dart' as http;

import '../../common/dialog/commonAlert.dart';
import '../../service/service_location_search.dart';

class ProfileApartmentEdit extends StatefulWidget{
  final int apartSeq;
  const ProfileApartmentEdit({super.key, required this.apartSeq});

  @override
  State<ProfileApartmentEdit> createState() => _ProfileApartmentEditState();
}

class _ProfileApartmentEditState extends State<ProfileApartmentEdit> {
  final storage = FlutterSecureStorage();

  String? reg_id;

  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  Map result = {};
  final TextEditingController _name = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addres_detail = TextEditingController();

  late FocusNode nameNode;
  late FocusNode addressNode;
  late FocusNode addressDetailNode;

  @override
  void initState() {
    super.initState();

    nameNode = FocusNode();
    addressNode = FocusNode();
    addressDetailNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getApartment();
      });
    });
  }

  @override
  void dispose() {
    nameNode.dispose();
    addressNode.dispose();
    addressDetailNode.dispose();
    super.dispose();
  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }

  void getApartment() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberApartmentView.do',
      //'http://192.168.100.31:8080/mf/member/getMemberApartmentView.do',
    );

    try {

      Map data = {
        "apartSeq": widget.apartSeq,
        "memberId": reg_id,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body)['result']['view']);
        setState(() {
          result = json.decode(response.body)['result']['view'];

          _name.text = result['NAME'];
          _addressController.text = result['ADDRESS'];
          _addres_detail.text = result['ADDRESS_DETAIL'];
        });
      }

    }catch(e) {
      print(e);
    }


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child : Scaffold(
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

          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        // height: 25 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(243, 246, 248, 1)
                          ),
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: TextFormField(
                          controller: _name,
                          focusNode: nameNode,
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
                                color: Color.fromRGBO(243, 246, 248, 1),
                              ),
                            ),*/
                            // labelText: 'Search',
                            hintText: '아파트 별칭',
                            hintStyle: TextStyle(
                              color:Color(0xffC4CCD0),
                              fontSize: 14  * (MediaQuery.of(context).size.width / 360),
                            ),

                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                          validator: (value) {
                            value = value?.trim();
                            if(value == null || value.isEmpty) {
                              nameNode.requestFocus();
                              return "아파트 별칭은 필수값 입니다.";
                            }
                            return null;
                          },
                          style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                        ),
                      ),
                      Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        // height: 25 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(243, 246, 248, 1)
                          ),
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 265 * (MediaQuery.of(context).size.width / 360),
                              /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                              child: TextFormField(
                                controller: _addressController,
                                focusNode: addressNode,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                                      10 * (MediaQuery.of(context).size.height / 360),
                                      0,
                                      10 * (MediaQuery.of(context).size.height / 360)),
                                  /*enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),*/
                                  // labelText: 'Search',
                                  hintText: '아파트 주소 검색/입력',
                                  hintStyle: TextStyle(
                                    color:Color(0xffC4CCD0),
                                    fontSize: 14  * (MediaQuery.of(context).size.width / 360),
                                  ),                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  value = value?.trim();
                                  if(value == null || value.isEmpty) {
                                    if(_name.text != null && _name.text != '') {
                                      addressNode.requestFocus();
                                    }
                                    return "아파트 주소는 필수 값입니다.";
                                  }
                                  return null;
                                },
                                style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),

                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Color(0xffFFFFF),
                                // padding: EdgeInsets.all(0.5), // 여백 설정
                              ),
                              onPressed: () async {
                                final route = MaterialPageRoute(builder: (context) => ServiceLocationSearch());

                                final addResult = await Navigator.push(context, route);
                                _addressController.text = addResult;

                              },
                              child:  Container(
                                  margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                  // width: 20 * (MediaQuery.of(context).size.width / 360),
                                  child : Image(image: AssetImage("assets/my_location2.png"), width: 20 * (MediaQuery.of(context).size.width / 360),)

                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 360 * (MediaQuery.of(context).size.width / 360),
                        // height: 25 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(243, 246, 248, 1)
                          ),
                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: TextFormField(
                          style: TextStyle(decorationThickness: 0 , fontSize: 14 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                          controller: _addres_detail,
                          focusNode: addressDetailNode,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),
                                10 * (MediaQuery.of(context).size.height / 360),
                                0,
                                10 * (MediaQuery.of(context).size.height / 360)),
                            border: InputBorder.none,
                            hintText: '상세주소',
                            hintStyle: TextStyle(
                              color:Color(0xffC4CCD0),
                              fontSize: 14  * (MediaQuery.of(context).size.width / 360),
                            ),                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            value = value?.trim();
                            if(value == null || value.isEmpty) {
                              if(_name.text != null && _name.text != '' && _addressController.text != null && _addressController.text != '') {
                                addressDetailNode.requestFocus();
                              }
                              return "아파트 상세 주소는 필수 값입니다.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 360 * (MediaQuery.of(context).size.width / 360),
          child:  Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            margin: EdgeInsets.fromLTRB(30 * (MediaQuery.of(context).size.width / 360),0,0 * (MediaQuery.of(context).size.width / 360),10  * (MediaQuery.of(context).size.height / 360)),
            height: 30 * (MediaQuery.of(context).size.height / 360),
            child:
            ElevatedButton(
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
                if(_formKey.currentState!.validate()) {
                  if(click_check == 1) {
                    setState(() {
                      click_check = 0;
                    });
                    FlutterDialog(context);
                  }
                }
              },
              child: (
                  Text("저장하기", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color:Color.fromRGBO(255,255,255,1)),)
              ),
            ),
          ),
        ),
        extendBody: true,
bottomNavigationBar: Footer(nowPage: 'My_page'),
      )
    );
  }

  void FlutterDialog(context) async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/editMemberApartment.do',
      //'http://192.168.100.31:8080/mf/member/editMemberApartment.do',
    );

    Map jsoData = {
      "apartSeq": widget.apartSeq,
      "memberId": reg_id,
      "name": _name.text,
      "address": _addressController.text,
      "addressDetail": _addres_detail.text
    };
    var body = json.encode(jsoData);
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print('response api ');
    print(json.decode(response.body));
    if(json.decode(response.body)['state'] == 200) {
      showDialog(
        context: context,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: adoptalert(context),
          );
        },
      ).then((value) => {
        if(value == true) {
          Navigator.pop(context, true),
          Navigator.pop(context, true),
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return Profile_apartment();
            },
          ))
        }
      });

    }

  }
}